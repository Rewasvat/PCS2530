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
		
		public function IsNear(obj:BaseGameObj):Boolean {
			return (checkCoord(gridX, obj.gridX, 1) && checkCoord(gridY, obj.gridY, 0)) ||
					(checkCoord(gridX, obj.gridX, -1) && checkCoord(gridY, obj.gridY, 0)) ||
					(checkCoord(gridX, obj.gridX, 0) && checkCoord(gridY, obj.gridY, 1)) ||
					(checkCoord(gridX, obj.gridX, 0) && checkCoord(gridY, obj.gridY, -1)) ;
		}
		private function checkCoord(a:int, b:int, dist:int):Boolean {
			return a - dist == b;
		}
		
		public function destroy():void
		{
			var myworld:GameWorld = world as GameWorld;
			myworld.removeFromGrid(this);
			world.remove(this);
		}
		
		public static function CreateDummy(gX:int, gY:int):BaseGameObj {
			var obj:BaseGameObj = new BaseGameObj();
			obj.gridX = gX;
			obj.gridY = gY;
			return obj;
		}
	}

}