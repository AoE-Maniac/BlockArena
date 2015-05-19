package;

import kha.Color;
import kha.Configuration;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.Game;
import kha.Loader;
import kha.networking.Session;
import kha.Scheduler;

class BlockArena extends Game {
	private var session: Session;
	private var waiting: Bool;
	private var font: Font;
	
	private var blocks: Array<Block> = new Array();
	
	public function new() {
		super("BlockArena");
	}
	
	override public function init(): Void {
		Configuration.setScreen(this);
		waiting = true;
		Loader.the.loadRoom("all", startGame);
	}
	
	private function startGame(): Void {
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 20);
		session = new Session(2);
		session.waitForStart(startSession);
		//startSession();
	}
	
	private function startSession(): Void {
		waiting = false;
		
		var block = new Block();
		block.__id = 0;
		block.x = 100;
		block.y = 100;
		
		session.addEntity(block);
		blocks.push(block);
			
		Scheduler.addTimeTask(updateBlocks, 0, 1 / 60);
		
		/*
		Jumpman.get(1).__id = id++;
		//Session.the().addEntity(Jumpman.get(0));
		//Session.the().addEntity(Jumpman.get(1));
		Scene.the.addHero(Jumpman.get(0));
		Scene.the.addHero(Jumpman.get(1));
		
		session.addController(Keyboard.get());
		
		Keyboard.get().notify(
			function (key: Key, char: String) {
				switch (mode) {
				case Game:
					switch (key) {
					case UP:
						Jumpman.get(session.me.id).setUp();
					case LEFT:
						Jumpman.get(session.me.id).left = true;
					case RIGHT:
						Jumpman.get(session.me.id).right = true;
					default:
					}
				default:
				}
			},
			function (key: Key, char: String) {
				switch (mode) {
				case Game:
					switch (key) {
					case UP:
						Jumpman.get(session.me.id).up = false;
					case LEFT:
						Jumpman.get(session.me.id).left = false;
					case RIGHT:
						Jumpman.get(session.me.id).right = false;
					default:
					}	
				default:
				}
			}
		);
		*/
	}
	
	private function updateBlocks(): Void {
		for (block in blocks) {
			block.sx += block.ax;
			block.sy += block.ay;
			if (block.sy > 5) block.sy = 5;
			block.x += block.sx;
			block.y += block.sy;
			if (block.y > height) block.y -= height + 100;
		}
	}
	
	override public function render(frame: Framebuffer): Void {
		if (waiting) {
			var g = frame.g2;
			g.begin();
			g.clear(Color.Black);
			if (font != null) {
				g.color = Color.White;
				g.font = font;
				var text = "Waiting";
				g.drawString(text, width / 2 - font.stringWidth(text) / 2, height / 2 - font.getHeight() / 2);
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
