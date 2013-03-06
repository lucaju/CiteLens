package controller {
	
	//imports
	import model.CitationFunction;
	import model.Country;
	import model.Filter;
	import model.Language;
	import model.Note;
	import model.PubType;
	import model.RefBibliographic;
	
	public class FilterProcess {
		
		public static const BIBL_ID:String = "bibl_id";
		public static const NOTE_ID:String = "note_id";
		
		public static var results:Array = new Array();
		
		//properties
		private var _filter:Filter;
		private var _bibliography:Array;
		private var resultArray:Array;
		
		public function FilterProcess() {
			
			resultArray = new Array;
		}
		
		public function get filter():Filter {
			return _filter;
		}
		
		public function get bibliography():Array {
			return _bibliography;
		}
		
		public function set bibliography(value:Array):void {
			_bibliography = value;
		}
		
		public function process(filter_:Filter):void {
			
			//define filter
			_filter = filter_
			
			var bib:RefBibliographic;
			var filteredBib:Array = bibliography;
			
			if (filter.empty == true) {
				filteredBib = [];
			} else {
				filteredBib = bibliography;
			}
			
			var partialFilteredBib:Array = new Array();
			
			//----------- language
			
			
			//filter for languages
			var languages:Array = filter.getOptionsByType("language");
			
			if (languages.length > 0) {
				//looping bibliography
				for each(bib in filteredBib) {
					
					
					//looping selected languages
					for each(var lang:Language in languages) {
						
						//compare
						if (bib.language.toLowerCase() == lang.code2.toLowerCase() || bib.language.toLowerCase() == lang.code3.toLowerCase() ) {
							partialFilteredBib.push(bib);
							break;
						}
					}
				}
				
				filteredBib = partialFilteredBib;
			}
			
			
			
			//----------- country
			partialFilteredBib = new Array();
			
			//filter for countries
			var countries:Array = filter.getOptionsByType("country");
			
			if (countries.length > 0) {
				
				//looping bibliography
				for each(bib in filteredBib) {
					
					for each(var bibCountry:String in bib.countries) {
						
						//looping selected countries
						for each(var countr:Country in countries) {
							
							//compare
							if (bibCountry.toLowerCase() == countr.name.toLowerCase()) {
								partialFilteredBib.push(bib);
								break;
							}
						}
					}
				}
				
				filteredBib = partialFilteredBib;
			}
			
			
			
			//----------- pubtype
			partialFilteredBib = new Array();
			
			//filter for pubtype
			var pubtypes:Array = filter.getOptionsByType("publication type");
			
			if (pubtypes.length > 0) {
				//looping bibliography
				for each(bib in filteredBib) {
					
					//looping selected pubtypes
					for each(var pubType:PubType in pubtypes) {
						
						//compare
						if (bib.type.toLowerCase() == pubType.name.toLowerCase()) {
							partialFilteredBib.push(bib);
							break;
						}
					}
					
				}
				
				filteredBib = partialFilteredBib;
			}
			
			
			//----------- Period
			partialFilteredBib = new Array();
			
			//filter for Period
			var periods:Array = filter.getOptionsByType("period");
			
			if (periods.length > 0) {
				//looping bibliography
				for each(bib in filteredBib) {
					
					//looping selected periods
					for each(var period:Object in periods) {
						
						//compare
						if (bib.date >= period.from && bib.date <= period.to) {
							partialFilteredBib.push(bib);
							break;
						}
						
					}
					
				}
				
				filteredBib = partialFilteredBib;
			}
			
			
			//----------- Author
			partialFilteredBib = new Array();
			
			//filter for Authors
			var authors:Array = filter.getOptionsByType("author");
			
			if (authors.length > 0) {
				//looping bibliography
				for each(bib in filteredBib) {
					
					for each(var bibAuthor:Object in bib.authors) {
						
						//looping selected authors
						for each(var auth:String in authors) {
							
							//author full name
							var fullName:String = bibAuthor.firstName + " " + bibAuthor.lastName;
							
							//compare (if the substring given by the user is contained in the author's name)
							if (fullName.toLowerCase().indexOf(auth.toLowerCase()) > -1) {
								partialFilteredBib.push(bib);
								break;
							}
							
						}
					}
				}
				
				filteredBib = partialFilteredBib;
			}
			
			
			//----------- Citation Function
			/*
			partialFilteredBib = new Array();
			
			//filter for Functions
			var functions:Array = filter.getOptionsByType("function");
			
			//trace (">>" +filteredBib.length)
			
			if (functions.length > 0) {
				
				//looping bibliography
				
				for each(bib in filteredBib) {
					
					//notes looping
					for each(var note:Object in bib.notes) {

						//functions looping
						for each(var func:CitationFunction in functions) {
							
							//trace (func.label)
							
							var subFunct:Object;
							var subFunctions:Array = func.subFunctions;
							var opt:Object;
							var options:Array = func.options;
							var funcLabel:String = func.label;
							var fact:Object;				//fact
							var opinion:Object;			//opinion
							
							
								
							//** --------- PRIMARY SOURCE
							
							if (funcLabel == "Primary Source" && bib.sourceRole.toLowerCase() == "primary") {
								
								if (func.hasOptions) {
									
									fact = options[0];				//fact
									opinion = options[1];			//opinion
									
									//trace (funcLabel)
									//trace (fact.label + " clicked: " + fact.value);
									//trace (opinion.label + " clicked: " + opinion.value);
									//trace ("*****")
									
									//if BOTH are NOT SELECTED
									if (!fact.value && !opinion.value) {
										partialFilteredBib.push(bib);
									} else if (fact.value && !opinion.value && note.contentType == "fact") {
										//if FACT is SELECTED and OPINION is NOT SELECTED
										partialFilteredBib.push(bib);
									} else if (!fact.value && opinion.value && note.contentType == "opinion") {
										//if FACT is NOT SELECTED and OPINION is SELECTED
										partialFilteredBib.push(bib);
									}
								} else {
									partialFilteredBib.push(bib);
								}
								
							}
							
							
							//** --------- SECONDARY SOURCE
							if (funcLabel == "Secondary Source" && bib.sourceRole.toLowerCase() == "secondary") {
								
								
								
								
								var selectedSubFuncs:int = subFunctions.length;		//count how many subfunctions is active in the filter.
								
								for each (var subFunc:CitationFunction in subFunctions) {
									
									//trace (subFunc.label + " : " + subFunc.value)
									
									if (subFunc.value == true) {
										
										if (note.reason == subFunc.label) {
											
											fact = subFunc.options[0];
											opinion = subFunc.options[1];
											
											//support - FACT AND OPINION
											if (!fact.value && !opinion.value) {
												//if BOTH are NOT SELECTED
												partialFilteredBib.push(bib);
											} else if (fact.value && !opinion.value && note.contentType == "fact") {
												//if FACT is SELECTED and OPINION is NOT SELECTED
												partialFilteredBib.push(bib);
											} else if (!fact.value && opinion.value && note.contentType == "opinion") {
												//if FACT is NOT SELECTED and OPINION is SELECTED
												partialFilteredBib.push(bib);
											}
										}
										
									} else {
										selectedSubFuncs--;
									}
								}
								
								//trace (selectedSubFuncs)
								
								//if none of the subfunctions is selected, add them all;
								if (selectedSubFuncs == 0) {
									partialFilteredBib.push(bib);
								}
								
								/*
								trace ("ei")
								//trace (funcLabel)
								
								var support:CitationFunction = subFunctions[0];								//support
								var reject:CitationFunction = subFunctions[1];								//reject
								var neither:CitationFunction = subFunctions[2];								//neither
								var both:CitationFunction = subFunctions[3];								//both
								
								
								var supportFact:Object = support.options[0];								//support Fact
								var supportOpinion:Object = support.options[1];								//support Opinion
								
								var rejectFact:Object = reject.options[0];									//reject Fact
								var rejectOpinion:Object = reject.options[1];								//reject Opinion
								
								var neitherFact:Object = neither.options[0];								//neither Fact
								var neitherOpinion:Object = neither.options[1];								//neither Opinion
								
								var bothFact:Object = neither.options[0];									//both Fact
								var bothOpinion:Object = neither.options[1];								//both Opinion
								
								/*
								trace (support.label + " clicked: " + support.value);
								trace (reject.label + " clicked: " + reject.value);
								trace (neither.label + " clicked: " + neither.value);
								trace (both.label + " clicked: " + boths.value);
								trace ("*****")
								
								
								trace (supportFact.label)
								trace (supportOpinion.label)
								
								trace (rejectFact.label)
								trace (rejectOpinion.label)
								
								trace (neitherFact.label)
								trace (neitherOpinion.label)
								
								trace (bothFact.label)
								trace (bothOpinion.label)
								
								trace ("@@@@@@@")
								

								
								trace (!support.value && !reject.value && !neither.value && !both.value)
								
								//No reason selected - Push all
								if (!support.value && !reject.value && !neither.value && !both.value) {
									//add all
									partialFilteredBib.push(bib);
									
								}
								
								
								//if SUPPORT is SELECTED
								if (support.value) {	
									
									//test the for SUPPORT
									if (note.reason == "support") {
										
										//support - FACT AND OPINION
										if (!supportFact.value && !supportOpinion.value) {
											//if BOTH are NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (supportFact.value && !supportOpinion.value && note.contentType == "fact") {
											//if FACT is SELECTED and OPINION is NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (!supportFact.value && supportOpinion.value && note.contentType == "opinion") {
											//if FACT is NOT SELECTED and OPINION is SELECTED
											partialFilteredBib.push(bib);
										} else if (supportFact.value && supportOpinion.value) {
											//if BOTH YES and No are SELECTED
											partialFilteredBib.push(bib);
										}
									}
								}
								
								//if REJECT is SELECTED
								if (reject.label) {
									
									//test the for REJECT
									if (note.reason == "reject") {
										
										//reject - FACT AND OPINION
										if (!rejectFact.value && !rejectOpinion.value) {
											//if BOTH are NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (rejectFact.value && !rejectOpinion.value && note.contentType == "fact") {
											//if FACT is SELECTED and OPINION is NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (!rejectFact.value && rejectOpinion.value && note.contentType == "opinion") {
											//if FACT is NOT SELECTED and OPINION is SELECTED
											partialFilteredBib.push(bib);
										} else if (rejectFact.value && rejectOpinion.value) {
											//if BOTH YES and No are SELECTED
											partialFilteredBib.push(bib);
										}
									}
								}
								
								
								//if NEITHER is SELECTED
								if (neither.label) {
								
									//test the for NEITHER
									if (note.reason == "neither") {
										
										//neither - FACT AND OPINION
										if (!neitherFact.value && !neitherOpinion.value) {
											//if BOTH are NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (neitherFact.value && !neitherOpinion.value && note.contentType == "fact") {
											//if FACT is SELECTED and OPINION is NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (!neitherFact.value && neitherOpinion.value && note.contentType == "opinion") {
											//if FACT is NOT SELECTED and OPINION is SELECTED
											partialFilteredBib.push(bib);
										} else if (neitherFact.value && neitherOpinion.value) {
											//if BOTH YES and No are SELECTED
											partialFilteredBib.push(bib);
										}
									}
								}
								
								//if BOTH is SELECTED
								if (both.label) {
									
									//test the for BOTH
									if (note.reason == "both") {
										
										//both - FACT AND OPINION
										if (!bothFact.value && !bothOpinion.value) {
											//if BOTH are NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (bothFact.value && !bothOpinion.value && note.contentType == "fact") {
											//if FACT is SELECTED and OPINION is NOT SELECTED
											partialFilteredBib.push(bib);
										} else if (!bothFact.value && bothOpinion.value && note.contentType == "opinion") {
											//if FACT is NOT SELECTED and OPINION is SELECTED
											partialFilteredBib.push(bib);
										} else if (bothFact.value && bothOpinion.value) {
											//if BOTH YES and No are SELECTED
											partialFilteredBib.push(bib);
										}
									}
								}
								
								
								
							}	
							
						}
						
					}
					
				}
				
				filteredBib = partialFilteredBib;
				
				//trace (">>" +filteredBib.length)
				
				partialFilteredBib = new Array();
				//** --------- FURTHER READING
				
				//looping bibliography
				for each(bib in filteredBib) {
					
					//notes looping
					for each(note in bib.notes) {
						
						//functions looping
						for each(func in functions) {
							
							//trace (func.label)
							funcLabel = func.label;
							
							
							//** --------- FURTHER READING
							if (funcLabel == "Further Reading") {
								
								if (func.hasOptions) {
									options = func.options;
									
									var yes:Object = options[0];				//Yes
									var no:Object = options[1];					//No
									
									//trace (funcLabel)
									//trace (yes.label + " clicked: " + yes.value);
									//trace (no.label + " clicked: " + no.value);
									//trace ("*****");
									
									//if BOTH are NOT SELECTED
									if (!yes.value && !no.value) {
										partialFilteredBib.push(bib);
									} else if (yes.value && !no.value && note.furtherReading == "true") {
										//if YES is SELECTED and NO is NOT SELECTED
										partialFilteredBib.push(bib);
									} else if (!yes.value && no.value && note.furtherReading == "false") {
										//if YES is NOT SELECTED and NO is SELECTED
										partialFilteredBib.push(bib);
									}
								}	
							}
							
							
						}
						
					}
					
					trace ("-------")
				}
				
				
				filteredBib = partialFilteredBib;
			}
			
			*/
			//trace ("-------")
			
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
		
		private function combineResults():Array {
			var combo:Array = new Array();
			
			var i:int;
			
			for(i = 0 ; i< results.length; i++) {
				if (results[i] is Array) {
					combo = combo.concat(results[i]);
				}
			}
			
			//remove duplicates
			for (i = combo.length; i > 0; i--){
				if (combo.indexOf(combo[i-1]) != i-1){
					combo.splice(i-1,1);
				}
			}
			
			return combo;
		}
		
		private function notesResults(filterID:int):Array {
			
			resultArray = results[filterID];
			
			var resultNotes:Array = new Array();
			
			for each(var bib:RefBibliographic in resultArray) {
				
				//trace (bib.uniqueID + ": " + bib.title + " - " + bib.language)
				
				var notes:Array = bib.notes;
				var note:Object
				
				for each(note in notes) {
					
					//if (note.id < 80) { //////////!!!!!!! need to solve the note inline id problem- note 60 doesn't have ref correspondent
					
					resultNotes.push(note);
					//}
				}
				
				//trace ("*********")
			}
			
			//organize
			resultNotes.sortOn("id",Array.NUMERIC);
			
			//remove duplicates
			var uniqueNotes:Array =  removeDuplicates(resultNotes);
		
			return uniqueNotes;
		}
		
		private function removeDuplicates(target:Array):Array {
			
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
		
	}
}