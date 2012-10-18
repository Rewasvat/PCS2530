package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Rock extends Entity 
	{
		[Embed(source = 'assets/rock1.png')] private const ROCK:Class;
		
		public function Rock() 
		{
			graphic = new Image(ROCK);
			setHitbox(32, 32);
			type = "rock";
			x = (3+FP.rand(19))*32;
			y = (3+FP.rand(13)) * 32;
			layer = 1;
			
		}
		
		public function destroy():void
		{
			world.remove(this);
		}
		
	}

}