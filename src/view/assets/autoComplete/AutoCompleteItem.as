package view.assets.autoComplete {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AutoCompleteItem extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var label			:String;
		protected var type			:String;
		protected var userPartial	:String
		protected var _itemWidth	:Number;
		
		protected var labelTF		:TextField;
		protected var typeTF		:TextField
		protected var BG			:Sprite;
		
		protected var initial		:int;
		protected var end			:int;
		
		protected var _showType		:Boolean = true;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * @param t
		 * @param _partial
		 * 
		 */
		public function AutoCompleteItem(l:String, t:String, _partial:String) {
			label = l;
			type = t;
			userPartial = _partial;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//define text style // bold match the user typing
			initial = label.toLowerCase().search(userPartial.toLowerCase());
			end = initial + userPartial.length;
			
			//type
			if (_showType) {
				typeTF = new TextField();
				typeTF.selectable = false;
				typeTF.autoSize = "left";
				typeTF.x = 5;
				typeTF.text = type + ": ";
				typeTF.alpha = .2;
				typeTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold"));
				this.addChild(typeTF);
			}
			
			//label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.multiline = true;
			labelTF.wordWrap = true;
			labelTF.autoSize = "left";
			
			if (_showType)	{
				labelTF.width = itemWidth - typeTF.x - typeTF.width;
				labelTF.x = typeTF.x + typeTF.width;
			} else {
				labelTF.width = itemWidth;
				labelTF.x = 5;
			}
			
			labelTF.text = label;
			
			//style
			if (initial > -1) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","gray"),0,initial+1);
			
			labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold"),initial,end);
			
			if (end != label.length) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","gray"),end,label.length);
			
			this.addChild(labelTF);
			
			//bg
			BG = new Sprite();
			BG.graphics.beginFill(ColorSchema.getColor("red"),1);
			BG.graphics.drawRect(0,0,itemWidth, labelTF.height);
			BG.graphics.endFill();
			
			BG.alpha = 0;
			this.addChildAt(BG,0);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, _rollOver)
			this.addEventListener(MouseEvent.ROLL_OUT, _rollOut)
		}
		
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _rollOver(e:MouseEvent = null):void {
			
			//style
			if (_showType) {
				typeTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold","white"));
				typeTF.alpha = .7;
			}
			
			if (initial > -1) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","white"),0,initial+1);
			
			labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold","white"),initial,end);
			
			if (end != label.length) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","white"),end,label.length);
			
			BG.alpha = 1;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _rollOut(e:MouseEvent = null):void {
			
			//style
			if (_showType) {
				typeTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold"));
				typeTF.alpha = .2;
			}
			
			if (initial > -1) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","gray"),0,initial+1);
			
			labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Bold"),initial,end);
			
			if (end != label.length) labelTF.setTextFormat(TXTFormat.getStyle("AutoComplete Text","gray"),end,label.length);
			
			BG.alpha = 0;
		}

		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLabel():String {
			return label;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function getType():String {
			return type;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get itemWidth():Number {
			return _itemWidth;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set itemWidth(value:Number):void {
			_itemWidth = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get showType():Boolean {
			return _showType;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set showType(value:Boolean):void {
			_showType = value;
		}
		
	}
}