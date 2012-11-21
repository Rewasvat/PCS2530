package worlds
{
	import entities.Tunnel;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import entities.BaseGameObj;
	import entities.Gold;
	import entities.Player;
	import entities.Rock;
	import utils.Fog;
	import utils.GameMap;
	import utils.Constants;
	import utils.TunnelBlock;
	import utils.TunnelManager;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class GameWorld extends World 
	{
		private var player:Player;
		public var map:GameMap;
		private var tunnelManager:TunnelManager;
		private var placingTunnel:Boolean ;
		private var tunnelIndex:int;
		private var tunnelObj:Tunnel;
		
		public var grid:Vector.<Vector.<BaseGameObj>>;
		
		public function GameWorld() 
		{
			tunnelManager = new TunnelManager();
			placingTunnel = false;
			tunnelIndex = 0;
			tunnelObj = null;
			
			map = new GameMap;
			grid = new Vector.<Vector.<BaseGameObj>>(Constants.MAP_WIDTH);
			var i:int;
			for (i=0; i < Constants.MAP_WIDTH; i++) {
				grid[i] = new Vector.<BaseGameObj>(Constants.MAP_HEIGHT);
			}
			
			player = new Player(3, 8);
			grid[3][8] = player; // we only need this when generating the map, remove it later
			
			add(map);
			add(player);
			for (i = 0; i < 10;i++) {
				var rock:Rock = new Rock();
				setGridPosForObj(rock);
				add(rock);
			}
			for (i = 0; i < 15;i++) {
				var gold:Gold = new Gold();
				setGridPosForObj(gold);
				add(gold);
			}
			add(new Fog(player) );
			
			grid[3][8] = null;
		}
		
		private function setGridPosForObj(obj:BaseGameObj):void {
			var x:int, y:int;
			while (true) {
				x = FP.rand(Constants.MAP_WIDTH - Constants.BORDER_SIZE*2) + Constants.BORDER_SIZE;
				y = FP.rand(Constants.MAP_HEIGHT - Constants.BORDER_SIZE*2) + Constants.BORDER_SIZE;
				
				if (!grid[x][y]) {
					grid[x][y] = obj;
					obj.gridX = x;
					obj.gridY = y;
					break;
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			UpdateMap();
			UpdateTunnelCreation();
			player.canMove = !placingTunnel;
			if (Input.pressed(Key.ESCAPE)) {
				/*TODO: fechar o jogo...? */
			}
		}
		
		public function UpdateMap():void {
			map.PlayerMovedTo(player.gridX, player.gridY);
		}
		
		public function UpdateTunnelCreation():void {
			if (!placingTunnel) {
				if (Input.pressed(Key.T)) {
					placingTunnel = true;
					resetTunnelObj();
				}
			}
			else {
				tunnelObj.gridX = int(Input.mouseX/Constants.TILE_WIDTH);
				tunnelObj.gridY = int(Input.mouseY/Constants.TILE_HEIGHT);
				if (checkForTunnelPlacement()) {
					trace("trying to place tunnel");
					tunnelObj.color = 0x00ff00;
					if (Input.mousePressed) {
						trace("tunnel created!");
						addTunnel();
						tunnelObj = null;
						placingTunnel = false;
					}
				}
				else if (Input.pressed(Key.T)) {
					placingTunnel = false;
					remove(tunnelObj);
					tunnelObj = null;
				}
				else {
					tunnelObj.color = 0xff0000;
				}
			}
			HandleTunnelIndex();
		}
		private function HandleTunnelIndex():void {
			if (!placingTunnel) {
				if (Input.pressed(Key.R)) {
					tunnelIndex--;
					if (tunnelIndex < 0) {
						tunnelIndex = tunnelManager.tunnels.length - 1;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
				}
				else if (Input.pressed(Key.Y)) {
					tunnelIndex++;
					if (tunnelIndex >= tunnelManager.tunnels.length) {
						tunnelIndex = 0;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
				}
			}
			else {
				if (Input.pressed(Key.R)) {
					tunnelIndex--;
					if (tunnelIndex < 0) {
						tunnelIndex = tunnelManager.tunnels.length - 1;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
					resetTunnelObj();
				}
				else if (Input.pressed(Key.Y)) {
					tunnelIndex++;
					if (tunnelIndex >= tunnelManager.tunnels.length) {
						tunnelIndex = 0;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
					resetTunnelObj();
				}
			}
		}
		private function resetTunnelObj():void {
			if (tunnelObj) {
				remove(tunnelObj);
			}
			tunnelObj = tunnelManager.tunnels[tunnelIndex].Clone();
			add(tunnelObj);
		}
		private function checkForTunnelPlacement():Boolean {
			var gX:int, gY:int;
			for (var i:int = 0; i < tunnelObj.tunnelWidth; i++) {
				for (var j:int = 0; j < tunnelObj.tunnelHeight; j++)  {
					gX = tunnelObj.gridX + i;
					gY = tunnelObj.gridY + j;
					var tb:TunnelBlock = tunnelObj.GetBlockInTile(gX, gY);
					if ( tunnelObj.GetBlockInTile(gX, gY) && (map.getTile(gX, gY) != GameMap.NONE || grid[gX][gY]) ) {
						return false;
					}
				}
			}
			return true;
		}
		private function addTunnel():void {
			var gX:int, gY:int;
			for (var i:int = 0; i < tunnelObj.tunnelWidth; i++) {
				for (var j:int = 0; j < tunnelObj.tunnelHeight; j++)  {
					gX = tunnelObj.gridX + i;
					gY = tunnelObj.gridY + j;
					if ( tunnelObj.GetBlockInTile(gX, gY) ) {
						grid[gX][gY] = tunnelObj;
						tunnelObj.color = 0xffffff;
					}
				}
			}
		}
		
		private function canGoToFrom(x:int, y:int, dir:String):Boolean {
			if (grid[x][y]) {
				if ( grid[x][y].type == "rock") {
					return false;
				}
				else if (grid[x][y].type == "tunnel") {
					/*TODO: checar se da pra passar*/
					var t:Tunnel = grid[x][y] as Tunnel;
					return t.CheckPassage(x, y, dir);
				}
			}
			return true;
		}
		public function canGoTo(x:int, y:int):Boolean {
			if (map.getTile(x, y) == GameMap.NONE) {
				/*Target tile is already opened, does not matter if player can go or not*/
			}
			if (grid[x][y]) {
				if ( grid[x][y].type == "rock") {
					return false;
				}
			}
			
			if ( (map.getTile(x - 1, y) == GameMap.NONE) && canGoToFrom(x - 1, y, "right") ||
				 (map.getTile(x + 1, y) == GameMap.NONE) && canGoToFrom(x + 1, y, "left") ||
				 (map.getTile(x, y - 1) == GameMap.NONE) && canGoToFrom(x, y - 1, "down") ||
				 (map.getTile(x, y + 1) == GameMap.NONE) && canGoToFrom(x, y + 1, "up") )
			{
				return true;
			}
			return false;
		}
	}

}