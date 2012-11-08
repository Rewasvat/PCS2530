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
		
		private static const NONE:int = 0;
		private static const SAND:int = 2;
		private static const DIRT:int = 3;
		
		public function GameMap() 
		{
			tiles = new Tilemap(GROUND, Constants.GAME_WIDTH, Constants.GAME_HEIGHT, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			layer = 2;
			tiles.setRect(0, 0, Constants.MAP_WIDTH, Constants.MAP_HEIGHT, SAND);
			tiles.setRect(Constants.BORDER_SIZE, Constants.BORDER_SIZE,
						  Constants.MAP_WIDTH -Constants.BORDER_SIZE*2, Constants.MAP_HEIGHT-Constants.BORDER_SIZE*2,
						  DIRT);
		}
		
		public function PlayerMovedTo(column:int, row:int)
		{
			if(tiles.getTile(column,row) == DIRT) {
				tiles.setTile(column, row, NONE);
			}
		}
		
	}

}