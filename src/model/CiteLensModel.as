package model {
	
	//imports
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	
	import flashx.textLayout.elements.TextFlow;
	
	import model.library.Country;
	import model.library.CountryLibrary;
	import model.library.Language;
	import model.library.LanguageLibrary;
	import model.library.PubType;
	
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CiteLensModel extends Observable {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var data					:XML;
		protected var document				:Document;
		protected var bibliography			:Bibliography;
		protected var notes					:Notes;
		protected var session				:Session;
		protected var bodyModel				:DocBodyModel;
		protected var _plainTex				:String;
		
		protected var traceBibliography		:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function CiteLensModel() {
			super();
			
			//define name
			this.name = "citelens";
			
			
			//load xmls
			//create a LoaderMax named "mainQueue" and set up onProgress, onComplete and onError listeners
			var dataQueu:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
			//append several loaders
			dataQueu.append( new XMLLoader("model/library/languages.xml", {name:"xmlLanguages"}) );
			dataQueu.append( new XMLLoader("model/library/countries.xml", {name:"xmlCountries"}) );
			dataQueu.append( new XMLLoader("resources/CareOfTheDead_chap1-revised.xml", {name:"xmlDoc"}) );
			
			dataQueu.prioritize("xmlLanguages");
			dataQueu.load();
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function progressHandler(event:LoaderEvent):void {
			//trace("progress: " + event.target.progress);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:LoaderEvent):void {
			
			LanguageLibrary.processData(LoaderMax.getContent("xmlLanguages"));
			CountryLibrary.processData(LoaderMax.getContent("xmlCountries"));
			
			this.processXML(LoaderMax.getContent("xmlDoc"))
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function errorHandler(event:LoaderEvent):void {
			//trace("error occured with " + event.target + ": " + event.text);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * Load XML Complete - loadXMLcomplete
		 * Parse XML, build docuemnt info, bibliography and notes structures. 
		 *  
		 * @param e
		 * 
		 */
		protected function processXML(data:XML):void {
			
			//data = new XML(e.target.data);
			
			//grab the document header info
			document = new Document(data);
			//document.traceDoc();
			
			//create bibliogaphy
			bibliography = new Bibliography(data);
			
			//grab notes
			notes = new Notes(data, bibliography);
			
			
			//---------test bibliograpy
			if (traceBibliography) BibliographyOutput.traceAll(bibliography);
			
			
			
			/*
			var bibs:Array = bibliography.getBibligraphy();
			
			bibs.sortOn("id", Array.NUMERIC);
			
			trace (bibs.length)
			
			for each(var item:RefBibliographic in bibs) {
				trace (item.id);
				trace (item.uniqueID);
				trace ("------")
			}
			*/
			
			//------------- test notes
			/*
			//trace (notes.length)
			
			for (var n:int = 0; n<notes.length; n++) {
				notes.traceNotes(n);
			}
			*/
			
			//start session
			session = new Session(bibliography);
			
			//body model
			bodyModel = new DocBodyModel(data);
			
			//complete
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		
		//****************** DOCUMENT INFORMATION ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocInfo():RefBibliographic {
			return document.getDocRef();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getXML():XML {
			return data;
		}

		
		//****************** BIBLIOGRAPHY INFORMATION ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBibliographyLenght():int {
			return bibliography.length;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getBibByIndex(value:int):RefBibliographic {
			return bibliography.getRefByIndex(value);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBibliography():Array {
			return bibliography.getBibligraphy();;
		}
		
		/**
		 * 
		 * 
		 */
		public function getRefNotes(refID:String):Array {
			return bibliography.getRefNotes(refID);
		}
		
		
		//****************** READER ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getAllParagraphs():XML {
			return bodyModel.getAllParagraphsXML();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlowConvertText():TextFlow {
			return bodyModel.getFlowConvertText();
		}
		
		
		//****************** COLOR CODE COLUMN ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainText():String {
			return bodyModel.getPlainText();;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainTextLength():int {
			return bodyModel.getPlainTextLength();;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getRefsId():Array {
			return bodyModel.getRefsId();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNoteSpanData():Array {
			return bodyModel.getNoteSpanData();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getRefLocationByID(id:String):Object {
			return bodyModel.getRefLocationByID(id);
		}
		
		
		//****************** SESSION ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLanguages(showAll:Boolean):Array {
			return session.getLanguages(showAll);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getLanguageByID(id:int):Language {
			return session.getLanguageByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCountries(showAll:Boolean):Array {
			return session.getCountries(showAll);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getCountryByID(id:int):Country {
			return session.getCountryByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPubTypes():Array {
			return session.getPubTypes();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPubTypeByID(id:int):PubType {
			return session.getPubTypeByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCitationFunctions():Array {
			return session.getCitationFunctions();
		}
		
		
		//****************** SESSION - FILTER ****************** ****************** ******************
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function addFilter(filterID:int):void {
			session.addFilter(filterID);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param data
		 * 
		 */
		public function updateFilter(filterID:int, data:Object):void {
			session.updateFilter(filterID, data);
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function removeFilter(filterID:int):void {
			session.removeFilter(filterID);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			return session.filterHasSelectedOptions(filterID, type);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @param option
		 * @return 
		 * 
		 */
		public function checkSelectedFilterOption(filterID:int, type:String, option:Object):Boolean {
			return session.checkSelectedFilterOption(filterID, type, option);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			return session.getFilterOptionsByType(filterID, type);
		}
		
		/**
		 * 
		 * @param filterID
		 * @return 
		 * 
		 */
		public function getFilterByID(filterID:int):Filter {
			return session.getFilterByID(filterID);
		}
	}
}