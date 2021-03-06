package view.reader {
	
	import com.greensock.TweenMax;
	
	import controller.CiteLensController;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import events.CiteLensEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.WindowHeader;
	import view.reader.readerScroll.ReaderScroll;
	import view.style.ColorSchema;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ReaderWindow extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var header					:WindowHeader;					//header
		protected var border					:Shape;
		
		protected var reader					:AbstractReader;
		protected var footnoteReader			:AbstractReader;
		
		protected var scroll					:ReaderScroll;
		protected var scrollFootnotes			:ReaderScroll;
		
		protected var dimensions				:Rectangle;
		
		protected var marginW					:uint	 = 10;
		protected var marginH					:uint	 = 0;
		
		protected var _headerTitle				:String;
		
		protected var splitLine					:Sprite;
		
		protected var hasFootnotes				:Boolean = false;
		
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
			
			//has footnotes
			if (CiteLensController(this.getController()).numFootnotes() > 0) hasFootnotes = true;
			
			//border
			border = new Shape();
			border.graphics.lineStyle(2,0xCCCCCC,0,false,LineScaleMode.NONE);
			border.graphics.beginFill(0xFFFFFF,0);
			border.graphics.drawRoundRect(0,0,dimensions.width, dimensions.height, 10);
			border.graphics.endFill();
			
			this.addChild(border);
			
			//header
			if (_headerTitle) {
				header = new WindowHeader();
				
				header.setDimensions(this.width-1);
				header.init();
				header.setTitle(headerTitle,ColorSchema.DARK_GREY);
				this.addChildAt(header,0);
			}
			
			//sizes
			var readerW:Number = dimensions.width - ( 2 *marginW);
			var readerH:Number = dimensions.height - (2 * marginH) - ( (header) ? header.height: 0 );
			
			
			//---------------Main reader
			reader = new MainReader(this);
			reader.name = "mainReader";
			reader.x = marginW
			reader.y = ( (header) ? header.height: 0 ) + marginH;
			this.addChild(reader);
			
			if (hasFootnotes) {
				reader.setDimensions(readerW, readerH * .80);
			} else {
				reader.setDimensions(readerW, readerH);
			}
			
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
			
			reader.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			reader.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			reader.addEventListener(CiteLensEvent.READER_CLICK, readerClicklHander);
			
			if (hasFootnotes) {
			
				//---------------Split Line
				
				splitLine = new Sprite();
				splitLine.graphics.lineStyle(1, ColorSchema.LIGHT_GREY);
				splitLine.graphics.lineTo(readerW,0);
				splitLine.x = marginW;
				splitLine.y = reader.y + reader.height;
				this.addChild(splitLine);
				
				//---------------Footnote reader
				footnoteReader = new FootnoteReader(this);
				footnoteReader.name = "footnoteReader";
				footnoteReader.x = marginW
				footnoteReader.y = splitLine.y + 4;
				this.addChild(footnoteReader);
				footnoteReader.setDimensions(readerW, readerH * .17);
				footnoteReader.init();
				
				footnoteReader.addEventListener(Event.RESIZE, readerResize);
				
				//Scroll
				scrollFootnotes = new ReaderScroll();
				scrollFootnotes.target = footnoteReader;
				this.addChildAt(scroll,0);
				scrollFootnotes.init();
				scrollFootnotes.alpha = 0;
				scrollFootnotes.visible = false;
				scrollFootnotes.x = dimensions.width - scroll.width;
				
			}
			
			
			
			/*if (this.name == "reader") {
				reader = new MainReader(this);
			} else if (this.name == "footnotes") {
				reader = new FootnoteReader(this);
			}
			
			if (reader) {
				reader.x = marginW
				reader.y = ( (header) ? header.height: 0 ) + marginH;
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
			}*/
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
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function readerClicklHander(event:CiteLensEvent):void {
			footnoteReader.scrollToElement(event.parameters.footnoteID);
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
			TweenMax.to(border, .5, {width:dimensions.width});
			if (header) TweenMax.to(header, .5, {width:dimensions.width - 1});
			
			TweenMax.to(scroll, .5, {x:dimensions.width - scroll.width - 1});
			
			var NewReaderW:Number = dimensions.width - ( 2 *marginW);
			var NewReaderH:Number = dimensions.height - (2 * marginH) - ( (header) ? header.height: 0 );
			
			//reader
			
			if (hasFootnotes) {
				reader.updateDimension(NewReaderW,NewReaderH * .80);
			} else {
				reader.updateDimension(NewReaderW,NewReaderH);
			}
			
			if (footnoteReader) {
				TweenMax.to(splitLine, .5, {width:NewReaderW});
				footnoteReader.updateDimension(NewReaderW,NewReaderH *.17);
			}
			
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
		
		/**
		 * 
		 * @param elementID
		 * 
		 */
		public function scrollToElement(elementID:String):void {
			reader.scrollToElement(elementID);
		}
		
		/**
		 * 
		 * @param notesIDs
		 * @return 
		 * 
		 */
		public function getFootnoteIDs(notesIDs):Array {
			return reader.getFootnoteIDs(notesIDs);
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
				
			if (footnoteReader) {
			//get footnote reference
				var footnotesIDs:Array = reader.getFootnoteIDs(elementID);
				footnoteReader.highlightElementByID(footnotesIDs,"selectedFootnote")
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function clearHighlightElements():void {
			reader.clearHighlightElements();
			if (footnoteReader) footnoteReader.clearHighlightElements();
		}

		
		
		//****************** GETTER // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get headerTitle():String {
			return _headerTitle;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set headerTitle(value:String):void {
			_headerTitle = value;
		}

		
	}
}

