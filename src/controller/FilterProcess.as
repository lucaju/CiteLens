package controller {
	
	//imports
	import model.Filter;
	import model.Note;
	import model.RefBibliographic;
	import model.citation.CitationContentType;
	import model.citation.CitationFunction;
	import model.citation.CitationReason;
	import model.citation.CitationType;
	import model.library.Country;
	import model.library.Language;
	import model.library.PubType;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FilterProcess {
		
		//****************** Properties ****************** ****************** ******************
		
		public static const BIBL_ID		:String	 = "bibl_id";
		public static const NOTE_ID		:String	 = "note_id";
		
		public static var results		:Array	 = new Array();
		
		protected var _bibliography		:Array;
		protected var resultArray		:Array;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function FilterProcess() {
			resultArray = new Array;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function combineResults():Array {
			var combo:Array = new Array();
			
			var i:int;
			
			for(i = 0 ; i< results.length; i++) {
				if (results[i] is Array) {
					combo = combo.concat(results[i]);
				}
			}
			
			//remove duplicates
			for (i = combo.length; i > 0; i--){
				if (combo.indexOf(combo[i-1]) != i-1) {
					combo.splice(i-1,1);
				}
			}
			
			return combo;
		}
		
		/**
		 * 
		 * @param filterID
		 * @return 
		 * 
		 */
		protected function notesResults(filterID:int):Array {
			
			resultArray = results[filterID];
			
			var resultNotes:Array = new Array();
			
			for each(var bib:RefBibliographic in resultArray) {
				
				//trace (bib.uniqueID + ": " + bib.title + " - " + bib.language)
				
				var notes:Array = bib.notes;
				var note:Object
				
				for each(note in notes) {
					resultNotes.push(note);
				}
				
				//trace ("*********")
			}
			
			//organize
			resultNotes.sortOn("id",Array.NUMERIC);
			
			//remove duplicates
			var uniqueNotes:Array =  removeDuplicates(resultNotes);
			
			return uniqueNotes;
		}
		
		/**
		 * 
		 * @param target
		 * @return 
		 * 
		 */
		protected function removeDuplicates(target:Array):Array {
			
			var uniqueArray:Array = new Array();
			
			var duplicated:Boolean = false;
			var note:Object
			
			for each(note in target) {
				for each(var uniqueNote:Object in uniqueArray) {
					if (uniqueNote is Object) {
						//trace (note.id +" - "+ uniqueNote.id)
						if (note.id == uniqueNote.id) {
							duplicated = true;
							break;
						}
					}
					
				}
				
				
				if (!duplicated) {
					uniqueArray.push(note);
					
				}
				
				duplicated = false;
			}
			
			return uniqueArray
		}
		
		/**
		 * 
		 * @param selectedLanguages
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterLanguage(selected:Array, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop selected languages
				for each(var lang:Language in selected) {
					
					//compare
					if (bib.language.toLowerCase() == lang.name.toLocaleLowerCase() ||
						bib.language.toLowerCase() == lang.iso6391.toLowerCase() ||
						bib.language.toLowerCase() == lang.iso6392.toLowerCase()) {
						
						partialResults.push(bib);
						break;
					}
				}
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param selectedCountries
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterCountries(selected:Array, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop Countries
				for each(var bibCountry:String in bib.countries) {
					
					//loop selected countries
					for each(var countr:Country in selected) {
						
						//compare
						if (bibCountry.toLowerCase() == countr.name.toLowerCase() ||
							bibCountry.toLowerCase() == countr.alpha2.toLocaleLowerCase()  ||
							bibCountry.toLowerCase() == countr.alpha3.toLocaleLowerCase()) {
							
							partialResults.push(bib);
							break;
						}
						
					}
				}
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param selected
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterPubTypes(selected:Array, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop selected pubtypes
				for each(var pubType:PubType in selected) {
					
					//compare
					if (bib.type.toLowerCase() == pubType.name.toLowerCase() ||
						bib.type.toLowerCase() == pubType.code.toLocaleLowerCase()) {
						
						partialResults.push(bib);
						break;
					}
				}
				
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param selected
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterPeriod(selected:Array, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop selected periods
				for each(var period:Object in selected) {
					
					//compare
					if (bib.date >= period.from && bib.date <= period.to) {
						partialResults.push(bib);
						break;
					}
					
				}
				
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param citationFunction
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterPrimaryRole(citationFunction:CitationFunction, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			var options:Array = citationFunction.options;
			const FACT		:Object = options[0];
			const OPINION	:Object = options[1];
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//Check Source Role
				if (bib.sourceRole.toLowerCase() == "primary") {
					
					//loop notes 
					for each(var note:Object in bib.notes) {
						
						//Check for FACT & OPINION
			
						if (!FACT.value && !OPINION.value) {															//if BOTH are NOT SELECTED
							partialResults.push(bib);
						} else if (FACT.value && !OPINION.value && note.contentType == CitationContentType.FACT) {		//if FACT is SELECTED and OPINION is NOT SELECTED
							partialResults.push(bib);
						} else if (!FACT.value && OPINION.value && note.contentType == CitationContentType.OPINION) {	//if FACT is NOT SELECTED and OPINION is SELECTED
							partialResults.push(bib);
						}
						
					}
				}
				
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param citationFunction
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterSecondaryRole(citationFunction:CitationFunction, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			var subFunctions:Array = citationFunction.subFunctions;
			var FACT:Object;
			var OPINION:Object;
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//Check Source Role
				if (bib.sourceRole.toLowerCase() == "secondary") {
					
					//loop notes 
					for each(var note:Object in bib.notes) {
						
						var selectedSubFuncs:int = subFunctions.length;		//count how many subfunctions is active in the filter.
						
						//Loop subfucntions
						for each (var subFunc:CitationFunction in subFunctions) {
							
							//check if subFunction is Selected
							if (subFunc.value == true) {
								
								//Check subFucntion Label (Reason)
								if (note.reason.toLowerCase() == subFunc.label.toLowerCase()) {
									
									FACT = subFunc.options[0];
									OPINION = subFunc.options[1];
									
									//Check for FACT & OPINION
									
									if (!FACT.value && !OPINION.value) {															//if BOTH are NOT SELECTED
										partialResults.push(bib);
									} else if (FACT.value && !OPINION.value && note.contentType == CitationContentType.FACT) {		//if FACT is SELECTED and OPINION is NOT SELECTED
										partialResults.push(bib);	
									} else if (!FACT.value && OPINION.value && note.contentType == CitationContentType.OPINION) {	//if FACT is NOT SELECTED and OPINION is SELECTED
										partialResults.push(bib);
									}
								}
								
							} else {
								selectedSubFuncs--;
							}
						}
						
						//trace (selectedSubFuncs)
						
						//if none of the subfunctions is selected, add them all;
						if (selectedSubFuncs == 0) partialResults.push(bib);
						
					}
					
				}
				
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param citationFunction
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterFurtherReading(citationFunction:CitationFunction, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			var options:Array = citationFunction.options;
			const YES	:Object = options[0];
			const NO	:Object = options[1];
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop notes 
				for each(var note:Object in bib.notes) {
					
					//Check for YES & NO
					
					if (!YES.value && !NO.value) {												//if BOTH are NOT SELECTED
						partialResults.push(bib);												
					} else if (YES.value && !NO.value && note.furtherReading == "true") {		//if YES is SELECTED and NO is NOT SELECTED
						partialResults.push(bib);												
					} else if (!YES.value && NO.value && note.furtherReading == "false") {		//if YES is SELECTED and NO is NOT SELECTED
						partialResults.push(bib);													
					}
					
				}
			}
			
			return partialResults;
		}
		
		/**
		 * 
		 * @param selected
		 * @param filteredBib
		 * @return 
		 * 
		 */
		protected function filterAuthor(selected:Array, filteredBib:Array):Array {
			
			var partialResults:Array = new Array();
			
			//loop bibliography
			for each(var bib:RefBibliographic in filteredBib) {
				
				//loop Authors
				for each(var bibAuthor:Object in bib.authors) {
					
					//loop selected authors
					for each(var auth:String in selected) {
						
						//author full name
						var fullName:String = bibAuthor.firstName + " " + bibAuthor.lastName;
						
						//compare (if the substring given by the user is contained in the author's name)
						if (fullName.toLowerCase().indexOf(auth.toLowerCase()) > -1) {
							partialResults.push(bib);
							break;
						}
						
					}
				}
			}
			
			return partialResults;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param filter
		 * 
		 */
		public function process(filter:Filter):void {
			
			var bib:RefBibliographic;
			var filteredBib:Array;
			
			if (filter.empty == true) {
				filteredBib = [];
			} else {
				filteredBib = []//bibliography;
			}
			
			//to remove
			var partialFilteredBib:Array = new Array();
			
			
			//****************** LANGUAGE ******************
			var languages:Array = filter.getOptionsByType("language");
			
			if (languages.length > 0) {
				if (filteredBib.length == 0) filteredBib = bibliography;
				var filteredByLanguage:Array = this.filterLanguage(languages, filteredBib);
				/*if (filteredByLanguage.length > 0)*/ filteredBib = filteredByLanguage;
			}
			
			
			//****************** COUNTRY ******************
			var countries:Array = filter.getOptionsByType("country");
			
			if (countries.length > 0) {
				if (filteredBib.length == 0) filteredBib = bibliography;
				var filteredByCountries:Array = this.filterCountries(countries, filteredBib);
				/*if (filteredByCountries.length > 0)*/ filteredBib = filteredByCountries;
			}
			
			
			//****************** PUB TYPE ******************
			var pubtypes:Array = filter.getOptionsByType("publication type");
			
			if (pubtypes.length > 0) {
				if (filteredBib.length == 0) filteredBib = bibliography;
				var filteredByPubType:Array = this.filterPubTypes(pubtypes, filteredBib);
				/*if (filteredByPubType.length > 0)*/ filteredBib = filteredByPubType;
			}
			
			
			//****************** PERIOD ******************
			var periods:Array = filter.getOptionsByType("period");
			
			if (periods.length > 0) {
				if (filteredBib.length == 0) filteredBib = bibliography;
				var filteredByPeriod:Array = this.filterPeriod(periods, filteredBib);
				/*if (filteredByPeriod.length > 0)*/ filteredBib = filteredByPeriod;
			}
			
			
			//****************** CITATION FUNCTION ******************
			
			var functionON	:Boolean = true;
			var primaryON	:Boolean = true;
			var secondaryON	:Boolean = true;
			var furtherON	:Boolean = true;
			
			if (functionON) {
				
				var functions:Array = filter.getOptionsByType("function");
				
				if (functions.length > 0) {
					
					var ref:RefBibliographic;
					var filteredBiblFunct:Array = new Array();
				
					for each(var citationFunction:CitationFunction in functions) {
						
						//check if function is ON
						if (citationFunction.value) {
							
							var filteredFunction:Array = new Array();
						
							switch (citationFunction.label) {
								
								//****************** PRIMARY ******************
								case CitationType.PRIMARY:
									if (primaryON) {
										//filteredFunction = this.filterPrimaryRole(citationFunction, filteredBib);
										
										if (filteredBib.length == 0) filteredBib = bibliography;
										var primary:Array = this.filterPrimaryRole(citationFunction, filteredBib);
										for each (ref in primary) {
											filteredBiblFunct.push(ref);
										}
										
									}
									break;
								
								//****************** SECONDARY ******************
								case CitationType.SECONDARY:
									if (secondaryON) {
										//filteredFunction = this.filterSecondaryRole(citationFunction, filteredBib);
										
										if (filteredBib.length == 0) filteredBib = bibliography;
										var secondary:Array = this.filterSecondaryRole(citationFunction, filteredBib);
										for each (ref in secondary) {
											filteredBiblFunct.push(ref);
										}
									
									}
									break;
								
								//****************** FURTHER READING ******************
								case CitationType.FURTHER_READING:
									if (furtherON) {
										
										// AND further reading (REMOVE those that doesn't fullfil the requeriment)
										filteredBiblFunct = this.filterFurtherReading(citationFunction, filteredBiblFunct);
									
										// OR further reading (ADD those that fullfil the requeriment)
										/*
										if (filteredBib.length == 0) filteredBib = bibliography;
										var further:Array = this.filterFurtherReading(citationFunction, filteredBib);
										for each (ref in further) {
											filteredBiblFunct.push(ref);
										}
										*/
										
										
									}
									break;
								
							}
							
							//save
							/*if (filteredFunction.length > 0)*/ //filteredBib = filteredFunction;
							
						}
						
					}
					
					//trace (filteredBiblFunct.length)
					//save
					if (filteredBiblFunct.length > 0) filteredBib = filteredBiblFunct;
					
				}
				
			}
			
			
			//****************** AUTHOR ******************
			var authors:Array = filter.getOptionsByType("author");
			
			if (authors.length > 0) {
				var filteredByAuthor:Array = this.filterAuthor(authors, filteredBib);
				/*if (filteredByAuthor.length > 0)*/ filteredBib = filteredByAuthor;
			}
			
			
			//****************** Wrap up ******************
			
			//grab
			resultArray = filteredBib;
			
			//organize
			resultArray.sortOn("id",Array.NUMERIC);
			
			//remove duplicates
			var uniqueNotes:Array =  removeDuplicates(resultArray);
			
			//saving
			var filterID:int = filter.id;
			results[filterID] = uniqueNotes;
			
			resultArray = null;
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function removeResults(filterID:int = 0):void {
			
			if (filterID == 0) {
				for each(var res:Array in results) {
					res = null;
				}
				
				results = new Array();
				
			} else {
				results[filterID] = null;
			}
		}
		
		/**
		 * 
		 * @param type
		 * @param filterID
		 * @return 
		 * 
		 */
		public function getResult(type:String, filterID:int = 0):Array {
			
			//get one filter result or combine all of them
			if (filterID == 0) {
				resultArray = combineResults()
			} else {
				resultArray = results[filterID];
			}
			
			switch (type) {
				
				case NOTE_ID:
					return notesResults(filterID);
					break;
				
				case BIBL_ID:
					return resultArray;
					break;
				
				default:
					return resultArray;
					break;
			}
		}		
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bibliography():Array {
			return _bibliography;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bibliography(value:Array):void {
			_bibliography = value;
		}	
	
	}
}