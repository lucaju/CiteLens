package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.Global;
	
	import view.WindowHeader;
	import view.columnViz.ColumnViz;
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FilterWindow extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		internal var origWidth				:Number;
		internal var origHeight				:Number;
		
		internal var filterID				:int;
		
		internal var active					:Boolean = false;			// switch: Filter active or inactive
		
		protected var header				:WindowHeader;				//header
		
		protected var filterPanels			:FilterPanels;				//Options
		
		protected var border				:Sprite;
		
		protected var opened				:Boolean = false;			// Painel open or close;
		
		protected var _viz					:ColumnViz;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
		public function FilterWindow(c:IController, fID:int) {
			super(c);
			filterID = fID;
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//global size
			origWidth = Global.globalWidth/5;
			origHeight = Global.globalHeight - 50;
			
			//header
			header = new WindowHeader(filterID,"filter");
			header.init();
			header.setTitle("Add comparison set");
			addChild(header);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function close():void {
			
			TweenMax.to(filterPanels,.5,{alpha:0, y:filterPanels.y - 20, onComplete:removeOptionPanel});
			TweenMax.to(border,.5,{alpha:0, height:this.height -20});
			
			opened = !opened;
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeOptionPanel():void {
			this.removeChild(border);
			border = null;
			
			this.removeChild(filterPanels);
			filterPanels = null;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @param create
		 * 
		 */
		public function resizeBorder(value:Number = 0, create:Boolean = false):void {
			
			//Resize border if it exists. Otherwise create it.
			if (create) {
				border = new Sprite();
				border.graphics.lineStyle(2,ColorSchema.getColor("filter"+filterID),1,true,"none");
				border.graphics.beginFill(0x000000,0);
				border.graphics.drawRoundRect(1,0,153, header.height + filterPanels.height + 7, 10);
				border.graphics.endFill();
				
				//this.addChild(border)
				this.addChildAt(border,0);
				
			} else {
				if (border) TweenMax.to(border,.5,{alpha:1, height: String(value)});
			}
		}
		
		/**
		 * 
		 * @param resultsTotal
		 * 
		 */
		public function updateFilterPanel(resultsTotal:int):void  {
			//update header
			header.update(resultsTotal);
		}
		
		/**
		 * 
		 * 
		 */
		public function reset():void {
			active = false;
			opened = !opened;
			
			this.removeChild(filterPanels);
			filterPanels = null;
			this.removeChild(border);
			border = null;
			
			header.update(-1);
			
			open();
		}
		
		/**
		 * 
		 * 
		 */
		public function open():void {
			filterPanels = new FilterPanels(this);
			filterPanels.y = header.height;
			this.addChild(filterPanels)
			filterPanels.init(active);
			
			resizeBorder(0,true);
			
			opened = !opened;
		
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFilterData():Object {
			active = true
			return filterPanels.getSelectedOptions();
		}
		
		/**
		 * 
		 * @param viz
		 * 
		 */
		public function addViz(viz):void {
			_viz = viz;
		}
		
		/**
		 * 
		 * @param viz
		 * 
		 */
		public function removeViz():void {
			_viz = null;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addRemoveButton(value:Boolean):void {
			header.addEraseButton(value);
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return filterID;
		}	

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasViz():Boolean {
			return (_viz) ? true: false;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get viz():ColumnViz {
			return _viz;
		}

		
	}
}