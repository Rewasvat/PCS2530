package utils 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import net.flashpunk.FP;
	import entities.Tunnel;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class TunnelManager 
	{
		public var tunnels:Vector.<Tunnel>;
		private var allTunnels:Vector.<Tunnel>;
		private var blocks:Vector.<TunnelBlock>;
		
		public var maxTunnelWidth:int;
		public var maxTunnelHeight:int;
		
		public function TunnelManager() 
		{
			tunnels = new Vector.<Tunnel>;
			allTunnels = new Vector.<Tunnel>;
			blocks = new Vector.<TunnelBlock>;
			maxTunnelWidth = 0;
			maxTunnelHeight = 0;
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
				if (t.tunnelWidth > maxTunnelWidth) { maxTunnelWidth = t.tunnelWidth; }
				if (t.tunnelHeight > maxTunnelHeight) { maxTunnelHeight = t.tunnelHeight; }
				allTunnels.push(t);
			}
			
			tunnels.push( randTunnel() );
			tunnels.push( randTunnel() );
			tunnels.push( randTunnel() );
		}
		private function randTunnel():Tunnel {
			var a:int = 0;
			var b:int = allTunnels.length - 1;
			return allTunnels[a + int(Math.random() * (b - a))].Clone();
		}
		public function UpdateTunnelList(index:int):void {
			tunnels[index] = randTunnel();
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