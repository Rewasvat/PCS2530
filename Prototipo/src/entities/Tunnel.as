package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import utils.TunnelManager;
	import utils.Constants;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Tunnel extends BaseGameObj 
	{
		private var tiles: Tilemap;
		[Embed(source = '../assets/tunnels.png')] private const TUNNEL:Class;
		
		private var manager:TunnelManager;
		
		private var tunnelWidth:int;
		private var tunnelHeight:int;
		
		public function Tunnel(tunnelWidth:int, tunnelHeight:int, manager:TunnelManager) 
		{
			this.manager = manager;
			this.tunnelWidth = tunnelWidth;
			this.tunnelHeight = tunnelHeight;
			tiles = new Tilemap(TUNNEL, 96, 64, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			
		}
		
		public function SetTunnelTile(posX:int, posY:int, type:int):void {
			this.tiles.setTile(posX, posY, type);
		}
		
	}

}