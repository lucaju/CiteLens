package util {
	
	//imports
	import model.Bibliography;
	import model.DocBodyModel;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class XmlParser extends EventDispatcher {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var xml			:XML;
		protected var notes			:XMLList;
		protected var paragraphs	:XMLList;
		
		protected var bibliography	:Bibliography;
		
		
		//****************** COnstructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function XmlParser(data:*) {
			xml = new XML(data);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
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
		
		/**
		 * 
		 * @return 
		 * 
		 */
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