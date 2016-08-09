package;

import kha.Color;
import kha.graphics2.Graphics;
import kha.network.Entity;
import kha.network.Sync;

class Block implements Entity implements Sync {

	// After implementing Entity:
	// All variables annoted with @replicated are synchronized between the clients,
	// with the server having the authority in case of conflicts
	@replicated
	public var x: Float = 0;
	@replicated
	public var y: Float = 0;
	@replicated
	public var sx: Float = 0;
	@replicated
	public var sy: Float = 0;
	@replicated
	public var left: Float = 0;
	@replicated
	public var right: Float = 0;
		
	private var w: Float = 100;
	private var h: Float = 100;
	private var color: Color = Color.fromFloats(1, 0, 0);
	
	public function new(x: Float, y: Float) {
		this.x = x;
		this.y = y;
	}
	
	public function render(g: Graphics) {
		g.color = color;
		g.fillRect(x, y, w, h);
	}
	
	// After implementing Sync:
	// All functions annoted with @synced are called remotely,
	// with "all" and "server" defining the execution target
	// Use this for seldom events or for complex variables that cannot be replicated (list of chat messages)
	@synced("all")
	public function flipColor() {
		color = Color.fromFloats(1 - color.R, 1 - color.G, 0);
		trace("Flip!");
	}

	@synced("server")
	public static function flop() {
		trace("Flop!");
	}
}
