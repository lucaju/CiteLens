package model {
	
	//import
	import model.dictionay.DicCountries
	
	public class Country {
		
		//properties
		private var _id:int;
		private var _code2:String;
		private var _code3:String;
		private var _name:String;
		
		
		public function Country(id_:int, value:String) {
			
			_id = id_;
			
			//check with the dictionary
			fillInfo(DicCountries.getCountryInfo(value));
		}
		
		private function fillInfo(info:Object):void {
			
			//add code2
			if (!code2) {
				code2 = info.alpha2_code;
			}
			
			//add code3
			if (!code3) {
				code3 = info.alpha3_code;
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

		public function get code2():String {
			return _code2;
		}
		
		public function set code2(value:String):void {
			_code2 = value;;
		}

		public function get code3():String {
			return _code3;
		}

		public function set code3(value:String):void {
			_code3 = value;
		}
		
		public function getCode(value:String):String {
			switch (value) {
				case "code2":
					return _code2;
					break;
				
				case "code3":
					return _code3;
					break;
				
				default:
					return null;
					break;
			}
		}


	}
}