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
			tiles = new Tilemap(FOG, 800, 600, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			graphic = tiles;
			tiles.setRect(0, 0, 25, 20,1);
			layer = 0;
			this.parent = parent;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (parent) {
				tiles.setRect(0, 0, 25, 20, 1);
				tiles.clearRect(parent.gridX - Constants.BORDER_SIZE, parent.gridY - Constants.BORDER_SIZE, 
								Constants.BORDER_SIZE*2+1, Constants.BORDER_SIZE*2+1);
			}
		}
	}
}