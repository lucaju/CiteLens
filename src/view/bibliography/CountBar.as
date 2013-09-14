package view.bibliography {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import view.assets.ShadowLine;
	import view.style.TXTFormat;
	
	public class CountBar extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var total			:int;
		protected var partial		:int;
		protected var wider			:int;
		
		protected var bg			:Sprite;
		protected var TF			:TextField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * 
		 */
		public function CountBar(w:int) {

			wider = w;
			
			bg = new Sprite();
			TF = new TextField();
			
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param t
		 * 
		 */
		public function initialize(t:int):void {
			
			total = t;
			
			//bg
			bg.graphics.beginFill(0xEEEEEE,.3);
			bg.graphics.drawRoundRect(0,0,wider-4, 16, 6);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//shadow line
			var shadow:ShadowLine = new ShadowLine(wider-4);
			shadow.rotation = 180;
			shadow.x = shadow.width;
			addChild(shadow);
			
			
			//label
			TF.width = wider - 16;
			TF.autoSize = TextFieldAutoSize.LEFT;
			TF.selectable = false;
			TF.height = 16;
			TF.defaultTextFormat = TXTFormat.getStyle("Count Total");
			TF.text = total.toString() + " references";
			TF.embedFonts = true;
			TF.antiAliasType = AntiAliasType.ADVANCED;
			
			TF.x = (this.width/2) - (TF.width/2);
			
			this.addChild(TF);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param p
		 * 
		 */
		public function update(p:int, reset:Boolean = false):void {
			
				if (reset && p == 0) {
					partial = total;
				} else {
					partial = p;
				}
				
				if (partial == total) {	
					TweenMax.to(TF, .5, {y:"5", alpha: 0, onComplete:updateData});
				} else {
					TweenMax.to(TF, .5, {y:"-5", alpha: 0, onComplete:updateData});
				}

		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function updateData():void {
			
			TF.y = 0;
			var tweenFrom:int;
			TF.alpha = 1;
			
			if (partial == total) {			
				TF.text = total.toString() + " references";
				TF.x = (this.width/2) - (TF.width/2);
				TweenMax.from(TF, .5, {y:"-5", alpha: 0, delay:.2})
			} else {
				TF.text = "filter: " + partial.toString() + " of " + total.toString() + " references";
				TF.x = (this.width/2) - (TF.width/2);
				TweenMax.from(TF, .5, {y:"5", alpha: 0})
			}
		}
		
	}
}