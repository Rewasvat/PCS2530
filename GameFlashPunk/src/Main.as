package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Guilherme Toschi
	 */
	public class Main extends Engine 
	{
			
		public function Main():void 
		{
			super(800, 600, 60, false);
			trace("Game Started!");
			FP.console.enable();
		}
		
		override public function init():void
		{
			trace("FlashPunk has started successfully!");
			FP.world = new Gameplay;
			super.init();
		}
		
	}
	
}