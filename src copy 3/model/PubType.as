package model {
	
	//imports
	import model.dictionay.DicPubTypes;
	
	public class PubType {
		
		//properties
		private var _id:int;
		private var _code:String;
		private var _code3:String;
		private var _code4:String;
		private var _name:String;
		
		public function PubType(id_:int, value:String) {
			_id = id_;
			
			//check with the dictionary
			fillInfo(DicPubTypes.getPubTypeInfo(value));
		}
		
		private function fillInfo(info:Object):void {
			
			//add code
			if (!code) {
				code = info.code;
			}
			
			//add code
			if (!code3) {
				code3 = info.code3;
			}
			
			//add code
			if (!code4) {
				code4 = info.code4;
			}
			
			//add name
			if (!name) {
				name = info.name;
			}
		}

		public function get id():int {
			return _id;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get code():String {
			return _code;
		}
		
		public function set code(value:String):void {
			_code = value;
		}

		public function get code3():String {
			return _code3;
		}

		public function set code3(value:String):void {
			_code3 = value;
		}
		
		public function get code4():String {
			return _code4;
		}
		
		public function set code4(value:String):void {
			_code4 = value;
		}
		
		public function getCode(value:String):String {
			switch (value) {
				case "code":
					return _code;
					break;
				
				case "code3":
					return _code3;
					break;
				
				case "code4":
					return _code4;
					break;
				
				default:
					return null;
					break;
			}
		}


	}
}