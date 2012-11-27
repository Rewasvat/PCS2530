package entities 
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import utils.Constants;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class HUD extends BaseGameObj 
	{
		[Embed(source = '../assets/hud.png')] private const HUDIMAGE:Class;
		private var hudImage:Image;
		private var hudCollision:Pixelmask;
		
		public function get sideMenuVisible():Boolean { return this.hudImage.visible; }
		public function set sideMenuVisible(b:Boolean):void { this.hudImage.visible = b;  } 
		
		private var goldText:Text;
		private var endText:Text;
		
		private var riskBarX:Number = 0;
		private var riskBarY:Number = 0;
		private var riskBarWidth:Number = 200;
		private var riskBarHeight:Number = 22;
		private var riskText:Text;
		
		private const slot1x:Number = 10;
		private const slot1y:Number = 67;
		private const slot2x:Number = 10;
		private const slot2y:Number = 172;
		private const slot3x:Number = 10;
		private const slot3y:Number = 277;
		
		private const accr1x:Number = 12;
		private const accr1y:Number = 382;
		private const accr2x:Number = 55;
		private const accr2y:Number = 382;
		private const accr3x:Number = 31;
		private const accr3y:Number = 430;
		private const accrW:Number = 30;
		private const accrH:Number = 30;
		
		public function HUD() 
		{
			layer = -2;
			
			hudImage = new Image(HUDIMAGE);
			hudCollision = new Pixelmask(HUDIMAGE);
			graphic = hudImage;
			mask = hudCollision;
			type = "hud";
			
			goldText = new Text("Gold: N/A", 15, 30);
			goldText.color = 0xffff00;
			addGraphic(goldText);
			
			riskText = new Text("Cave-in Risk", riskBarX, riskBarY + 5);
			riskText.color = 0x0;
			riskText.align = "center";
			riskText.width = riskBarWidth;
			riskText.height = riskBarHeight;
			addGraphic(riskText);
			
			endText = new Text("", 0, 0);
			endText.align = "center";
			endText.width = Constants.GAME_WIDTH;
			endText.height = Constants.GAME_HEIGHT;
			endText.size = 70;
			endText.y = (Constants.GAME_HEIGHT / 2) - (endText.size / 2);
			endText.visible = false;
			addGraphic(endText);
		}
		
		public function SetEndText(msg:String):void {
			endText.text = msg;
			endText.visible = true;
		}
		public function RemoveEndText():void {
			endText.visible = false;
		}
		
		public function SetTunnelCoordsForMenu(t:Tunnel, index:int):void {
			var posx:int = slot1x;
			var posy:int = slot1y + index * 14 + index * 96;
			
			var w:int = t.tunnelWidth * Constants.TILE_WIDTH;
			var h:int = t.tunnelHeight * Constants.TILE_HEIGHT;
			
			t.x = posx + (92/2) - (w/2);
			t.y = posy + (96/2) - (h/2);
		}
		
		override public function update():void 
		{
			super.update();
			
			/* Updating gold text */
			var w:GameWorld = world as GameWorld;
			goldText.text = "Gold: " + w.player.gold_amount.toString();

			if (hudImage.visible && Input.mousePressed) {
				if (checkMouseInRect(slot1x, slot1y, 96, 96)) {
					w.MenuSetTunnelIndex(0);
				}
				else if (checkMouseInRect(slot2x, slot2y, 96, 96)) {
					w.MenuSetTunnelIndex(1);
				}
				else if (checkMouseInRect(slot3x, slot3y, 96, 96)) {
					w.MenuSetTunnelIndex(2);
				}
				else if (checkMouseInRect(accr1x, accr1y, accrW, accrH)) {
					w.aleatorizeTunnels();
				}
				else if (checkMouseInRect(accr2x, accr2y, accrW, accrH)) {
					w.setupFogPoint();
				}
				else if (checkMouseInRect(accr3x, accr3y, accrW, accrH)) {
					
				}
			}
		}
		private function checkMouseInRect(x:int, y:int, w:int, h:int):Boolean {
			var mx:int = Input.mouseX;
			var my:int = Input.mouseY;
			
			return (x <= mx && mx <= x + w && y <= my && my <= y+h);
		}
		override public function render():void 
		{
			super.render();
			
			var w:GameWorld = world as GameWorld;
			
			/* Rendering Risk bar */
			Draw.rectPlus(riskBarX, riskBarY, riskBarWidth, riskBarHeight, 0x808080, 1.0, true, 0, 0); // Bar background
			var riskColor:uint;
			var factor:Number = w.getRiskPercentage();
			if (factor > 1.0) {	factor = 1.0;}
			var rw:Number = factor * riskBarWidth;
			if (factor < 0.5) {
				riskColor = FP.colorLerp(0x00ff00, 0xffff00, factor*2);
			}
			else {
				riskColor = FP.colorLerp(0xffff00, 0xff0000, (factor-0.5)*2);
			}
			Draw.rectPlus(riskBarX, riskBarY, rw, riskBarHeight, riskColor, 1.0, true, 0, 0);// Bar
			factor = w.getCaveInPercentage();
			if (factor > 1.0 || factor < 0) { factor = 1.0; }
			rw = factor * riskBarWidth;
			Draw.rectPlus(riskBarX, riskBarY, rw, riskBarHeight, 0x0000ff, 1.0, true, 0, 0);// Cave In Timer Bar
			//Draw.rectPlus(riskBarX, riskBarY, riskBarWidth, riskBarHeight, 0xffffff, 1.0, false, 2, 0); // Bar border
		}
		
	}

}