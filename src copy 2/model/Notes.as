package model {
	
	//imports
	
	public class Notes {
		
		//properties
		private var data:XMLList
		
		private var bibliography:Bibliography
		
		private var note:Note;
		private var notesCollection:Array;
		
		private var xmlns:Namespace;
		private var xsi:Namespace;
		private var teiH:Namespace;
		
		private var total:int = 0;
		
		public function Notes(fullData:XML, bib:Bibliography) {
			
			bibliography = bib;
			
			//namespaces
			
			//xmlns = new Namespace(fullData.namespace());
			//trace (xmlns.prefix, xmlns.uri)
			
			var namespaces:Array = fullData.namespaceDeclarations();
			xsi = namespaces[0];
			xmlns = namespaces[1];
			
			//define namespace of id attributes
			teiH = new Namespace('http://www.w3.org/XML/1998/namespace');
						
			//define the default namespace
			default xml namespace = xmlns;
		
			//filter the data
			data = fullData.text.body.div.descendants("note");
			var noteId:int;
			
			notesCollection = new Array();
			
			//adding Notes
			for each(var note:XML in data) {
				noteId = note@teiH::lang;
				
				addNote(note, noteId);
				total++
				
			}
			
			//look for notespan
			data = fullData.text.body.div.descendants("ref");
			
			//adding notespan
			for each(var span:XML in data) {
				if (span.@type == "noteSpan") {
					addNoteSpan(span);
				}
			}
				
		}
		
		public function addNote(item:XML, noteID:int):void {
			
			//create new bibliographic reference
			note = new Note(noteID);
			
			//add to the list
			notesCollection.push(note);
			
			//test for unique ide
			if (item.@teiH::id != "") {
				note.uniqueID = item.@teiH::id;
			}
			
			//note place
			if (item.hasOwnProperty("@place")) {
				note.notePlace = item.@place
			}
			
			//citations
			//test for series information
			for each(var ref:RefBibliographic in bibliography.getBibligraphy()) {
				for each (var refNote:Object in ref.notes) {
					if (refNote.id == noteID) {
						note.addCitation(ref);
					}
				}
			}
			
			note = null
		}
		
		public function addNoteSpan(span:XML):void {
			
			var corresp:String = span.@corresp.toString();
			corresp = corresp.substring(1);
			
			for each (note in notesCollection) {
				if (note.uniqueID == corresp) {			//in this case
					note.noteSpan = span.text();
				}
			}
			
			note = null;
		}
		
		public function get length():int {
			return notesCollection.length;
		}
		
		public function getRefByIndex(value:int):Note {
			return notesCollection[value];
		}
		
		public function traceNotes(value:int):void {
			note = notesCollection[value];
			trace ("ID: " + note.id)
			trace ("UniqueID: " + note.uniqueID)
			trace ("Chapter: "+note.chapter)
			trace ("Note Place: "+note.notePlace)
			trace ("Start Location: "+note.startLocation)
			trace ("Note Span: "+note.noteSpan)
			if (note.citations.length > 0) {
				trace ("Citations:" + note.citations.length)
				for (var i:uint = 0; i<note.citations.length; i++) {
					trace (note.citations[i].uniqueID);
				}
			}
			trace ("--------")
		}

	}
}