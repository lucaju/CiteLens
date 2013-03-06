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
				trace ("countries")
				
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
				trace ("pubtypes")
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
				trace ("periods")
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
				trace ("authors")
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
			
			partialFilteredBib = new Array();
			
			//filter for Functions
			var functions:Array = filter.getOptionsByType("function");
			
			
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
							
							//tweak
							var funcLabel:String = func.label;
							funcLabel = funcLabel.slice(0,funcLabel.length-7);
							
							//trace (bib.sourceRole.toLowerCase() + "---" + func.label + "-" + func.subFunctions)
							
								
							/*
							
							if (funcLabel.toLowerCase() == "primary" && bib.sourceRole.toLowerCase() == funcLabel) {
								//trace (bib.sourceRole.toLowerCase())
								for each (opt in options) {
									
									//trace (note.contentType.toLowerCase() + "---" + opt.label.toLowerCase() + ":" + opt.value + "-")
									if (note.contentType.toLowerCase() == opt.label.toLowerCase() && opt.value == true) {
										//trace (" - " + opt.label + ": " + opt.value)
										partialFilteredBib.push(bib);
										break;
										break;
									}
								}
							}
							
							else if (funcLabel.toLowerCase() == "secondary" && bib.sourceRole.toLowerCase() == funcLabel) {
								
	
								for each (subFunct in subFunctions) {
									
									var testForSubOption:Boolean = false;
									
									if (subFunct.label == "agree" && note.reason == "support" || subFunct.label == "agree" && note.reason == "both") {
										//trace (subFunct.label + "--" + note.reason)
										testForSubOption = true;
										
									} else if (subFunct.label == "disagree" && note.reason == "reject" || subFunct.label == "disagree" && note.reason == "both") {
										//trace (subFunct.label + "--" + note.reason)
										testForSubOption = true;
										
									} else if (subFunct.label == "neutral" && note.reason == "neither") {
										//trace (subFunct.label + "--" + note.reason)
										testForSubOption = true;
									}
									
									
									if (testForSubOption == true) {
									
										//trace (" - " + subFunct.label)
										
										//suboptions
										var subOptions:Array = subFunct.options;
										
										for each (var subOpt:Object in subOptions) {
											
											//trace (note.contentType.toLowerCase() + "---" + subOpt.label.toLowerCase() + ":" + subOpt.value + "-")
											if (note.contentType.toLowerCase() == subOpt.label.toLowerCase() && subOpt.value == true) {
												//trace (" - " + subOpt.label + ": " + subOpt.value)
												partialFilteredBib.push(bib);
												break;
												break;
											}
											
										}
									}
								}
								
							
								
							} else*/ 
							
							
							if (func.label.toLowerCase() == "further reading") {
								//trace ("saved: " + note.furtherReading.toLowerCase() +" - Filtered: "+ func.value + " => ", note.furtherReading.toLowerCase() == func.value)
								if (note.furtherReading.toLowerCase() == func.value.toString()) {
									//trace (bib.sourceRole.toLowerCase())
									trace (func.value)
									partialFilteredBib.push(bib);
									break;
									
								}
							}
							
						}
					//trace ("************")
					}
				}
				
				
				filteredBib = partialFilteredBib;
			}
			trace ("-------")
			
			
			//save reults
			var filterID:int = filter.id;
			
			
			resultArray = filteredBib;
			
			results[filterID] = resultArray;
			
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
			var uniqueNotes:Array = new Array();
			var duplicated:Boolean = false;
			
			for each(note in resultNotes) {
				for each(var uniqueNote:Object in uniqueNotes) {
					if (uniqueNote is Object) {
						//trace (note.id +" - "+ uniqueNote.id)
						if (note.id == uniqueNote.id) {
							duplicated = true;
							break;
						}
					}
					
				}
					
					
				if (!duplicated) {
					uniqueNotes.push(note);
					
				}
				
				duplicated = false;
			}
			
			
			return uniqueNotes;
		}
	
	}
}