package view.reader.readerScroll {		//imports	import flash.display.Sprite;	import flash.geom.Rectangle;		/**	 * 	 * @author lucaju	 * 	 */	public class Roll extends Sprite {				//****************** Proprieties ****************** ****************** ******************				protected var _color			:uint;						//****************** Constructor ****************** ****************** ******************				public function Roll(color_:uint = 0x000000) {			color = color_		}						//****************** Public Methods ****************** ****************** ******************				public function init():void {						var slice9rect:Rectangle;						this.graphics.beginFill(color, .6);			this.graphics.drawRoundRect(0,0,6,30,5);			slice9rect = new Rectangle(1, 10, 4, 6);			this.graphics.endFill();			this.scale9Grid = slice9rect; 					}						//****************** GETTERS // SETTERS ****************** ****************** ******************				/**		 * 		 * @return 		 * 		 */		public function get color():uint {			return _color;		}				/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
		}	}	}