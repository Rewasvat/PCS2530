package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	import utils.Fog;
	import utils.Constants;
	import worlds.GameWorld;
	import utils.GameMap;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Player extends BaseGameObj 
	{
		private var tiles: Tilemap;
		
		private var last_stable_x:int;
		private var last_stable_y:int;
		
		public var canMove:Boolean;
		public var gold_amount:int;
		
		private static const DOWN:int = 0;
		private static const LEFT:int = 1;
		private static const RIGHT:int = 2;
		private static const UP:int = 3;
		
		public function Player(gridX:int, gridY:int) 
		{
			setHitbox(Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			this.gridX = gridX;
			this.gridY = gridY;
			layer = 0;
			canMove = true;
			gold_amount = 0;
		}
		
		override public function update():void
		{
			last_stable_x = x;
			last_stable_y = y;
			var moved:Boolean = UpdateMovement();
			
			var collided:Boolean = CheckForCollisions();
			if (collided) 
			{
				x = last_stable_x;
				y = last_stable_y;
			}
			else if (moved) {
				var myworld:GameWorld = world as GameWorld;
				myworld.UpdateMap();
			}
		}
		
		public function CheckForCollisions():Boolean 
		{
			return false;
		}
		
		public function UpdateMovement():Boolean 
		{
			if(Input.mousePressed && canMove)
			{
				var posX:int = int(Input.mouseX/Constants.TILE_WIDTH);
				var posY:int = int(Input.mouseY/Constants.TILE_HEIGHT);
				if (verifyTiles(posX, posY))
				{
					gridX = posX;
					gridY = posY;
					return true;
				}
				
			}
			return false;
		}
		
		public function verifyTiles(gX:int,gY:int):Boolean
		{
			var myworld:GameWorld = world as GameWorld;
			if (myworld.canGoTo(gX, gY))
			{
				return true;
			}
			return false;
		}
	}
}
	