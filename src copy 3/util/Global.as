package util {
	
	public class Global {
		
		//properties
		private static var _globalWidth:Number;
		private static var _globalHeight:Number;
		
		public function Global() {
			
		}
		
		
		public static function get globalWidth():Number {
			return _globalWidth;
		}

		public static function set globalWidth(value:Number):void {
			_globalWidth = value;
		}

		public static function get globalHeight():Number {
			return _globalHeight;
		}

		public static function set globalHeight(value:Number):void {
			_globalHeight = value;
		}
	}
}