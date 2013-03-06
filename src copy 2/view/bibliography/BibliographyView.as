package view.bibliography {
	
	//imports
	import controller.CiteLensController;
	
	import events.CiteLensEvent;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	import util.Global;
	
	import view.CiteLensView;
	
	public class BibliographyView extends CiteLensView {
		
		private var origWidth:Number;
		private var origHeight:Number;
		
		private var border:Shape;
		
		private var searchBar:SearchBar;			
		private var sortBar:SortByBar;
		private var countBar:CountBar;
		private var list:List;
		
		internal var margin:uint = 2;
		
		public function BibliographyView() {
			
			super(citeLensController);
		}
		
		
		override public function initialize():void {
			
			//global size
			origWidth = Global.globalWidth/5;
			origHeight = Global.globalHeight - 50;
			
			//border
			border = new Shape();
			border.graphics.lineStyle(2,0xCCCCCC,1,true);
			border.graphics.beginFill(0xFFFFFF,0);
			border.graphics.drawRoundRect(0,0,186, 536, 10);
			border.graphics.endFill();
			
			this.addChild(border);
			
			//search bar container			
			searchBar = new SearchBar();
			searchBar.x = margin;
			searchBar.y = 2 * margin;
			addChild(searchBar);
			searchBar.initialize();
			
			//sort bar container
			sortBar = new SortByBar();
			sortBar.x = margin;
			sortBar.y = searchBar.y + searchBar.height + (3 * margin);
			addChildAt(sortBar,0);
			sortBar.initialize();
			
			//list container
			list = new List();
			list.y = sortBar.y + sortBar.height;
			this.addChildAt(list,0);
			list.initialize();
			
			//Count bar
			countBar = new CountBar(this.width);
			this.addChildAt(countBar,1);
			countBar.initialize(list.getTotalCount());
			countBar.y = border.height -18;
			
			///listening
			citeLensController.addEventListener(CiteLensEvent.FILTER, updateList)
			this.addEventListener(CiteLensEvent.SORT, listSort);
				
		}
		
		public function updateList(e:CiteLensEvent):void {
			
			var params:Object = e.parameters;
			
			var filterResult:Array = params.filterResult;
			var filterType:String = params.type;
			
			list.filter(filterResult, filterType);
				
			countBar.update(list.getActualCount());
		}
		
		private function listSort(e:CiteLensEvent):void {
			
			var eventParams:Object = e.parameters;
			
			var option:String = eventParams.option;
			var asc:Boolean = eventParams.asc;
			
			list.sort(option, asc);
			
			eventParams = null;
			asc = false;
			
		}
		
	}
}