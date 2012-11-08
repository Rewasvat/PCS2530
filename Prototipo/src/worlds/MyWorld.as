package worlds
{
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
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class MyWorld extends World 
	{
		private var player:Player;
		private var map:GameMap;
		
		private var grid:Vector.<Vector.<BaseGameObj>>;
		
		public function MyWorld() 
		{
			map = new GameMap;
			grid = new Vector.<Vector.<BaseGameObj>>(Constants.MAP_WIDTH);
			for (var i:int; i < Constants.MAP_WIDTH; i++) {
				grid[i] = new Vector.<BaseGameObj>(Constants.MAP_HEIGHT);
			}
			
			player = new Player(3, 8);
			grid[3][8] = player;
			
			var i:int;
			add(map);
			add(player);
			for (i = 0; i < 80;i++) {
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
			if (Input.pressed(Key.ESCAPE)) {
				/*TODO: fechar o jogo...? */
			}
		}
		
		public function UpdateMap():void {
			map.PlayerMovedTo(player.gridX, player.gridY);
		}
	}

}