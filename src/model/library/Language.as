package model.library {
	
	//import
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Language {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id			:int;
		protected var _name			:String;
		protected var _iso6391		:String;
		protected var _iso6392		:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * @param value
		 * 
		 */
		public function Language(id_:int,
								name_:String,
								iso6391_:String,
								iso6392_:String) {
			
			_id = id_;
			_name = name_;
			_iso6391 = iso6391_;
			_iso6392 = iso6392_;
		}

		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		public function getCode(value:String):String {
			switch (value) {
				case "iso6391":
					return iso6391;
					break;
				
				case "iso6392":
					return iso6392;
					break;
				
				default:
					return name;
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
		 * @return 
		 * 
		 */
		public function get iso6391():String {
			return _iso6391;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get iso6392():String {
			return _iso6392;
		}


	}
}