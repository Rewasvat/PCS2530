package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import utils.TunnelBlock;
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
		
		public var tunnelWidth:int;
		public var tunnelHeight:int;
		private var grid:Vector.<Vector.<int>>;
		
		public function Tunnel(tunnelWidth:int, tunnelHeight:int, manager:TunnelManager) 
		{
			this.manager = manager;
			this.tunnelWidth = tunnelWidth;
			this.tunnelHeight = tunnelHeight;
			tiles = new Tilemap(TUNNEL, Constants.TILE_WIDTH * tunnelWidth, Constants.TILE_HEIGHT * tunnelHeight,
										Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			type = "tunnel";
			layer = 1;
			tiles.clearRect(0, 0, tunnelWidth, tunnelHeight);
			
			grid = new Vector.<Vector.<int>>(tunnelWidth);
			for (var i:int=0; i < tunnelWidth; i++) {
				grid[i] = new Vector.<int>(tunnelHeight);
				for (var j:int = 0; j < tunnelHeight; j++) {
					grid[i][j] = -1;
				}
			}
		}
		
		public function SetTunnelTile(posX:int, posY:int, type:int):void {
			this.tiles.setTile(posX, posY, type);
			grid[posX][posY] = type;
		}
		
		public function GetBlockInTile(gX:int, gY:int):TunnelBlock {
			var pX:int = gX - this.gridX;
			var pY:int = gY - this.gridY;
			
			var type:int = grid[pX][pY];
			return manager.GetBlock(type);
		}
		public function CheckPassage(gX:int, gY:int, dir:String):Boolean {
			var block:TunnelBlock = GetBlockInTile(gX, gY);
			if (dir == "left") {
				return block.left;
			}
			else if (dir == "right") {
				return block.right;
			}
			else if (dir == "up") {
				return block.up;
			}
			else if (dir == "down") {
				return block.down;
			}
			return false;
		}
		
		
		public function Clone():Tunnel {
			var t:Tunnel = new Tunnel(tunnelWidth, tunnelHeight, manager);
			for (var i:int = 0; i < tunnelWidth; i++) {
				for (var j:int = 0; j < tunnelHeight; j++)  {
					if (grid[i][j] != -1) {
						t.SetTunnelTile(i, j, grid[i][j] );
					}
				}
			}
			return t;
		}
	}

}