package view.reader {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import flashx.textLayout.compose.*;
	import flashx.textLayout.container.*;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.*;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	//import util.Global;
	
	import view.CiteLensView;
	
	public class Reader extends CiteLensView {
		
		//properties
		private var p:XML;
		private var paragraph:ParagraphElement;
		private var span:SpanElement
		private var paragraphArray:Array;
		private var readerFlow:TextFlow;
		
		private var container:Sprite;
		
		private var border:Shape;
		
		private var marginW:uint = 10;
		private var marginH:uint = 3;
		
		public function Reader() {
			
			super(citeLensController);
		}
		
		
		override public function initialize():void {
			
			//border
			border = new Shape();
			border.graphics.lineStyle(2,0x666666,1,true);
			border.graphics.beginFill(0xFFFFFF,0);
			border.graphics.drawRoundRect(0,0,275, 536, 10);
			border.graphics.endFill();
			
			this.addChild(border);
			
			
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
			container.y = marginH;
			this.addChild(container);
			
			// import xml from the doc model
			//var xml:XML = citeLensController.getAllParagraphs();
			
			//readerFlow = new TextFlow();
			
			//trace (xml)
			
			//readerFlow = TextConverter.importToFlow(xml,TextConverter.TEXT_FIELD_HTML_FORMAT)
			readerFlow = citeLensController.getFlowConvertText();
				
			readerFlow.flowComposer.addController(new ContainerController(container, 275 - (2*marginW), 536 - (2*marginH))); // make it mini - change the width to 20
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
			
			// ----- always remember to update controler after any change
			
			readerFlow.flowComposer.updateAllControllers()
		
			
			//-----debug - output the xml of the text flow
			//var outXML:XML = TextConverter.export(readerFlow,TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE) as XML;
			//trace(outXML);
			
			//IMPORTANT !!!!
			//Text for Color Code Column export from here
			//var outString:String = TextConverter.export(readerFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			
			
		}
	}
}