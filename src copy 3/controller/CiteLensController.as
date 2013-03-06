package controller {
	
	//imports
	//import events.OrlandoEvent;
	
	import events.CiteLensEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.TextFlow;
	
	import model.Bibliography;
	import model.CiteLensModel;
	import model.Country;
	import model.Filter;
	import model.Language;
	import model.PubType;
	import model.RefBibliographic;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	public class CiteLensController extends AbstractController {
		
		//properties
		private var citeLensModel:CiteLensModel					//CiteLens Model
		private var filterProcess:FilterProcess = new FilterProcess();
		
		public function CiteLensController(list:Array) {
			
			super(list);
			
			citeLensModel = CiteLensModel(getModel("citelens"));
		}
		
		//---------- DOCUMENT CONTROLS
		public function getDocumentSummary():RefBibliographic {
			
			return citeLensModel.getDocInfo();
		}
		
		public function getXML():XML {
			return citeLensModel.getXML()
		}
		
		
		//---------- BIblIOGRAPHY CONTROLS
		public function getBibliographyLenght():int {
			
			return citeLensModel.getBibliographyLenght();
			
		}
		
		public function getBibByIndex(value:int):RefBibliographic {
			
			return citeLensModel.getBibByIndex(value);
			
		}
		
		public function getBibliography():Array {
			return citeLensModel.getBibliography();
		}
		
		public function updateBiblList(newList:Array):void {
			
			var params:Object = new Object();
			params.type = "filter";
			params.filterResult = newList;
			
			dispatchEvent(new CiteLensEvent(CiteLensEvent.FILTER, params));
		}
		
		public function searchBibliography(value:String, target:Array = null, autoComplete:Boolean = false):Array {
			
			if (value == "~all") {
				results = [value];
			} else {
				
				var search:SearchProcess = new SearchProcess(value, autoComplete);
				search.dictionary = getBibliography()
				
				//target search
				if (target) {
					for each (var v:String in target) {
						search.addTarget(v);
					}
				} else {
					search.addTarget("author");
				}
				
				var results:Array = search.result;
				
				search = null;
			}
			
			if (!autoComplete) {
				var params:Object = new Object();
				params.type = "search";
				params.filterResult = results;
				
				dispatchEvent(new CiteLensEvent(CiteLensEvent.FILTER, params));
				
				return null;
			} else {
				return results;
			}
		}
		
		//---------- READER CONTROLS
		
		public function getAllParagraphs():XML {
			return citeLensModel.getAllParagraphs();
		}
		
		public function getFlowConvertText():TextFlow {
			return citeLensModel.getFlowConvertText();
		}
		
		//---------- COLOR CODE COLUMN
		public function getPlainText():String {
			return citeLensModel.getPlainText();
		}
		
		public function getPlainTextLength():int {
			return citeLensModel.getPlainTextLength();
		}
		
		public function getRefsId():Array {
			return citeLensModel.getRefsId();
		}
		
		public function getRefLocationByID(id:String):Object {
			return citeLensModel.getRefLocationByID(id);
		}
		
		//---------- Session
		public function getLanguages():Array {
			return citeLensModel.getLanguages();
		}
		
		public function getLanguageByID(id:int):Language {
			return citeLensModel.getLanguageByID(id);
		}
		
		public function getCountries():Array {
			return citeLensModel.getCountries();
		}
		
		public function getCountryByID(id:int):Country {
			return citeLensModel.getCountryByID(id);
		}
		
		public function getPubTypes():Array {
			return citeLensModel.getPubTypes();
		}
		
		public function getPubTypeByID(id:int):PubType {
			return citeLensModel.getPubTypeByID(id);
		}
		
		public function getCitationFunctions():Array {
			return citeLensModel.getCitationFunctions();
		}
		
		//-------- SESSION - FILTER
		
		public function addFilter(filterID:int):void {
			citeLensModel.addFilter(filterID);
		}
		
		public function updateFilter(filterID:int, data:Object):void {
			citeLensModel.updateFilter(filterID, data);
		}
		
		public function removeFilter(filterID:int):void {
			citeLensModel.removeFilter(filterID);
		}
		
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			var checked:Boolean = citeLensModel.filterHasSelectedOptions(filterID, type);
			return checked;
		}
		
		public function checkSelectedFilterOption(filterID:int, type:String, option:Object):Boolean {
			var checked:Boolean = citeLensModel.checkSelectedFilterOption(filterID, type, option);
			return checked;
		}
		
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			var filterOptions:Array = citeLensModel.getFilterOptionsByType(filterID, type);
			return filterOptions;
		}
		
		public function processFilter(filterID:int):void {
			var filter:Filter = citeLensModel.getFilterByID(filterID);
			filterProcess.bibliography = this.getBibliography();
			filterProcess.process(filter);
			//return process.getResult(filterID, FilterProcess.NOTE_ID);
		}
		
		public function getFilterResults(type:String, filterID:int = 0):Array {
			switch (type) {
				
				case FilterProcess.NOTE_ID:
					return filterProcess.getResult(FilterProcess.NOTE_ID, filterID);
					break;
				
				case FilterProcess.BIBL_ID:
					return filterProcess.getResult(FilterProcess.BIBL_ID, filterID);
					break;
				
				default:
					return null;
					break;
			}
		}
		
		public function removeResults(filterID:int = 0):void {
			filterProcess.removeResults(filterID);
		}
	}
}