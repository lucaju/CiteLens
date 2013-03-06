package model {
	
	//import
	
	public class CitationFunction {
		
		//properties
		static private var _id:int = 0;
		
		static public const UNIQUE:String = "unique";
		static public const SIMPLE:String = "simple";
		static public const COMPLEX:String = "complex";
		
		private var _label:String;
		private var _type:String;
		private var _subFunctions:Array;
		private var subFunc:CitationFunction;
		private var _options:Array;
		private var _value:Boolean = false;
		
		
		public function CitationFunction(label_:String, type_:String = UNIQUE) {
			
			//inital values
			_id = _id++;
			_label = label_;
			type = type_;
			
			//If unique
			if (type == UNIQUE) {
				value = false;
			}
		}

		public function get id():int {
			return _id;
		}

		public function get label():String {
			return _label;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		public function get value():Boolean {
			return _value;
		}
		
		public function set value(value:Boolean):void {
			_value = value;
		}

		public function get subFunctions():Array {
			if (_subFunctions) {
				return _subFunctions.concat()
			}	
			return null;
		}
		
		public function addSubFunction(label:String):void {
			if (!_subFunctions) {
				_subFunctions = new Array();
			}
			
			subFunc = new CitationFunction(label);
			_subFunctions.push(subFunc);
			
			//change to complex type
			if (type != COMPLEX) {
				type = COMPLEX
			}
			
			subFunc = null;
		}
		
		public function get options():Array {
			if (_options) {
				return _options.concat()
			}
			return null;
		}
		
		public function addOption(label:String, value:Boolean):void {
			if (!_options) {
				_options = new Array();
			}
			
			var option:Object = new Object();
			option.label = label;
			option.value = value;
			_options.push(option);
			
			//change to complex type
			if (type != SIMPLE) {
				type = SIMPLE;
			}
			
			option = null;
		}
		
		public function addOptionToSubFunction(subFunctionLabel:String, label:String, value:Boolean):void {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					break;
				}
			}
			
			subFunc.addOption(label, value);
			
			subFunc = null;
		}
		
		public function setSubFunctionValue(subFunctionLabel:String, value:Boolean):void {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					break;
				}
			}
			
			subFunc.value = value;
			
			subFunc = null;
			
		}
		
		public function getSubFunctionValue(subFunctionLabel:String):Boolean {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					break;
				}
			}
			
			subFunc = null;
			
			return subFunc.value;
			
		}
		
		public function get hasSubFunctions():Boolean {
			if (subFunctions) {
				return true;
			}	
			return false;
		}
		
		public function get hasOptions():Boolean {
			if (options) {
				return true;
			}	
			return false;
		}

	}
}