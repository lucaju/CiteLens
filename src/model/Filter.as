package model {
	
	public class Filter {
		
		//properties
		private var _id:uint;
		private var _languages:Array;
		private var _countries:Array;
		private var _pubTypes:Array;
		private var _periods:Array;
		private var _functions:Array;
		private var _authors:Array;
		private var _empty:Boolean = false;
		
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

		public function get id():uint {
			return _id;
		}
		
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
		
		public function hasSelectedOptions(type:String):Boolean {
			var checked:Boolean;
			
			var typeCollection:Array = getOptionsByType(type);
			
			if (typeCollection.length > 0) {
				checked = true;
			} else {
				checked = false;
			}
			
			return checked;
			
		}
		
		public function checkSelectedOption(type:String, option:Object):Boolean {
			
			var checked:Boolean = false;;
			
			var typeCollection:Array = getOptionsByType(type);
			
			for each (var item:Object in typeCollection) {
				if (item.id == option.id) {
					checked = true;
					break;
				}
			}
			
			return checked;
			
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
		
		
		public function getLanguagesID():Array {
			return _languages.concat();
		}
		
		public function getCountriesID():Array {
			return _countries.concat();
		}
		
		public function getPubTypesID():Array {
			return _pubTypes.concat();
		}
		
		public function getPeriods():Array {
			return _periods.concat();
		}
		
		public function getFunctions():Object {
			return _functions;
		}
		
		public function getAuthors():Object {
			return _authors;
		}

		public function get empty():Boolean {
			return _empty;
		}

		public function set empty(value:Boolean):void {
			_empty = value;
		}


	}
}