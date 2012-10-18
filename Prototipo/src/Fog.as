package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	public class Fog extends Entity 
	{
		private var _Tiles: Tilemap;
		private var _grid: Grid;
		[Embed(source = 'assets/Fog.png')] private const FOG:Class;
		
		public function Fog() 
		{
			_Tiles = new Tilemap(FOG, 800, 600, 32, 32);
			graphic = _Tiles;
			_Tiles.setRect(0, 0, 25, 20,1);
			//setHitbox(32, 32);
			layer = 0;
			
			_grid = new Grid(800, 600, 32, 32, 1, 1);
			mask = _grid;
			_grid.setRect(0 , 0, 800, 600, true);
			type = 'fog'
		}
		
		public function Clear(column,row)
		{
			_Tiles.clearRect(column - 3, row - 3, 7, 7);
		}
		public function Recover(key,column,row)
		{
			if (key == "left")
			{
			_Tiles.setRect(column + 4, row - 3, 1, 7, 1);
			_Tiles.setRect(column - 3, row - 3, 1, 7, 1);
			}
			if (key == "right")
			{
			_Tiles.setRect(column - 4, row - 3, 1, 7, 1);
			_Tiles.setRect(column + 3, row - 3, 1, 7, 1);
			}
			if (key == "up")
			{
			_Tiles.setRect(column - 3, row + 4, 7, 1, 1);
			_Tiles.setRect(column - 3, row - 3, 7, 1, 1);
			}
			if (key == "down")
			{
			_Tiles.setRect(column - 3, row - 4, 7, 1, 1);
			_Tiles.setRect(column - 3, row + 3, 7, 1, 1);
			}
		}
	}
}