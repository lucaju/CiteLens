package controller {
	
	//imports
	import com.greensock.plugins.OnChangeRatioPlugin;
	
	import model.RefBibliographic;
	
	public class SearchProcess {
		
		//properties
		private var partialString:String;
		private var target:Array;
		private var dic:Array;
		private var numMax:uint = 6;
		private var autoComplete:Boolean;
		
		public function SearchProcess(value:String, autoC:Boolean = false) {
			
			//
			partialString = value;
			autoComplete = autoC;
			target = new Array();
			
		}
		
		public function set dictionary(value:Array):void {
			dic = value;
		}
		
		public function addTarget(value:String):void {
			target.push(value);
		}
		
		public function get result():Array {
			
			var finalResult:Array = new Array();
			var results:Array = new Array();
			
			for each(var targ:String in target) {
				
				switch (targ) {
					case "title":
						var titles:Array = parseTitle();
						results.push(titles);
						break;
					
					case "author":
						var authors:Array = parseAuthor();
						results.push(authors);
						break;
				}
				
			}
			
			//if autocomplete is off, concatenate all results
			var result:Array;
			
			if (!autoComplete) {
				
				for each (result in results) {
					finalResult = finalResult.concat(result);
				}
				
			}
			//If the field check just one target
			else if (results.length == 1) {
				finalResult = results[0];
				
			}
			//grab the first items from each result
			else {
				
				//Here the final results will combine the results in each category
				var i:int = 0;
				var r:int = 0;
				
				while (i < numMax) {
					
					var resultIteration:Array;
					var previousI:int = i;
					
					for each (result in results) {
						if (r < result.length) {
							finalResult.push(result[r]);
							i++;
						}
					}
					
					//jump to the next line in the results
					r++;
					
					//if this iteration didn't save anything
					if (i == previousI) {
						i++;
					}
					
				}
			}
			
			finalResult.sortOn("type");
			
			return finalResult;
		}
		
		private function parseAuthor():Array {
			var result:Array = new Array();
			
			//label:String - type:String
			var item:Object;
			
			//loop in the bibls
			for each (var bibl:RefBibliographic in dic) {
				var authors:Array = bibl.authors;
				
				//loop in the author
				for each (var author:Object in authors) {
					var authorFullName:String = author.firstName + " " + author.lastName;
					
					//if partial string matches with author name at least partialy
					if (authorFullName.toLowerCase().search(partialString.toLowerCase()) >= 0) {
						//trace (authorFullName)
						
						//test if the author isn't already in the list
						if (result.length > 0) {
							var duplicated:Boolean = false;
							
							for each (var resultItem:Object in result) {
								
								if (authorFullName == resultItem.label) {
									duplicated = true;
									break
								}
								
							}
							
							if (!duplicated) {
								item = new Object();
								item.label = authorFullName;
								item.type = "author";
								
								result.push(item);
							}
							
							
						} else {	//if the list is empty, add the first one		
							item = new Object();
							item.label = authorFullName;
							item.type = "author";
							
							result.push(item);
						}
						
						
					}
					
					
					
				}
				//stop looking if reah the maximum
				if (autoComplete && result.length > numMax-1) {
					break;
					break;
					break;
				}
				
			}
			
			return result;
		}
		
		private function parseTitle():Array {
			var result:Array = new Array();
			
			//label:String - type:String
			var item:Object;
			
			//loop in the bibls
			for each (var bibl:RefBibliographic in dic) {
				var titles:Array = bibl.titles;
				
				//loop in the titles
				for each (var title:Object in titles) {
					var refTitle:String = title.name;
					
					//if partial tring matches with title name at least partialy
					if (refTitle.toLowerCase().search(partialString.toLowerCase()) >= 0) {
						//trace (authorFullName)
						
						//test if the tile isn't already in the list
						if (result.length > 0) {
							var duplicated:Boolean = false;
							
							for each (var resultItem:Object in result) {
								
								if (refTitle == resultItem.label) {
									duplicated = true;
									break
								}
								
							}
							
							if (!duplicated) {
								item = new Object();
								item.label = refTitle;
								item.type = "title";
								
								result.push(item);
							}
							
							
						} else {	//if the list is empty, add the first one		
							item = new Object();
							item.label = refTitle;
							item.type = "title";
							
							result.push(item);
						}
						
						
					}
					
					
					
				}
				//stop looking if reah the maximum
				if (autoComplete && result.length > numMax-1) {
					break;
					break;
					break;
				}
				
			}
			
			return result;
		}
	}
}