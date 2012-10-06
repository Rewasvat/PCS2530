package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class Digger extends Entity
	{
		[Embed(source="../assets/player.png")] private const PLAYER_GRAPHIC:Class;
		public var image:Image;
		
		public function Digger()
		{
			image = new Image(PLAYER_GRAPHIC);
			graphic = image;
			setHitbox(100, 100, 0, 70);
		}
		
		override public function update():void
		{
			//trace("Digger Entity updates.");
			if (Input.check(Key.RIGHT))
			{
				x += 100 * FP.elapsed;
			}
			if (Input.check(Key.LEFT))
			{
				x -= 100 * FP.elapsed;
			}
			if (Input.check(Key.UP))
			{
				y -= 100 * FP.elapsed;
			}
			if (Input.check(Key.DOWN))
			{
				y += 100 * FP.elapsed;
			}
			
			super.update();
		}
		
	}
}