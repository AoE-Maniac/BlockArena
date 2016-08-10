package;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Framebuffer;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.Key;
import kha.network.Session;
import kha.Scheduler;
import kha.System;

class BlockArena {
	private var session: Session;
	private var waiting: Bool;
	private var font: Font;
	
	private var message: String = "";
	private var blocks: Array<Block> = new Array();
	
	public function new() {
		waiting = true;
		Assets.loadEverything(onLoaded);
	}
	
	private function onLoaded(): Void {
		font = Assets.fonts.DejaVuSansMono;
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
    
		// Initialize the network session
		// Note: If you do not want to use a hardcoded server address ask the user beforehand
		var serverAddress = "localhost";
		session = new Session(2, serverAddress, 6789);

		// Wait for enough players to connect
		message = "[Waiting for more clients]";
		session.waitForStart(startSession, onSessionRefused, onSessionError, onSessionClosed, resetSession);
	}
	
	private function startSession(): Void {
		waiting = false;
		message = "";
		
		// Create game objects and add them to the session
		var block = new Block(100, 100);
		blocks.push(block);
		session.addEntity(block);

		block = new Block(500, 100);
		blocks.push(block);
		session.addEntity(block);
		
		// Define controls and add input device to the session to have it synched to the server
		// Note: Use session.me.id to identify the local player
		Keyboard.get().notify(
			function (key: Key, char: String) {
				if (waiting) return;
				switch (key) {
				case LEFT:
					blocks[session.me.id].left = 2;
				case RIGHT:
					blocks[session.me.id].right = 2;
				default:
				}
			},
			function (key: Key, char: String) {
				if (waiting) return;
				switch (key) {
				case LEFT:
					blocks[session.me.id].left = 0;
				case RIGHT:
					blocks[session.me.id].right = 0;
				default:
				}	
			}
		);
		session.addController(Keyboard.get());

		Mouse.get().notify(
			function (button: Int, x: Int, y: Int) {
				if (waiting) return;
				if (button == 0) {
					blocks[session.me.id].flipColor();
					Block.flop();
				}	
			}, null, null, null);
	}
	
	private function resetSession(): Void {
		blocks = new Array();
		
		Keyboard.get().notify(null, null);
		Mouse.get().notify(null, null, null, null);
	}

	private function onSessionRefused(): Void {
		message = "[Server refused connection]";
	}

	private function onSessionError(): Void {
		message = "[Network error]";
	}

	private function onSessionClosed(): Void {
		message = "[Server shut down]";
	}
	
	private function update(): Void {
		for (block in blocks) {
			block.sx = block.right - block.left;
			block.sy = 7.5;
			block.x += block.sx;
			block.y += block.sy;
			if (block.y > System.windowHeight()) block.y -= System.windowHeight() + 100;
		}
	}
	
	public function render(frame: Framebuffer): Void {
		var g = frame.g2;
		g.begin(true, Color.Black);

		if (!waiting) {
			for (block in blocks) {
				block.render(g);
			}

			g.color = Color.White;
			g.font = font;
			g.fontSize = 20;

			g.drawString("" + Scheduler.time(), 10, 10);
			g.drawString("Ping: " + Std.int(session.ping * 1000), 10, 35);
		}

		if (message != "") {
			g.color = Color.White;
			g.font = font;
			g.fontSize = 20;

			var text = message;
			g.drawString(text, System.windowWidth() / 2 - font.width(g.fontSize, text) / 2, System.windowHeight() / 2 - font.height(g.fontSize) / 2);
		}

		g.end();
	}
}
