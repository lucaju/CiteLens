package view.reader {
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import controller.CiteLensController;
	
	import events.CiteLensEvent;
	
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.SubParagraphGroupElement;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.events.TextLayoutEvent;
	
	//namespace
	use namespace tlf_internal;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class MainReader extends AbstractReader {
		
		//****************** Properties ****************** ****************** ******************
	
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function MainReader(_target:ReaderWindow):void {
			
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
			this.addChild(container);
			
			///FLOW
			
			readerFlow = CiteLensController(target.getController()).getFlowConvertText();
			
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
			this.changeElementStyleByName("chapter","chapter");
			this.changeElementStyleByName("chapter_section","chapterSection");
			this.changeElementStyleByName("label","label");
			this.changeElementStyleByName("note_span","noteSpan");
			this.changeElementStyleByName("note_loc","superScript");
			
			//!!!!!!!!!!!!!!!selectable
			readerFlow.interactionManager = new SelectionManager();
			//readerFlow.interactionManager = new EditManager();
			
			//IMPORTANT !!!!
			//Text for Color Code Column export from here
			//var outString:String = TextConverter.export(readerFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			
			//scroll listener
			
			readerFlow.addEventListener(TextLayoutEvent.SCROLL, scroll);
			
			//noteSpan listener
			this.addEventListenerToNoteSpan();
			
			// ----- always remember to update controler after any change
			readerFlow.flowComposer.updateAllControllers();
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function addEventListenerToNoteSpan():void {
			
			var elementArray:Array = readerFlow.getElementsByTypeName("note_loc");
			for each (var element:FlowElement in elementArray) {
				
				var mirror:IEventDispatcher = element.getEventMirror();
				mirror.addEventListener(FlowElementMouseEvent.ROLL_OVER, spanNoteRollOver);
				mirror.addEventListener(FlowElementMouseEvent.ROLL_OUT, spanNoteRollOut);
				mirror.addEventListener(FlowElementMouseEvent.CLICK, spanNoteClick);
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function spanNoteRollOver(event:FlowElementMouseEvent):void {
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function spanNoteRollOut(event:FlowElementMouseEvent):void {
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function spanNoteClick(event:FlowElementMouseEvent):void {
			var element:FlowElement = event.flowElement;
			
			
			var data:Object = new Object();
			data.footnoteID = element.id;
			
			this.dispatchEvent(new CiteLensEvent(CiteLensEvent.READER_CLICK, data));
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function clearHighlightElements():void {
			this.changeElementStyleByName("note_span","noteSpan");
			readerFlow.flowComposer.updateAllControllers();
		}
		

		/**
		 * 
		 * @param notesIDs
		 * @return 
		 * 
		 */
		override public function getFootnoteIDs(notesIDs):Array {
			
			var footnotesIDs:Array = new Array();
			
			for each (var noteID:String in notesIDs) {
				
				var footNoteElement:Array = readerFlow.getElementsByTypeName("note_loc");
					
				for each (var fNoteElem:FlowElement in footNoteElement) {
					
					var parentElement:FlowElement = fNoteElem.getParentByType(SubParagraphGroupElement);
				
					if (parentElement.id == noteID) {
						footnotesIDs.push(fNoteElem.id);
						break;
					}
					
				}
			}
			
			
			return footnotesIDs;
		}
		
		
	}
}