package model {
	
	public class BibliographyOutput {
		
		/**
		 * 
		 * @param biblography
		 * 
		 */
		static public function traceAll(biblography:Bibliography):void {
			for each (var ref:RefBibliographic in biblography.getBibligraphy()) {
				traceRef (ref)
			}
		}
		

		/**
		 * 
		 * @param ref
		 * 
		 */
		static public function traceRef(ref:RefBibliographic):void {
			
			trace ("ID:" + ref.id)
			
			trace ("UniqueID:" + ref.uniqueID)
			
			trace ("Main Title: "+ref.title)
			
			if (ref.titles.length > 0) {
				trace ("Titles:" + ref.titles.length)
				for (var i:int = 0; i<ref.titles.length; i++) {
					trace ("id: " + ref.titles[i].id + " - Level: " + ref.titles[i].level + " - Title: " + ref.titles[i].name);
				}
			}
			
			trace ("Authors: "+ref.getAuthorship(true))
			
			trace ("Language: "+ref.language)
			
			trace ("Publisher: "+ref.publisher)
			
			if (ref.pubPlaces.length > 0) {
				trace ("Publication Place:" + ref.pubPlaces.length)
				for (i = 0; i<ref.pubPlaces.length; i++) {
					trace (ref.pubPlaces[i]);
				}
			}
			
			if (ref.countries.length > 0) {
				trace ("Countries:" + ref.countries.length)
				for (i = 0; i<ref.countries.length; i++) {
					trace (ref.countries[i]);
				}
			}
			
			trace ("Date: "+ref.date)
			
			if (ref.series.length > 0) {
				trace ("Series:" + ref.series.length)
				for (i = 0; i<ref.series.length; i++) {
					trace ("-- id: " + ref.series[i].id + " - Title: " + ref.series[i].title + " - Type: " + ref.series[i].type + " - Bibliography Scope: " + ref.series[i].bibScope);
				}
			}
			
			trace ("Scope: "+ref.scope)
			
			trace ("Source Role: "+ref.sourceRole)
			
			trace ("Type: "+ref.type)
			
			if (ref.notes.length > 0) {
				trace ("Notes: " + ref.notes.length)
				for (i=0; i<ref.notes.length; i++) {
					trace ("-- id: " + ref.notes[i].id + " - Reason: " + ref.notes[i].reason + " - Content Type: " + ref.notes[i].contentType+ " - Further Reading: " + ref.notes[i].furtherReading);
				}
			}
			
			trace ("--------");
		}
	}
}