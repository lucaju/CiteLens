package view.util.scroll {		//imports	import flash.display.Sprite;	import flash.geom.Rectangle;		public class Roll extends Sprite {				protected var _h:Number;		protected var _color:uint;				//properties		public function Roll(color_:uint = 0x000000) {						color = color_						// constructor code			alpha = 0;						this.graphics.beginFill(color, .6);			this.graphics.drawRoundRect(0,0,5,30,5,5);			this.graphics.endFill();						var slice9rect:Rectangle = new Rectangle(1, 10, 3, 6);			this.scale9Grid = slice9rect; 						h = this.height;		}		public function get h():Number {
			return _h;
		}		public function set h(value:Number):void {
			_h = value;
		}		public function get color():uint {
			return _color;
		}		public function set color(value:uint):void {
			_color = value;
		}	}	}