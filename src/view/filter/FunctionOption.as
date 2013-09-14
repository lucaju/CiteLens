package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.CiteLensEvent;
	
	import model.citation.CitationType;
	import model.citation.CitationCategory;
	import model.citation.CitationFunction;
	
	import view.assets.Button;
	import view.assets.ButtonStatus;
	import view.style.ColorSchema;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FunctionOption extends AbstractPanel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;																								//Function Option ID
		protected var _category			:String;
		protected var _label			:String;
		protected var _options			:Array;
		protected var _subFunctions		:Array;
		protected var _selected			:Boolean;
		protected var _subItemLevel		:int	 = 0;
		protected var posX				:Number	 = 100;

		protected var labelContainer	:Sprite;
		protected var functionButton	:Button;	
		protected var functionOption	:FunctionOption
		protected var line				:Sprite;
		protected var sepLine			:Sprite;
		protected var button			:Button;	
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param labelString
		 * @param fID
		 * @param id_
		 * @param type_
		 * 
		 */
		public function FunctionOption(source:FilterPanels,labelString:String, id_:int = -1, type_:String = CitationCategory.UNIQUE) {
			
			super(source);
			
			//Save id
			if (_id != -1) id = id_;
			
			//save label
			_label = labelString;
			
			//type
			category = type_;
			
			//If unique
			if (category == CitationCategory.UNIQUE) selected = false;
			
			//Container
			labelContainer = new Sprite();
			this.addChild(labelContainer);
			
			//button
			functionButton = new Button(labelString,"Button Style",ColorSchema.getColor("gray"));
			//button = new Button(lbl,"Button Style",ColorSchema.getColor("gray"));
			labelContainer.addChild(functionButton);
			functionButton.addEventListener(MouseEvent.CLICK, functionClick);
			
			//spaces
			posY = this.height + 2;
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function showSubFunctions():void {
			
			optionArray = new Array;
			
			var expandedHeight:Number = 0;
			for each (var item:CitationFunction in subFunctions) {
				
				//Functions
				functionOption = new FunctionOption(source, item.label, item.id, item.category);
				functionOption.subItemLevel = 1;
				functionOption.options = item.options;
				
				functionOption.x = 15;
				functionOption.y = posY;
				this.addChild(functionOption);
				
				//check if the button is selected
				if (item.value == true) functionOption.selected;
				
				optionArray.push({id:item.id, label:item.label, bt:functionOption, source:item}); //original id:item.label
				
				//update position
				posY = this.height + 2;
				
				expandedHeight += functionOption.height + 2;
				
				//TweenMax.from(functionOption,.5,{y:functionOption.y - 20, alpha:0,delay:.1 * item.id});
			}
			
			//prevent the button to be clicked during the animation
			//labelContainer.mouseChildren = false;
			
			//move endline further down
			if (line) {
				TweenMax.to(line,.5,{y:line.y + expandedHeight,onComplete:showOptionCompleted});
				
				function showOptionCompleted():void {
					labelContainer.mouseChildren = true;
				}
				
			}
			
			//expand main box
			FunctionPanel(this.parent.parent).expandHeight(this, expandedHeight);
			
			//change expenad state
			selected = true;
			
			triggerEvent()
		}
		
		/**
		 * 
		 * 
		 */
		protected function hideSubFunctions():void {
			
			var contractedHeight:Number = 0;
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:FunctionOption = optionArray[i].bt;
				contractedHeight += item.height + 2;
				
				//animation
				TweenMax.to(item,.5,{y:0, alpha:0});
				
			}
			
			//move endline further down
			if (line) TweenMax.to(line,.5,{y:line.y - contractedHeight,onComplete:removeSubOptions});
			
			//remove items
			removeSubOptions();
			
			//expand main box
			FunctionPanel(this.parent.parent).contractHeight(this, contractedHeight);
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeSubOptions():void {
			
			var item:FunctionOption;
			for (var i:int = 0; i < optionArray.length; i++) {
				item = optionArray[i].bt;
				
				this.removeChild(item);
			}
			
			posY = this.height;
			
			item = null;
			optionArray = null;
			
			//change expenad state
			selected = false;
			
			triggerEvent()
		}
		
		/**
		 * 
		 * 
		 */
		protected function showFactOpinion():void {
			optionArray = new Array;
			
			for (var i:int = 0; i < options.length; i++) {
				
				//taking the 1º character
				var optLabel:String = options[i].label		
				optLabel = optLabel.slice(0,1);
				
				button = new Button(optLabel.toUpperCase(),"Button Style");
				button.x = posX - (subItemLevel * 30);
				this.addChild(button);
				
				button.addEventListener(MouseEvent.CLICK, factOpinionClick);
				
				//check if the button is selected
				if (options[i].value == true) switchClick(button, ButtonStatus.SELECTED);
				
				optionArray.push({label:options[i].label, bt:button, selected:options[i].value});
				
				//update position
				posX += button.width + 2;
				
				//animation
				TweenMax.from(button,.3,{x:button.x - 5, alpha:0});
				
			}
			
			if (label == CitationType.FURTHER_READING) {
				button = optionArray[0].bt;
				button.status = ButtonStatus.SELECTED;
				optionArray[0].selected = true;
			}	
			
			selected = true;
			
			triggerEvent();
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function hideFactOpinion():void {
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:Button = optionArray[i].bt;
				
				//animation
				if (i == optionArray.length-1) {
					TweenMax.to(item,.5,{x:item.x - 5, alpha:0,onComplete:removeFactOpinion});
				} else {
					TweenMax.to(item,.5,{x:item.x - 5, alpha:0});
				}
				
			}
			
			changeSubFunctionsStatus();
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeFactOpinion():void {
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:Button = optionArray[i].bt;
				
				this.removeChild(item);
			}
			
			posX = 90;
			optionArray = null;
			selected = false;
			triggerEvent();
		}
		
		/**
		 * 
		 * 
		 */
		protected function changeSubFunctionsStatus():void {
			this.selected = false;
			
			if (this.parent is FunctionOption) {
				
				var func:FunctionOption = FunctionOption(this.parent);
				
				var sub:Object;
				var anySubSelected:Boolean = false;
				
				for each (sub in func.optionArray) {
					var subBT:FunctionOption = sub.bt;
					
					if (subBT.selected == true) {
						anySubSelected = true;
						break;
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function triggerEvent():void {
			//dispatch visualization change
			var obj:Object = new Object()
			obj.filterID = source.filterID;
			
			dispatchEvent(new CiteLensEvent(CiteLensEvent.CHANGE_VISUALIZATION,obj));
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		protected function functionClick(e:MouseEvent):void {
			
			var button:Button = Button(e.target);
			
			if (!this.selected) {
				switchClick(button, ButtonStatus.SELECTED)
			} else {
				switchClick(button, ButtonStatus.ACTIVE);
			}
			
			switch (category) {
				
				case CitationCategory.SIMPLE:
					(selected) ? hideFactOpinion() : showFactOpinion();
					break;
				
				case CitationCategory.COMPLEX:
					(selected) ? hideSubFunctions() : showSubFunctions();
					break;
				
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function factOpinionClick(event:MouseEvent = null):void {
			
			var targetButton:Button = Button(event.target);
			
			//deselect
			if (targetButton.status != ButtonStatus.SELECTED) {
				
				for each (var option:Object in optionArray) {
					var button:Button = option.bt;
					button.status = ButtonStatus.ACTIVE;
					option.selected = false;
				}
				
			}
			
			//option click
			if (event) _click(event);
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		public function separateLine():void {
			
			var lineW:Number = maxW - (4 * margin)
			var dashLenght:Number = 2;
			var gapLenght:Number = 4;
			var currentXPos:Number = 0;	
			
			line = new Sprite();
			line.graphics.lineStyle(1,ColorSchema.getColor("filter"+source.filterID));
			line.graphics.beginFill(0x000000);
			
			while(currentXPos < lineW) {
				line.graphics.lineTo(currentXPos + dashLenght, 0);
				currentXPos = currentXPos + dashLenght;
				line.graphics.moveTo(currentXPos + gapLenght, 0);
				currentXPos = currentXPos + gapLenght;
			}
			
			line.graphics.endFill();
			
			line.y = this.height + 2;
			this.addChild(line);
		}
		

		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set id(value:int):void {
			_id = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get category():String {
			return _category;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set category(value:String):void {
			_category = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get subItemLevel():int {
			return _subItemLevel;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set subItemLevel(value:int):void {
			_subItemLevel = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
			if (functionButton) {
				(_selected) ? functionButton.status = ButtonStatus.SELECTED : functionButton.status = ButtonStatus.ACTIVE;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get options():Array {
			return _options.concat();
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set options(value:Array):void {
			_options = value;
			
			//test if there is selected options
			for each (var item:Object in _options) {
				if (item.value == true) {
					showFactOpinion();
					break;
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get subFunctions():Array {
			return _subFunctions.concat();
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set subFunctions(value:Array):void {
			_subFunctions = value;
			
			//test if there is selected options
			var testSelected:Boolean = false;
			
			for each (var subFunct:CitationFunction in _subFunctions) {
				var items:Array = subFunct.options;
				for each (var item:Object in items) {
					if (item.value == true) {
						showSubFunctions();
						testSelected = true;
						break;
					}
				}
				
				if (testSelected) break;
				
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasSubFuntions():Boolean {
			return (_subFunctions) ? true : false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasOption():Boolean {
			return (_options) ? true : false;
		}
	}
}