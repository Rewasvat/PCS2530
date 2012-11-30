package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import utils.Constants;
	import utils.GameMap;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class Cursor extends BaseGameObj 
	{
		[Embed(source = '../assets/cursor.png')] private const CURSOR:Class;
		private var tileImage:Image;
		
		[Embed(source = '../assets/cursor_picareta.png')] private const PICURSOR:Class;
		private var mouseImage:Image;
		
		public function get color():uint { return this.tileImage.color; }
		public function set color(c:uint):void { this.tileImage.color = c;  }
		
		private var cursorCollision:Pixelmask;
		
		public function Cursor() 
		{
			tileImage = new Image(CURSOR);
			graphic = tileImage;
			layer = -3;
			
			
			mouseImage = new Image(PICURSOR);
			addGraphic(mouseImage);
			cursorCollision = new Pixelmask(PICURSOR);
			mask = cursorCollision;
		}
		
		override public function update():void 
		{
			super.update();
			
			gridX = int(Input.mouseX / Constants.TILE_WIDTH) - 1;
			gridY = int(Input.mouseY / Constants.TILE_HEIGHT) - 1;
			
			mouseImage.x = Input.mouseX - x - Constants.TILE_WIDTH;
			mouseImage.y = Input.mouseY - y - Constants.TILE_HEIGHT;
			
			var w:GameWorld = world as GameWorld;
			if (w.map.getTile(gridX + 1, gridY + 1) == GameMap.NONE || w.isTunnelIn(gridX+1, gridY+1) ) {
				color = 0x0000ff;
			}
			else if (w.canGoTo(gridX+1, gridY+1)) {
				color = 0x00ff00;
			}
			else {
				color = 0xff0000;
			}
			
			if (collide("hud", x, y)) {
				tileImage.visible = false;
			}
			else {
				tileImage.visible = true;
			}
		}
	}
}