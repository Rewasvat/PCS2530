package worlds
{
	import entities.HUD;
	import entities.Tunnel;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import flash.ui.Mouse;
	import entities.BaseGameObj;
	import entities.Player;
	import entities.Cursor;
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
		public var player:Player;
		public var map:GameMap;
		private var fog:Fog;
		private var cursor:Cursor;
		private var hud:HUD;
		private var tunnelManager:TunnelManager;
		private var placingTunnel:Boolean ;
		private var tunnelIndex:int;
		private var tunnelObj:Tunnel;
		private var caveInCounter:Number;
		private var caveInLimit:Number;
		private var cavingIn:Boolean;
		private var totalRisk:Number;
		
		public var grid:Vector.<Vector.<BaseGameObj>>;
		private var riskMatrix:Vector.<Vector.<Number>>;
		
		
		public function GameWorld() 
		{
			tunnelManager = new TunnelManager();
			placingTunnel = false;
			tunnelIndex = 0;
			tunnelObj = null;
			caveInCounter = 0;
			caveInLimit = 1;
			cavingIn = false;
			totalRisk = 0;
			Mouse.hide();
			
			map = new GameMap;
			grid = new Vector.<Vector.<BaseGameObj>>(Constants.MAP_WIDTH);
			riskMatrix = new Vector.<Vector.<Number>>(Constants.MAP_WIDTH);
			var i:int;
			for (i=0; i < Constants.MAP_WIDTH; i++) {
				grid[i] = new Vector.<BaseGameObj>(Constants.MAP_HEIGHT);
				riskMatrix[i] = new Vector.<Number>(Constants.MAP_HEIGHT);
			}
			
			if (Math.random() > 0.5) {
				entryPoint = BaseGameObj.CreateDummy(0, randInt(1, Constants.MAP_HEIGHT - 2));
				map.setTile(entryPoint.gridX, entryPoint.gridY, GameMap.POINT_HORIZONTAL);
				map.setTile(entryPoint.gridX+1, entryPoint.gridY, GameMap.NONE);
				exitPoint = BaseGameObj.CreateDummy(Constants.MAP_WIDTH - Constants.BORDER_SIZE, randInt(1, Constants.MAP_HEIGHT - 2));
				exitPoint.type = "exit";
				map.setTile(exitPoint.gridX, exitPoint.gridY, GameMap.POINT_HORIZONTAL);
			}
			else {
				entryPoint = BaseGameObj.CreateDummy(randInt(1, Constants.MAP_WIDTH - 2), 0);
				map.setTile(entryPoint.gridX, entryPoint.gridY, GameMap.POINT_VERTICAL);
				map.setTile(entryPoint.gridX, entryPoint.gridY+1, GameMap.NONE);
				exitPoint = BaseGameObj.CreateDummy(randInt(1, Constants.MAP_WIDTH - 2), Constants.MAP_HEIGHT - Constants.BORDER_SIZE);
				exitPoint.type = "exit";
				map.setTile(exitPoint.gridX, exitPoint.gridY, GameMap.POINT_VERTICAL);
			}
			
			addToGrid(entryPoint);
			addToGrid(exitPoint);
			
			player = new Player(entryPoint.gridX, entryPoint.gridY);
			fog = new Fog(player);
			cursor = new Cursor;
			hud = new HUD();
			
			add(map);
			add(player);
			generateEntities();
			add(fog);
			add(cursor);
			add(hud);
			
			removeFromGrid(entryPoint); /*this might need to be changed*/
			UpdateMap();
			fog.ClearFogIn(exitPoint.gridX, exitPoint.gridY, Constants.VISION_RANGE);
		}
		private function randInt(start:int, end:int, useOffset:Boolean = true):int {
			var a:int = start;
			var b:int = end;
			if (useOffset) {
				a += Constants.SPAWN_OFFSET;
				b -= Constants.SPAWN_OFFSET;
			}
			return a + int(Math.random() * (b - a));
		}
		private function generateEntities():void {
			var i:int;
			for (i = 0; i < 20;i++) {
				//var rock:Rock = new Rock();
				setGridPosForObj(GameMap.ROCK);
				//add(rock);
				//map.setTile(rock.gridX, rock.gridY, GameMap.ROCK);
			}
			for (i = 0; i < 15;i++) {
				//var gold:Gold = new Gold();
				setGridPosForObj(GameMap.GOLD);
				//add(gold);
				//map.setTile(gold.gridX, gold.gridY, GameMap.GOLD);
			}
		}
		private function setGridPosForObj(type:int):void {
			var x:int, y:int;
			while (true) {
				x = FP.rand(Constants.MAP_WIDTH - Constants.BORDER_SIZE*2) + Constants.BORDER_SIZE;
				y = FP.rand(Constants.MAP_HEIGHT - Constants.BORDER_SIZE*2) + Constants.BORDER_SIZE;
				
				if (map.getTile(x-1, y-1) == GameMap.DIRT && 
					map.getTile(x-1, y) == GameMap.DIRT &&
					map.getTile(x-1, y+1) == GameMap.DIRT &&
					map.getTile(x, y-1) == GameMap.DIRT &&
					map.getTile(x, y) == GameMap.DIRT &&
					map.getTile(x, y+1) == GameMap.DIRT &&
					map.getTile(x+1, y-1) == GameMap.DIRT &&
					map.getTile(x+1, y) == GameMap.DIRT &&
					map.getTile(x+1, y+1) == GameMap.DIRT) {
						
					map.setTile(x, y, type);
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
		
		override public function update():void {
			super.update();
			//UpdateMap();
			UpdateTunnelCreation();
			player.canMove = !placingTunnel;
			
			if (cavingIn) {
				if (caveInCounter > caveInLimit) {
					trace("FAILED");
					hud.SetEndText("FAILED");
					cavingIn = false;
				}
				camera.x = randInt( -Constants.CAVEIN_SHAKE_SIZE, Constants.CAVEIN_SHAKE_SIZE, false);
				camera.y = randInt( -Constants.CAVEIN_SHAKE_SIZE, Constants.CAVEIN_SHAKE_SIZE, false);
				caveInCounter += FP.elapsed;
			}
			else {
				camera.x = 0;
				camera.y = 0;
			}
		}
		
		public function UpdateMap():void {
			if (map.getTile(player.gridX, player.gridY) == GameMap.GOLD) {
				player.gold_amount += 1;
			}
			map.PlayerMovedTo(player.gridX, player.gridY);
			
			if (checkTunnelPath()) {//(player.IsNear(exitPoint)) {
				trace("TUNNEL COMPLETED!");
				hud.SetEndText("COMPLETED!");
			}
			
			totalRisk = 0;
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
				caveInCounter = 0;
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
						else if (map.getTile(x, y) == GameMap.ROCK) {//grid[x][y] && grid[x][y].type == "rock") {
							risk += Constants.ROCK_RISK;
						}
						else if (map.getTile(x, y) == GameMap.DIRT) {
							risk += Constants.DIRT_RISK;
						}
						else if (map.getTile(x, y) == GameMap.GOLD) {
							risk += Constants.GOLD_RISK;
						}
						else if (map.getTile(x, y) == GameMap.BORDER) {
							risk += Constants.BORDER_RISK;
						}
						else if (map.getTile(x, y) == GameMap.NONE) {
							risk += Constants.NONE_RISK;
						}
					}
				}
			}
			return risk;
		}
		public function getRiskPercentage():Number {
			return totalRisk / Constants.RISK_THRESHOLD;
		}
		public function getCaveInPercentage():Number {
			return caveInCounter / caveInLimit;
		}
		
		
		private function checkTunnelPath():Boolean {
			var queue:Vector.<BaseGameObj> = new Vector.<BaseGameObj>;
			var pathMatrix:Vector.<Vector.<BaseGameObj>> = new Vector.<Vector.<BaseGameObj>>(Constants.MAP_WIDTH);
			var i:int;
			for (i=0; i < Constants.MAP_WIDTH; i++) {
				pathMatrix[i] = new Vector.<BaseGameObj>(Constants.MAP_HEIGHT);
			}
			
			/* Place first coord in the queue */
			queue.push( BaseGameObj.CreateDummy(entryPoint.gridX, entryPoint.gridY) );
			var obj:BaseGameObj;
			while (queue.length > 0) {
				/* grab coord from queue */
				obj = queue.shift();
				/* check if we already passed in it */
				if (pathMatrix[obj.gridX][obj.gridY] != null) {
					continue;
				}
				pathMatrix[obj.gridX][obj.gridY] = obj;
				
				/* check if we reached destination */
				if (obj.IsNear(exitPoint)) {
					return true;
				}
				
				/* if this coord is a tunnel, check if we can go to adjacent tiles */
				var left:Boolean = true;
				var right:Boolean = true;
				var up:Boolean = true;
				var down:Boolean = true;
				if (isTunnelIn(obj.gridX, obj.gridY)) {
					var t:Tunnel = grid[obj.gridX][obj.gridY] as Tunnel;
					var tb:TunnelBlock = t.GetBlockInTile(obj.gridX, obj.gridY);
					left = tb.left;
					right = tb.right;
					up = tb.up;
					down = tb.down;
				}
				
				/* check and place adjacent coords in the queue */
				if (CTPaux(obj.gridX - 1, obj.gridY, "right") && left) {
					queue.push( BaseGameObj.CreateDummy(obj.gridX - 1, obj.gridY) );
				}
				if (CTPaux(obj.gridX + 1, obj.gridY, "left") && right) {
					queue.push( BaseGameObj.CreateDummy(obj.gridX + 1, obj.gridY) );
				}
				if (CTPaux(obj.gridX, obj.gridY - 1, "down") && up) {
					queue.push( BaseGameObj.CreateDummy(obj.gridX, obj.gridY - 1) );
				}
				if (CTPaux(obj.gridX, obj.gridY + 1, "up") && down) {
					queue.push( BaseGameObj.CreateDummy(obj.gridX, obj.gridY + 1) );
				}
			}
			/* search is over and no path to exit was found */
			return false;
		}
		private function CTPaux(x:int, y:int, dir:String):Boolean {
			if (map.getTile(x, y) == GameMap.NONE) {
				if (grid[x][y] != null && grid[x][y].type == "tunnel") {
					var t:Tunnel = grid[x][y] as Tunnel;
					return t.CheckPassage(x, y, dir);
				}
				else if (grid[x][y] != null && grid[x][y].type == "exit") {
					return true
				}
				else {
					return true;
				}
			}
			return false;
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
			if (!Input.mouseWheel) {
				return;
			}
			var delta:int = Input.mouseWheelDelta;
			if (!placingTunnel) {
				if (delta < 0) {
					tunnelIndex--;
					if (tunnelIndex < 0) {
						tunnelIndex = tunnelManager.tunnels.length - 1;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
				}
				else if (delta > 0) {
					tunnelIndex++;
					if (tunnelIndex >= tunnelManager.tunnels.length) {
						tunnelIndex = 0;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
				}
			}
			else {
				if ( delta < 0) {
					tunnelIndex--;
					if (tunnelIndex < 0) {
						tunnelIndex = tunnelManager.tunnels.length - 1;
					}
					trace("Tunnel Index = " + tunnelIndex.toString());
					resetTunnelObj();
				}
				else if ( delta > 0) {
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
			if (map.getTile(x, y) == GameMap.ROCK ||
				map.getTile(x, y) == GameMap.BORDER ) {
				return false;
			}
			if (grid[x][y]) {
				if (grid[x][y].type == "tunnel") {
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
			if (map.getTile(x, y) == GameMap.ROCK ||
				map.getTile(x, y) == GameMap.BORDER ||
				map.getTile(x, y) == GameMap.POINT_HORIZONTAL ||
				map.getTile(x, y) == GameMap.POINT_VERTICAL ) {
				return false;
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
		
		public function isTunnelIn(gx:int, gy:int):Boolean {
			if (gx < 0 || gx >= Constants.MAP_WIDTH || gy < 0 || gy >= Constants.MAP_HEIGHT) {
				return false;
			}
			if (grid[gx][gy] != null && grid[gx][gy].type == "tunnel") {
				return true;
			}
			return false;
		}
	}

}