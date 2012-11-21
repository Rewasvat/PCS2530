package utils 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import entities.Tunnel;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class TunnelManager 
	{
		public var tunnels:Vector.<Tunnel>;
		private var blocks:Vector.<TunnelBlock>;
		
		public function TunnelManager() 
		{
			tunnels = new Vector.<Tunnel>;
			blocks = new Vector.<TunnelBlock>;
			LoadTunnels();
		}
		
		private function LoadTunnels():void {
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest("Tunnel.xml"));
			loader.addEventListener(Event.COMPLETE, this.finishLoad);
		}
		private function finishLoad(e:Event):void {
			var data:XML = new XML(e.target.data);
			var i:int = 0, j:int;
			
			/* lendo os blocos */
			for (i = 0; i < data.blocks.block.length(); i++) {
				blocks.push( new TunnelBlock(data.blocks.block[i].@index, 
											Boolean(parseInt(data.blocks.block[i].@up)),
											Boolean(parseInt(data.blocks.block[i].@down)),
											Boolean(parseInt(data.blocks.block[i].@left)),
											Boolean(parseInt(data.blocks.block[i].@right))) );
			}
			
			/* lendo os tuneis */
			for (i = 0; i < data.tunnels.tunnel.length(); i++) {
				var t:Tunnel = new Tunnel(parseInt(data.tunnels.tunnel[i].@width),
										  parseInt(data.tunnels.tunnel[i].@height), this);
				for (j = 0; j < data.tunnels.tunnel[i].piece.length(); j++) {
					t.SetTunnelTile(parseInt(data.tunnels.tunnel[i].piece[j].@posX),
									parseInt(data.tunnels.tunnel[i].piece[j].@posY),
									parseInt(data.tunnels.tunnel[i].piece[j].@type));
				}
				tunnels.push(t);
			}
		}
		
		public function GetBlock(type:int):TunnelBlock {
			for (var i:int = 0; i < blocks.length; i++) {
				if (blocks[i].index == type) {
					return blocks[i];
				}
			}
			return null;
		}
	}

}