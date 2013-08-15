package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Button extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var shape				:Shape;
		protected var labelTF			:TextField;
		
		protected var _label			:String
		protected var _color			:uint;
		protected var _style			:String;
		protected var _border			:Sprite;
		
		protected var txtFormat			:TXTFormat;
		
		protected var margin			:Number = .2; 				//Defined proportionaly in percentage
		
		protected var _status			:String = "active";
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * @param s
		 * @param c
		 * 
		 */
		public function Button(l:String, s:String = "Button Style", c:uint = 0x333333) {
			
			super();
			
			//init
			label = l;
			color = c;
			style = s;
			
			//label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = "left";
			labelTF.text = label;
			labelTF.setTextFormat(TXTFormat.getStyle(style, status));
			this.addChild(labelTF);
			
			//shape
			
			var w:Number = labelTF.width + (labelTF.width * margin * 0.2);
			var h:Number = labelTF.height + (labelTF.height * margin * 0.2);
			
			shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRoundRect(0,0,w,h,10);
			shape.graphics.endFill();
			
			shape.alpha = 0;
			
			//this.addChildAt(shape,0);
			
			_border = new Sprite();
			_border.graphics.lineStyle(2,color);
			_border.graphics.beginFill(0xFFFFFF,0);
			_border.graphics.drawRoundRect(0,0,shape.width + 2, shape.height - 2, 10);
			_border.graphics.endFill();
			_border.alpha = .3;
			_border.x = -1;
			_border.y = 1;
			
			//align
			labelTF.x = (shape.width/2 - labelTF.width/2) - 1;
			labelTF.y = (shape.height/2 - labelTF.height/2) + 1;
			
			//events
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _over(e:MouseEvent):void {
				shape.alpha = .1;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _out(e:MouseEvent):void {
				shape.alpha = 0;
		}

		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
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
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get status():String {
			return _status;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set status(value:String):void {
			_status = value;
			labelTF.setTextFormat(TXTFormat.getStyle(style, status));
			
			if (status == "selected") {
				//shape.alpha = 1;
				shape.alpha = .1;
				_border.alpha = .8;
				
				this.removeEventListener(MouseEvent.MOUSE_OVER, _over);
				this.removeEventListener(MouseEvent.MOUSE_OUT, _out);
				
			} else {
				shape.alpha = 0;
				_border.alpha = .3;
				
				this.addEventListener(MouseEvent.MOUSE_OVER, _over);
				this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			}
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get style():String {
			return _style;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set style(value:String):void {
			_style = value;
		}
		
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set border(value:Boolean):void {
			if (value) {
				this.addChild(_border);
			} else {
				this.removeChild(_border);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBorder():Sprite {
			return _border;
		}

	}
}