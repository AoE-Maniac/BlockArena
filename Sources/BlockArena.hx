package;

import kha.Color;
import kha.Configuration;
import kha.Font;
import kha.Framebuffer;
import kha.Game;
import kha.networking.Session;

class BlockArena extends Game {
	private var session: Session;
	private var waiting: Bool;
	private var font: Font;
	
	public function new() {
		super("BlockArena");
	}
	
	override public function init(): Void {
		session = new Session(2);
		session.waitForStart(startGame);
		Configuration.setScreen(this);
		waiting = true;
	}
	
	private function startGame(): Void {
		waiting = false;
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
	
	override public function render(frame: Framebuffer): Void {
		if (waiting) {
			var g = frame.g2;
			g.begin();
			g.clear(Color.Black);
			g.color = Color.White;
			var text = "Waiting";
			g.drawString(text, width / 2 - font.stringWidth(text) / 2, height / 2 - font.getHeight() / 2);
			g.end();
			return;
		}
		
		var g = frame.g2;
		g.begin();
		g.color = Color.Orange;
		g.fillRect(100, 100, 200, 200);
		g.end();
	}
}
