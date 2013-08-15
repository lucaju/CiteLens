package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CitationFunction {
		
		//****************** Properties ****************** ****************** ******************
		
		static public const UNIQUE			:String		 = "unique";
		static public const SIMPLE			:String		 = "simple";
		static public const COMPLEX			:String		 = "complex";
		
		static protected var _id			:int		 = 0;
		
		protected var _label				:String;
		protected var _type					:String;
		protected var _subFunctions			:Array;
		protected var subFunc				:CitationFunction;
		protected var _options				:Array;
		protected var _value				:Boolean	 = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param label_
		 * @param type_
		 * 
		 */
		public function CitationFunction(label_:String, type_:String = UNIQUE) {
			
			//inital values
			_id = _id++;
			_label = label_;
			type = type_;
			
			//If unique
			if (type == UNIQUE) value = false;
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param label
		 * 
		 */
		public function addSubFunction(label:String):void {
			if (!_subFunctions) _subFunctions = new Array();
			
			subFunc = new CitationFunction(label);
			_subFunctions.push(subFunc);
			
			//change to complex type
			if (type != COMPLEX) type = COMPLEX;
			
			subFunc = null;
		}
		
		/**
		 * 
		 * @param label
		 * @param value
		 * 
		 */
		public function addOption(label:String, value:Boolean):void {
			if (!_options) _options = new Array();
			
			var option:Object = new Object();
			option.label = label;
			option.value = value;
			_options.push(option);
			
			//change to complex type
			if (type != SIMPLE) type = SIMPLE;
			
			option = null;
		}
		
		/**
		 * 
		 * @param subFunctionLabel
		 * @param label
		 * @param value
		 * 
		 */
		public function addOptionToSubFunction(subFunctionLabel:String, label:String, value:Boolean):void {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					subFunc.addOption(label, value);
					break;
				}
			}
			
		}
		
		/**
		 * 
		 * @param subFunctionLabel
		 * @param value
		 * 
		 */
		public function setSubFunctionValue(subFunctionLabel:String, value:Boolean):void {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					subFunc.value = value;
					break;
				}
			}
			
		}
		
		/**
		 * 
		 * @param subFunctionLabel
		 * @return 
		 * 
		 */
		public function getSubFunctionValue(subFunctionLabel:String):Boolean {
			
			var subFunc:CitationFunction;
			
			for each(subFunc in subFunctions) {
				if (subFunc.label == subFunctionLabel) {
					return subFunc.value;
				}
			}
			
			return null;
			
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
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
		public function get label():String {
			return _label;
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
		public function get value():Boolean {
			return _value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set value(value:Boolean):void {
			_value = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasSubFunctions():Boolean {
			if (subFunctions) return true;
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get subFunctions():Array {
			if (_subFunctions) return _subFunctions.concat();
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasOptions():Boolean {
			if (options) return true;
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get options():Array {
			if (_options) return _options.concat()
			return null;
		}

	}
}