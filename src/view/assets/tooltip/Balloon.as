package view.assets.tooltip {
	
	//imports
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Balloon extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var balloon			:Sprite;
		
		protected var round				:Number = 10;				// Round corners
		
		protected var arrow				:Sprite;
		protected var arrowDirection	:String = "bottom";			// Arrow point direction	
		protected var arrowWidth		:Number = 10;				// Balloon's arrow point width
		protected var arrowHeight		:Number = 5;				// Balloon's arrow point height
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * @param h
		 * 
		 */
		public function Balloon(w:Number, h:Number) {
			
			super();
			
			//draw balloon
			balloon = new Sprite();
			balloon.graphics.beginFill(0xFFFFFF,1);
			balloon.graphics.drawRoundRect(0,0,w,h,round,round);
			balloon.graphics.endFill();
			
			addChild(balloon)
			
			//draw arrow
			arrow = new Sprite();
			arrow.graphics.beginFill(0xFFFFFF,1);
			arrow.graphics.moveTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(0,arrowHeight/2);
			arrow.graphics.lineTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.endFill();
			
			addChild(arrow)
			
			arrow.x = balloon.x + balloon.width/2;
			arrow.y = balloon.y + balloon.height + arrow.height/2;
			
			//effects
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x000000, .5);
			fxs.push(fxGlow);
			this.filters = fxs;
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param orient
		 * 
		 */
		public function changeOrientation(orient:String):void {
			switch(orient) {
				case "top":
					arrow.scaleY = -1;
					arrow.y = arrow.height/2;
					balloon.y = arrow.y + arrow.height/2;
					break;
			}
		}
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function arrowOffsetH(offset:Number):void {
			arrow.x += -offset;
		}
		

		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @return 
		 * 
		 */
		protected function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 6;
			var blurY:Number = 6;
			var strength:Number = 3;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
	}
}