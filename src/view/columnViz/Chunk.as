package view.columnViz {
	
	//imports
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Chunk extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int;
		protected var _type					:String = SamplePixelType.TEXT;
		protected var _numPixels			:int;
		protected var _selected				:Boolean = false;
		protected var _highlighted			:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function Chunk(id:int = 0) {
			
			_id = id;
			
		}
		
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get numPixels():int {
			return _numPixels;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set numPixels(value:int):void {
			_numPixels = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get highlighted():Boolean {
			return _highlighted;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set highlighted(value:Boolean):void {
			_highlighted = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
		}

	}
}