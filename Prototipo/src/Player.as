package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Player extends Entity 
	{
		private var _Tiles: Tilemap;
		[Embed(source = 'assets/mulher0.png')] private const PLAYER:Class;
		
		public function Player() 
		{
			_Tiles = new Tilemap(PLAYER, 32, 32, 32, 32);
			graphic = _Tiles;
			_Tiles.setTile(0, 0, 0);
			setHitbox(32, 32);
			//x = (2+FP.rand(21))*32;
			//y = (2+FP.rand(15)) * 32;
			x = 3 * 32;
			y = 8 * 32;
			layer = 0;
		}
		
		override public function update():void
		{
			var rock: Rock = collide("rock", x, y) as Rock;
			if (Input.pressed(Key.LEFT)) 
				{ 
					if(x!=3*32)
					{
						x -= 32;
						_Tiles.setTile(x / 32, y / 32 , 1); 
					}
				}
			if (Input.pressed(Key.RIGHT)) 
				{ 
					if (x != 21 * 32)
					{
					x += 32; 
					_Tiles.setTile(x / 32, y / 32 , 2);
					}
				}
			if (Input.pressed(Key.UP)) 
				{ 
					if (y != 3 * 32)
					{
					y -= 32; 
					_Tiles.setTile(x / 32 , y / 32, 3);
					}
				}
			if (Input.pressed(Key.DOWN)) 
				{ 
					if (y != 17 * 32)
					{
					y += 32; 
					_Tiles.setTile(x / 32 , y / 32, 0);
					}
				}

			var fog: Fog = collide("fog", x, y) as Fog;
			if (collide("fog", x, y))
			{
				fog.Clear(x / 32, y / 32);
				if (Input.pressed(Key.LEFT)) {fog.Recover("left", x / 32,y / 32); }
				if (Input.pressed(Key.RIGHT)) {fog.Recover("right", x / 32,y / 32); }
				if (Input.pressed(Key.UP)) {fog.Recover("up", x / 32,y / 32); }
				if (Input.pressed(Key.DOWN)) {fog.Recover("down", x / 32,y / 32); }
			}
			
			var level: TestLevel = collide("level", x, y) as TestLevel;
			if (collide('level',x,y))
			{
				level.destroy(x / 32, y / 32);
			}
			else 
			{
				if (Input.pressed(Key.LEFT)) { x += 32; _Tiles.setTile(x / 32, y/32 , 1); }
				if (Input.pressed(Key.RIGHT)) { x -= 32; _Tiles.setTile(x / 32, y/32 , 2); }
				if (Input.pressed(Key.UP)) { y += 32; _Tiles.setTile(x/32 , y / 32, 3); }
				if (Input.pressed(Key.DOWN)) { y -= 32; _Tiles.setTile(x/32 , y/ 32, 0);}
			}
			
			var rock: Rock = collide("rock", x, y) as Rock;
			if (collide('rock', x, y))
			{
				if (Input.pressed(Key.LEFT)) { x += 32; _Tiles.setTile(x / 32, y/32 , 1); }
				if (Input.pressed(Key.RIGHT)) { x -= 32; _Tiles.setTile(x / 32, y/32 , 2); }
				if (Input.pressed(Key.UP)) { y += 32; _Tiles.setTile(x/32 , y / 32, 3); }
				if (Input.pressed(Key.DOWN)) { y -= 32; _Tiles.setTile(x/32 , y/ 32, 0);}
			}
			
			var gold: Gold = collide("gold", x, y) as Gold;
			if (collide('gold', x, y))
			{
				gold.destroy();
			}
		}
	}

}