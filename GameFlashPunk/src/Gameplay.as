package
{
	import net.flashpunk.World;
	public class Gameplay extends World
	{
		public function Gameplay()
		{
			trace("Gameplay Word constructor.");
		}
		override public function begin():void
		{
			add(new Digger);
			add(new Rock());
			add(new Tunnel);
			super.begin;
		}
	}
}