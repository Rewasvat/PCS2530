package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.GameWorld;
	import utils.Constants;

	public class Main extends Engine
	{
		public function Main()
		{
			super(Constants.GAME_WIDTH, Constants.GAME_HEIGHT, 60, false);
			FP.world = new GameWorld;
		}

		override public function init():void
		{
			trace("FlashPunk has started successfully!");
		}
	}
}