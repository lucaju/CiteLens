package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class MinusBT extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape		:Shape;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param color
		 * 
		 */
		public function MinusBT(color:uint = 0xFFFFFF) {
			
			//base
			shape = new Shape();
			shape.graphics.beginFill(0x000000,0);
			shape.graphics.drawCircle(0,0,5);
			shape.graphics.endFill();
			this.addChild(shape);
			
			//shape
			shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(0,0,5);
			shape.graphics.drawRect(-4,-1,8,2);
			shape.graphics.endFill();
			
			this.addChild(shape);
		}

	}
}