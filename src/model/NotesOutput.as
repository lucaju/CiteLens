package model {
	
	
	public class NotesOutput {
		
		
		/**
		 * 
		 * @param biblography
		 * 
		 */
		static public function traceAll(notes:Notes):void {
			for each (var note:Note in notes.getNotesCollection()) {
				traceNote(note)
			}
		}
		
		/**
		 * 
		 * @param ref
		 * 
		 */
		static public function traceNote(note:Note):void {
			
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
			
			trace ("--------");
			
		}
	}
}