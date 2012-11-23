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
		private var entryPoint:BaseGameObj;
		private var exitPoint:BaseGameObj;
		private var player:Player;
		public var map:GameMap;
		private var fog:Fog;
		private var tunnelManager:TunnelManager;
		private var placingTunnel:Boolean ;
		private var tunnelIndex:int;
		private var tunnelObj:Tunnel;
		private var caveInCounter:Number;
		private var caveInLimit:Number;
		private var cavingIn:Boolean;
		
		public var grid:Vector.<Vector.<BaseGameObj>>;
		private var riskMatrix:Vector.<Vector.<Number>>;
		
		
		public function GameWorld() 
		{
			tunnelManager = new TunnelManager();
			placingTunnel = false;
			tunnelIndex = 0;
			tunnelObj = null;
			caveInCounter = 0;
			caveInLimit = 0;
			cavingIn = false;
			
			map = new GameMap;
			grid = new Vector.<Vector.<BaseGameObj>>(Constants.MAP_WIDTH);
			riskMatrix = new Vector.<Vector.<Number>>(Constants.MAP_WIDTH);
			var i:int;
			for (i=0; i < Constants.MAP_WIDTH; i++) {
				grid[i] = new Vector.<BaseGameObj>(Constants.MAP_HEIGHT);
				riskMatrix[i] = new Vector.<Number>(Constants.MAP_HEIGHT);
			}
			
			entryPoint = BaseGameObj.CreateDummy(Constants.BORDER_SIZE, 8);
			addToGrid(entryPoint);
			exitPoint = BaseGameObj.CreateDummy(Constants.MAP_WIDTH - Constants.BORDER_SIZE, 8);
			addToGrid(exitPoint);
			
			player = new Player(entryPoint.gridX, entryPoint.gridY);
			fog = new Fog(player);
			
			add(map);
			add(player);
			generateEntities();
			add(fog);
			
			removeFromGrid(entryPoint); /*this might need to be changed*/
			UpdateMap();
			fog.ClearFogIn(exitPoint.gridX, exitPoint.gridY, Constants.BORDER_SIZE);
		}
		private function generateEntities():void {
			var i:int;
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
		public function addToGrid(obj:BaseGameObj):void {
			grid[obj.gridX][obj.gridY] = obj;
		}
		public function removeFromGrid(obj:BaseGameObj):void {
			grid[obj.gridX][obj.gridY] = null;
		}
		
		override public function update():void 
		{
			super.update();
			//UpdateMap();
			UpdateTunnelCreation();
			player.canMove = !placingTunnel;
			
			if (cavingIn) {
				if (caveInCounter > caveInLimit) {
					trace("FAILED");
					cavingIn = false;
				}
				caveInCounter += FP.elapsed;
			}
		}
		
		public function UpdateMap():void {
			if (player.IsNear(exitPoint)) {
				trace("TUNNEL COMPLETED!");
			}
			map.PlayerMovedTo(player.gridX, player.gridY);
			
			var totalRisk:Number = 0;
			var risk:Number;
			var i:int, j:int;
			for (i = 0; i < Constants.MAP_WIDTH; i++) {
				for (j = 0; j < Constants.MAP_HEIGHT; j++) {
					if (map.getTile(i, j) == GameMap.NONE && grid[i][j] == null) {
						risk = getRiskForTile(i, j);
						totalRisk += risk;
						riskMatrix[i][j] = risk;
					}
				}
			}
			if (!cavingIn && totalRisk > Constants.RISK_THRESHOLD) {
				cavingIn = true;
				caveInCounter = 0;
				caveInLimit = Constants.DEFAULT_CAVEIN_LIMIT * (1 - (totalRisk - Constants.RISK_THRESHOLD) / Constants.RISK_THRESHOLD);
				trace("RISK TOO GREAT - STARTING CAVE IN "+caveInLimit.toString()+" seconds");
			}
			else if (cavingIn && totalRisk < Constants.RISK_THRESHOLD) {
				cavingIn = false;
				trace("NO LONGER IN RISK");
			}
			else if (cavingIn) {
				/*We are already caving in and the risk is still high - update limit */
				caveInLimit = Constants.DEFAULT_CAVEIN_LIMIT * (1 - (totalRisk - Constants.RISK_THRESHOLD) / Constants.RISK_THRESHOLD);
				trace("RISK STILL HIGH - new cave in limit is "+caveInLimit.toString()+" seconds");
			}
			trace("RISK: " + totalRisk.toString());
		}
		private function getRiskForTile(a:int, b:int):Number {
			var risk:Number = 0;
			var i:int, j:int, x:int, y:int;
			for (i = -1; i < 2; i++) {
				for (j = -1; j < 2; j++) {
					x = a + i;
					y = b + j;
					if (i != 0 && j != 0 && 
						x >= 0 && x < Constants.MAP_WIDTH &&
						y >= 0 && y < Constants.MAP_HEIGHT) {
						/****/
						if (grid[x][y] && grid[x][y].type == "tunnel") {
							risk += Constants.TUNNEL_RISK;
						}
						else if (grid[x][y] && grid[x][y].type == "rock") {
							risk += Constants.ROCK_RISK;
						}
						else if (map.getTile(x, y) == GameMap.DIRT) {
							risk += Constants.DIRT_RISK;
						}
						else if (map.getTile(x, y) == GameMap.SAND) {
							risk += Constants.SAND_RISK;
						}
						else if (map.getTile(x, y) == GameMap.NONE) {
							risk += Constants.NONE_RISK;
						}
					}
				}
			}
			return risk;
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
					//trace("trying to place tunnel");
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
					}
				}
			}
			tunnelObj.color = 0xffffff;
			UpdateMap();
		}
		
		private function canGoToFrom(x:int, y:int, dir:String):Boolean {
			if (grid[x][y]) {
				if ( grid[x][y].type == "rock") {
					return false;
				}
				else if (grid[x][y].type == "tunnel") {
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