package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import utils.Constants;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class Cursor extends BaseGameObj 
	{
		[Embed(source = '../assets/cursor.png')] private const CURSOR:Class;
		private var image:Image;
		
		public function get color():uint { return this.image.color; }
		public function set color(c:uint):void { this.image.color = c;  }
		
		
		
		public function Cursor() 
		{
			image = new Image(CURSOR);
			graphic = image;
			layer = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			gridX = int(Input.mouseX / Constants.TILE_WIDTH) - 1;
			gridY = int(Input.mouseY / Constants.TILE_HEIGHT) - 1;
			
			var w:GameWorld = world as GameWorld;
			if (w.canGoTo(gridX+1, gridY+1)) {
				color = 0x00ff00;
			}
			else {
				color = 0xff0000;
			}
		}
	}
}