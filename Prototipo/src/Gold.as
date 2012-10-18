package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class Gold extends Entity 
	{
		[Embed(source = 'assets/Gold.png')] private const GOLD:Class;
		
		public function Gold() 
		{
			graphic = new Image(GOLD);
			setHitbox(32, 32);
			type = "gold";
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