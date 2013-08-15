package util {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Global {
		
		//****************** Properties ****************** ****************** ******************
		
		protected static var _globalWidth		:Number;
		protected static var _globalHeight		:Number;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Global() {
			
		}
		
		
		//****************** STATIC GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get globalWidth():Number {
			return _globalWidth;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set globalWidth(value:Number):void {
			_globalWidth = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get globalHeight():Number {
			return _globalHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set globalHeight(value:Number):void {
			_globalHeight = value;
		}
	}
}