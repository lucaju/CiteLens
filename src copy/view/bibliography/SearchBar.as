package view.bibliography {
	
	//imports
	import flash.display.Shape;
	import flash.text.TextField;
	
	import view.style.TXTFormat;
	
	public class SearchBar extends BibliographyView {
		
		//properties
		private var labelTF:TextField;
		private var inputTF:TextField;
		private var inputBG:Shape;
		
		
		public function SearchBar() {
			
			super();
			
		}
		
		override public function initialize():void {
			//label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = "left";
			labelTF.text = "search";
			labelTF.setTextFormat(TXTFormat.getStyle("General Label"));
			
			this.addChild(labelTF);
			
			//input
			inputTF = new TextField();
			inputTF.x = labelTF.width + 5;
			inputTF.width = this.parent.width - labelTF.width - 15;
			inputTF.height = 16;
			
			inputTF.type = "input";
			inputTF.defaultTextFormat = TXTFormat.getStyle("General Label");
			
			this.addChild(inputTF);
			
			//Input Background
			var w:Number = this.parent.width - labelTF.width - 10;						//inputBG width 
			
			inputBG = new Shape();
			inputBG.graphics.beginFill(0xDDDDDD);
			inputBG.graphics.drawRoundRect(0,0,w, 16, 8);
			inputBG.graphics.endFill();
			
			inputBG.x = inputTF.x - 2;
			
			this.addChildAt(inputBG,0);
			
		}
	}
}