package controller {
	
	//imports
	
	import events.CiteLensEvent;
	
	import flashx.textLayout.elements.TextFlow;
	
	import model.CiteLensModel;
	import model.Filter;
	import model.RefBibliographic;
	import model.library.Country;
	import model.library.Language;
	import model.library.PubType;
	
	import mvc.AbstractController;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CiteLensController extends AbstractController {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var citeLensModel			:CiteLensModel							//CiteLens Model
		protected var filterProcess			:FilterProcess = new FilterProcess();
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param list
		 * 
		 */
		public function CiteLensController(list:Array) {
			super(list);
			citeLensModel = CiteLensModel(getModel("citelens"));
		}
		
		
		//****************** DOCUMENT CONTROLS ****************** ****************** ******************
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getDocumentSummary():RefBibliographic {
			return citeLensModel.getDocInfo();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getXML():XML {
			return citeLensModel.getXML()
		}
		
		
		//****************** BIblIOGRAPHY CONTROLS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBibliographyLenght():int {
			return citeLensModel.getBibliographyLenght();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getBibByIndex(value:int):RefBibliographic {
			return citeLensModel.getBibByIndex(value);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getBibliography():Array {
			return citeLensModel.getBibliography();
		}
		
		/**
		 * 
		 * 
		 */
		public function getRefNotes(refID:String):Array {
			return citeLensModel.getRefNotes(refID);
		}
		
		/**
		 * 
		 * 
		 */
		public function getRefNotesIDs(refID:String):Array {
			var refNotes:Array = citeLensModel.getRefNotes(refID);
			
			var notesIDs:Array = new Array();
			for each (var note:Object in refNotes) {
				notesIDs.push(note.uniqueID);
			}
			
			return notesIDs;
		}
		
		/**
		 * 
		 * @param newList
		 * @param reset
		 * 
		 */
		public function updateBiblList(newList:Array, reset:Boolean = false):void {
			var params:Object = new Object();
			params.type = "filter";
			params.reset = reset;
			params.filterResult = newList;
			
			dispatchEvent(new CiteLensEvent(CiteLensEvent.FILTER, params));
		}
		
		/**
		 * 
		 * @param value
		 * @param target
		 * @param autoComplete
		 * @return 
		 * 
		 */
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
				
				this.dispatchEvent(new CiteLensEvent(CiteLensEvent.FILTER, params));
				
				return null;
			} else {
				return results;
			}
		}
		
		
		//****************** READER CONTROLS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getAllParagraphs():XML {
			return citeLensModel.getAllParagraphs();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlowConvertText():TextFlow {
			return citeLensModel.getFlowConvertText();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNotesAsTextFlow():TextFlow {
			return citeLensModel.getNotesAsTextFlow();
		}
		
		//****************** COLOR CODE  CONTROLS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainText():String {
			return citeLensModel.getPlainText();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainTextLength():int {
			return citeLensModel.getPlainTextLength();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getRefsId():Array {
			return citeLensModel.getRefsId();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNoteSpanData():Array {
			return citeLensModel.getNoteSpanData();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getRefLocationByID(id:String):Object {
			return citeLensModel.getRefLocationByID(id);
		}
		
		
		//****************** SESSION ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLanguages(showAll:Boolean):Array {
			return citeLensModel.getLanguages(showAll);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getLanguageByID(id:int):Language {
			return citeLensModel.getLanguageByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCountries(showAll:Boolean):Array {
			return citeLensModel.getCountries(showAll);
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getCountryByID(id:int):Country {
			return citeLensModel.getCountryByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPubTypes():Array {
			return citeLensModel.getPubTypes();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPubTypeByID(id:int):PubType {
			return citeLensModel.getPubTypeByID(id);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCitationFunctions():Array {
			return citeLensModel.getCitationFunctions();
		}
		
		
		//****************** SESSION - FILTER ****************** ****************** ******************
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function addFilter(filterID:int):void {
			citeLensModel.addFilter(filterID);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param data
		 * 
		 */
		public function updateFilter(filterID:int, data:Object):void {
			citeLensModel.updateFilter(filterID, data);
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function removeFilter(filterID:int):void {
			citeLensModel.removeFilter(filterID);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function filterHasSelectedOptions(filterID:int, type:String):Boolean {
			return citeLensModel.filterHasSelectedOptions(filterID, type);
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
			return citeLensModel.checkSelectedFilterOption(filterID, type, option);
		}
		
		/**
		 * 
		 * @param filterID
		 * @param type
		 * @return 
		 * 
		 */
		public function getFilterOptionsByType(filterID:int, type:String):Array {
			return citeLensModel.getFilterOptionsByType(filterID, type);
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function processFilter(filterID:int):void {
			var filter:Filter = citeLensModel.getFilterByID(filterID);
			filterProcess.bibliography = this.getBibliography();
			filterProcess.process(filter);
		}
		
		/**
		 * 
		 * @param type
		 * @param filterID
		 * @return 
		 * 
		 */
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
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		public function removeResults(filterID:int = 0):void {
			filterProcess.removeResults(filterID);
		}
	}
}