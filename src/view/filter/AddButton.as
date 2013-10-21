package view.filter {
	
	//imports
	import flash.display.Sprite;
	
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AddButton extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _filterID						:int;
		
		protected var shape							:Sprite;
		protected var cross							:Sprite;
		
		protected var color							:uint;
		
		protected var shapeW						:Number = 155;
		protected var shapeH						:Number = 20;
		protected var shapeRound					:Number = 6;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function AddButton(id:int = 3) {
			_filterID = id;
			color = ColorSchema.getColor("filter"+filterID);
			
			shapeW = 34;
			shapeH = 20;
			shapeRound = 6;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//shape
			shape = new Sprite();
			shape.graphics.beginFill(color);
			shape.graphics.drawRoundRect(0,0,shapeW,shapeH,shapeRound);
			shape.graphics.endFill();
			this.addChild(shape);
			
			//cross
			cross = new Sprite();
			cross.graphics.beginFill(0xFFFFFF);
			cross.graphics.drawRect(-1,-4,2,8);
			cross.graphics.drawRect(-4,-1,8,2);
			cross.graphics.drawRect(-1,-1,2,2);
			cross.graphics.endFill();
			cross.alpha = .9;
			cross.x = shape.width/2;
			cross.y = shape.height/2;
			
			this.addChild(cross);
			
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		
		//****************** Initialize ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get filterID():int {
			return _filterID;
		}

		
	}
}