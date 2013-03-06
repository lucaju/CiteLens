package view.bibliography {
	
	//imports
	import com.greensock.TweenMax;
	
	import controller.CiteLensController;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.CrossBT;
	import view.assets.autoComplete.AutoCompleteBox;
	import view.style.TXTFormat;
	
	public class SearchBar extends BibliographyView {
		
		//properties
		private var labelTF:TextField;
		private var inputTF:TextField;
		private var inputBG:Shape;
		private var autoCompleteBox:AutoCompleteBox;
		
		private var w:Number;
		
		private var eraseBT:CrossBT;
		
		public function SearchBar() {
			
			super();
			
		}
		
		override public function initialize():void {
			
			w = this.parent.width - 12;						//inputBG width 
			
			//input
			inputTF = new TextField();
			inputTF.x = 5;
			inputTF.width = w - 16;
			inputTF.height = 16;
			inputTF.alpha = .2;
			inputTF.type = "input";
			inputTF.defaultTextFormat = TXTFormat.getStyle("General Label");
			inputTF.text = "search";
			
			this.addChild(inputTF);
			
			//Input Background
			
			inputBG = new Shape();
			inputBG.graphics.lineStyle(1,0xCCCCCC,2,true);
			inputBG.graphics.beginFill(0x000000,.05);
			inputBG.graphics.drawRoundRect(0,0,w, 16, 6);
			inputBG.graphics.endFill();
			
			inputBG.x = inputTF.x - 2;
			
			this.addChildAt(inputBG,0);
			
			inputTF.addEventListener(FocusEvent.FOCUS_IN, _focusIn);		//Focus IN
			inputTF.addEventListener(FocusEvent.FOCUS_OUT, _focusOff);		//Focus OFF
			inputTF.addEventListener(KeyboardEvent.KEY_UP, _typing);

		}
		
		private function _focusIn(e:FocusEvent):void {
			if (inputTF.text == "search") {
				inputTF.text = "";
				inputTF.alpha = 1;
			}
		}
		
		private function _focusOff(e:FocusEvent):void {
			if (inputTF.text.length == 0) {
				//focus = false;
				inputTF.text = "search";
				inputTF.alpha = .2;
				
				//remove erase button
				if (eraseBT) {
					eraseBT.removeEventListener(MouseEvent.CLICK, eraseClick);
					this.removeChild(eraseBT)
					eraseBT = null;
				}
				
				doQuery();
				
			}
			
			if (autoCompleteBox) {
				TweenMax.to(autoCompleteBox, .3, {alpha:0, delay: .5, onComplete:removeAutoCompleteFocusOff});
			}
			
			
			
		}
		
		private function removeAutoCompleteFocusOff():void {
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}				
		}
		
		private function _typing(e:KeyboardEvent):void {
			
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
					
					if (inputTF.length > 0) {
						
						//erase BT
						if (!eraseBT) {
							eraseBT = new CrossBT(0x666666);
							eraseBT.x = inputBG.width - 5;
							eraseBT.y = inputBG.height/2;
							this.addChild(eraseBT);
							eraseBT.buttonMode = true;
							eraseBT.addEventListener(MouseEvent.CLICK, eraseClick);
						}
						
						//autocomplete
						var autoCompList:Array = citeLensController.searchBibliography(inputTF.text, ["author","title"],true);
						
						if (autoCompList.length > 0) {
							
							if (!autoCompleteBox) {
								autoCompleteBox = new AutoCompleteBox();
								autoCompleteBox.y = inputBG.y + inputBG.height;
								autoCompleteBox.x = inputTF.x - 2;
								
								autoCompleteBox.boxWidth = w;
								autoCompleteBox.content = autoCompList;
								autoCompleteBox.init();
								this.addChildAt(autoCompleteBox,0);
									
								
								autoCompleteBox.addEventListener(Event.SELECT, doQuery);
							}
							
							autoCompleteBox.updateList(autoCompList, inputTF.text);
							
						} else {
							if (autoCompleteBox) {
								this.removeChild(autoCompleteBox)
								autoCompleteBox = null;
							}
						}
						
					} else if (inputTF.length == 0) {
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
					query = inputTF.text;
				} else {
					inputTF.text = query;
				}
			
			
				var queryTarget:Array = [autoCompleteBox.searchTarget];
				if (autoCompleteBox.searchTarget == "") {
					queryTarget = ["author","title"]
				}
				
			} else {
				query = "~all"
			}
			
			citeLensController.searchBibliography(query, queryTarget);
			
			
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}
			
		}
		
		private function eraseClick(e:MouseEvent):void {
			
			//remove info in the inout fiels
			inputTF.text = "search";
			inputTF.alpha = .2;
			
			//remove autocomplete
			if (autoCompleteBox) {
				this.removeChild(autoCompleteBox)
				autoCompleteBox = null;
			}
			
			//remove erase button
			eraseBT.removeEventListener(MouseEvent.CLICK, eraseClick);
			this.removeChild(eraseBT)
			eraseBT = null;
			
			//do query to show all again
			doQuery();
			
		}
		
	}
}