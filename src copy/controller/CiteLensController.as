package controller {
	
	//imports
	//import events.OrlandoEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.TextFlow;
	
	import model.Bibliography;
	import model.CiteLensModel;
	import model.Country;
	import model.Language;
	import model.PubType;
	import model.RefBibliographic;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	public class CiteLensController extends AbstractController {
		
		//properties
		private var citeLensModel:CiteLensModel					//CiteLens Model
		
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
		
	}
}