package view.filter {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import controller.CiteLensController;
	
	import settings.Settings;
	
	import view.assets.Button;
	import view.assets.ButtonStatus;
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CheckBoxPanel extends AbstractPanel {
		
		//****************** Properties ****************** ****************** ******************
				
		protected var marginX				:int		 = 50;
		protected var posX					:Number		 = 0;
		
		protected var collumnCount			:uint		 = 3;
		
		protected var _type					:String;
		
		protected var button				:Button;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * @param t
		 * 
		 */
		public function CheckBoxPanel(source:FilterPanels, type:String) {
			super(source);
			_type = type;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param active
		 * 
		 */
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) hasSelectedOptions = CiteLensController(this.getController()).filterHasSelectedOptions(source.filterID, type);
			
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
					dictionary = CiteLensController(this.getController()).getLanguages(Settings.showAllLanguages);
					collumnCount = 5;
					var langNotation:String = Settings.languageFilterNotation;
					dictionary.sortOn(langNotation);
					populate(dictionary, langNotation);
					break;
				
				case "Country":
					dictionary = CiteLensController(this.getController()).getCountries(Settings.showAllCountries);
					collumnCount = 4;
					var countryNotation:String = Settings.countryFilterNotation;
					dictionary.sortOn(countryNotation);
					populate(dictionary, countryNotation);
					break;
				
				case "Publication Type":
					dictionary = CiteLensController(this.getController()).getPubTypes();
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
				lbl = lbl.toUpperCase();
				
				button = new Button(lbl,"Button Style",ColorSchema.gray);
				
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
					if (CiteLensController(this.getController()).checkSelectedFilterOption(source.filterID, type, dicOption)) {
						info.selected = true;
						switchClick(button, ButtonStatus.SELECTED)
					} else {
						info.selected = false;
						switchClick(button, ButtonStatus.ACTIVE)
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
		override public function getSelectedOptions():Array {
			
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
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}

		
	}
}