package utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Constants 
	{
		public static const TILE_WIDTH:int = 32;
		public static const TILE_HEIGHT:int = 32;
		
		public static const GAME_WIDTH:int = 640;
		public static const GAME_HEIGHT:int = 480;
		
		public static var MAP_WIDTH:int = GAME_WIDTH / TILE_WIDTH;
		public static var MAP_HEIGHT:int = GAME_HEIGHT / TILE_HEIGHT;
		
		public static const BORDER_SIZE:int = 1;
		public static const VISION_RANGE:int = 3;
		public static const SPAWN_OFFSET:int = 3;
		
		public static const TUNNEL_RISK:Number = 2.0;
		public static const ROCK_RISK:Number = 5.0;
		public static const DIRT_RISK:Number = 10.0;
		public static const SAND_RISK:Number = 15.0;
		public static const NONE_RISK:Number = 20.0;
		
		public static const RISK_THRESHOLD:Number = 200.0;
		public static const DEFAULT_CAVEIN_LIMIT:Number = 10.0;
	}

}