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
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Player extends BaseGameObj 
	{
		private var tiles: Tilemap;
		[Embed(source = '../assets/mulher0.png')] private const PLAYER:Class;
		
		private var last_stable_x:int;
		private var last_stable_y:int;
		
		private static const DOWN:int = 0;
		private static const LEFT:int = 1;
		private static const RIGHT:int = 2;
		private static const UP:int = 3;
		
		public function Player(gridX:int, gridY:int) 
		{
			tiles = new Tilemap(PLAYER, 32, 32, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			tiles.setTile(0, 0, 0);
			setHitbox(Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			this.gridX = gridX;
			this.gridY = gridY;
			layer = 0;
		}
		
		override public function update():void
		{
			last_stable_x = x;
			last_stable_y = y;
			UpdateMovement();
			
			var collided:Boolean = CheckForCollisions();
			if (collided) {
				x = last_stable_x;
				y = last_stable_y;
			}
		}
		
		public function CheckForCollisions():Boolean 
		{
			var rock:Rock = collide("rock", x, y) as Rock;
			if (rock) {
				return true;
			}
			
			var gold:Gold = collide("gold", x, y) as Gold;
			if (gold) {
				gold.destroy();
			}
			
			return false;
		}
		
		public function UpdateMovement():void 
		{
			if (Input.pressed(Key.LEFT)) 
			{ 
				tiles.setTile(gridX, gridY , LEFT); 
				if(x > Constants.BORDER_SIZE*Constants.TILE_WIDTH)
				{
					x -= Constants.TILE_WIDTH;
				}
			}
			else if (Input.pressed(Key.RIGHT)) 
			{ 
				tiles.setTile(gridX, gridY , RIGHT);
				if (x < (Constants.MAP_WIDTH-Constants.BORDER_SIZE-1) * Constants.TILE_WIDTH)
				{
					x += Constants.TILE_WIDTH; 
				}
			}
			else if (Input.pressed(Key.UP)) 
			{ 
				tiles.setTile(gridX, gridY, UP);
				if (y > Constants.BORDER_SIZE * Constants.TILE_HEIGHT)
				{
					y -= Constants.TILE_HEIGHT; 
				}
			}
			else if (Input.pressed(Key.DOWN)) 
			{ 
				tiles.setTile(gridX, gridY, DOWN);
				if (y < (Constants.MAP_HEIGHT-Constants.BORDER_SIZE-1) * Constants.TILE_HEIGHT)
				{
					y += Constants.TILE_HEIGHT; 
				}
			}
		}
	}

}