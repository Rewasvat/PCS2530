package  
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Thiago Yashiro
	 */
	public class MyWorld extends World 
	{
		
		public function MyWorld() 
		{
			var i:int;
			add(new TestLevel);
			add(new Player);
			for (i = 0; i < 80;i++)
			add(new Rock);
			for (i = 0; i < 15;i++)
			add(new Gold);
			add(new Fog);
		}
		
	}

}