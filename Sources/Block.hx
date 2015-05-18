package;

import kha.Color;
import kha.graphics2.Graphics;
import kha.networking.Entity;

class Block implements Entity {
	@replicated
	public var x: Float = 0;
	@replicated
	public var y: Float = 0;
	@replicated
	public var sx: Float = 0;
	@replicated
	public var sy: Float = 0;
	@replicated
	public var ax: Float = 0;
	@replicated
	public var ay: Float = 1;
	
	private var w: Float = 100;
	private var h: Float = 100;
	
	public function new() {
		
	}
	
	public function render(g: Graphics): Void {
		g.color = Color.Red;
		g.fillRect(x, y, w, h);
	}
}
