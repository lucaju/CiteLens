package view {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import model.RefBibliographic;
	
	import view.assets.Button;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	
	final public class Header extends CiteLensView {
		
		//properties
		private var url:URLRequest;
		private var loader:Loader
		
		private var logo:Sprite;
		
		private var menu:Array = new Array("compare", "contextualize")
		private var button:Button;
		
		private var titleHeader:TextField;
		
		public function Header() {
			
			super(citeLensController);
			
			initialize();
		}
		
		
		override public function initialize():void {
			
			//---------- LOGO
			logo = new Sprite();
			logo.x = 25;
			logo.y = 0;
			this.addChild(logo);
			
			url = new URLRequest("images/logo.swf");
			loader = new Loader();
			
			loader.load(url);
			logo.addChild(loader);
			
			var posX:Number = 220;
			
			//intro sentence
			var intro:TextField = new TextField();
			intro.selectable = false;
			intro.autoSize = "left";
			intro.text = "I would like to";
			intro.setTextFormat(TXTFormat.getStyle("Author Header"));
			
			intro.x = posX;
			intro.y = 17;
			
			this.addChild(intro);
			
			
			posX += intro.width + 4;
			
			//---------- MENU
			
			
			
			for (var i:int = 0; i < menu.length; i++) {
				
				button = new Button(menu[i],"Main Button Style");
				button.x = posX;
				button.y = 16;
				button.border = true;
				
				//make the first option selected
				if (i == 0) { button.status = "selected"; }
				
				this.addChild(button);
				
				//add to button collection
				menu[i] = button;
				
				//event
				button.addEventListener(MouseEvent.CLICK, _switchFocus);
				
				posX = button.x + button.width + 4;
			}
			
			
			//---------- DOCUMENT TITLE
			var doc:RefBibliographic = citeLensController.getDocumentSummary();
			
			titleHeader = new TextField();
			titleHeader.selectable = false;
			titleHeader.autoSize = "left";
			
			titleHeader.text = "citations of ";
			var span1:int = titleHeader.length;
			
			titleHeader.appendText(doc.title);
			var span2:int = titleHeader.length;
			
			titleHeader.appendText(". " + doc.getAuthorship(true) + ". " + doc.date + ".");
			var span3:int = titleHeader.length;
			
			titleHeader.setTextFormat(TXTFormat.getStyle("Author Header"),0,span1);
			titleHeader.setTextFormat(TXTFormat.getStyle("Title Header"),span1,span2);
			titleHeader.setTextFormat(TXTFormat.getStyle("Author Header"),span2,span3);
				
			titleHeader.x = posX;
			titleHeader.y = 17;
			this.addChild(titleHeader);
		}
		
		/**
		 * Swithc Focus - _switchFocus
		 * 
		 * Deselect all buttons and change the focus to clicked button
		 *  
		 * @param e
		 * 
		 */
		private function _switchFocus(e:MouseEvent):void {
			
			//deselect all
			for each (button in menu) {
				button.status = "active";
			}
			
			//select option clicked
			button = Button(e.target);
			button.status = "selected";
		}
	
	
	}
}