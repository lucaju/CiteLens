package view.bibliography {
	
	//imports
	import events.SortEvent;
	
	import flash.display.Shape;
	
	import util.Global;
	
	import view.CiteLensView;
	
	public class BibliographyView extends CiteLensView {
		
		private var origWidth:Number;
		private var origHeight:Number;
		
		private var border:Shape;
		
		private var searchBar:SearchBar;			
		private var sortBar:SortByBar;
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
			border.graphics.lineStyle(2,0x666666,1,true);
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
			addChild(sortBar);
			sortBar.initialize();
			
			//list container
			list = new List();
			list.y = sortBar.y + sortBar.height;
			this.addChild(list);
			list.initialize();
			
			this.addEventListener(SortEvent.SORT, listSort);
		}
		
		private function listSort(e:SortEvent):void {
			
			var parameter:String = e.parameter;
			var asc:Boolean = e.asc;
			
			list.sort(parameter, asc);
			
			parameter = null;
			asc = false;
			
		}
		
	}
}