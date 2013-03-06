package model {
	
	public class Session {
		
		//properties
		private var bibliography:Bibliography
		
		private var languageLibrary:Array;
		private var CountryLibrary:Array;
		private var pubTypeLibrary:Array;
		private var citationFunctionLibrary:Array;
		
		private var filters:Array;
		
		private var language:Language;
		private var country:Country;
		private var pubType:PubType;
		private var citationFunction:CitationFunction;
		
		private var filter:Filter;
		
		public function Session(bib:Bibliography) {
			
			bibliography = bib;
			
			languageLibrary = new Array();
			CountryLibrary = new Array();
			pubTypeLibrary = new Array();
			citationFunctionLibrary = new Array();
			
			filters = new Array();
			
			//loop in bibliography
			for each(var ref:RefBibliographic in bibliography.getBibligraphy()) {
				
				var repeated:Boolean = false;
				
				//-------Language
				//test for repetition
				for each (language in languageLibrary) {
					
					if (ref.language.toLowerCase() == language.name.toLowerCase()) {
						repeated = true;
						break;
					}
					
					if (ref.language.toLowerCase() == language.code2.toLowerCase()) {
						repeated = true;
						break;
					}
					
					if (ref.language.toLowerCase() == language.code3.toLowerCase()) {
						repeated = true;
						break;
					}
				}
				
				//add new language
				if (!repeated) {
					language = new Language(languageLibrary.length, ref.language);
					languageLibrary.push(language);
				}
				
				
				//-------Country
				repeated = false;
				//test for repetition
				for each (var item:String in ref.countries) {
					for each (country in CountryLibrary) {
						
						if (item.toLowerCase() == country.name.toLowerCase()) {  			//test name
							repeated = true;
						}
						
						if (item.toLowerCase() == country.code2.toLowerCase()) {			//test code2
							repeated = true;
						}
							
						if (item.toLowerCase() == country.code3.toLowerCase()) {			//test code3
							repeated = true;
						}
					}
					
					//add new country
					if (!repeated) {
						country = new Country(CountryLibrary.length, item);
						CountryLibrary.push(country);
					}
				
				}
			
				
				//-------Pub Type
				repeated = false;
				//test for repetition
				for each (pubType in pubTypeLibrary) {
					if (ref.type == pubType.code) {
						repeated = true;
						break;
					}
					
					if (ref.type == pubType.name) {
						repeated = true;
						break;
					}
				}
				
				//add new pub type
				if (!repeated) {
					pubType = new PubType(pubTypeLibrary.length, ref.type);
					pubTypeLibrary.push(pubType);
				}
			}
			
			//-------Functions of Citation
			citationFunction = new CitationFunction("Primary Source",CitationFunction.SIMPLE);
			citationFunction.addOption("Fact", false)
			citationFunction.addOption("Opinion", false);
			citationFunctionLibrary.push(citationFunction);
			
			citationFunction = new CitationFunction("Secondary Source",CitationFunction.COMPLEX);
			citationFunction.addSubFunction("Support");
			citationFunction.addOptionToSubFunction("Support","Fact", false);
			citationFunction.addOptionToSubFunction("Support","Opinion", false);
			citationFunction.addSubFunction("Reject");
			citationFunction.addOptionToSubFunction("Reject","Fact", false);
			citationFunction.addOptionToSubFunction("Reject","Opinion", false);
			citationFunction.addSubFunction("Neither");
			citationFunction.addOptionToSubFunction("Neither","Fact", false);
			citationFunction.addOptionToSubFunction("Neither","Opinion", false);
			citationFunction.addSubFunction("Both");
			citationFunction.addOptionToSubFunction("Both","Fact", false);
			citationFunction.addOptionToSubFunction("Both","Opinion", false);
			citationFunctionLibrary.push(citationFunction);
			
			citationFunction = new CitationFunction("Further Reading",CitationFunction.SIMPLE);
			citationFunction.addOption("Yes", false)
			citationFunction.addOption("No", false);
			citationFunctionLibrary.push(citationFunction);
		
		}
		
		//----------- filter
		
		public function addFilter(id:uint):void {
			filter = new Filter(id);
			filters[id] = filter;
		}
		
		public function updateFilter(id:uint, data:Object):void {
			//trace(data);
			
			if (filters[id] == null) {
				addFilter(id);
			}
				filters[id].update(data);
		}
		
		public function removeFilter(filterID:int):void {
			filters[filterID] = null;
		}
		
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			var checked:Boolean = filters[filterID].hasSelectedOptions(type);
			return checked;
		}
		
		public function checkSelectedFilterOption(filterID:int, type:String, option:Object):Boolean {
			var checked:Boolean = filters[filterID].checkSelectedOption(type, option);
			return checked;
		}
		
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			var filterOptions:Array = filters[filterID].getOptionsByType(type);
			return filterOptions;
		}
		
		public function getFilterByID(filterID:int):Filter {
			return filters[filterID];
		}
		
		//------------- GETTERS
		public function getLanguages():Array {
			return languageLibrary.concat();
		}
		
		public function getLanguageByID(requestID:int):Language {
			for each (language in languageLibrary) {
				if (language.id == requestID) {
					return language;
					break;
				}
			}
			
			return null;
		}
		
		public function getCountries():Array {
			return CountryLibrary.concat();
		}
		
		public function getCountryByID(requestID:int):Country {
			for each (country in CountryLibrary) {
				if (country.id == requestID) {
					return country;
					break;
				}
			}
			
			return null;
		}
		
		public function getPubTypes():Array {
			return pubTypeLibrary.concat();
		}
		
		public function getPubTypeByID(requestID:int):PubType {
			for each (pubType in pubTypeLibrary) {
				if (pubType.id == requestID) {
					return pubType;
					break;
				}
			}
			
			return null;
		}
		
		public function getCitationFunctions():Array {
			return citationFunctionLibrary.concat();
		}
	}
}