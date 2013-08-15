package view.filter {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import events.CiteLensEvent;
	
	import settings.Settings;
	
	import view.assets.Button;
	import view.assets.tooltip.ToolTip;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class OptionBox extends OptionsPanel {
		
		//****************** Properties ****************** ****************** ******************
		
		internal var optionArray			:Array;
		internal var optionsList			:Sprite;		
		internal var endLine				:Sprite;
		internal var labelTF				:TextField;
		internal var optionCount			:int		 = 0;
		internal var marginX				:int		 = 50;
		internal var posY					:Number		 = 0;
		
		protected var collumnCount			:uint		 = 3;
		protected var button				:Button;
		protected var posX					:Number		 = 0;
		protected var type					:String;
		
		protected var toolTip				:ToolTip;
		
		internal var hasSelectedOptions		:Boolean	 = false;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * @param t
		 * 
		 */
		public function OptionBox(fID:int, t:String = "") {
			
			super(fID);
			
			optionArray = new Array();
			
			type = t;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param active
		 * 
		 */
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) hasSelectedOptions = citeLensController.filterHasSelectedOptions(filterID, type);
			
			//label
			buildLabel(type.toLowerCase());
			
			//list
			optionsList = new Sprite();
			optionsList.y = labelTF.height;
			this.addChild(optionsList);
			
			//Dictionary select
			var dictionary:Array;
			switch (type) {
				
				case "Language":
					dictionary = citeLensController.getLanguages(Settings.showAllLanguages);
					collumnCount = 5;
					var langNotation:String = Settings.languageFilterNotation;
					dictionary.sortOn(langNotation);
					populate(dictionary, langNotation);
					break;
				
				case "Country":
					dictionary = citeLensController.getCountries(Settings.showAllCountries);
					collumnCount = 4;
					var countryNotation:String = Settings.countryFilterNotation;
					dictionary.sortOn(countryNotation);
					populate(dictionary, countryNotation);
					break;
				
				case "Publication Type":
					dictionary = citeLensController.getPubTypes();
					dictionary.sortOn("code4");
					populate(dictionary, "code4");
					break;	
			}
				
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param dictionary
		 * @param labelType
		 * 
		 */
		protected function populate(dictionary:Array, labelType:String):void {
			
			//dictionary loop
			for each (var dicOption:* in dictionary) {
				
				//bt label
				var lbl:String = dicOption.getCode(labelType);
				
				//if (type != "Publication Type") {
					lbl = lbl.toUpperCase();
				//}	

				
			//	button = new Button(lbl,"Button Style",ColorSchema.getColor("filter"+filterID));
				button = new Button(lbl,"Button Style",ColorSchema.getColor("gray"));
				
				button.x = posX;
				button.y = posY;
				
				//if (type == "Country") trace (lbl);
				
				//test position
				if (button.x + button.width > maxW - margin) {
					posY += button.height + 2;
					posX = 0;
					
					button.x = 0;
					button.y = posY;	
				}
				
				//posX += button.width + 2;
				//posX += (maxW - (2 * margin)) / collumnCount
				posX += maxW / collumnCount;
				
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
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function selectedOptions():Array {
			
			var selOptions:Array;
			
			for each (var option:Object in optionArray) {
				
				//trace (option.selected)
				
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
		
		//****************** INTERNAL METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * 
		 */
		internal function buildLabel(l:String):void {
			
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.mouseEnabled = false;
			labelTF.autoSize = "left";
			labelTF.antiAliasType = "Advanced";
			labelTF.width = 20;
			
			labelTF.text = l;
			labelTF.setTextFormat(TXTFormat.getStyle("General Label","filter"+filterID));
			
			this.addChild(labelTF);
			
		}
		
		/**
		 * 
		 * 
		 */
		internal function makeEndLine():void {
			endLine = new Sprite();
			endLine.graphics.lineStyle(1);
			endLine.graphics.lineStyle(1,ColorSchema.getColor("filter"+filterID));
			endLine.graphics.beginFill(0x000000);
			//endLine.graphics.moveTo(margin, 0);
			endLine.graphics.lineTo( maxW - (2 * margin), 0);
			endLine.graphics.endFill();
			
			endLine.y = this.height;
			this.addChild(endLine);
		}
		
		/**
		 * 
		 * @param target
		 * @param status
		 * 
		 */
		internal function switchClick(target:Button, status:String):void {
			target.status = status;
		}
		
		/**
		 * 
		 * @param target
		 * 
		 */
		public function deleteOption(target:*):void {
			//Override
		}
		
		//****************** INTERNAL EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
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

			
			//dispatch visualization change
			var obj:Object = new Object()
			obj.filterID = filterID;
			
			dispatchEvent(new CiteLensEvent(CiteLensEvent.CHANGE_VISUALIZATION,obj));
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function addOption(e:MouseEvent = null):void {
			//override
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _over(e:MouseEvent):void{
			
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
				stage.addChild(toolTip)
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _out(e:MouseEvent):void{
			if (toolTip) {
				stage.removeChild(toolTip);
				toolTip = null;
			}
		}
		
	}
}