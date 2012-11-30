package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Graphiclist;
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
		
		[Embed(source = '../assets/cursor_picareta_dourada.png')] private const GOLDPICURSOR:Class;
		private var goldMouseImage:Image;
		
		[Embed(source = '../assets/cursor_radar.png')] private const RADARCURSOR:Class;
		public var radarImage:Image;
		
		[Embed(source = '../assets/cursorGrande.png')] private const FOGCURSOR:Class;
		public var fogImage:Image;
		
		public function get color():uint { return this.tileImage.color; }
		public function set color(c:uint):void { this.tileImage.color = c;  }
		
		private var cursorCollision:Pixelmask;
		private var glist:Graphiclist;
		
		public function Cursor() 
		{
			glist = new Graphiclist();
			graphic = glist;
			layer = -3;
			
			tileImage = new Image(CURSOR);
			glist.add(tileImage)
			
			mouseImage = new Image(PICURSOR);
			//addGraphic(mouseImage);
			glist.add(mouseImage);
			
			cursorCollision = new Pixelmask(PICURSOR);
			mask = cursorCollision;
			
			goldMouseImage = new Image(GOLDPICURSOR);
			radarImage = new Image(RADARCURSOR);
			fogImage = new Image(FOGCURSOR);
			fogImage.x = - Constants.VISION_RANGE * Constants.TILE_WIDTH;
			fogImage.y = - Constants.VISION_RANGE * Constants.TILE_HEIGHT;
		}
		
		override public function update():void 
		{
			super.update();
			
			gridX = int(Input.mouseX / Constants.TILE_WIDTH) - 1;
			gridY = int(Input.mouseY / Constants.TILE_HEIGHT) - 1;
			
			mouseImage.x = Input.mouseX - x - Constants.TILE_WIDTH;
			mouseImage.y = Input.mouseY - y - Constants.TILE_HEIGHT;
			goldMouseImage.x = Input.mouseX - x - Constants.TILE_WIDTH;
			goldMouseImage.y = Input.mouseY - y - Constants.TILE_HEIGHT;
			
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
		
		public function ChangeGraphicTo(g:Graphic):void {
			graphic = g;
		}
		public function UseDefaultGraphic():void {
			graphic = glist;
		}
		public function useGoldPickaxe():void {
			glist.remove(mouseImage);
			glist.add(goldMouseImage);
		}
	}
}