package model.library {
	
	//import
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Country {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;
		protected var _name				:String;
		protected var _alpha2			:String;
		protected var _alpha3			:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * @param value
		 * 
		 */
		public function Country(id_:int,
								name_:String,
								alpha2_:String,
								alpha3_:String) {
			_id = id_;
			_name = name_;
			_alpha2 = alpha2_;
			_alpha3 = alpha3_;
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
				case "alpha2":
					return alpha2;
					break;
				
				case "alpha3":
					return alpha3;
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
		public function get alpha2():String {
			return _alpha2;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get alpha3():String {
			return _alpha3;
		}


	}
}