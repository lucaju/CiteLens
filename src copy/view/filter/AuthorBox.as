package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.CrossBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
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
			
			//add button
			var addBT:CrossBT = new CrossBT(ColorSchema.getColor("filter"+filterID));
			addBT.rotation = 45;
			addBT.x = addBT.width;
			addBT.y = label.height + ((addBT.height/2) - 1);
			this.addChild(addBT);
			
			addBT.buttonMode = true;
			addBT.addEventListener(MouseEvent.CLICK, _click);
			
			//list
			optionsList = new Sprite();
			optionsList.y = label.height - 3;
			this.addChild(optionsList);
			
			//end line
			//makeEndLine();
			
			
			//looking for preselected authors, otherwise add the first one
			if (hasSelectedOptions) {
				var selectedAuthors:Array = citeLensController.getFilterOptionsByType(filterID, "author");
				
				for each (var authorName:String in selectedAuthors) {
					addAuthor(authorName);
				}
				
				
			} else {
				addAuthor();
				optionArray[0].activeDeleteButton = false; //disble remove button
			}
			
		}
		
		override internal function _click(e:MouseEvent):void {
			addAuthor();
		}
		
		private function addAuthor(authorName:String = null):void {
			author = new AuthorOption(filterID, optionCount++);
			if (authorName) {
				author.authorName = authorName;
			}
			author.x = 44;
			author.y = posY;
			
			optionsList.addChild(author);
			
			optionArray.push(author);
			
			//update vertical space 
			posY += author.height + 3;
			
			//move endline further down
			if (endLine) {
				TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
			}
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, author.height + 3);
			
			//animation
			//TweenLite.from(author,.5,{y:author.y - 10, alpha:0});
			
			//if there are more than one in the option list
			if (optionArray.length > 1) {
				optionArray[0].activeDeleteButton = true; //enable remove button in the first one
			}
			
		}
		
		public function deleteAuthorName(target:AuthorOption):void {
			
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
				
				//update posY and move up the end line 
				if (endLine) {
				
					if (isFIrst) {
						posY = optionsList.height + 3;
						TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
					} else {
						posY = optionsList.height - gap + 3;
						TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height - gap + 3});
					}
				}
				
			} else {															//if was the last one
				//update posY and move up the end line  
				posY = optionsList.height + 3;
				if (endLine) {
					TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
				}
			}
			
			//if there is just one option in the list - disable remove button, move end line and update posY
			if (optionArray.length == 1) {
				optionArray[0].activeDeleteButton = false;
				if (endLine) {
					TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
				}
				posY = optionsList.height + 3;
			}
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, - (author.height + 3));
			
		}
		
		//get selected data
		override public function selectedOptions():Array {
			var selOptions:Array;
			
			for each (var author:AuthorOption in optionArray) {
				
				var name:String = author.authorName;
				
				if (name) {
					
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