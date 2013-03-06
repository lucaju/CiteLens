package model {
	
	//imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mvc.Observable;
	
	public class CiteLensModel extends Observable {
		
		//properties
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var file:String;
		private var data:XML;
		private var document:Document;
		private var bibliography:Bibliography;
		private var notes:Notes;
		private var session:Session;
		private var bodyModel:DocBodyModel;
		private var _plainTex:String;
		
		public function CiteLensModel() {
			
			super();
			
			//define name
			this.name = "citelens";
			
			//load data
			file = "resources/CareOfTheDead_chap1-inProgress.xml";
			
			urlRequest = new URLRequest(file);
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,loadXMLComplete);
			urlLoader.load(urlRequest);
			
		}
		
		/**
		 * Load XML Complete - loadXMLcomplete
		 * Parse XML, build docuemnt info, bibliography and notes structures. 
		 *  
		 * @param e
		 * 
		 */
		private function loadXMLComplete(e:Event):void {
			
			data = new XML(e.target.data);
			
			//grab the document header info
			document = new Document(data);
			//document.traceDoc();
			
			//create bibliogaphy
			bibliography = new Bibliography(data);
			//test
			/*
			trace (bibliography.length)
			for (var i:int = 0; i<bibliography.length; i++) {
				bibliography.traceRef(i);
			}
			*/
			
			
			var bibs:Array = bibliography.getBibligraphy();
			
			bibs.sortOn("uniqueID");
			
			trace (bibliography.length)
			
			for (var i:int = 0; i<bibs.length; i++) {
			//	bibliography.traceRef(i);
			}
			
			
			
			//grab notes
			notes = new Notes(data, bibliography);
			trace (notes.length)
			
			for (var n:int = 0; n<notes.length; n++) {
				notes.traceNotes(n);
			}
			
			
			//start session
			session = new Session(bibliography);
			
			//body model
			bodyModel = new DocBodyModel(data);
			
			//complete
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		
		//---------- DOCUMENT INFORMATION
		public function getDocInfo():RefBibliographic {
			var ref:RefBibliographic = document.getDocRef();
			return ref;
		}
		
		public function getXML():XML {
			return data;
		}
		
		//---------- BIBLIOGRAPHY INFORMATION
		public function getBibliographyLenght():int {
			var bibTotal:int = bibliography.length;
			return bibTotal;
		}
		
		public function getBibByIndex(value:int):RefBibliographic {
			var bib:RefBibliographic = bibliography.getRefByIndex(value);
			return bib;
		}
		
		public function getBibliography():Array {
			return bibliography.getBibligraphy();;
		}
		
		//---------- READER
		
		public function getAllParagraphs():XML {
			var allP:XML = bodyModel.getAllParagraphsXML();
			return allP;
		}
		
		public function getFlowConvertText():TextFlow {
			var textFlow:TextFlow = bodyModel.getFlowConvertText();
			return textFlow;
		}
		
		//---------- COLOR CODE COLUMN
		public function getPlainText():String {
			return bodyModel.getPlainText();;
		}
		
		public function getPlainTextLength():int {
			return bodyModel.getPlainTextLength();;
		}
		
		public function getRefsId():Array {
			return bodyModel.getRefsId();
		}
		
		public function getRefLocationByID(id:String):Object {
			return bodyModel.getRefLocationByID(id);
		}
		
		//-------- SESSION
		
		public function getLanguages():Array {
			return session.getLanguages();
		}
		
		public function getLanguageByID(id:int):Language {
			return session.getLanguageByID(id);
		}
		
		public function getCountries():Array {
			return session.getCountries();
		}
		
		public function getCountryByID(id:int):Country {
			return session.getCountryByID(id);
		}
		
		public function getPubTypes():Array {
			return session.getPubTypes();
		}
		
		public function getPubTypeByID(id:int):PubType {
			return session.getPubTypeByID(id);
		}
		
		public function getCitationFunctions():Array {
			return session.getCitationFunctions();
		}
		
		//-------- SESSION - FILTER
		
		public function addFilter(filterID:int):void {
			session.addFilter(filterID);
		}
		
		public function updateFilter(filterID:int, data:Object):void {
			session.updateFilter(filterID, data);
		}
		
		public function removeFilter(filterID:int):void {
			session.removeFilter(filterID);
		}
		
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			var checked:Boolean = session.filterHasSelectedOptions(filterID, type);	
			return checked;
		}
		
		public function checkSelectedFilterOption(filterID:int, type:String, option:Object):Boolean {
			var checked:Boolean = session.checkSelectedFilterOption(filterID, type, option);
			return checked;
		}
		
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			var filterOptions:Array = session.getFilterOptionsByType(filterID, type);
			return filterOptions;
		}
		
		public function getFilterByID(filterID:int):Filter {
			return session.getFilterByID(filterID);
		}
	}
}