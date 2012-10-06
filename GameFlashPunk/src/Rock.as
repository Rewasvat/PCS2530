package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class Rock extends Entity
	{
		[Embed(source="../assets/ground.png")] private const PLAYER_GRAPHIC:Class;
		public var image:Image;
		
		public function Rock()
		{
			image = new Image(PLAYER_GRAPHIC);
			graphic = image;
			setHitbox(100, 100, 0, 70);
			x = FP.world.mouseX;
			y = FP.world.mouseY;
		}
		
		override public function update():void
		{
			//trace("Rosck Entity updates.");
			// Assigns the Entity's position to that of the mouse (relative to the Camera).
			//x =Input.mouseX;
			//y =Input.mouseY;
			// Assigns the Entity's position to that of the mouse (relative to the World).
			//x =FP.world.mouseX;
			//y =FP.world.mouseY;
			
			super.update();
		}
		
	}
}