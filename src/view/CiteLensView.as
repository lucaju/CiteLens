package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import controller.CiteLensController;
	
	import events.CiteLensEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.bibliography.BibliographyView;
	import view.columnViz.ColumnViz;
	import view.filter.FilterWindow;
	import view.reader.ReaderWindow;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CiteLensView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		//static public var citeLensController		:CiteLensController				//controller
		
		protected var elementsArray					:Array;					//List of elements
		protected var _filterWindowArray				:Array;					//List of Filter Windows
		protected var _filterVizArray				:Array;					//List of Filter Visualization
		
		protected var header						:Header;
		protected var _bibiographyView				:BibliographyView;
		protected var _readerView					:ReaderWindow;
		protected var mainViz						:ColumnViz;
		
		protected var _gap							:int 	= 5;			//gap between elements
		protected var posMainY						:Number = 60;
		
		protected var _vizGrouping					:Boolean = false;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function CiteLensView(c:IController) {
			super(c);
			
			//define controller
			//citeLensController = CiteLensController(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		public function initialize():void {
			
			//****************** INITIAL ****************** 
			
			elementsArray = new Array();
			_filterVizArray = new Array();
			
			CiteLensViewAdjustLayout.target = this;
			
			var posX:Number;
			
			//****************** HEADER ****************** 
			
			header = new Header(this.getController());
			this.y = 20;
			this.addChild(header);
			
			
			//****************** Main ****************** 
			
			
			//****************** Bibliography list;
			
			_bibiographyView = new BibliographyView(this.getController());
			bibiographyView.name = "bibliography";
			
			if (DeviceInfo.os() != "Mac") {
				bibiographyView.setDimensions(186,670)
			} else {
				bibiographyView.setDimensions(186,556)
			}
			
			bibiographyView.x = 25;
			bibiographyView.y = posMainY;
			
			this.addChild(bibiographyView);
			bibiographyView.initialize();
			
			elementsArray[0] = bibiographyView;
			
			bibiographyView.addEventListener(Event.SELECT, bibiographySelect);
			
			//****************** Filter Windows
			
			_filterWindowArray = new Array();
			var numFilterPanel:int;
			
			posX = bibiographyView.x + bibiographyView.width + gap + gap;
			
			if (DeviceInfo.os() != "Mac") {
				numFilterPanel = 2;
			} else {
				numFilterPanel = 3;
			}
			
			//Loop filters
			var filterWindow:FilterWindow;
			
			for (var i:int = 1; i <= numFilterPanel; i++) {
				
				filterWindow = new FilterWindow(this.getController(),i);
				filterWindow.y = posMainY
				filterWindow.x = posX;
				this.addChild(filterWindow);
				
				filterWindow.init();
				filterWindow.open();
				
				filterWindowArray[i] = filterWindow;
				elementsArray[i] = filterWindow;
				
				filterWindow.addEventListener(CiteLensEvent.CHANGE_VISUALIZATION, updateViualization);
				
				posX += filterWindow.width + gap;
			}
			
			
			//****************** Reader;
			
			_readerView = new ReaderWindow(this.getController());
			readerView.name = "reader";
			readerView.y = posMainY;
			readerView.x = posX + gap;
			
			if (DeviceInfo.os() != "Mac") {
				readerView.setDimensions(410,670);
			} else {
				readerView.setDimensions(385,558);
			}
			
			this.addChild(readerView);
			readerView.initialize();
			
			elementsArray.push(readerView);
			
			posX += readerView.width + gap + gap;
			
			readerView.addEventListener(CiteLensEvent.READER_SCROLL, readerScrollHander);
			
			
			//****************** Main Viz
			
			mainViz = new ColumnViz(this.getController());
			mainViz.name = "mainViz";
			
			mainViz.y = posMainY
			mainViz.x = posX;
			
			mainViz.roll.hTotal = readerView.getReaderMaxHeight();
			
			this.addChild(mainViz);
			
			if (DeviceInfo.os() != "Mac") {
				mainViz.hMax = 670;
				mainViz.wMax = 35;
			}
			
			mainViz.initialize();
			
			elementsArray.push(mainViz);
			
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param obj
		 * 
		 */
		private function removeObject(obj:DisplayObject):void {
			this.removeChild(obj);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		protected function addViualization(filterID:int):ColumnViz {
			
			//get corresp filterWindow
			var filterWindow:FilterWindow = this.getFilterWindowByID(filterID);
			
			if (!filterWindow.hasViz) {
				
				//add viz
				var viz:ColumnViz = new ColumnViz(this.getController(), filterID); //filterID
				viz.y = posMainY;
				
				viz.roll.hTotal = readerView.getReaderMaxHeight();
				
				if (DeviceInfo.os() != "Mac") {
					viz.hMax = 670;
					viz.wMax = 35;
				}
				
				this.addChildAt(viz,0);
				
				filterWindow.addViz(viz);
				filterVizArray.push(viz);
				elementsArray.push(viz);
				
				viz.initialize();
				
				TweenMax.from(viz, .5, {alpha:0, delay: .3});
				
				//Adjust Layout
				CiteLensViewAdjustLayout.vizAdded(filterWindow.id);
				
				//listeners
				viz.addEventListener(MouseEvent.CLICK, vizClick);
				
				return viz;
			}
			
			return null
			
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		protected function RemoveVizByID(value:int):Boolean {
			
			for each (var viz:ColumnViz in filterVizArray) {
				if (viz.id == value) {
					filterVizArray.splice(filterVizArray.indexOf(viz),1);
					elementsArray.splice(elementsArray.indexOf(viz),1);
					return true;
				}
			}
			
			return false;
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function bibiographySelect(event:Event):void {
			
			if (event.target.parent is BibliographyView) {
				var bibliographyView:BibliographyView = event.target.parent as BibliographyView;
				var selectedItemID:String = bibliographyView.getSelectedItemID();
				
				if (selectedItemID) {
					
					//get notes Ids
					var notesIDs:Array = CiteLensController(this.getController()).getRefNotesIDs(selectedItemID);
					
					//highlight selected item in visualziation
					mainViz.selectChunks(notesIDs);
					
					////highlight selected item in the reader
					readerView.highlightElementByID(notesIDs);
					
				} else {
					
					//remove highlight selection in visualziation
					mainViz.clearSelectedChunks();
					
					//remove highlight selection in the reader
					readerView.clearHighlightElements();
				}
					
			}
				
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function vizClick(event:MouseEvent):void {
			if  (filterVizArray.length > 1 || vizGrouping) {
				_vizGrouping = !vizGrouping;
				CiteLensViewAdjustLayout.moveFilters();
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function readerScrollHander(event:CiteLensEvent):void {
			
			mainViz.updateRoll(event.parameters);
			
			for each (var viz:ColumnViz in filterVizArray) {
				viz.updateRoll(event.parameters);
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function updateViualization(e:CiteLensEvent):void {
			
			var controler:CiteLensController = CiteLensController(this.getController());
			
			//defining window
			var filterWindow:FilterWindow = FilterWindow(e.currentTarget) as FilterWindow;
			var filterID:int = filterWindow.id;
			var viz:ColumnViz;
			
			if (e.parameters.reset) {
				
				//Update filter data model
				controler.removeFilter(filterID);
				
				//reseting options
				filterWindow.reset();
				controler.removeResults(filterID);
				
				//get bibliography results for bibliographic panel
				var BiblData:Array = controler.getFilterResults("bibl_id");
				
				//update bibliography
				controler.updateBiblList(BiblData, true);
				
				//viz
				viz = filterWindow.viz;
				
				//remove viz and adjust layout
				this.RemoveVizByID(filterID);
				if (filterVizArray.length == 0) _vizGrouping = false;
				CiteLensViewAdjustLayout.vizRemoved(filterWindow.id);
				
				//Animation
				TweenMax.to(viz, .3, {alpha:0, onComplete:removeObject, onCompleteParams:[viz]});
				
			} else {
				
				//collectiong data
				var data:Object = filterWindow.getFilterData();
				
				//Update filter data model
				controler.updateFilter(filterID, data);
				
				//process filter
				controler.processFilter(filterID);
				
				//get bibliography results for citation fiter window
				var BiblFilterData:Array = controler.getFilterResults("bibl_id", filterID);
				
				//update filter header
				filterWindow.updateFilterPanel(BiblFilterData.length);
				
				//get bibliography results for bibliographic panel
				BiblData = controler.getFilterResults("bibl_id");
				
				//update bibliography
				controler.updateBiblList(BiblData);
				
				//viz
				if (!filterWindow.hasViz) {
					viz = this.addViualization(filterID);
				} else {
					viz = filterWindow.viz;
				}
				
				var vizData:Array = controler.getFilterResults("note_id", filterID);
				viz.highlightChunks(vizData);
				
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getFilterWindowByID(value:int):FilterWindow {
			for each (var filter:FilterWindow in filterWindowArray) {
				if (filter.id == value) return filter;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getVizByID(value:int):ColumnViz {
			filterVizArray
			for each (var viz:ColumnViz in filterVizArray) {
				if (viz.id == value) return viz;
			}
			return null;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bibiographyView():BibliographyView {
			return _bibiographyView;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get gap():int {
			return _gap;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get filterWindowArray():Array {
			return _filterWindowArray;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get readerView():ReaderWindow {
			return _readerView;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get vizGrouping():Boolean {
			return _vizGrouping;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get filterVizArray():Array {
			return _filterVizArray;
		}

		
	}
}