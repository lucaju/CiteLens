package view.filter {
	
	//imports
	import controller.CiteLensController;
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import view.assets.MinusBT;
	import view.assets.autoComplete.AutoCompleteBox;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AuthorOption extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var instances			:int = 0;
		
		protected var source				:AuthorPanel;
		
		protected var _id					:int;
		protected var input					:TextField;
		protected var ghostInput			:TextField
		protected var deleteButton			:MinusBT;
		protected var autoCompleteBox		:AutoCompleteBox;
		protected var brd					:Shape;
		protected var _label				:String = "";
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
		public function AuthorOption(source:AuthorPanel) {
			
			this.source = source;
			
			id = instances++;
			
			//input
			input = new TextField();
			
			input.antiAliasType = AntiAliasType.ADVANCED;
			input.type = TextFieldType.INPUT;
			input.embedFonts = true;
			input.defaultTextFormat = TXTFormat.getStyle("Input Author Name");
			input.width = 120;
			input.height = 16;
			input.text = "author name";
			input.alpha = .2;
			input.y = -1;
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
			deleteButton = new MinusBT(ColorSchema.RED);
			deleteButton.x = brd.x + brd.width + 2 + deleteButton.width;
			deleteButton.y = deleteButton.height - 2;
			this.addChild(deleteButton);
			
			TweenMax.to(deleteButton,.0,{tint:0xCCCCCC});

		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _addField(e:Event):void {
			if (input.text.length == 1) {
				AuthorPanel(this.parent.parent).addAuthor();
				input.removeEventListener(Event.CHANGE, _addField);
				
			} else if (input.text.length == 0) {
				//AuthorBox(this.parent.parent).deleteAuthorName(this);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _focusOff(e:FocusEvent):void {
			
			if (input.text.length == 0) {
				input.text = "author name";
				input.alpha = .2;
				
				activeDeleteButton = false;
				input.addEventListener(Event.CHANGE, _addField);;
				
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT)); 
				
			}
			
			if (autoCompleteBox) TweenMax.to(autoCompleteBox, .3, {alpha:0, onComplete:removeAutoCompleteFocusOff});
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _typing(e:KeyboardEvent):void {
			
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
						var autoCompList:Array = CiteLensController(source.getController()).searchBibliography(input.text, ["author"],true);
						
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
								
								ghostInput.text = autoCompleteBox.getFirstOnTheList();				//preload the first autoComplete in the field
								
								} else {
									if (ghostInput) {
										this.removeChild(ghostInput);
										ghostInput = null;
									}
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
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function removeAutoCompleteFocusOff():void {
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}				
		}
		
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function focusIn(e:FocusEvent = null):void {
			if (input.text == "author name") input.text = "";
			input.alpha = 1;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
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
				if (autoCompleteBox.searchTarget == "") queryTarget = ["author","title"];
				
			} else {
				query = "~all"
			}
			
			if (query != "") {
				CiteLensController(source.getController()).searchBibliography(query, queryTarget);
				source.updatePanel();
			}
			
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function removeAuthorName(e:MouseEvent):void {
			var box:AuthorPanel = AuthorPanel(this.parent.parent);
			
			//animation
			TweenMax.to(this,.5,{x:this.x - 10, alpha:0, onComplete:box.deleteAuthorName, onCompleteParams:[this]});
			TweenMax.to(deleteButton, .5, {rotation:-90});
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
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
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set id(value:int):void {
			_id = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get authorName():String {
			return input.text;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set authorName(value:String):void {
			input.text = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasContent():Boolean {
			return (input.text.length > 0) ? true : false;
		}


	}
}