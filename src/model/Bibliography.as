package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Bibliography {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var data				:XMLList
		
		protected var ref				:RefBibliographic;
		protected var refCollection		:Array;
		
		protected var xmlns				:Namespace;
		protected var xsi				:Namespace;
		protected var teiH				:Namespace;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fullData
		 * 
		 */
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
			
			refCollection = new Array();
			
			//adding references
			for each(var note:XML in data) {
				for each (var bib:XML in note.descendants("bibl")) {
					
					addRef(bib, note.@teiH::id);
					
					//trace (bib)
					
				}
			}
				
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param item
		 * @param _noteUniqueID
		 * 
		 */
		protected function addRef(item:XML, _noteUniqueID:String):void {
			
			/// Namespace
			default xml namespace = xmlns;
			
			//get the number part of ID attribute
			var noteUniqueID:String = _noteUniqueID
			noteUniqueID = noteUniqueID.substr(5); 			//removing "note_" part
			var noteID:int = Number(noteUniqueID);			//create a number
			
			// -- test for repetition of this reference is the collection using bibl id
			var repeatedRef:Boolean = false;
			
			//treat corresp tag
			if (item.hasOwnProperty("@corresp")) {
				var corresp:String = item.@corresp.toString();
				corresp = corresp.substring(1);
				
				for each (var itemInCollection:RefBibliographic in refCollection) {
					//if (itemInCollection.uniqueID == ref.uniqueID || itemInCollection.uniqueID == item.@corresp) {			//in this case
					
					if (itemInCollection.uniqueID == corresp) {			//in this case
						
						//----add connected note
						
						//reason
						var reason:String = item.@reason;
						
						//contentType
						var contentType:String = item.@contentType;
						
						//furtherReading
						var furtherReading:String = item.@furtherReading;
						if (furtherReading == "") {
							furtherReading = "false";
						} else {
							furtherReading = "true";
						}
						
						//trace (furtherReading)
						
						itemInCollection.addNote(noteID, noteUniqueID, reason, contentType, furtherReading)										//add the note span id to the array
							
						repeatedRef = true;	
						break;																							//stop the search
					}
				}
			}
			
			
			//in case of this is a new reference, continue and add to the collection
			if (!repeatedRef) {
				
				//create new bibliographic reference
				
				//get the number part of ID attribute
				var biblUniqueID:String = item.@teiH::id
				biblUniqueID = biblUniqueID.substr(5); 			//removing "bibl_" part
				var biblID:int = Number(biblUniqueID);			//create a number
				
				
				ref = new RefBibliographic(biblID); /// possible mistake
				
				//add to the list
				refCollection.push(ref);
				
				
				// -- Add info
				
				//test for unique id
				if (item.@teiH::id != "") ref.uniqueID = item.@teiH::id;
				
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
				if (item.@teiH::lang.toString().length > 0) ref.language = item.@teiH::lang;
				
				//degub Language
				if (item.@teiH::lang.toString().length == 0) ref.language = "**";
				
				
				//test for publisher
				if (item.hasOwnProperty("publisher")) ref.publisher = item.publisher;
				
				
				//test for pubplace
				if (item.hasOwnProperty("pubPlace")) {
					for each(var pubPlace:XML in item.pubPlace) {
						ref.addPubPlace(pubPlace.text());
					}
				}
				
				//test for country
				
				var ntei:Namespace = new Namespace("http://www.example.org/ns/nonTEI");
				if (item.ntei::pubCountry.toString().length > 0) {
					for each(var country:XML in item.ntei::pubCountry) {
						ref.addCountry(country);
					}
				}
				
				//degub country
				else {
					ref.addCountry("Other");
				}
			
				//test for date
				if (item.hasOwnProperty("date")) ref.date = item.date;
				
				
				//test for series information
				if (item.hasOwnProperty("series")) {
					for each(var serie:XML in item.series) {
						ref.addSerie(serie.title, serie.biblScope.@type, serie.biblScope.text());
					}
				}
				
				//test for scope		
				if (item.@biblScope) ref.scope = item.biblScope.text();
				
				//test for source role
				if (item.@sourceRole != "") ref.sourceRole = item.@sourceRole;
				
				//test for type
				if (item.hasOwnProperty("@type")) ref.type = item.@type;
				
				//debug type
				if (!item.hasOwnProperty("@type")) ref.type = "*other";
				
					
				//----add connected note
				
				//reason
				reason = item.@reason;
				
				//contentType
				contentType = item.@contentType;
				
				//furtherReading
				furtherReading = item.@furtherReading;
				if (furtherReading == "") furtherReading = "false";
				
				ref.addNote(noteID, noteUniqueID, reason, contentType, furtherReading)
				
			}
			
			ref = null
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get length():int {
			return refCollection.length;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBibligraphy():Array {
			return refCollection.concat();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRefByIndex(value:int):RefBibliographic {
			return refCollection[value];
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function traceRef(value:int):void {
			ref = refCollection[value];
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