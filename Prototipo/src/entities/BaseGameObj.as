package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import utils.Constants;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseGameObj extends Entity 
	{
		public function get gridX():int { return this.x / Constants.TILE_WIDTH; }
		public function set gridX(x:int):void { this.x = x * Constants.TILE_WIDTH;  }
		
		public function get gridY():int { return this.y / Constants.TILE_HEIGHT; }
		public function set gridY(y:int):void { this.y = y * Constants.TILE_HEIGHT;  }
		
		public function BaseGameObj(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			
		}
		
		public function destroy():void
		{
			var myworld:GameWorld = world as GameWorld;
			world.remove(this);
			myworld.grid[gridX][gridY] = null;
		}
	}

}