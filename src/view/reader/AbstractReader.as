package view.reader {
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import events.CiteLensEvent;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.TextLayoutEvent;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractReader extends Sprite {
		
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
		public function AbstractReader(_target:ReaderWindow):void {
			
			target = _target;
			
		}
		
		//****************** Initialize ****************** ****************** ******************
			
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//To Override
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
			
			TweenMax.to(readerDimension, .5, {endArray:[width,height], onUpdate:resize, onUpdateParams:[readerDimension]});
			
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
			
			this.scrollToElement(firtsElementId);
			
			readerFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 
		 * 
		 */
		public function clearHighlightElements():void {
			//to Override
		}
		
		/**
		 * 
		 * @param elementID
		 * 
		 */
		public function scrollToElement(elementID:String):void {
			
			//get element
			var element:FlowElement = readerFlow.getElementByID(elementID);
			
			//get Absolute start
			var absolueStart:int = element.getAbsoluteStart();
			
			
	
			//get line
			var line:TextFlowLine = readerFlow.flowComposer.findLineAtPosition(absolueStart);
			
			//deceive the reader: Scroll to the end to activate all lines, otherwise sime lines will not "exists" 
			//containerController.verticalScrollPosition = containerController.getContentBounds().height;
			//readerFlow.flowComposer.updateAllControllers();
				
			//update scroll
			containerController.verticalScrollPosition = line.y;
			readerFlow.flowComposer.updateAllControllers();
	
		}
		
		/**
		 * 
		 * @param notesIDs
		 * @return 
		 * 
		 */
		public function getFootnoteIDs(notesIDs):Array {
			//to override
			return null;
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