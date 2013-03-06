package view.bibliography {
	
	import events.CiteLensEvent;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.Button;
	import view.style.*;
	
	public class SortByBar extends BibliographyView {
		
		//properties
		private var _target:*;
		
		private var labelTF:TextField;
		
		private var menu:Array = new Array("author", "title", "date");
		private var selectedOption:String = "";
			
		private var button:Button;
		
		public function SortByBar() {
			
			super();
			
		}
		
		
		override public function initialize():void {
			
			//label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = "left";
			labelTF.text = "sort by:";
			labelTF.setTextFormat(TXTFormat.getStyle("General Label"));
			labelTF.x = 3;
			labelTF.y = -1;
			this.addChild(labelTF);
			
			
			
			//---------- MENU
			
			var posX:Number = labelTF.width + 15;
			
			for (var i:int = 0; i < menu.length; i++) {
				
				button = new Button(menu[i]);
				button.x = posX;
				button.y = -2;
				
				this.addChild(button);
				
				//add to button collection
				menu[i] = button;
				
				//event
				button.addEventListener(MouseEvent.CLICK, _click);
				
				posX = button.x + button.width + 15;
			}
			
		}
		
		/**
		 * Swithc Focus - _switchFocus
		 * 
		 * Deselect all buttons and change the focus to clicked button
		 *  
		 * @param e
		 * 
		 */
		private function _click(e:MouseEvent):void {
			
			
			
			//deselect all
			for each (button in menu) {
				button.status = "active";
			}
			
			if (selectedOption == Button(e.target).label) {
				selectedOption = "";
				
			} else {
				
				selectedOption = Button(e.target).label;
				
				//select option clicked
				button = Button(e.target);
				button.status = "selected";

			}
			
			//sort
			var params:Object = new Object();
			params.option = selectedOption;
			params.asc = true;
			
			dispatchEvent(new CiteLensEvent(CiteLensEvent.SORT, params));
		}
		
	}
}