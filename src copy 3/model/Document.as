package model {
	
	//imports
	
	public class Document {
		
		//properties
		private var data:XMLList
		
		private var ref:RefBibliographic;
		
		private var xmlns:Namespace;
		private var xsi:Namespace;
		private var teiH:Namespace;
		
		public function Document(fullData:XML) {
			//namespaces
			var namespaces:Array = fullData.namespaceDeclarations();
			xsi = namespaces[0];
			xmlns = namespaces[1];
			
						
			//define the default namespace
			default xml namespace = xmlns;
		
			//filter the data
			data = fullData.teiHeader.fileDesc;
			teiH = new Namespace('http://www.w3.org/XML/1998/namespace');
			
			//create new bibliographic reference
			ref = new RefBibliographic(0);
			
			
			//test for tittle
			if (data.titleStmt.hasOwnProperty("title")) {
				var titles:XMLList = data.titleStmt.descendants("title");
				for each(var title:XML in titles) {
					ref.addTitle(title.text(), title.@level);
				}
			}
			
			//test for authors
			if (data.titleStmt.hasOwnProperty("author")) {
				for each(var auth:XML in data.titleStmt.author) {
					ref.addAuthor(auth.name.(@type == "last"), auth.name.(@type == "first"));
				}
			}
			
			
			//test for Editors
			if (data.titleStmt.hasOwnProperty("editor")) {
				for each(var edit:XML in data.titleStmt.editor) {
					ref.addEditor(edit.name.(@type == "last"), edit.name.(@type == "first"));
				}
			}
			
			//test for language
			if (data.titleStmt.title.@teiH::lang != "") {
				ref.language = data.titleStmt.title.@teiH::lang;
			}
			
			//test for publisher
			if (data.publicationStmt.hasOwnProperty("publisher")) {
				ref.publisher = data.publicationStmt.publisher;
			}

			//test for pubplace
			
			//test for pubplace
			if (data.publicationStmt.hasOwnProperty("pubPlace")) {
				for each(var pubPlace:XML in data.publicationStmt.pubPlace) {
					ref.addPubPlace(pubPlace.text());
				}
			}
			
			//test for country
			var ntei:Namespace = new Namespace("http://www.example.org/ns/nonTEI");
			
			if (data.publicationStmt.ntei::pubCountry != "") {
				for each(var country:XML in data.publicationStmt.ntei::pubCountry) {
					ref.addCountry(country);
				}
			}
		
			//test for date
			if (data.publicationStmt.hasOwnProperty("date")) {
				ref.date = data.publicationStmt.date;
			}
			
			//test for series information
			if (data.publicationStmt.hasOwnProperty("series")) {
				for each(var serie:XML in data.publicationStmt.series) {
					ref.addSerie(serie.title, serie.biblScope.@type, serie.biblScope.text());
				}
			}
			
			//test for scope		
			if (data.publicationStmt.@biblScope) {
				ref.scope = data.publicationStmt.biblScope.text();
			}
			
			//test for type
			if (data.publicationStmt.@type != "") {
				ref.type = data.publicationStmt.@type;
			}
		}
		
		/**
		 * Output Document Information - tracedoc 
		 * 
		 */
		public function traceDoc():void {
			trace ("Title: "+ref.title);
			trace ("Authors: "+ref.getAuthorship());
			trace ("Language: "+ref.language)
			trace ("Publisher: "+ref.publisher)
			if (ref.pubPlaces.length > 0) {
				trace ("Publication Place:" + ref.pubPlaces.length)
				for (var i:uint = 0; i<ref.pubPlaces.length; i++) {
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
			trace ("Scope: "+ref.scope);
			trace ("Type: "+ref.type);
		}


		/**
		 * Return Document bibliography information
		 * 
		 * @return ref:RefBibliogrphic
		 * 
		 */
		public function getDocRef():RefBibliographic {
			return ref;
		}
	}
}