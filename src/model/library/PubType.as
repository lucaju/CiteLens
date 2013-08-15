package model.library {
	
	//imports
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PubType {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id			:int;
		protected var _code			:String;
		protected var _code3		:String;
		protected var _code4		:String;
		protected var _name			:String;
		
		
		//****************** Construcor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * @param value
		 * 
		 */
		public function PubType(id_:int, value:String) {
			_id = id_;
			
			//check with the dictionary
			fillInfo(PubTypeLibrary.getPubTypeInfo(value));
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		protected function fillInfo(info:Object):void {
			
			//add code
			if (!code) code = info.code;
			
			//add code
			if (!code3) code3 = info.code3;
			
			//add code
			if (!code4) code4 = info.code4;
			
			//add name
			if (!name) name = info.name;
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
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
		public function get name():String {
			return _name;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set name(value:String):void {
			_name = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get code():String {
			return _code;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set code(value:String):void {
			_code = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get code3():String {
			return _code3;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set code3(value:String):void {
			_code3 = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get code4():String {
			return _code4;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set code4(value:String):void {
			_code4 = value;
		}


	}
}