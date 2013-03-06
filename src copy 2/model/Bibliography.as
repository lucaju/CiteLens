package model {
	
	//imports
	
	public class Bibliography {
		
		//properties
		private var data:XMLList
		
		private var ref:RefBibliographic;
		private var refCollection:Array;
		
		private var xmlns:Namespace;
		private var xsi:Namespace;
		private var teiH:Namespace;
		
		private var total:int = 0;
		
		public function Bibliography(fullData:XML) {
			//namespaces
			
			//xmlns = new Namespace(fullData.namespace());
			//trace (xmlns.prefix, xmlns.uri)
			
			var namespaces:Array = fullData.namespaceDeclarations();
			xsi = namespaces[0];
			xmlns = namespaces[1];
			
			//define namespace of lang and id attributes
			//trace(item.attributes()[1].name());
			teiH = new Namespace('http://www.w3.org/XML/1998/namespace');
						
			//define the default namespace
			default xml namespace = xmlns;
		
			//filter the data
			data = fullData.text.body.div.descendants("note");
			var noteId:int;
			var noteName:String;
			
			refCollection = new Array();
			
			//adding references
			for each(var note:XML in data) {
				noteId = note.@n;
				
				for each(var bib:XML in note.descendants("bibl")) {
					addRef(bib, noteId);
					total++;
				}
				
			}
			//trace (total)
				
		}
		
		public function addRef(item:XML, noteID:int):void {
			// -- test for repetition of this reference is the collection using bibl id
			var repeatedRef:Boolean = false;
			
			//treat corresp tag
			if (item.hasOwnProperty("@corresp")) {
				var corresp:String = item.@corresp.toString();
				corresp = corresp.substring(1);


				for each (var itemInCollection:RefBibliographic in refCollection) {
					//if (itemInCollection.uniqueID == ref.uniqueID || itemInCollection.uniqueID == item.@corresp) {			//in this case
					
					if (itemInCollection.uniqueID == corresp) {			//in this case
						//if (item.@reason || item.@contentType) {				//test for data
							itemInCollection.addNote(noteID, item.@reason, item.@contentType, item.@furtherReading)							//add the note span id to the array
						//}	
						repeatedRef = true;	
						break;																							//stop the search
					}
				}
			}
			
			//in case of this is a new reference, continue and add to the collection
			if (!repeatedRef) {
				
				//create new bibliographic reference
				ref = new RefBibliographic(refCollection.length); /// possible mistake
				
				//add to the list
				refCollection.push(ref);
				
				
				// -- Add info
				
				//test for unique id
				if (item.@teiH::id != "") {
					ref.uniqueID = item.@teiH::id;
				}
				
				//test for tittle
				if (item.hasOwnProperty("title")) {
					var titles:XMLList = item.descendants("title");
					
					for each(var title:XML in titles) {
						
						if (title.parent().localName() == "bibl") {  						///exclude titles under "Series" and "Related Items"
						
							if (title.hasOwnProperty("expan")) {
								ref.addTitle(title.expan.text(), title.@level);
							} else {
								ref.addTitle(title.text(), title.@level);	
							}
						}
					} 
				} else {
					ref.addTitle("---------", "a");
				}
				
				//test for authors
				if (item.hasOwnProperty("author")) {
					for each(var auth:XML in item.author) {
						ref.addAuthor(auth.name.(@type == "last"), auth.name.(@type == "first"));
					}
				} else {
					ref.addAuthor("*******", "");
				}
				
				//test for Editors
				if (item.hasOwnProperty("editor")) {
					for each(var edit:XML in item.editor) {
						ref.addEditor(edit.name.(@type == "last"), edit.name.(@type == "first"));
					}
				}
				
				//test for language
				if (item.@teiH::lang != "") {
					ref.language = item.@teiH::lang;
				}
				
				//test for publisher
				if (item.hasOwnProperty("publisher")) {
					ref.publisher = item.publisher;
				}
				
				//test for pubplace
				if (item.hasOwnProperty("pubPlace")) {
					for each(var pubPlace:XML in item.pubPlace) {
						ref.addPubPlace(pubPlace.text());
					}
				}
				
				//test for country
				var ntei:Namespace = new Namespace("http://www.example.org/ns/nonTEI");
				
				if (item.ntei::pubCountry != "") {
					for each(var country:XML in item.ntei::pubCountry) {
						ref.addCountry(country);
					}
				}
			
				//test for date
				if (item.hasOwnProperty("date")) {
					ref.date = item.date;
				}
				
				//test for series information
				if (item.hasOwnProperty("series")) {
					for each(var serie:XML in item.series) {
						ref.addSerie(serie.title, serie.biblScope.@type, serie.biblScope.text());
					}
				}
				
				//test for scope		
				if (item.@biblScope) {
					ref.scope = item.biblScope.text();
				}
		

				//test for source role
				if (item.@sourceRole != "") {
					ref.sourceRole = item.@sourceRole;
				}
				
				
				//test for type
				if (item.@type != "") {
					ref.type = item.@type;
				}
					
				//add connected note
				if (item.@reason != "" || item.@contentType) {
					ref.addNote(noteID, item.@reason, item.@contentType, item.@furtherReading)
				}
				
				
			}
			ref = null
		}
		
		public function get length():int {
			return refCollection.length;
		}
		
		public function getBibligraphy():Array {
			return refCollection.concat();
		}
		
		public function getRefByIndex(value:int):RefBibliographic {
			return refCollection[value];
		}
		
		public function traceRef(value:int):void {
			ref = refCollection[value];
			trace ("ID:" + value)
			trace ("UniqueID:" + ref.uniqueID + "-")
			trace ("Main Title: "+ref.title)
			if (ref.titles.length > 0) {
				trace ("Titles:" + ref.titles.length)
				for (var i:int = 0; i<ref.titles.length; i++) {
					trace ("id: " + ref.titles[i].id + " - Level: " + ref.titles[i].level + " - Title: " + ref.titles[i].name);
				}
			}
			trace ("Authors: "+ref.getAuthorship(true))
			trace ("Language: "+ref.language)
			
			if (ref.language == "") {
				trace ("heeeeyyy")
			}
			
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
					trace ("-- id: " + ref.notes[i].id + " - Reason: " + ref.notes[i].reason + " - Content Type: " + ref.notes[i].contentType);
				}
			}
			trace ("--------")
		}

	}
}