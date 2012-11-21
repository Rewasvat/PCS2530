package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import utils.Constants;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Gold extends BaseGameObj 
	{
		[Embed(source = '../assets/Gold.png')] private const GOLD:Class;
		
		public function Gold(gridX:int=0, gridY:int=0) 
		{
			graphic = new Image(GOLD);
			setHitbox(Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			type = "gold";
			this.gridX = gridX;
			this.gridY = gridY;
			layer = 1;
			
		}
		
	}

}