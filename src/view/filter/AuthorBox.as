package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import view.assets.CrossBT;
	
	public class AuthorBox extends OptionBox {
		
		//properties
		private var author:AuthorOption;
		private var addBT:CrossBT;
		
		public function AuthorBox(fID:int) {
			super(fID);
		}
		
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) {
				hasSelectedOptions = citeLensController.filterHasSelectedOptions(filterID, "author");
			}
			
			//label
			buildLabel("author");
			
			//list
			optionsList = new Sprite();
			optionsList.y = labelTF.height;
			this.addChild(optionsList);
			
			//end line
			//makeEndLine();
			
			//looking for preselected authors, otherwise add the first one
			if (hasSelectedOptions) {
				var selectedAuthors:Array = citeLensController.getFilterOptionsByType(filterID, "author");
				
				for each (var authorName:String in selectedAuthors) {
					addAuthor(authorName, true);
					
				}
				//extra one
				addAuthor();
				
			} else {
				
				//add the first
				addAuthor();
			}
			
			//listener
			this.addEventListener(FocusEvent.FOCUS_OUT, removeNextBlankField)
			
		}
		
		override internal function _click(e:MouseEvent):void {
			addAuthor();
		}
		
		public function addAuthor(authorName:String = null, focusValue:Boolean = false):void {
			
			//verify if it doesn't have any blank space before add one
			var blankSpace:Boolean = false;
			for each (var auth:AuthorOption in optionArray) {
				if (auth.label == "author name") {
					blankSpace = true;
					break;
				}
			}
			
			if (!blankSpace) {
				
				author = new AuthorOption(filterID);
				if (authorName) {
					author.authorName = authorName;
				}
				
				if (focusValue) {
					author.focusIn();
				}
				
				author.y = posY;
				optionsList.addChild(author);
				
				optionArray.push(author);
				
				//update vertical space 
				posY = optionsList.height + 3;
				
				//move endline further down
				if (endLine) {
					TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
				}
				
				//move box in optionPanel
				OptionsPanel(this.parent).moveBoxes(this, author.height + 3);
				
				//animation
				//TweenLite.from(author,.5,{y:author.y - 10, alpha:0});
				
				//enable remove button in the previus option
				if (optionArray.length > 1) {
					optionArray[optionArray.length-2].activeDeleteButton = true; //enable remove button in the first one
				}
			}
			
		}
		

		private function removeNextBlankField(e:FocusEvent):void {
			
			if (e.target is AuthorOption) {
				
				var currentField:AuthorOption = AuthorOption(e.target);
				for (var i:int = 0; i<optionArray.length; i++) {
					if (optionArray[i] == currentField) {
						if (i != optionArray.length-1) {
							if (optionArray[i+1].label == "") {
								deleteAuthorName(optionArray[i+1]);
								break;
							} else {
								deleteAuthorName(optionArray[i]);
								break;
							}
						}
					}
				}
			}
		}
		
		public function deleteAuthorName(target:AuthorOption = null):void {
			
			//test for target
			for (var i:int = 0; i < optionArray.length; i++) {	
				if (optionArray[i] == target) {								
					var gap:Number = optionArray[i].height + 3;				//calculate the gap
					optionsList.removeChild(optionArray[i]); 					//remove option from the screen

					//if the option is the first, change the the second option label and tag for futher changing													
					if (i == 0) {
						var isFIrst:Boolean = true;
					}
					
					// if the option is not the last, select those after the delete option
					if (i < optionArray.length-1) {						
						var partOfAuthors:Array = optionArray.slice(i);
					}
					
					optionArray.splice(i,1);									//remove target from collection
					
					break;
				}
			}
			
			//animation to realocate
			if (partOfAuthors) {												//if the option removed was in the middle
				for each (author in partOfAuthors) {
					TweenLite.to(author,.5,{y:author.y - gap});					//move up each line
				}
				//posY = optionsList.height - author.height;
				
				
				if (isFIrst) {
					posY = optionsList.height + 3;
				} else {
					posY = optionsList.height - author.height;
				}
				
				//update posY and move up the end line 
				if (endLine) {
					posY = optionsList.height + 3;
					TweenLite.to(endLine,.5,{y:optionsList.y + posY});
				}
				
			} else {															//if was the last one
				//update posY and move up the end line  
				posY = optionsList.height + 3;
				if (endLine) {
					TweenLite.to(endLine,.5,{y:optionsList.y + posY});
				}
			}
			
			//if there is just one option in the list - disable remove button, move end line and update posY
			if (optionArray.length == 1) {
				
				optionArray[0].activeDeleteButton = false;
				//posY = optionsList.height + 3;
				if (endLine) {
					TweenLite.to(endLine,.5,{y:optionsList.y + posY});
				}
			}
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, - (author.height + 3));
		}
		
		//get selected data
		override public function selectedOptions():Array {
			var selOptions:Array;
			
			for each (var author:AuthorOption in optionArray) {
				
				var name:String = author.authorName;
				
				if (name != "" && name != "author name") {
					
					//initialize array
					if (!selOptions) {
						selOptions = new Array();
					}
					
					selOptions.push(author.authorName);
				}
				
			}
			
			return selOptions;
		}
		
	}
}