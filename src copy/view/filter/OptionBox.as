package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.Country;
	import model.Language;
	import model.PubType;
	
	import view.assets.Button;
	import view.assets.tooltip.ToolTip;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class OptionBox extends OptionsPanel {
		
		//properties
		internal var optionArray:Array;
		internal var optionsList:Sprite;		
		internal var endLine:Sprite;
		internal var label:TextField;
		internal var optionCount:int = 0;
		internal var marginX:int = 50;
		internal var posY:Number = 0;
		
		private var button:Button;
		private var posX:Number = 0;
		private var type:String;
		
		private var toolTip:ToolTip;
		
		internal var hasSelectedOptions:Boolean = false;
		
		public function OptionBox(fID:int, t:String = "") {
			
			super(fID);
			
			optionArray = new Array();
			
			type = t;
		}
		
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) {
				hasSelectedOptions = citeLensController.filterHasSelectedOptions(filterID, type);
			}
			
			//label
			buildLabel(type.toLowerCase());
			
			//list
			optionsList = new Sprite();
			optionsList.y = label.height - 3;
			this.addChild(optionsList);
			
			//Dictionary select
			var dictionary:Array;
			var btLabel:String;
			switch (type) {
				
				case "Language":
					dictionary = citeLensController.getLanguages();
					break;
				
				case "Country":
					dictionary = citeLensController.getCountries();
					break;
				
				case "Publication Type":
					dictionary = citeLensController.getPubTypes();
					break;	
			}
			
			//sort
			dictionary.sortOn("code3");
			
			//dictionary loop
			for each (var dicOption:* in dictionary) {
				
				button = new Button(dicOption.code3.toUpperCase(),"Button Style",ColorSchema.getColor("filter"+filterID));
				
				button.x = posX;
				button.y = posY;
				
				//test position
				if (button.x + button.width > maxW - (2 * margin)) {
					posY += button.height + 2;
					posX = 0;
					
					button.x = 0;
					button.y = posY;	
				}
				
				//posX += button.width + 2;
				posX += (maxW - (2 * margin)) / 4
				
				optionsList.addChild(button);
				
				//save info in a list
				var info:Object = new Object();
				info.id = dicOption.id;
				info.bt = button;
				info.source = dicOption;
				info.selected = false;
				
				if (hasSelectedOptions) {
					//check if this opition was already selected
					if (citeLensController.checkSelectedFilterOption(filterID, type, dicOption)) {
						info.selected = true;
						switchClick(button, "selected")
					} else {
						info.selected = false;
						switchClick(button, "active")
					}
				}
				
				optionArray.push(info);
				
				
				button.addEventListener(MouseEvent.CLICK, _click);
				button.addEventListener(MouseEvent.MOUSE_OVER, _over);
				button.addEventListener(MouseEvent.MOUSE_OUT, _out);
			}
			
			posY = optionsList.y + optionsList.height + 2;
			
			//separate line
			makeEndLine();
			
		}
		
		internal function buildLabel(l:String):void {
			label = new TextField();
			label.selectable = false;
			label.mouseEnabled = false;
			label.autoSize = "left";
			label.antiAliasType = "Advanced";
			label.width = 20;
			
			label.text = l;
			label.setTextFormat(TXTFormat.getStyle("General Label","filter"+filterID));
			
			this.addChild(label);
		}
		
		internal function makeEndLine():void {
			endLine = new Sprite();
			endLine.graphics.lineStyle(1);
			endLine.graphics.lineStyle(1,ColorSchema.getColor("filter"+filterID));
			endLine.graphics.beginFill(0x000000);
			endLine.graphics.moveTo(margin, 0);
			endLine.graphics.lineTo( maxW - (3 * margin), 0);
			endLine.graphics.endFill();
			
			endLine.y = this.height;
			this.addChild(endLine);
		}
		
		internal function _click(e:MouseEvent):void {
			var button:Button = Button(e.target);
			
			//identify button in the collection
			
			for each (var option:Object in optionArray) {
				if (option.bt == button) {
					break;
				}
			}
			
			if (option.selected == false) {
				switchClick(button, "selected")
				option.selected = true;
				
			} else {
				switchClick(button, "active")
				option.selected = false;
			}
			
			
		}
		
		internal function switchClick(target:Button, status:String):void {
			target.status = status;
		}
		
		private function addOption(e:MouseEvent = null):void {
			//override
		}
		
		public function deleteOption(target:*):void {
			//Override
		}
		
		private function _over(e:MouseEvent):void{
			
			var data:Object = new Object();
			data.target = e.target;
			
			for each(var option:Object in optionArray) {
				if (e.target == option.bt) {
					data.title = option.source.name
					break;
				}
			}
			
			if (data) {
				toolTip = new ToolTip();
				toolTip.initialize(data)
				this.addChild(toolTip)
			}
		}
		
		private function _out(e:MouseEvent):void{
			this.removeChild(toolTip);
			toolTip = null;
		}
		
		//get selected data
		public function selectedOptions():Array {
			
			var selOptions:Array;
			
			for each (var option:Object in optionArray) {
				
				if (option.selected == true) {
					
					//initialize array
					if (!selOptions) {
						selOptions = new Array();
					}
					
					selOptions.push(option.source);
				}
			}
			
			return selOptions;
		}
	}
}