package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Filter {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:uint;
		protected var _languages		:Array;
		protected var _countries		:Array;
		protected var _pubTypes			:Array;
		protected var _periods			:Array;
		protected var _functions		:Array;
		protected var _authors			:Array;
		protected var _empty			:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * 
		 */
		public function Filter(id_:uint) {
			//initialize
			_id = id_;
			
			_languages = new Array();
			_countries = new Array();
			_pubTypes = new Array();
			_periods = new Array();
			_functions = new Array();
			_authors = new Array();
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function update(data:Object):void {
			
			var filterCount:int = 0;
			
			//Languages
			if (data.languages) {
				_languages = data.languages;
				filterCount++;
			} else {
				_languages = [];
			}
			
			//Countries
			if (data.countries) {
				_countries = data.countries;
				filterCount++;
			} else {
				_countries = [];
			}
			
			//Pub Type
			if (data.pubTypes) {
				_pubTypes = data.pubTypes;
				filterCount++;
			} else {
				_pubTypes = [];
			}
			
			//Period
			if (data.periods) {
				_periods = data.periods;
				filterCount++;
			} else {
				_periods = [];
			}
			
			//Functions
			if (data.functions) {
				_functions = data.functions;
				filterCount++;
			} else {
				_functions = [];
			}
			
			//Authors
			if (data.auhtors) {
				_authors = data.auhtors;
				filterCount++;
			} else {
				_authors = [];
			}
			
			if (filterCount == 0) {
				empty = true;
			} else {
				empty = false;
			}
			
		}
		
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */
		public function hasSelectedOptions(type:String):Boolean {
			var typeCollection:Array = getOptionsByType(type);
			
			if (typeCollection.length > 0) {
				return true;
			} else {
				return false;
			}
		}
		
		public function checkSelectedOption(type:String, option:Object):Boolean {
			
			var typeCollection:Array = getOptionsByType(type);
			
			for each (var item:Object in typeCollection) {
				if (item.id == option.id) return true;
			}
			
			return false;
		}
		
		public function getOptionsByType(type:String):Array {
			var collection:Array;
			
			switch (type.toLowerCase()) {
				
				case "language":
					collection = _languages;
					break;
				
				case "country":
					collection = _countries;
					break;
				
				case "publication type":
					collection = _pubTypes;
					break;
				
				case "period":
					collection = _periods;
					break;
				
				case "function":
					collection = _functions;
					break;
				
				case "author":
					collection = _authors;
					break;
			}
			
			return collection;	
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():uint {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLanguagesID():Array {
			return _languages.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCountriesID():Array {
			return _countries.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPubTypesID():Array {
			return _pubTypes.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPeriods():Array {
			return _periods.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFunctions():Object {
			return _functions;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getAuthors():Object {
			return _authors;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get empty():Boolean {
			return _empty;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set empty(value:Boolean):void {
			_empty = value;
		}

	}
}