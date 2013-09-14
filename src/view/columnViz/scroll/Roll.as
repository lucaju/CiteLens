package view.columnViz.scroll {		//imports	import flash.display.BlendMode;	import flash.display.Sprite;		/**	 * 	 * @author lucaju	 * 	 */	public class Roll extends Sprite {				//****************** Proprieties ****************** ****************** ******************				protected var _offset			:Number;		protected var _color			:uint = 0x000000;;		protected var _hTotal			:Number;		protected var _hMax				:Number;		protected var rate				:Number;				//****************** Constructor ****************** ****************** ******************				/**		 * 		 * @param color_		 * 		 */		public function Roll() {					}						//****************** Initialize ****************** ****************** ******************					public function init(w:Number):void {						this.ratePage();						this.graphics.beginFill(color);			this.graphics.drawRect(0,0,w,hMax/rate);			this.graphics.endFill();						this.alpha = .7;						this.blendMode = BlendMode.OVERLAY;		}						//****************** PROTECTED METHODS ****************** ****************** ******************				/**		 * 		 * 		 */		protected function ratePage():void {			rate = hTotal / hMax;		}						//****************** PUBLIC METHODS METHODS ****************** ****************** ******************			/**		 * 		 * 		 */		public function update(data:Object):void {												hTotal = data.totalHeight;			ratePage();							this.height = hMax/rate;						this.y = _offset + data.verticalPosition / rate;					}						//****************** GETTERS // SETTERS ****************** ****************** ******************				/**		 * 		 * @return 		 * 		 */		public function get color():uint {			return _color;		}		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
		}		/**
		 * 
		 * @return 
		 * 
		 */
		public function get offset():Number {
			return _offset;
		}		/**
		 * 
		 * @param value
		 * 
		 */
		public function set offset(value:Number):void {
			_offset = value;			this.y += offset;
		}		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hTotal():Number {
			return _hTotal;
		}		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hTotal(value:Number):void {
			_hTotal = value;
		}		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hMax():Number {
			return _hMax;
		}		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hMax(value:Number):void {
			_hMax = value;
		}	}	}