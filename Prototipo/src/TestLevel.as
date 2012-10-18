package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class TestLevel extends Entity 
	{
		private var _Tiles: Tilemap;
		private var _grid: Grid;
		[Embed(source = 'assets/tiles.png')] private const GROUND:Class;
		[Embed(source = 'assets/Rock.png')] private const ROCK:Class;
		
		public function TestLevel() 
		{
			_Tiles = new Tilemap(GROUND, 800, 600, 32, 32);
			graphic = _Tiles;
			layer = 2;
			_Tiles.setRect(0, 0, 25, 20, 0);
			_Tiles.setRect(3, 3, 19, 13, 3);
			//_Tiles.setRectOutline(0, 0, 24, 18, 2);

			_grid = new Grid(700, 500, 32, 32, 1, 1);
			mask = _grid;
			_grid.setRect(3 , 3, 18, 13, true);
			type = 'level'
		}
		
		public function destroy(column,row)
		{
			if(_Tiles.getTile(column,row) == 3)
				_Tiles.setTile(column, row, 0);
		}
		
	}
}