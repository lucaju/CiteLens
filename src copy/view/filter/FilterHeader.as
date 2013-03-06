package view.filter {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.ArrowBT;
	import view.assets.CrossBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class FilterHeader extends Sprite {
		
		//properties
		private var box:Sprite;
		private var labelID:TextField;
		private var titlteTF:TextField;
		private var arrowBT:ArrowBT;
		private var closeBT:CrossBT;
		
		public function FilterHeader(id:int) {
			
			super();
			
			//backgorund box
			box = new Sprite;
			box.graphics.beginFill(ColorSchema.getColor("filter"+id));
			box.graphics.drawRoundRect(0,0,185,15,6);
			box.graphics.endFill();
			
			this.addChild(box);
			
			//Label ID field
			labelID = new TextField();
			labelID.selectable = false;
			labelID.mouseEnabled = false;
			labelID.autoSize = "left";
			labelID.antiAliasType = "Advanced";
			labelID.width = 20;
			labelID.x = 2;
			labelID.y = -1;
			
			labelID.text = id.toString() + ".";
			labelID.setTextFormat(TXTFormat.getStyle("filter header"));
			
			this.addChild(labelID);
			
			//result field
			titlteTF = new TextField();
			titlteTF.selectable = false;
			titlteTF.mouseEnabled = false;
			titlteTF.autoSize = "left";
			titlteTF.antiAliasType = "Advanced";
			
			titlteTF.width = 20;
			titlteTF.y = -1;
			titlteTF.x = 15;
			
			titlteTF.text = "Add comparison set";
			titlteTF.setTextFormat(TXTFormat.getStyle("filter header"));
			
			this.addChild(titlteTF);
			
			//action - Add/Update filter options
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, _click);
			
			
			/*
			
			//arrow
			arrowBT = new ArrowBT();
			arrowBT.x = 163;
			arrowBT.y = (box.height/2);
			this.addChild(arrowBT);
			*/
			
			
		}
		
		public function setTitle(value:String):void {
			titlteTF.text = value;
			titlteTF.setTextFormat(TXTFormat.getStyle("filter header"));
		}
		
		private function _click(e:MouseEvent):void {
			FilterPanel(this.parent).updateFilterPanel();
		}
		
		public function updateHeader(data:Object):void {
			var action:String = data.action;
			
			switch (action) {
				case "openPanel":
					
					//add closeBT
					if (!closeBT) {
						closeBT = new CrossBT();
						closeBT.x = 177;
						closeBT.y = (box.height/2);
						this.addChild(closeBT);
					}
					
					//change title
					var s:String = "Click here to save";
					setTitle(s)
					break;
				
				case "updateFilter":
					var results:String = "results"
					break;
			}
		}
	}
}