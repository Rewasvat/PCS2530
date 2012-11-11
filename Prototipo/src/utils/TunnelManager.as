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
		private var sets:Vector.<Tunnel>;
		private var blocks:Vector.<TunnelBlock>
		
		public function TunnelManager() 
		{
			sets = new Vector.<Tunnel>;
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
			var i:int = 0;
			
			/* lendo os blocos */
			for (i = 0; i < data.blocks.block.length(); i++) {
				blocks.push( new TunnelBlock(data.blocks.block[i].@index, 
											data.blocks.block[i].@up,
											data.blocks.block[i].@down,
											data.blocks.block[i].@left,
											data.blocks.block[i].@right) );
			}
			
			
			/* lendo os tuneis */
			for (i = 0; i < data.sets.set.length(); i++) {
				var t:Tunnel = new Tunnel(data.sets.set[i].@width, data.sets.set[i].@height, this);
				for (var j:int = 0; i < data.sets.set[i].piece.length(); i++)
			}
			
			this.heroName = xmlData.name;
			this.description = xmlData.description;
			this.currentHP = this.maxHP = xmlData.hp;
			this.currentAP = this.maxAP = xmlData.ap;
			this.regenRateAP = xmlData.ap_regen_rate;
			this.apPerMove = xmlData.ap_per_move;
			this.initiative = xmlData.initiative;
			this.sprite = new BitmapFileMaterial("Data/Graphics/hero_" + xmlData.graphics + ".png");
			sprite.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.loadHero);
			
			skillList.push(new HeroSkill(xmlData.abilities.ability[0] + ".xml", this) );
			//skillList.push(new HeroSkill(xmlData.abilities.ability[1] + ".xml", this) );
			//skillList.push(new HeroSkill(xmlData.abilities.ability[2] + ".xml", this) );
			//skillList.push(new HeroSkill(xmlData.abilities.ability[3]+".xml", this) );
			loaded = true;
			
			setReady();
			dispatchEvent(new Event(FINISHED_LOAD));
		}
	}

}