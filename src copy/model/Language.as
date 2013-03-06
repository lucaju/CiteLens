package model {
	
	//import
	import model.dictionay.DicLanguages;
	
	public class Language {
		
		//properties
		private var _id:int;
		private var _name:String;
		private var _code2:String;
		private var _code3:String;
		
		public function Language(id_:int, value:String) {
			_id = id_;
			
			//complete information
			fillInfo(DicLanguages.getLangInfo(value));
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

		public function get code2():String
		{
			return _code2;
		}

		public function set code2(value:String):void
		{
			_code2 = value;
		}

		public function get code3():String
		{
			return _code3;
		}

		public function set code3(value:String):void
		{
			_code3 = value;
		}


	}
}