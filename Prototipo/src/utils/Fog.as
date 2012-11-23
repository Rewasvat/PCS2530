package utils
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import entities.BaseGameObj;
	
	public class Fog extends Entity 
	{
		private var tiles: Tilemap;
		[Embed(source = '../assets/Fog.png')] private const FOG:Class;
		
		private var parent:BaseGameObj;
		
		public function Fog(parent:BaseGameObj) 
		{
			tiles = new Tilemap(FOG, Constants.GAME_WIDTH, Constants.GAME_HEIGHT, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			tiles.setRect(0, 0, Constants.MAP_WIDTH, Constants.MAP_HEIGHT,1);
			layer = 0;
			this.parent = parent;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (parent) {
				//tiles.setRect(0, 0, 25, 20, 1);
				ClearFogIn(parent.gridX, parent.gridY, Constants.VISION_RANGE);
			}
		}
		
		public function ClearFogIn(centerX:int, centerY:int, radius:int):void {
			var fogX:int;
			var fogY:int = centerY;
			var fogH:int = 1;
			for (var i:int = -radius; i <= radius; i++) {
				for (var j:int = -radius; j <= radius; j++) {
					fogX = centerX + i;
					fogY = centerY + j;
					if ( Math.abs(i) + Math.abs(j) <= radius) {
						if (fogX >= 0 && fogY >= 0 && fogX < Constants.MAP_WIDTH && fogY < Constants.MAP_HEIGHT) {
							tiles.clearTile(fogX, fogY);
						}
					}
				}
			}
		}
	}
}