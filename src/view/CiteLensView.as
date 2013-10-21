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
	import view.filter.AddButton;
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
		protected var _filterWindowArray			:Array;					//List of Filter Windows
		protected var _filterVizArray				:Array;					//List of Filter Visualization
		
		protected var _addFilterButton				:AddButton;
		
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
				numFilterPanel = 2;
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
				
				filterWindowArray.push(filterWindow);
				elementsArray.push(filterWindow);
				
				filterWindow.addEventListener(CiteLensEvent.CHANGE_VISUALIZATION, changeVisualizationHandler);
				filterWindow.addEventListener(CiteLensEvent.REMOVE_FILTER, removeFilter);
				
				posX += filterWindow.width + gap;
			}
			
			//****************** Add Filter Button;
			
			this.showAddFilterButton(true);
			addFilterButton.x = posX;
			
			posX += addFilterButton.width + gap;
			
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
			
			//resize reader
			var readerX:Number = readerView.x;
			var spaceAvailable:Number = this.stage.stageWidth - readerX - (2*gap) - mainViz.width;
			
			
			readerView.updateDimension({width:spaceAvailable});
			TweenMax.to(mainViz,.2,{x:readerView.x + spaceAvailable + gap});
			
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
		 * @param value
		 * 
		 */
		protected function showAddFilterButton(value:Boolean):void {
			
			if (value) {
				
				//get next filter id and color
				var nextFilterID:int = 1;
				
				var fArray:Array = filterWindowArray.concat();
				fArray.sortOn("id");
				
				for each (var filterWindow:FilterWindow in fArray) {
					if (filterWindow.id == nextFilterID) {
						nextFilterID++;
					} else {
						break;
					}
				}
			
				
				
				_addFilterButton = new AddButton(nextFilterID);
				addFilterButton.y = posMainY;
				this.addChild(addFilterButton);
				addFilterButton.init();
				
				elementsArray.push(addFilterButton);
				
				addFilterButton.addEventListener(MouseEvent.CLICK, addFilterClick);
				
			} else {
				
				addFilterButton.removeEventListener(MouseEvent.CLICK, addFilterClick);
				this.removeChild(addFilterButton);
				
				elementsArray.splice(elementsArray.indexOf(addFilterButton),1);
				
				_addFilterButton = null;
				
			}
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		protected function addFilterWindow(filterID:int):void {
			
			//filter view
			
			var filterWindow:FilterWindow = new FilterWindow(this.getController(),filterID);
			filterWindow.y = posMainY
			filterWindow.x = filterWindowArray[filterWindowArray.length-1].x + filterWindowArray[filterWindowArray.length-1].width + gap;
			this.addChild(filterWindow);
			
			filterWindow.init();
			filterWindow.open();
			
			filterWindowArray.push(filterWindow);
			elementsArray.push(filterWindow);
			
			TweenMax.from(filterWindow, .6, {alpha:0});
			
			//Adjust Layout
			CiteLensViewAdjustLayout.filterAdded(filterWindow.id, addFilterButton.width);
			
			filterWindow.addEventListener(CiteLensEvent.CHANGE_VISUALIZATION, changeVisualizationHandler);
			filterWindow.addEventListener(CiteLensEvent.REMOVE_FILTER, removeFilter);
			
			//remove add filter button
			showAddFilterButton(false)
			
			//add remove button to filterWindows
			for each (var fWindow:FilterWindow in filterWindowArray) {
				fWindow.addRemoveButton(true);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function removeFilter(event:CiteLensEvent):void {
			
			var controler:CiteLensController = CiteLensController(this.getController());
			
			//defining window
			var filterWindow:FilterWindow = this.getFilterWindowByID(event.parameters.filterID);
				
			//Update filter data model
			controler.removeFilter(filterWindow.id);
			
			//reseting options
			controler.removeResults(filterWindow.id);
			
			//get bibliography results for bibliographic panel
			var BiblData:Array = controler.getFilterResults("bibl_id");
			
			//update bibliography
			controler.updateBiblList(BiblData, true);
			
			//remove listeners
			filterWindow.removeEventListener(CiteLensEvent.CHANGE_VISUALIZATION, changeVisualizationHandler);
			filterWindow.removeEventListener(CiteLensEvent.REMOVE_FILTER, removeFilter);
			
			//save filter width
			var filterWindowWidth:Number = filterWindow.width;
			
			//remove viz
			var viz:ColumnViz = filterWindow.viz;
			if (viz) {
				filterWindowWidth += viz.width + gap;
				this.RemoveVizByID(filterWindow.id);
				this.removeChild(viz);
			}
			
			if (filterVizArray.length == 0) _vizGrouping = false;
			
			//remove filter from array
			filterWindowArray.splice(filterWindowArray.indexOf(filterWindow),1);
			elementsArray.splice(elementsArray.indexOf(filterWindow),1);
			
			//Animation
			TweenMax.to(filterWindow, .3, {alpha:0, onComplete:removeObject, onCompleteParams:[filterWindow]});
			
			//add function button
			this.showAddFilterButton(true);
			addFilterButton.x = filterWindowArray[filterWindowArray.length-1].x + filterWindowArray[filterWindowArray.length-1].width + gap;
			
			//adjust layout
			CiteLensViewAdjustLayout.filterRemoved(filterWindowWidth, addFilterButton.width);	
			
			//remove remove button to filterWindows
			for each (var fWindow:FilterWindow in filterWindowArray) {
				fWindow.addRemoveButton(false);
			}
			
		}	
		
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
		 * @param filterWindow
		 * @param reset
		 * 
		 */
		public function updateVisualization(filterWindow:FilterWindow, reset:Boolean = false):void {
			
			var controler:CiteLensController = CiteLensController(this.getController());
			
			var filterID:int = filterWindow.id;
			var viz:ColumnViz;
			
			if (reset) {
				
				//Update filter data model
				controler.removeFilter(filterID);
				
				//reseting options
				filterWindow.reset();
				controler.removeResults(filterID);
				
				//get bibliography results for bibliographic panel
				var BiblData:Array = controler.getFilterResults("bibl_id");
				
				//update bibliography
				controler.updateBiblList(BiblData, true);
				
				//reset header
				//filterWindow.reset();
				
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
				
				if (data.reset) {
					updateVisualization(filterWindow,true)
					return;
				}
			}
			
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
		protected function addFilterClick(event:MouseEvent):void {
			if (event.target is AddButton) {
				var addButton:AddButton = event.target as AddButton;
				this.addFilterWindow(addButton.filterID);
			}
		}
		
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
			
			if (event.target.name == "mainReader") {
				
				mainViz.updateRoll(event.parameters);
				
				for each (var viz:ColumnViz in filterVizArray) {
					viz.updateRoll(event.parameters);
				}
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function changeVisualizationHandler(event:CiteLensEvent):void {
			var filterWindow:FilterWindow = FilterWindow(event.currentTarget) as FilterWindow;
			
			var reset:Boolean = event.parameters.reset;
			
			updateVisualization(filterWindow,reset);
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get addFilterButton():AddButton {
			return _addFilterButton;
		}


		
	}
}