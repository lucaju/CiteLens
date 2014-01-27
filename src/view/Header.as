package view {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import controller.CiteLensController;
	
	import model.RefBibliographic;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.Button;
	import view.style.TXTFormat;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	final public class Header extends AbstractView {
		
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
		public function Header(c:IController) {
			super(c);
			initialize();
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function initialize():void {
			
			//---------- LOGO
			logo = new Sprite();
			logo.x = 60;
			logo.y = 0;
			this.addChild(logo);
			
			var file:String;
			if (DeviceInfo.os() != "Mac") {
				file = "images/logo@2x.png"
			} else {
				file = "images/logo.png";
			}
			
			var url:URLRequest = new URLRequest(file);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(url);
			logo.addChild(loader);
			
			var posX:Number = 220;
			
			//intro sentence
			var intro:TextField = new TextField();
			intro.selectable = false;
			intro.antiAliasType = AntiAliasType.ADVANCED;
			intro.embedFonts = true;
			intro.autoSize = TextFieldAutoSize.LEFT;
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
			var doc:RefBibliographic = CiteLensController(this.getController()).getDocumentSummary();
			
			titleHeader = new TextField();
			titleHeader.selectable = false;
			titleHeader.autoSize = TextFieldAutoSize.LEFT;
			titleHeader.antiAliasType = AntiAliasType.ADVANCED;
			titleHeader.embedFonts = true;
			
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
		
		//****************** PROTECTED Events ****************** ****************** ******************
	
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onComplete(event:Event):void {
			if (DeviceInfo.os() != "Mac") logo.scaleX = logo.scaleY = .5;
		}
		
	}
}