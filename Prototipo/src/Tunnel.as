package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Tunnel extends Entity 
	{
		private var _Tiles: Tilemap;
		[Embed(source = 'assets/mulher0.png')] private const PLAYER:Class;
		
		public function Tunnel() 
		{
			_Tiles = new Tilemap(PLAYER, 32, 128, 64, 64);
			graphic = _Tiles;
			_Tiles.setTile(0, 0, 0);
		}
		
	}

}