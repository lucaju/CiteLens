package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.Global;
	
	import view.CiteLensView;
	import view.style.ColorSchema;
	
	public class FilterPanel extends CiteLensView {
		
		//properties
		internal var origWidth:Number;
		internal var origHeight:Number;
		
		internal var filterID:int;
		
		internal var active:Boolean = false;								// switch: Filter active or inactive
		
		private var header:FilterHeader;									//header
		private var optionsPanel:OptionsPanel;								//Options
		
		private var border:Sprite;
		
		private var open:Boolean = false;									// Painel open or close;
		
		
		public function FilterPanel(fID:int) {
			super(citeLensController);

			filterID = fID;
			
		}
		
		public function init():void {
			
			//global size
			origWidth = Global.globalWidth/5;
			origHeight = Global.globalHeight - 50;
			
			//header
			header = new FilterHeader(filterID);
			addChild(header);
			
		}
		
		public function resizeBorder(value:Number = 0, create:Boolean = false):void {
			
			//Resize border if it exists. Otherwise create it.
			//trace (create)
			//trace (border)
			
			
			if (create) {
				border = new Sprite();
				border.graphics.lineStyle(2,ColorSchema.getColor("filter"+filterID),1,true,"none");
				border.graphics.beginFill(0xFFFFFF,0);
				border.graphics.drawRoundRect(1,0,183, header.height + this.height + 7, 10);
				border.graphics.endFill();
				
				this.addChildAt(border,0);
				
			} else {
				if (border) {
					//trace ("hey")
					//trace (value)
					TweenMax.to(border,.5,{alpha:1, height: String(value)});
				}
			}
			//trace ("------")
		}
		
		public function updateFilterPanel():void  {
			
			if (open) {
				closePanel();
			} else {
				openPanel();
			}
			
		}
		
		private function openPanel():void {
			optionsPanel = new OptionsPanel(filterID);
			optionsPanel.y = header.height;
			addChild(optionsPanel)
			optionsPanel.init(active);
			
			TweenMax.from(optionsPanel,.5,{alpha:0, y:optionsPanel.y - 20});
			
			resizeBorder(0,true);
			
			//update header
			var data:Object = {action:"openPanel"}
			header.updateHeader(data);
			
			open = !open;
			
			//add filter to the model
			if (!active) {
				active = true;
				citeLensController.addFilter(filterID);
			}
			
		}
		
		private function closePanel():void {
			
			//update filter model
			if (active) {
				var data:Object = optionsPanel.getSelectedOptions();
				citeLensController.updateFilter(filterID, data);
			}
			
			TweenMax.to(optionsPanel,.5,{alpha:0, y:optionsPanel.y - 20, onComplete:removeOptionPanel});
			
			TweenMax.to(border,.5,{alpha:0, height:this.height -20});
			
			open = !open;
			
			
		}
		
		private function removeOptionPanel():void {
			this.removeChild(border);
			border = null;
			
			this.removeChild(optionsPanel);
			optionsPanel = null;
		}
		
	}
}