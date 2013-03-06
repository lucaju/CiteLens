package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.CrossBT;
	import view.assets.MinusBT;
	import view.assets.autoComplete.AutoCompleteBox;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class AuthorOption extends OptionBox {
		
		//properties
		static public var instances:int = 0;
		
		
		private var _id:int;
		private var input:TextField;
		private var ghostInput:TextField
		private var deleteButton:MinusBT;
		private var autoCompleteBox:AutoCompleteBox;
		private var brd:Shape;
		private var _label:String = "";
		
		public function AuthorOption(fID:int) {
			
			super(fID)
			
			id = instances++;
			
			//input
			input = new TextField();
			
			input.antiAliasType = "Advanced";
			input.type = "input";
			input.defaultTextFormat = TXTFormat.getStyle("Input Author Name");
			input.width = 120;
			input.height = 15;
			input.text = "author name";
			input.alpha = .2;
			this.addChild(input);
			
			input.addEventListener(Event.CHANGE, _addField);		//add another field if the user start to type in the current field
			input.addEventListener(FocusEvent.FOCUS_IN, focusIn)		//Focus IN
			input.addEventListener(FocusEvent.FOCUS_OUT, _focusOff)	//Focus OFF
			input.addEventListener(KeyboardEvent.KEY_UP, _typing);
			
			
			brd = new Shape();
			brd.graphics.lineStyle(1,0xCCCCCC,1,true);
			brd.graphics.beginFill(0x000000,0.05);
			brd.graphics.drawRoundRect(0,0,input.width,input.height,6,6);
			brd.graphics.endFill();
			this.addChild(brd);
			
			//add button
			deleteButton = new MinusBT(ColorSchema.getColor("red"));
			deleteButton.x = brd.x + brd.width + 2 + deleteButton.width;
			deleteButton.y = deleteButton.height - 2;
			this.addChild(deleteButton);
			
			TweenMax.to(deleteButton,.0,{tint:0xCCCCCC});

		}

		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		public function get authorName():String {
			return input.text;
		}
		
		public function set authorName(value:String):void {
			input.text = value;
		}
		
		
		public function get label():String {
			return _label;
		}
		
		public function get hasContent():Boolean {
			return (input.text.length > 0) ? true : false;
		}
		
		public function focusIn(e:FocusEvent = null):void {
			if (input.text == "author name") {
				input.text = "";
				
			}
			
			input.alpha = 1;
		}
		
		private function _focusOff(e:FocusEvent):void {
			if (input.text.length == 0) {
				input.text = "author name";
				input.alpha = .2;
				
				activeDeleteButton = false;
				input.addEventListener(Event.CHANGE, _addField);;
				
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT)); 
				
			}
			
			if (autoCompleteBox) {
				TweenMax.to(autoCompleteBox, .3, {alpha:0, onComplete:removeAutoCompleteFocusOff});
			}
			
		}
		
		private function removeAutoCompleteFocusOff():void {
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}				
		}
		
		private function _addField(e:Event):void {
			if (input.text.length == 1) {
				AuthorBox(this.parent.parent).addAuthor();
				input.removeEventListener(Event.CHANGE, _addField);
				
			} else if (input.text.length == 0) {
				//AuthorBox(this.parent.parent).deleteAuthorName(this);
			}
		}
		
		public function set activeDeleteButton(value:Boolean):void {
			if(value) {
				deleteButton.buttonMode = true;
				deleteButton.addEventListener(MouseEvent.CLICK, removeAuthorName);
				TweenMax.to(deleteButton,.5,{removeTint:true});
			} else {
				deleteButton.buttonMode = false;
				deleteButton.removeEventListener(MouseEvent.CLICK, removeAuthorName);
				TweenMax.to(deleteButton,.5,{tint:0xCCCCCC});
			}
		}
		
		public function removeAuthorName(e:MouseEvent):void {
			var box:AuthorBox = AuthorBox(this.parent.parent);
			
			//animation
			TweenMax.to(this,.5,{x:this.x - 10, alpha:0, onComplete:box.deleteAuthorName, onCompleteParams:[this]});
			TweenMax.to(deleteButton, .5, {rotation:-90});
		}
		
		private function _typing(e:KeyboardEvent):void {
			
			_label = input.text;
			
			switch (e.keyCode) {					//enter or return
				case 13:
					doQuery();
					break;
				
				case 38:							//up
					if (autoCompleteBox) {
						autoCompleteBox.keyboardSelection("up");
					}
					break;
				
				case 40:						//down
					if (autoCompleteBox) {
						autoCompleteBox.keyboardSelection("down");
					}
					break;
				
				default:
					
					if (input.length > 0) {
						
						//autocomplete
						var autoCompList:Array = citeLensController.searchBibliography(input.text, ["author"],true);
						
						if (autoCompList.length > 0) {
							
							if (!autoCompleteBox) {
								autoCompleteBox = new AutoCompleteBox();
								autoCompleteBox.boxWidth = input.width;;
								autoCompleteBox.showType = false;
								autoCompleteBox.numSugestions = 4;
								autoCompleteBox.content = autoCompList;
								autoCompleteBox.init();
								autoCompleteBox.y = brd.y - autoCompleteBox.height;
								autoCompleteBox.x = input.x;
								this.addChildAt(autoCompleteBox,0);
								
								
								autoCompleteBox.addEventListener(Event.SELECT, doQuery);
							}
							
							autoCompleteBox.updateList(autoCompList, input.text);
							
							//ghost
							/*
							//gost autocomplete
							if (autoCompleteBox.getFirstOnTheList() != null) {
								if (!ghostInput) {
									ghostInput = new TextField();
									ghostInput.selectable = false;
									ghostInput.antiAliasType = "Advanced";
									ghostInput.defaultTextFormat = TXTFormat.getStyle("Input Author Name");
									ghostInput.width = 110;
									ghostInput.height = 15;
									ghostInput.alpha = .2;
									this.addChildAt(ghostInput,0);
								}
							
								ghostInput.text = autoCompleteBox.getFirstOnTheList();									//preload the first autoComplete in the field
								
							} else {
								if (ghostInput) {
									this.removeChild(ghostInput);
									ghostInput = null;
								}
							}
							*/
							
							
							TweenMax.to(autoCompleteBox, .5, {y:brd.y - autoCompleteBox.newHeight});
							
						} else {
							if (autoCompleteBox) {
								this.removeChild(autoCompleteBox)
								autoCompleteBox = null;
							}
						}
						
					} else if (input.length == 0) {
						if (autoCompleteBox) {
							this.removeChild(autoCompleteBox)
							autoCompleteBox = null;
						}
					}
					
					break;
			}
			
		}
		
		public function doQuery(e:Event = null):void {
			
			if (autoCompleteBox) {
				var query:String = autoCompleteBox.searchQuery;
				if (query == "") {
					
					//if (ghostInput) {
					//	input.text = ghostInput.text;
					//}
					//query = input.text;
					
				} else {
					input.text = query;
				}
				
				if (ghostInput) {
					this.removeChild(ghostInput);
					ghostInput = null;
				}
				
				
				var queryTarget:Array = [autoCompleteBox.searchTarget];
				if (autoCompleteBox.searchTarget == "") {
					queryTarget = ["author","title"]
				}
				
			} else {
				query = "~all"
			}
			/*
			if (query != "") {
				citeLensController.searchBibliography(query, queryTarget);
			}
			*/
			
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}
			
		}


	}
}