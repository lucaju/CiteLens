package view.reader {
	
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import controller.CiteLensController;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	
	import view.PanelHeader;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Reader extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var citeLensController		:CiteLensController				//controller
		
		protected var p							:XML;
		protected var paragraph					:ParagraphElement;
		protected var span						:SpanElement
		protected var paragraphArray			:Array;
		protected var readerFlow				:TextFlow;
		protected var header					:PanelHeader;					//header
		protected var container					:Sprite;
		protected var containerController		:ContainerController;
		
		protected var border					:Shape;
		
		protected var w							:int	 = 275;
		protected var h							:int	 = 538;
			
		protected var marginW					:uint	 = 10;
		protected var marginH					:uint	 = 3;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function Reader(value:CiteLensController):void {
			citeLensController = value;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function initialize():void {
			
			//border
			border = new Shape();
			border.graphics.lineStyle(2,0xCCCCCC,1,true);
			border.graphics.beginFill(0xFFFFFF,0);
			border.graphics.drawRoundRect(0,0,w, h, 10);
			border.graphics.endFill();
			
			this.addChild(border);
			
			//header
			header = new PanelHeader();
			header.setDimensions(this.width-1);
			header.init();
			addChildAt(header,0);
			
			//make it mini
			/*
			textStyle.fontSize = 1;
			textStyle.fontWeight = "bold";
			textStyle.lineHeight = 2;
			textStyle.fontWeight = "bold";
			textStyle.paragraphSpaceBefore = 0;
			textStyle.paragraphSpaceAfter = 3;
			*/
			
			
			// --- Textflow
			// To built one you have 2 options
			// 1. import the text to a textFlow. It can be Plain text, XML (or HTML), Text Layout schema
			// Here, I worked with xml. But it dosn't like tags that have just text and no childrens. I had to inject child tags into tags without notespan
			// 2. it is possible to create a loop and build one element (div, paragraph, span, link) at a time. I found that way more compicated and time consuming for this project.
			
			//defining the container for the text flow
			container = new Sprite();
			container.x = marginW;
			container.y = header.height + marginH;
			this.addChild(container);
			
			// import xml from the doc model
			//var xml:XML = citeLensController.getAllParagraphs();
			
			//readerFlow = new TextFlow();
			
			//trace (xml)
			
			//readerFlow = TextConverter.importToFlow(xml,TextConverter.TEXT_FIELD_HTML_FORMAT)
			readerFlow = citeLensController.getFlowConvertText();
				
			containerController = new ContainerController(container, w - (2*marginW), h - (2*marginH) - header.height)
			
			
				
			readerFlow.flowComposer.addController(containerController); // make it mini - change the width to 20
			readerFlow.hostFormat = TextReaderStyle.getStyle("body");
			readerFlow.flowComposer.updateAllControllers();
			
			// -------select and change the stlyle in tag throught the flow
			
			
			// change notes style
			var notes:Array = readerFlow.getElementsByTypeName("ref");
			for each (var note:FlowElement in notes) {
				note.format = TextReaderStyle.getStyle("noteSpan");
			}
			
			// change footnote anchor style
			var footnoteAnchors:Array = readerFlow.getElementsByTypeName("noteloc");
			for each (var footnoteAnchor:FlowElement in footnoteAnchors) {
				footnoteAnchor.format = TextReaderStyle.getStyle("superScript");
			}
			
			
			// ----------change style in on span
			/*
			var a:FlowElement = readerFlow.getElementByID("96")
			a.setStyle("color", 0x0FF00A);
			*/
			
			
			//!!!!!!!!!!!!!!!selectable
			readerFlow.interactionManager = new SelectionManager();
			//readerFlow.interactionManager = new EditManager();
			
			// ----- always remember to update controler after any change
			readerFlow.flowComposer.updateAllControllers()
		
			
			//-----debug - output the xml of the text flow
			//var outXML:XML = TextConverter.export(readerFlow,TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE) as XML;
			//trace(outXML);
			
			//IMPORTANT !!!!
			//Text for Color Code Column export from here
			//var outString:String = TextConverter.export(readerFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param valueW
		 * @param valueH
		 * 
		 */
		public function setDimensions(valueW:Number, valueH:Number):void {
			w = valueW;
			h = valueH;
		}
		
		/**
		 * 
		 * @param valueW
		 * @param valueH
		 * 
		 */
		public function updateDimension(valueW:Number, valueH:Number = 0):void {
			
			//reader
			var actualReaderBounds:Rectangle = containerController.getContentBounds();
			var readerDomension:Array = [actualReaderBounds.width, actualReaderBounds.height];
			
			// new values
			 w = w + valueW;
			 h = h + valueH;
			 
			 var NewReaderW:Number = w - (2*marginW);
			 var NewReaderH:Number = h - (2*marginH) - header.height;
			
			TweenMax.to(readerDomension, .5, {endArray:[NewReaderW,NewReaderH], onUpdate:resize, onUpdateParams:[readerDomension],delay:.3});
			
			//boders
			TweenMax.to(border, .5, {width:border.width + valueW, delay:.3});
			TweenMax.to(header, .5, {width:header.width + valueW, delay:.3});
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function resize(value:Array):void {
			containerController.setCompositionSize(value[0],value[1]);
			readerFlow.flowComposer.updateAllControllers();
		}
	}
}