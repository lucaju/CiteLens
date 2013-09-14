package model {
	
	//imports
	import model.library.Country;
	import model.library.CountryLibrary;
	import model.library.Language;
	import model.library.LanguageLibrary;
	import model.library.PubType;
	import model.citation.CitationContentType;
	import model.citation.CitationFunction;
	import model.citation.CitationCategory;
	import model.citation.CitationReason;
	import model.citation.CitationType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Session {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var bibliography				:Bibliography
		
		protected var languageCollection		:Array;
		protected var countryCollection			:Array;
		protected var pubTypeCollection			:Array;
		protected var citationFunctionLibrary	:Array;
		
		protected var filters					:Array;
		
		protected var language					:Language;
		protected var country					:Country;
		protected var pubType					:PubType;
		protected var citationFunction			:CitationFunction;
		
		protected var filter					:Filter;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param bib
		 * 
		 */
		public function Session(bib:Bibliography) {
			
			bibliography = bib;
			
			languageCollection = new Array();
			countryCollection = new Array();
			pubTypeCollection = new Array();
			citationFunctionLibrary = new Array();
			
			filters = new Array();
			
			var repeated:Boolean = false;
			
			//loop in bibliography
			for each(var ref:RefBibliographic in bibliography.getBibligraphy()) {
				
				repeated = false;
				
				var langInReference:Language = LanguageLibrary.getLangInfo(ref.language)
				
				//-------Language
				//test for repetition
				for each (language in languageCollection) {
					
					if (langInReference.name.toLowerCase() == language.name.toLowerCase() ||			//test name
						langInReference.name.toLowerCase() == language.iso6391.toLowerCase() ||			//or iso 6391
						langInReference.name.toLowerCase() == language.iso6392.toLowerCase()) {			//or iso 6392 
						
						repeated = true;
						break;
					}
				}
				
				//add new language
				if (!repeated) languageCollection.push(langInReference);
				
				
				//-------Country
				repeated = false;
				//test for repetition
				for each (var item:String in ref.countries) {
					
					var countryInReference:Country = CountryLibrary.getCountryInfo(item);
					
					for each (country in countryCollection) {
						
						if (countryInReference.name.toLowerCase() == country.name.toLowerCase() ||			//test name
							countryInReference.name.toLowerCase() == country.alpha2.toLowerCase() ||		// or alpha 2
							countryInReference.name.toLowerCase() == country.alpha3.toLowerCase()) {		// or alpha 3
							
							repeated = true;  	//test name
							break;
						}
						
					}
				}
					
				//add new country
				if (!repeated) countryCollection.push(countryInReference);
				
				
				//-------Pub Type
				repeated = false;
				//test for repetition
				for each (pubType in pubTypeCollection) {
					
					if (ref.type.toLowerCase() == pubType.code.toLowerCase()) {
						repeated = true;
						break;
					}
					
					if (ref.type.toLowerCase() == pubType.name.toLowerCase()) {
						repeated = true;
						break;
					}
				}
				
				//add new pub type
				if (!repeated) {
					pubType = new PubType(pubTypeCollection.length, ref.type);
					pubTypeCollection.push(pubType);
				}
			}
			
			//-------Functions of Citation
			citationFunction = new CitationFunction(CitationType.PRIMARY,CitationCategory.SIMPLE);
			citationFunction.addOption(CitationContentType.FACT)
			citationFunction.addOption(CitationContentType.OPINION);
			citationFunctionLibrary.push(citationFunction);
			
			
			citationFunction = new CitationFunction(CitationType.SECONDARY,CitationCategory.COMPLEX);
			
			citationFunction.addSubFunction(CitationReason.SUPPORT);
			citationFunction.addOptionToSubFunction(CitationReason.SUPPORT,CitationContentType.FACT);
			citationFunction.addOptionToSubFunction(CitationReason.SUPPORT,CitationContentType.OPINION);
			
			citationFunction.addSubFunction(CitationReason.REJECT);
			citationFunction.addOptionToSubFunction(CitationReason.REJECT,CitationContentType.FACT);
			citationFunction.addOptionToSubFunction(CitationReason.REJECT,CitationContentType.OPINION);
			
			citationFunction.addSubFunction(CitationReason.NEITHER);
			citationFunction.addOptionToSubFunction(CitationReason.NEITHER,CitationContentType.FACT);
			citationFunction.addOptionToSubFunction(CitationReason.NEITHER,CitationContentType.OPINION);
			
			citationFunction.addSubFunction(CitationReason.BOTH);
			citationFunction.addOptionToSubFunction(CitationReason.BOTH,CitationContentType.FACT);
			citationFunction.addOptionToSubFunction(CitationReason.BOTH,CitationContentType.OPINION);
			citationFunctionLibrary.push(citationFunction);
			
			citationFunction = new CitationFunction(CitationType.FURTHER_READING,CitationCategory.SIMPLE);
			citationFunction.addOption("Yes")
			citationFunction.addOption("No");
			citationFunctionLibrary.push(citationFunction);
		
		}
		
		
		//****************** PUBLIC METHODS - FILTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function addFilter(id:uint):void {
			filter = new Filter(id);
			filters[id] = filter;
		}
		
		/**
		 * 
		 * @param id
		 * @param data
		 * 
		 */
		public function updateFilter(id:uint, data:Object):void {
			if (filters[id] == null) addFilter(id);
			filters[id].update(data);
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function removeFilter(filterID:int):void {
			filters[filterID] = null;
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			return filters[filterID].hasSelectedOptions(type);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @param option
		 * @return 
		 * 
		 */
		public function checkSelectedFilterOption(filterID:int, type:String, option:Object):Boolean {
			return filters[filterID].checkSelectedOption(type, option);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			return filters[filterID].getOptionsByType(type);
		}
		
		/**
		 * 
		 * @param filterID
		 * @return 
		 * 
		 */
		public function getFilterByID(filterID:int):Filter {
			return filters[filterID];
		}
		
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLanguages(showAll:Boolean):Array {
			if (showAll) {
				return LanguageLibrary.getLanguages();
			} else {
				return languageCollection.concat();
			}
		}
		
		/**
		 * 
		 * @param requestID
		 * @return 
		 * 
		 */
		public function getLanguageByID(requestID:int):Language {
			for each (language in languageCollection) {
				if (language.id == requestID) return language;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCountries(showAll:Boolean):Array {
			if (showAll) {
				return CountryLibrary.getCountries();
			} else {
				return countryCollection.concat();
			}
		}
		
		/**
		 * 
		 * @param requestID
		 * @return 
		 * 
		 */
		public function getCountryByID(requestID:int):Country {
			for each (country in countryCollection) {
				if (country.id == requestID) return country;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPubTypes():Array {
			return pubTypeCollection.concat();
		}
		
		/**
		 * 
		 * @param requestID
		 * @return 
		 * 
		 */
		public function getPubTypeByID(requestID:int):PubType {
			for each (pubType in pubTypeCollection) {
				if (pubType.id == requestID) return pubType;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCitationFunctions():Array {
			return citationFunctionLibrary.concat();
		}
	}
}