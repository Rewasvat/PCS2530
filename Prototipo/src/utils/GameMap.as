package utils 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class GameMap extends Entity
	{
		private var tiles: Tilemap;
		[Embed(source = '../assets/tiles.png')] private const GROUND:Class;
		
		public static const NONE:int = 0;
		public static const DIRT:int = 1;
		public static const BORDER:int = 2;
		public static const POINT_VERTICAL:int = 3;
		public static const POINT_HORIZONTAL:int = 4;
		public static const GOLD:int = 5
		public static const ROCK:int = 6;
		
		public function GameMap() 
		{
			tiles = new Tilemap(GROUND, Constants.GAME_WIDTH, Constants.GAME_HEIGHT, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			layer = 2;
			tiles.setRect(0, 0, Constants.MAP_WIDTH, Constants.MAP_HEIGHT, BORDER);
			tiles.setRect(Constants.BORDER_SIZE+Constants.MENU_COLUMNS, Constants.BORDER_SIZE,
						  Constants.MAP_WIDTH -Constants.BORDER_SIZE*2-Constants.MENU_COLUMNS, Constants.MAP_HEIGHT-Constants.BORDER_SIZE*2,
						  DIRT);
		}
		
		public function PlayerMovedTo(column:int, row:int):void
		{
			if (tiles.getTile(column, row) == DIRT ||
				tiles.getTile(column, row) == GOLD) {
				tiles.setTile(column, row, NONE);
			}
		}
		
		public function getTile(column:int, row:int):int
		{
			return tiles.getTile(column, row);
		}
		public function setTile(column:int, row:int, type:int):void
		{
			return tiles.setTile(column, row, type);
		}
	}

}