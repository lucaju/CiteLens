package view.filter {
	
	//imports
	import model.citation.CitationCategory;
	import model.citation.CitationFunction;
	import model.library.Country;
	import model.library.Language;
	import model.library.PubType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FilterPanelOutput {
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		static public function traceSelectedOption(data:Object):void {
			
			trace ("**************")
			trace ("SELECTED FILTERS")
			trace ("**************")
			
			
			//Language
			trace ("LANGUAGES:")
			var selecLang:Array = data.languages;
			for each (var language:Language in selecLang) {
				trace (language.name)
			}
			
			trace ("==============")
			
			//Countries
			trace ("COUNTRIES:")
			var selecCountries:Array = data.countries;
			for each (var country:Country in selecCountries) {
				trace (country.name)
			}
			
			trace ("==============")
			
			//Pub Type
			trace ("PUBLICATION TYPE:")
			var selecPubType:Array = data.pubTypes;
			for each (var pubType:PubType in selecPubType) {
				trace (pubType.name)
			}
			
			trace ("==============")
			
			//periods
			trace ("PERIODS:")
			var selecPeriods:Array = data.periods;
			for each (var periods:Object in selecPeriods) {
				trace ("From: " + periods.from + " - To: " + periods.to)
			}
			
			trace ("==============")
			
			//functions
			trace ("FUNCTIONS:")
			var selecFunctions:Array = data.functions;
			
			var subFunct:Object;
			var opt:Object;
			
			for each (var func:CitationFunction in selecFunctions) {
				
				trace (func.label + " (" + func.category + ")" + " : " + func.value)
				var subFunctions:Array = func.subFunctions;
				var options:Array = func.options;
				
				switch (func.category) {
					
					case CitationCategory.SIMPLE:
						for each (opt in options) {
							trace (" - " + opt.label + ": " + opt.value)
						}
						break;
					
					case CitationCategory.COMPLEX:
						
						for each (subFunct in subFunctions) {
						
							trace (" - " + subFunct.label + " : " + subFunct.value)
							
							
							//suboptions
							var subOptions:Array = subFunct.options;
							
							for each (var subOpt:Object in subOptions) {
								
								var subParams:Array = subOpt.options;
								
								trace (" ---- " + subOpt.label + ": " + subOpt.value);
								
							}
							
						}
						
						break;
					
				}
				
				trace ("--------------")
				
			}
			
			trace ("==============")
			
			//Authors
			trace ("AUTHORS:")
			var selecAuthors:Array = data.auhtors;
			for each (var author:String in selecAuthors) {
				trace (author)
			}
			
			trace ("**************")
		}
	}
}