package;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Framebuffer;
import kha.input.Keyboard;
import kha.Key;
import kha.network.Session;
import kha.Scheduler;
import kha.System;

class BlockArena {
	private var session: Session;
	private var waiting: Bool;
	private var font: Font;
	
	private var blocks: Array<Block> = new Array();
	
	public function new() {
		waiting = true;
		Assets.loadEverything(onLoaded);
	}
	
	private function onLoaded(): Void {
		font = Assets.fonts.DejaVuSansMono;
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
    
		session = new Session(2);
		session.waitForStart(startSession);
	}
	
	private function startSession(): Void {
		waiting = false;
		
		var block = new Block();
		block.__id = 0;
		block.x = 100;
		block.y = 100;

		session.addEntity(block);
		blocks.push(block);

		block = new Block();
		block.__id = 1;
		block.x = 500;
		block.y = 100;
		
		session.addEntity(block);
		blocks.push(block);
		
		session.addController(Keyboard.get());
		
		Keyboard.get().notify(
			function (key: Key, char: String) {
				if (waiting) return;
				switch (key) {
				case LEFT:
					blocks[session.me.id].sx = -2;
				case RIGHT:
					blocks[session.me.id].sx = 2;
				default:
				}
			},
			function (key: Key, char: String) {
				if (waiting) return;
				switch (key) {
				case LEFT:
					blocks[session.me.id].sx = 0;
				case RIGHT:
					blocks[session.me.id].sx = 0;
				default:
				}	
			}
		);
	}
	
	private function update(): Void {
		for (block in blocks) {
			block.sx += block.ax;
			block.sy += block.ay;
			if (block.sy > 5) block.sy = 5;
			block.x += block.sx;
			block.y += block.sy;
			if (block.y > System.windowHeight()) block.y -= System.windowHeight() + 100;
		}
	}
	
	public function render(frame: Framebuffer): Void {
		if (waiting) {
			var g = frame.g2;
			g.begin();
			g.clear(Color.Black);
			if (font != null) {
				g.color = Color.White;
				g.font = font;
				g.fontSize = 20;
				var text = "Waiting";
				g.drawString(text, System.windowWidth() / 2 - font.width(g.fontSize, text) / 2, System.windowHeight() / 2 - font.height(g.fontSize) / 2);
			}
			g.end();
			return;
		}
		
		var g = frame.g2;
		g.begin();
		g.color = Color.White;
		g.font = font;
		g.drawString("" + Scheduler.time(), 10, 10);
		for (block in blocks) {
			block.render(g);
		}
		g.end();
	}
}
