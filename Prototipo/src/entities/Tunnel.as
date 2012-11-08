package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Tunnel extends BaseGameObj 
	{
		private var tiles: Tilemap;
		[Embed(source = '../assets/mulher0.png')] private const PLAYER:Class;
		
		public function Tunnel() 
		{
			tiles = new Tilemap(PLAYER, 32, 128, 64, 64);
			graphic = _Tiles;
			tiles.setTile(0, 0, 0);
		}
		
	}

}