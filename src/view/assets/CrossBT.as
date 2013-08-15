package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CrossBT extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape			:Shape;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param color
		 * 
		 */
		public function CrossBT(color:uint = 0xFFFFFF) {
			
			super();
			
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
			shape.graphics.drawRect(-1,-4,2,8);
			shape.graphics.drawRect(-4,-1,8,2);
			shape.graphics.drawRect(-1,-1,2,2);
			
			/*
			shape.graphics.lineStyle(1.5,0xFFFFFF);
			shape.graphics.moveTo(-2,-2);
			shape.graphics.lineTo(2,2);
			shape.graphics.moveTo(2,-2);
			shape.graphics.lineTo(-2,2);
			*/
			shape.graphics.endFill();
			
			shape.rotation = 45;
			
			this.addChild(shape);
		}

	}
}