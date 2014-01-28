package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Notes {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var data				:XMLList
		
		protected var bibliography		:Bibliography
		
		protected var note				:Note;
		protected var notesCollection	:Array;
		
		protected var xmlns				:Namespace;
		protected var xsi				:Namespace;
		protected var teiH				:Namespace;
		
		protected var total				:int = 0;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fullData
		 * @param bib
		 * 
		 */
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
				noteId = note.@teiH::id;
				
				addNote(note, noteId);
				total++
				
			}
			
			//look for notespan
			data = fullData.text.body.div.descendants("ref");
			
			//adding notespan
			for each(var span:XML in data) {
				if (span.@type == "noteSpan") addNoteSpan(span);
			}
				
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param item
		 * @param noteID_
		 * 
		 */
		public function addNote(item:XML, noteID_:int):void {
			
			default xml namespace = xmlns;
			
			//get the number part of ID attribute
			var noteUniqueID:String = item.@teiH::id
			noteUniqueID = noteUniqueID.substr(5); 			//removing "note_" part
			var noteID:int = Number(noteUniqueID);			//create a number
			
			//create new bibliographic reference
			note = new Note(noteID);
			
			//add to the list
			notesCollection.push(note);
			
			//test for unique ide
			if (item.@teiH::id != "") note.uniqueID = item.@teiH::id;
			
			//note place
			if (item.hasOwnProperty("@place")) {
				note.notePlace = item.@place;
				
				//footnote anchor
				if (note.notePlace == "foot") note.noteAnchor = item.@n;
				
			}
			
			//citations
			//test for series information
			for each(var ref:RefBibliographic in bibliography.getBibligraphy()) {
				for each (var refNote:Object in ref.notes) {
					if (refNote.id == noteID) note.addCitation(ref);
				}
			}
			
			note = null
		}
		
		/**
		 * 
		 * @param span
		 * 
		 */
		public function addNoteSpan(span:XML):void {
			
			var corresp:String = span.@corresp.toString();
			corresp = corresp.substring(1);
			
			for each (note in notesCollection) {
				if (note.uniqueID == corresp) note.noteSpan = span.text();			//in this case
			}
			
			note = null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRefByIndex(value:int):Note {
			return notesCollection[value];
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function traceNotes(value:int):void {
			note = notesCollection[value];
			trace ("ID: " + note.id)
			trace ("UniqueID: " + note.uniqueID)
			trace ("Chapter: "+note.chapter)
			trace ("Note Place: "+note.notePlace)
			
			if (note.noteAnchor) {
				trace ("Note Anchor(n): "+note.noteAnchor)
			} else {
				trace ("Note Anchor(n): -")
			}
			
			trace ("Start Location: "+note.startLocation)
			trace ("Note Span: "+note.noteSpan)
			if (note.citations.length > 0) {
				trace ("Citations:" + note.citations.length)
				for (var i:uint = 0; i<note.citations.length; i++) {
					trace ("--- " + note.citations[i].uniqueID);
				}
			}
			
			trace ("--------")
		}

		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get length():int {
			return notesCollection.length;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNotesCollection():Array {
			return notesCollection.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function numFootnotes():int {
			var num:int = 0;
			for each (note in notesCollection) {
				if (note.notePlace == "foot") num++;
			}
			return num;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function numInLine():int {
			var num:int = 0;
			for each (note in notesCollection) {
				if (note.notePlace == "in-line") num++;
			}
			return num;
		}
	}
}