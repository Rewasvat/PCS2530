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
	public class Rock extends BaseGameObj 
	{
		[Embed(source = '../assets/rock1.png')] private const ROCK:Class;
		
		public function Rock(gridX:int = 0, gridY:int = 0) 
		{
			graphic = new Image(ROCK);
			setHitbox(Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			type = "rock";
			this.gridX = gridX;
			this.gridY = gridY;
			layer = 1;
			
		}
		
		public function destroy():void
		{
			world.remove(this);
		}
		
	}

}