package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import view.columnViz.ColumnViz;
	import view.filter.FilterWindow;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CiteLensViewAdjustLayout {
		
		//****************** Properties ****************** ****************** ******************
		
		static public var target		:CiteLensView;
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
	
		/**
		 * 
		 * @param filterID
		 * 
		 */
		static public function filterAdded(filterID:int, extraOffset:Number = 0):void {
			
			var filterWindow:FilterWindow = target.getFilterWindowByID(filterID);
			var readerOffset:Number = -(filterWindow.width - extraOffset);
			var posX:Number = CiteLensViewAdjustLayout.moveFilters() + target.gap;
			
			target.readerView.updateDimension({width:readerOffset.toString()});
			
			TweenMax.to(target.readerView, .5, {x:posX});
			
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		static public function filterRemoved(Offset:Number = 0, extraOffset:Number = 0):void {
			
			//var filterWindow:FilterWindow = target.getFilterWindowByID(filterID);
			var readerOffset:Number = Offset - extraOffset;
			var posX:Number = CiteLensViewAdjustLayout.moveFilters() + target.gap;
			
			target.readerView.updateDimension({width:readerOffset.toString()});
			
			TweenMax.to(target.addFilterButton, .5, {x:posX});
			posX += target.addFilterButton.width;
			
			TweenMax.to(target.readerView, .5, {x:posX});
			
		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		static public function vizAdded(filterID:int):void {
			
			var filterWindow:FilterWindow = target.getFilterWindowByID(filterID);
			var readerOffset:Number = -(filterWindow.viz.wMax + target.gap);
			var posX:Number = CiteLensViewAdjustLayout.moveFilters();
			
			target.readerView.updateDimension({width:readerOffset.toString()});
			
			if (target.addFilterButton) {
				TweenMax.to(target.addFilterButton, .5, {x:posX});
				posX += target.addFilterButton.width;
			}
			
			TweenMax.to(target.readerView, .5, {x:posX + target.gap});

		}
		
		/**
		 * 
		 * @param filterID
		 * 
		 */
		static public function vizRemoved(filterID:int):void {
			
			var filterWindow:FilterWindow = target.getFilterWindowByID(filterID);
			var readerOffset:Number =  filterWindow.viz.wMax + target.gap;
			filterWindow.removeViz();
			
			var posX:Number = CiteLensViewAdjustLayout.moveFilters() + target.gap;
			
			target.readerView.updateDimension({width:readerOffset.toString()});
			
			if (target.addFilterButton) {
				TweenMax.to(target.addFilterButton, .5, {x:posX});
				posX += target.addFilterButton.width;
			}
			
			TweenMax.to(target.readerView, .5, {x:posX});
			
		}
		
		/**
		 * 
		 * 
		 */
		static public function moveFilters():Number {
			
			var posX:Number = target.bibiographyView.x + target.bibiographyView.width + ( 2* target.gap);
			var filterWindow:FilterWindow;
			var viz:ColumnViz;

			if (target.vizGrouping) {
				
				for each (filterWindow in target.filterWindowArray) {
					TweenMax.to(filterWindow, .5, {x:posX})
					posX += filterWindow.width + target.gap;
				}
				
				var filterVizArrayReorded:Array = target.filterVizArray//.sortOn("id");
				
				for each (viz in filterVizArrayReorded) {
					TweenMax.to(viz, .5, {x:posX})
					posX += viz.wMax + target.gap;
				}
				
				
			} else {
				
				for each (filterWindow in target.filterWindowArray) {
					
					TweenMax.to(filterWindow, .5, {x:posX})
					
					posX += filterWindow.width + target.gap;
					
					if (filterWindow.hasViz) {
						TweenMax.to(filterWindow.viz, .5, {x:posX})
						posX += filterWindow.viz.wMax + target.gap;
					}
					
				}
				
			}
			
			return posX;
			
		}
	}
}