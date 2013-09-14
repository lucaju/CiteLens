package view.reader {
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.engine.FontLookup;
	
	import controller.CiteLensController;
	
	import events.CiteLensEvent;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.TextLayoutEvent;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Reader extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var target					:ReaderWindow;
		protected var readerFlow				:TextFlow;
		protected var containerController		:ContainerController;
		
		protected var dimensions				:Rectangle;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function Reader(_target:ReaderWindow):void {
			
			target = _target;
			
		}
		
		//****************** Initialize ****************** ****************** ******************
			
		public function init():void {
			
			// --- Textflow
			// To built one you have 2 options
			// 1. import the text to a textFlow. It can be Plain text, XML (or HTML), Text Layout schema
			// Here, I worked with xml. But it dosn't like tags that have just text and no childrens. I had to inject child tags into tags without notespan
			// 2. it is possible to create a loop and build one element (div, paragraph, span, link) at a time. I found that way more compicated and time consuming for this project.
			
			//defining the container for the text flow
			var container:Sprite = new Sprite();
			this.addChild(container);
			
			///FLOW
			readerFlow = CiteLensController(target.getController()).getFlowConvertText();
			
			containerController = new ContainerController(container, dimensions.width, dimensions.height)
				
			readerFlow.flowComposer.addController(containerController); // make it mini - change the width to 20
			readerFlow.hostFormat = TextReaderStyle.getStyle("body");
			//readerFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			readerFlow.flowComposer.updateAllControllers();
			
			//-----debug - output the xml of the text flow
			var outXML:XML = TextConverter.export(readerFlow,TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE) as XML;
			//trace(outXML);
			
			// -------select and change the stlyle in tag throught the flow
			this.changeElementStyleByName("chapter","chapter");
			this.changeElementStyleByName("chapter_section","chapterSection");
			this.changeElementStyleByName("label","label");
			this.changeElementStyleByName("note_span","noteSpan");
			this.changeElementStyleByName("note_loc","superScript");
			
			//!!!!!!!!!!!!!!!selectable
			readerFlow.interactionManager = new SelectionManager();
			//readerFlow.interactionManager = new EditManager();
			
			// ----- always remember to update controler after any change
			readerFlow.flowComposer.updateAllControllers();
			
			//IMPORTANT !!!!
			//Text for Color Code Column export from here
			//var outString:String = TextConverter.export(readerFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			
			readerFlow.addEventListener(TextLayoutEvent.SCROLL, scroll);
		}
		
		//****************** PUBLIC METHODS - Dimensions ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function scroll(event:TextLayoutEvent):void {
			var data:Object = new Object();
			data.verticalPosition = containerController.verticalScrollPosition
			data.totalHeight = Math.ceil(containerController.getContentBounds().height);
			
			this.dispatchEvent(new CiteLensEvent(CiteLensEvent.READER_SCROLL, data));
		}
		
		//****************** PUBLIC METHODS - Dimensions ****************** ****************** ******************
		
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
		public function updateDimension(width:Number, height:Number):void {
			
			//reader
			var actualReaderBounds:Rectangle = containerController.getContentBounds();
			var readerDimension:Array = [actualReaderBounds.width, actualReaderBounds.height];
			
			TweenMax.to(readerDimension, .5, {endArray:[width,height], onUpdate:resize, onUpdateParams:[readerDimension],delay:.3});
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function resize(value:Array):void {
			containerController.setCompositionSize(value[0],value[1]);
			readerFlow.flowComposer.updateAllControllers();
			
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * 
		 * 
		 */
		public function getCurrentVerticalPosition():Number {
			return containerController.verticalScrollPosition;
		}
		
		/**
		 * 
		 * 
		 */
		public function setVerticalPosition(value:Number):void {
			containerController.verticalScrollPosition = value;;
		}
		
		/**
		 * 
		 * 
		 */
		public function getVisibleHeight():Number {
			return containerController.compositionHeight;
		}
		
		/**
		 * 
		 * 
		 */
		public function getMaxHeight():Number {
			return Math.ceil(containerController.getContentBounds().height);
			
		}

		
		//****************** PUBLIC METHODS - TEXT ****************** ****************** ******************
		
		/**
		 * 
		 * @param elementName
		 * @param styleName
		 * 
		 */
		public function changeElementStyleByName(elementName:String, styleName:String):void {
			var elementArray:Array = readerFlow.getElementsByTypeName(elementName);
			for each (var element:FlowElement in elementArray) {
				element.format = TextReaderStyle.getStyle(styleName);
			}
			readerFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 
		 * @param elementName
		 * @param styleName
		 * 
		 */
		public function highlightElementByID(elementID:*, styleName:String = "selectedNoteSpan"):void {
			
			//remove highlights
			this.clearHighlightElements();
			
			var firtsElementId:String;
			var element:FlowElement;
			
			if (elementID is String) {
				firtsElementId = elementID;
				element = readerFlow.getElementByID(elementID);
				if (element) element.format = TextReaderStyle.getStyle(styleName);
			
			} if (elementID is Array) {
				for each (var id:String in elementID) {
					if(elementID.indexOf(id) == 0) firtsElementId = id;
					element = readerFlow.getElementByID(id);
					if (element) element.format = TextReaderStyle.getStyle(styleName);
				}
			
			}
			
			this.scrollToHighlightedElement(firtsElementId);
			
			readerFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 
		 * 
		 */
		public function clearHighlightElements():void {
			this.changeElementStyleByName("note_span","noteSpan");
			readerFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 
		 * @param elementID
		 * 
		 */
		public function scrollToHighlightedElement(elementID:String):void {
			
			//get element
			var element:FlowElement = readerFlow.getElementByID(elementID);
			
			//get Absolute start
			var absolueStart:int = element.getAbsoluteStart();
			
			//get line
			var line:TextFlowLine = readerFlow.flowComposer.findLineAtPosition(absolueStart);
			
			//update scroll
			containerController.verticalScrollPosition = line.y;
	
		}

		//****************** GETTERS // SETTER ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get textFlow():TextFlow {
			return readerFlow;
		}
	}
}