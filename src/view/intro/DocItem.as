package view.intro {

	//import
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class DocItem extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var background				:Sprite;
		protected var textField					:TextField;
		
		protected var _file						:String;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function DocItem(data:XML) {
			
			_file = data.file;
			
			//BG
			background = new Sprite();
			background.graphics.lineStyle(1,0xDDDDDD);
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, 250, 80);
			background.graphics.endFill();
			background.alpha = .7;
			
			this.addChild(background);
			
			//text
			textField = new TextField();
			textField.selectable = false;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = TXTFormat.getStyle("Document list");
			textField.width = background.width - 10;
			
			textField.text = data.title + "\n" + data.author + ", " + data.year;
			textField.setTextFormat(TXTFormat.getStyle("Document list Title"), 0 , data.title.toString().length)
			
			textField.alpha = .9;
			textField.x = 5;
			textField.y = 5;
			this.addChild(textField);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOver(event:MouseEvent):void {
			TweenMax.to(background,.5,{alpha:1});
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseOut(event:MouseEvent):void {
			TweenMax.to(background,.5,{alpha:.7});
			
		}
		
		
		//****************** GETTERS & SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get file():String {
			return _file;
		}
		
	}
}