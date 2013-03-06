package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import controller.CiteLensController;
	
	import events.CiteLensEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.bibliography.BibliographyView;
	import view.filter.FilterPanel;
	import view.mini.ColorColumns;
	import view.reader.Reader;
	
	import util.DeviceInfo;
	
	public class CiteLensView extends AbstractView {
		
		//properties
		static public var citeLensController:CiteLensController										//controller
		
		//graphic layout slots
		private var header:Header;																	//Header
		private var filterPanel:FilterPanel;														//flter panel
		private var elementsArray:Array;
		private var filterPanelArray:Array;															//Filter panel collection
		private var filterVisualArray:Array;														//Filter panel collection
		private var bibiographyView:BibliographyView;												//Bibliography List
		private var readerView:Reader;																//Reader
		private var viz:ColorColumns;																//Mini Nav
		private var gap:int = 5;																	//gap between elements
		private var posMainY:Number = 60;
		
		/**
		 * Contructor
		 **/
		public function CiteLensView(c:IController) {
			
			super(c);
			
			//define controller
			citeLensController = CiteLensController(c);
			
		}
		
		/**
		 * Initialize
		 **/
		public function initialize():void {
			
			elementsArray = new Array()
			
			//--------------header---------------
			//add Header to the main view
			header = new Header();
			this.y = 20;
			this.addChild(header);
			
			
			//--------------Main---------------
			//add Bibliography list;
			bibiographyView = new BibliographyView();
			
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
			
			//filter panels
			filterPanelArray = new Array();
			
			var posX:Number = bibiographyView.x + bibiographyView.width + gap + gap;
			
			//add filter panels
			var numFilterPanel:int;
			if (DeviceInfo.os() != "Mac") {
				numFilterPanel = 2;
			} else {
				numFilterPanel = 3;
			}
			
			
			for (var i:int = 1; i <= numFilterPanel; i++) {
				
				//panel
				filterPanel = new FilterPanel(i);
				filterPanel.y = posMainY
				filterPanel.x = posX;
				this.addChild(filterPanel);
				
				filterPanel.init();
				
				filterPanel.openPanel();
				
				filterPanel.addEventListener(CiteLensEvent.CHANGE_VISUALIZATION, updateViualization);
				
				
				filterPanelArray[i] = filterPanel;
				elementsArray[i] = filterPanel;
				
				posX += filterPanel.width + gap;
			}
			
			//add Reader;
			readerView = new Reader(citeLensController);
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
			
			//add Mini Nav;
			filterVisualArray = new Array();
			
			
			viz = new ColorColumns();
			viz.id = 0;
			viz.y = posMainY
			viz.x = posX;
			filterVisualArray.push(viz)
			this.addChild(viz);
			
			if (DeviceInfo.os() != "Mac") {
				viz.hMax = 670;
				viz.wMax = 35;
			}
			
			viz.initialize();
			
			
			var vizData:Array = citeLensController.getRefsId();
			viz.updateViz(vizData);
			
			viz.addEventListener(CiteLensEvent.DRAG, drag);
			
			elementsArray.push(viz);
			
		}
		
		public function addViualization(filterID:int):void {
			//add Mini Nav;
			viz = new ColorColumns(filterID); //filterID
			viz.id = filterID;
			viz.y = posMainY
			viz.x = filterPanelArray[filterID].x + 153 + 2 + gap;
			
			if (DeviceInfo.os() != "Mac") {
				viz.hMax = 670;
				viz.wMax = 35;
			}
			
			this.addChildAt(viz,0);
			
			viz.initialize()
		
			viz.addEventListener(CiteLensEvent.DRAG, drag);
			
			filterVisualArray[filterID] = viz;
			
			TweenMax.from(viz, .5, {alpha:0, delay: .3});
			
			//add in the elements list
			for (var i:int = 0; i < elementsArray.length; i++) {
				
				if (elementsArray[i] is FilterPanel || elementsArray[i] is ColorColumns) {	
					if (elementsArray[i].id == filterID) {
						elementsArray.splice(i+1,0,viz);
						move("add",i+2, viz.wMax + gap)
						break;
					}
				}
			}
			
			
		}
		
		public function updateViualization(e:CiteLensEvent):void {
			
			//defining panel
			filterPanel = FilterPanel(e.currentTarget);
			var filterID:int = filterPanel.id;
			
			if (e.parameters.reset) {
				
				//Update filter data model
				citeLensController.removeFilter(filterID);
				
				//reseting options
				filterPanel.resetPanel();
				citeLensController.removeResults(filterID);
				
				//get bibliography results for bibliographic panel
				var BiblData:Array = citeLensController.getFilterResults("bibl_id");
				
				//update bibliography
				citeLensController.updateBiblList(BiblData, true);
				
				//removing visualization
				viz = ColorColumns(filterVisualArray[filterID]);
				
				for (var i:int = 0; i < elementsArray.length; i++) {
					
					if (elementsArray[i] == viz) {	
						elementsArray.splice(i,1);
						move("remove",i, viz.wMax + gap)
						break;
					}
				}
				
				TweenMax.to(viz, .3, {alpha:0, onComplete:removeObject, onCompleteParams:[viz]});
				filterVisualArray[filterID] = null;
				
			} else {
				
				//collectiong data
				var data:Object = filterPanel.getFilterData();
				
				//Update filter data model
				citeLensController.updateFilter(filterID, data);
				
				//process filter
				citeLensController.processFilter(filterID);
				
				//get bibliography results for citation fiter panel
				var BiblFilterData:Array = citeLensController.getFilterResults("bibl_id", filterID);
				
				//update filter header
				filterPanel.updateFilterPanel(BiblFilterData.length)
				
				//get bibliography results for bibliographic panel
				BiblData = citeLensController.getFilterResults("bibl_id");
				
				//update bibliography
				citeLensController.updateBiblList(BiblData);
					
				//viz
				if (!(filterVisualArray[filterID] is ColorColumns)) {
					addViualization(filterID);
				}
				
				viz = ColorColumns(filterVisualArray[filterID]) 
				var vizData:Array = citeLensController.getFilterResults("note_id", filterID)
				viz.updateViz(vizData);
			}
			
		}
		
		
		//move
		private function move(type:String, target:int, offset:Number):void {
			
			switch (type) {
				
				case "add": 
				
					//move elements
					for (var i:int = target; i < elementsArray.length; i++) {
						if (i != elementsArray.length-1) {
							TweenMax.to(elementsArray[i], .5, {x:elementsArray[i].x + offset, delay: .3});
						}
					}
					
					var newReaderWidth:Number = -offset;
					readerView.updateDimension(newReaderWidth)
					break;
					
				
				case "move":
					for  (i = 0; i < elementsArray.length; i++) {
						if (i > 1 && i < elementsArray.length-2 && i!=target) {
							TweenMax.to(elementsArray[i], .5, {x:elementsArray[i].x + offset});
						}
					}
					break;
				
				case "remove": 
					
					//move elements
					for (i = target; i < elementsArray.length; i++) {
						if (i != elementsArray.length-1) {
							TweenMax.to(elementsArray[i], .5, {x:elementsArray[i].x - offset, delay: .1});
						}
					}
					
					newReaderWidth = +offset;
					readerView.updateDimension(newReaderWidth)
					break;
			}
			
		}
		
		
		private function drag(e:Event):void {
			viz = ColorColumns(e.target);
			
			//defining positon
			var originalX:Number = viz.originalPosition.x;
			var originalY:Number = viz.originalPosition.y;
			
			//defining end point
			var endPoint:Number = readerView.x - viz.width + gap;
			//trace (endPoint)
			
			var boundaries:Rectangle
			if (viz.id != 0) {
				boundaries = new Rectangle(originalX,originalY,endPoint-originalX,0)
			} else {
				boundaries = new Rectangle(endPoint,originalY,originalX-endPoint,0)
			}
			
			addEventListener(MouseEvent.MOUSE_MOVE, _displaceViz);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			
			viz.startDrag(false, boundaries);
		}
		
		private function dragStop(e:MouseEvent):void {
			viz.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, _displaceViz);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
		}
		
		private function _displaceViz(e:MouseEvent):void {
			var endPoint:Number = readerView.x - viz.width + gap;
			
			if (viz.x == endPoint && viz.endPoint == false) {
				for (var i:int = 0; i < elementsArray.length; i++) {
					if (elementsArray[i] == viz) {
						move("move", i, -viz.width);
						viz.endPoint = true;
					}
				}
			}
		}
		
		private function removeObject(obj:DisplayObject):void {
			this.removeChild(obj);
		}
		
	}
}