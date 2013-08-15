package view {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import model.RefBibliographic;
	
	import view.assets.Button;
	import view.style.TXTFormat;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	final public class Header extends CiteLensView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var logo			:Sprite;
		
		protected var menu			:Array = new Array("compare", "contextualize")
		protected var button		:Button;
		
		protected var titleHeader	:TextField;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Header() {
			super(citeLensController);
			initialize();
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function initialize():void {
			
			//---------- LOGO
			logo = new Sprite();
			logo.x = 25;
			logo.y = 0;
			this.addChild(logo);
			
			var url:URLRequest = new URLRequest("images/logo.swf");
			var loader:Loader = new Loader();
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
				if (i == 0) button.status = "selected";
				
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
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * Swithc Focus - _switchFocus
		 * 
		 * Deselect all buttons and change the focus to clicked button
		 *  
		 * @param e
		 * 
		 */
		protected function _switchFocus(e:MouseEvent):void {
			
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