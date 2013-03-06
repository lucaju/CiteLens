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
			
			//Languages
			if (data.languages) {
				_languages = data.languages;
			}
			
			//Countries
			if (data.countries) {
				_countries = data.countries;
			}
			
			//Pub Type
			if (data.pubTypes) {
				_pubTypes = data.pubTypes;
			}
			
			//Period
			if (data.periods) {
				_periods = data.periods;
			}
			
			//Functions
			if (data.functions) {
				_functions = data.functions;
			}
			
			//Authors
			if (data.auhtors) {
				_authors = data.auhtors;
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
			
			switch (type) {
				
				case "Language":
					collection = _languages;
					break;
				
				case "Country":
					collection = _countries;
					break;
				
				case "Publication Type":
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

	}
}