package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	import util.Global;
	
	import view.CiteLensView;
	import view.PanelHeader;
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FilterPanel extends CiteLensView {
		
		//****************** Properties ****************** ****************** ******************
		
		internal var origWidth				:Number;
		internal var origHeight				:Number;
		
		internal var filterID				:int;
		
		internal var active					:Boolean = false;			// switch: Filter active or inactive
		
		private var header					:PanelHeader;				//header
		
		protected var optionsPanel			:OptionsPanel;				//Options
		
		protected var border				:Sprite;
		
		protected var open					:Boolean = false;			// Painel open or close;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
		public function FilterPanel(fID:int) {
			super(citeLensController);
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
			header = new PanelHeader(filterID,"filter");
			header.init();
			header.setTitle("Add comparison set");
			addChild(header);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function closePanel():void {
			
			TweenMax.to(optionsPanel,.5,{alpha:0, y:optionsPanel.y - 20, onComplete:removeOptionPanel});
			TweenMax.to(border,.5,{alpha:0, height:this.height -20});
			
			open = !open;
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeOptionPanel():void {
			this.removeChild(border);
			border = null;
			
			this.removeChild(optionsPanel);
			optionsPanel = null;
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
				border.graphics.drawRoundRect(1,0,153, header.height + optionsPanel.height + 7, 10);
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
		public function resetPanel():void {
			active = false;
			open = !open;
			
			this.removeChild(optionsPanel);
			optionsPanel = null;
			this.removeChild(border);
			border = null;
			
			openPanel();
		}
		
		/**
		 * 
		 * 
		 */
		public function openPanel():void {
			optionsPanel = new OptionsPanel(filterID);
			optionsPanel.y = header.height;
			this.addChild(optionsPanel)
			optionsPanel.init(active);
			
			resizeBorder(0,true);
			
			open = !open;
		
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFilterData():Object {
			active = true
			return optionsPanel.getSelectedOptions();
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
		
	}
}