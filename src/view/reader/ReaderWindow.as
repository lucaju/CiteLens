package view.reader {
	
	import com.greensock.TweenMax;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.WindowHeader;
	import view.reader.readerScroll.ReaderScroll;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ReaderWindow extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var header					:WindowHeader;					//header
		protected var border					:Shape;
		protected var reader					:Reader;
		protected var scroll					:view.reader.readerScroll.ReaderScroll
		
		protected var dimensions				:Rectangle;
		
		protected var marginW					:uint	 = 10;
		protected var marginH					:uint	 = 0;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function ReaderWindow(c:IController):void {
			super(c);
			dimensions = new Rectangle(0,0,275,538);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function initialize():void {
			
			//border
			border = new Shape();
			border.graphics.lineStyle(2,0xCCCCCC,1,false,LineScaleMode.NONE);
			border.graphics.beginFill(0xFFFFFF,0);
			border.graphics.drawRoundRect(0,0,dimensions.width, dimensions.height, 10);
			border.graphics.endFill();
			
			this.addChild(border);
			
			//header
			header = new WindowHeader();
			header.setDimensions(this.width-1);
			header.init();
			this.addChildAt(header,0);
			
			//reader
			var readerW:Number = dimensions.width - ( 2 *marginW);
			var readerH:Number = dimensions.height - (2 * marginH) - header.height;
			
			reader = new Reader(this);
			reader.x = marginW
			reader.y = header.height + marginH;;
			this.addChild(reader);
			reader.setDimensions(readerW, readerH);
			reader.init();
			
			reader.addEventListener(Event.RESIZE, readerResize);
			
			//Scroll
			scroll = new ReaderScroll();
			scroll.target = reader;
			this.addChildAt(scroll,0);
			scroll.init();
			scroll.alpha = 0;
			scroll.visible = false;
			scroll.x = dimensions.width - scroll.width;
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}			
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		protected function evaluteUpdateDimensionValues(value:Object):Boolean {
			//evaluate
			for (var prop:String in value) {
					
				if (dimensions.hasOwnProperty(prop)) {
					if (value[prop] is String) {
						dimensions[prop] += new Number(value[prop])
					} else if (value[prop] is Number) {
						dimensions[prop] = value[prop];
					} else {
						throw new Error("Wrong " + prop + " value type. Must be a Number (for absolute values) or a String (for relative values)!");
					}
					
				} else {
					throw new Error("Property  '" + prop + "' not found!");
				}
				
			}
			return true;
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function readerResize(event:Event):void {
			scroll.update();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOver(event:MouseEvent):void {
			TweenMax.to(scroll,.4,{autoAlpha:1});
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function rollOut(event:MouseEvent):void {
			TweenMax.to(scroll,.4,{autoAlpha:0});
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param valueW
		 * @param valueH
		 * 
		 */
		public function setDimensions(valueW:Number, valueH:Number):void {
			dimensions = new Rectangle(0,0,valueW,valueH);
		}
		
		/**
		 * 
		 * @param valueW
		 * @param valueH
		 * 
		 */
		public function updateDimension(values:Object):void {
			
			this.evaluteUpdateDimensionValues(values);
			
			//Boders & Header
			TweenMax.to(border, .5, {width:dimensions.width, delay:.3});
			TweenMax.to(header, .5, {width:dimensions.width - 1, delay:.3});
			
			TweenMax.to(scroll, .5, {x:dimensions.width - scroll.width - 1, delay:.3});
			
			var NewReaderW:Number = dimensions.width - ( 2 *marginW);
			var NewReaderH:Number = dimensions.height - (2 * marginH) - header.height;
			
			//reader
			reader.updateDimension(NewReaderW,NewReaderH);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function resize(value:Array):void {
			reader.resize(value);
			scroll.update();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getReaderMaxHeight():Number {
			return reader.getMaxHeight();
		}
		
		
		//****************** READER PUBLIC METHODS PROXY ****************** ****************** ******************
		
		/**
		 * 
		 * @param elementName
		 * @param styleName
		 * 
		 */
		public function changeElementStyleByName(elementName:String, styleName:String):void {
			reader.changeElementStyleByName(elementName, styleName);
		}
		
		/**
		 * 
		 * @param elementName
		 * @param styleName
		 * 
		 */
		public function highlightElementByID(elementID:*, styleName:String = "selectedNoteSpan"):void {
			reader.highlightElementByID(elementID,styleName)
		}
		
		/**
		 * 
		 * 
		 */
		public function clearHighlightElements():void {
			reader.clearHighlightElements();
		}
		
	}
}

