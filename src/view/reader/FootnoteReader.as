package view.reader {
	
	import flash.display.Sprite;
	
	import controller.CiteLensController;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.events.TextLayoutEvent;
	
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FootnoteReader extends AbstractReader {
		
		//****************** Properties ****************** ****************** ******************
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function FootnoteReader(_target:ReaderWindow):void {
			
			super(_target);
			
		}
		
		//****************** Initialize ****************** ****************** ******************
			
		/**
		 * 
		 * 
		 */
		override public function init():void {
			
			// --- Textflow
			// To built one you have 2 options
			// 1. import the text to a textFlow. It can be Plain text, XML (or HTML), Text Layout schema
			// Here, I worked with xml. But it dosn't like tags that have just text and no childrens. I had to inject child tags into tags without notespan
			// 2. it is possible to create a loop and build one element (div, paragraph, span, link) at a time. I found that way more compicated and time consuming for this project.
			
			//defining the container for the text flow
			var container:Sprite = new Sprite();
			//container.opaqueBackground = 0xEEEEEE;
			this.addChild(container);
			
			///FLOW
			readerFlow = CiteLensController(target.getController()).getNotesAsTextFlow();
			
			containerController = new ContainerController(container, dimensions.width, dimensions.height)
				
			readerFlow.flowComposer.addController(containerController);
			readerFlow.flowComposer.composeToPosition();
			readerFlow.hostFormat = TextReaderStyle.getStyle("body");
			//readerFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			readerFlow.flowComposer.updateAllControllers();
			
			//-----debug - output the xml of the text flow
			var outXML:XML = TextConverter.export(readerFlow,TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE) as XML;
			//trace(outXML);
			
			// -------select and change the stlyle in tag throught the flow
			this.changeElementStyleByName("footnote","footnote");
			
			//!!!!!!!!!!!!!!!selectable
			readerFlow.interactionManager = new SelectionManager();
			//readerFlow.interactionManager = new EditManager();
			
			//IMPORTANT !!!!
			//Text for Color Code Column export from here
			//var outString:String = TextConverter.export(readerFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			
			readerFlow.addEventListener(TextLayoutEvent.SCROLL, scroll);
			
			// ----- always remember to update controler after any change
			readerFlow.flowComposer.updateAllControllers();
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param elementID
		 * 
		 */
		override public function scrollToElement(elementID:String):void {
			
			//trace (elementID)
			
			//get element
			var element:FlowElement// = readerFlow.getElementByID(elementID);
			
			var foots:Array = readerFlow.getElementsByTypeName("footnote");
			for each (var f:FlowElement in foots) {
				//trace (f.id, elementID, elementID.length, f.id == elementID)
				if (f.id == elementID) {
					element = f;
					break;
				}
			}
			
			
			//trace (element.getText())
			
			if (element) {
				//get Absolute start
				var absolueStart:int = element.getAbsoluteStart();
				
				//get line
				var line:TextFlowLine = readerFlow.flowComposer.findLineAtPosition(absolueStart);
				
				//deceive the reader: Scroll to the end to activate all lines, otherwise sime lines will not "exists" 
				containerController.verticalScrollPosition = containerController.getContentBounds().height;
				readerFlow.flowComposer.updateAllControllers();
				
				//update scroll
				containerController.verticalScrollPosition = line.y;
				
				// ----- always remember to update controler after any change
				readerFlow.flowComposer.updateAllControllers();
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		override public function clearHighlightElements():void {
			this.changeElementStyleByName("footnote","footnote");
			readerFlow.flowComposer.updateAllControllers();
		}
		
	}
}