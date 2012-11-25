package entities 
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import utils.Constants;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Omar
	 */
	public class HUD extends BaseGameObj 
	{
		private var goldText:Text;
		private var endText:Text;
		
		private var riskBarX:Number = 180;
		private var riskBarY:Number = 2;
		private var riskBarWidth:Number = 300;
		private var riskBarHeight:Number = 28;
		private var riskText:Text;
		
		public function HUD() 
		{
			layer = -1;
			
			goldText = new Text("Gold Collected: N/A", 30, 7);
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
		
		override public function update():void 
		{
			super.update();
			
			/* Updating gold text */
			var w:GameWorld = world as GameWorld;
			goldText.text = "Gold Collected: " + w.player.gold_amount.toString();
		}
		override public function render():void 
		{
			var w:GameWorld = world as GameWorld;
			
			/* Rendering Risk bar */
			Draw.rectPlus(riskBarX, riskBarY, riskBarWidth, riskBarHeight, 0x808080, 0.75, true, 0, 0); // Bar background
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
			Draw.rectPlus(riskBarX, riskBarY, riskBarWidth, riskBarHeight, 0xffffff, 1.0, false, 2, 0); // Bar border
			
			super.render();
		}
		
	}

}