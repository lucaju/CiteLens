package model {
	
	//import
	
	public class CitationFunction {
		
		//properties
		private var _id:int;
		private var _label:String;
		private var _options:Array;
		private var citationFunction:CitationFunction;
		
		
		public function CitationFunction(id_:int, value:String) {
			
			_id = id_;
			label = value;
			_options = new Array();
			
			if (value == "Secondary Source") {
				citationFunction = new CitationFunction(_options.length, "Agree");
				_options.push(citationFunction);
				citationFunction = new CitationFunction(_options.length, "Neutral");
				_options.push(citationFunction);
				citationFunction = new CitationFunction(_options.length, "Disagree");
				_options.push(citationFunction);
			} else {
				_options[0] = "Fact";
				_options[1] = "Opinion";
			}
		
		}

		public function get id():int {
			return _id;
		}

		public function get label():String {
			return _label;
		}

		public function set label(value:String):void {
			_label = value;
		}

		public function get options():Array {
			return _options;
		}
		
		public function set options(value:Array):void {
			_options = value;;
		}


	}
}