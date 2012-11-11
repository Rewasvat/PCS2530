package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.MyWorld;
	import utils.Constants;

	public class Main extends Engine
	{
		public function Main()
		{
			super(Constants.GAME_WIDTH, Constants.GAME_HEIGHT, 60, false);
			FP.world = new MyWorld;
		}

		override public function init():void
		{
			trace("FlashPunk has started successfully!");
		}
	}
}