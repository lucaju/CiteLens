package view.assets {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class EjectButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape				:Sprite;
		protected var arrow						:Sprite;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function EjectButton() {
			
			//Shape
			shape = new Sprite();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 25, 45);
			shape.graphics.endFill();
			shape.alpha = .7

			this.addChild(shape);
			
			
			//arrow
			arrow = new Sprite();
			arrow.graphics.beginFill(0xFFFFFF);
			arrow.graphics.lineTo(14,0);
			arrow.graphics.lineTo(7,-7);
			arrow.graphics.lineTo(0,0);
			arrow.graphics.endFill();
			
			arrow.x = (shape.width/2) - (arrow.width/2);
			arrow.y = arrow.height * 2;
			
			this.addChild(arrow);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(shape,.5,{alpha:1});
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(shape,.5,{alpha:.7});
			
		}
	}
}