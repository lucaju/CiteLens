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
			logo.y = 18;
			this.addChild(logo);
			
			url = new URLRequest("images/logo.swf");
			loader = new Loader();
			
			loader.load(url);
			logo.addChild(loader);
			
			//---------- MENU
			
			var posX:Number = 200;
			
			for (var i:int = 0; i < menu.length; i++) {
				
				button = new Button(menu[i],"Main Button Style");
				button.x = posX;
				button.y = 20;
				
				//make the first option selected
				if (i == 0) { button.status = "selected"; }
				
				this.addChild(button);
				
				//add to button collection
				menu[i] = button;
				
				//event
				button.addEventListener(MouseEvent.CLICK, _switchFocus);
				
				posX = button.x + button.width + 10;
			}
			
			
			//---------- DOCUMENT TITLE
			var doc:RefBibliographic = citeLensController.getDocumentSummary();
			
			titleHeader = new TextField();
			//titleHedear.selectable = false;
			titleHeader.multiline = true;
			titleHeader.autoSize = "left";
			
			titleHeader.text = doc.title;
			var span1:int = titleHeader.length;
			
			titleHeader.appendText("\n" + doc.getAuthorship(true) + ". " + doc.date + ".");
			var span2:int = titleHeader.length;
			
			titleHeader.setTextFormat(TXTFormat.getStyle("Title Header"),0,span1);
			titleHeader.setTextFormat(TXTFormat.getStyle("Author Header"),span1,span2);
				
			titleHeader.x = posX + 100;
			titleHeader.y = 14;
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