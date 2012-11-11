package utils 
{
	/**
	 * ...
	 * @author Omar
	 */
	public class TunnelBlock 
	{
		public var index:int;
		
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;
		
		public function TunnelBlock(index:int, up:Boolean, down:Boolean, left:Boolean, right:Boolean) 
		{
			this.index = index;
			this.up = up;
			this.down = down;
			this.left = left;
			this.right = right;
		}
		
	}

}