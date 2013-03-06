package util {
	
	//imports
	import model.Bibliography;
	import model.DocBodyModel;
	
	import flash.events.EventDispatcher;
	
	public class XmlParser extends EventDispatcher {
		
		//properties
		private var xml:XML;
		private var notes:XMLList;
		private var paragraphs:XMLList;
		
		private var bibliography:Bibliography;
		
		public function XmlParser(data:*) {
			xml = new XML(data);
		}
		
		public function createTextBody():DocBodyModel {
			
			paragraphs = xml.monograph.body.chapter.chapterBody.descendants("p");
			
			//create bibliography
			var docBody:DocBodyModel = new DocBodyModel(xml);
			
			//adding references
			for each(var p:XML in paragraphs) {
				docBody.addParagraph(p.toXMLString());
				
				/*
				var a:XML
				
				if (p.hasSimpleContent()) {
					//p.prependChild("<p>");
					//p.appendChild("</p>");
					
					
					var x:String = p.toXMLString();
					//trace (x);
					a = new XML(x);
					//trace (a)
					docBody.addParagraphXML(a);
				} else {
					
				}
				*/
				
				docBody.addParagraphXML(p);
				
			}
			
			return docBody;
		}
		
		public function createBibliography():Bibliography {
		
			notes = xml.monograph.body.chapter.chapterBody.descendants("note");
			var noteId:int;
			
			//create bibliography
			bibliography = new Bibliography(xml);
			
			//adding references
			for each(var note:XML in notes) {
				noteId = note.attribute("ID");
				
				for each(var bib:XML in note.descendants("bibRef")) {
					bibliography.addRef(bib, noteId.toString());
				}
				
			}
			
			return bibliography;
		}
	}
}