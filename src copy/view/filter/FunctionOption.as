package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.CitationFunction;
	
	import view.assets.Button;
	import view.assets.MinusBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class FunctionOption extends OptionBox{
		
		//properties
		private var _id:int;
		private var button:Button;
		private var line:Sprite;
		private var _options:Array;
		private var functionOption:FunctionOption
		private var labelContainer:Sprite;
		private var sepLine:Sprite;
		private var posX:Number = 90;
		private var _subItemLevel:int = 0;
		
		private var expanded:Boolean = false;
		
		public function FunctionOption(fID:int, id_:int, labelString:String, hasSelectedOpts:Boolean) {
			
			hasSelectedOptions = hasSelectedOpts;
			
			if (hasSelectedOptions) {
				//var selectedPeriods:Array = citeLensController.getFilterOptionsByType(filterID, "function");
			}
			
			
			
			super(fID);
			
			id = id_;
			
			trace (">" + hasSelectedOptions)
			
			//label
			labelContainer = new Sprite();
			this.addChild(labelContainer);
			
			label = new TextField();
			label.autoSize = "left";
			label.text = labelString.toLowerCase();
			label.setTextFormat(TXTFormat.getStyle("General Label","filter"+filterID));
			labelContainer.addChild(label);
				
			labelContainer.buttonMode = true;
			labelContainer.mouseChildren = false;
			labelContainer.addEventListener(MouseEvent.CLICK, _functionClick);
			
			if (hasSelectedOptions) {
				//check if this opition was already selected
				trace (labelString.toLowerCase())
				//if (citeLensController.checkSelectedFilterOption(filterID, "function", labelString.toLowerCase())) {
					showHideOptions();
				//}
			}
			
			posY = this.height;
			
		}

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}

		public function get options():Array {
			return _options;
		}

		public function set options(value:Array):void {
			_options = new Array();
			_options = value;
			
			optionArray = new Array;
		}
		
		public function separateLine():void {
			
			var lineW:Number = maxW - (4 * margin)
			var dashLenght:Number = 2;
			var gapLenght:Number = 4;
			var currentXPos:Number = 0;	
			
			line = new Sprite();
			line.graphics.lineStyle(1,ColorSchema.getColor("filter"+filterID));
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

		public function get subItemLevel():int {
			return _subItemLevel;
		}

		public function set subItemLevel(value:int):void {
			_subItemLevel = value;
		}
		
		
		private function _functionClick(e:MouseEvent):void {
			showHideOptions();
		}
		
		private function showHideOptions():void {
			
			switch (label.text.toLowerCase()) {
				case "secondary source":
					if (expanded) {
						hideSubOtions();
					} else {
						showSubOptions();
					}
					break
				
				default:
					if (expanded) {
						hideFactOpinion();
					} else {
						showFactOpinion();
					}
					break;
			}
		}
		
		
		private function showSubOptions():void {
			
			optionArray = new Array;
			
			expanded = true;
			
			var expandedHeight:Number = 0;
			
			for each (var item:* in _options) {
				
				//Functions
				functionOption = new FunctionOption(filterID, item.id, item.label, hasSelectedOptions);
				functionOption.subItemLevel = 1;
				functionOption.options = item.options;
					
				functionOption.x = 30;
				functionOption.y = posY;
					
				this.addChild(functionOption);
				
				optionArray.push({id:item.label, bt:functionOption, source:item});
					
				//update position
				posY = this.height + 2;
				
				expandedHeight += functionOption.height + 2;
				
				TweenMax.from(functionOption,.5,{y:functionOption.y - 20, alpha:0,delay:.1 * item.id});
			}
			
			//prevent the button to be clicked during the animation
			labelContainer.removeEventListener(MouseEvent.CLICK, _functionClick);
			
			//move endline further down
			TweenMax.to(line,.5,{y:line.y + expandedHeight,onComplete:showOptionCompleted});
			
			//expand main box
			FunctionBox(this.parent.parent).expandHeight(this, expandedHeight);
			
		}
		
		private function showOptionCompleted():void {
			labelContainer.addEventListener(MouseEvent.CLICK, _functionClick);
		}

		private function hideSubOtions():void {
			
			var contractedHeight:Number = 0;
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:FunctionOption = optionArray[i].bt;
				contractedHeight += item.height + 2;
				
				//animation
				TweenMax.to(item,.5,{y:0, alpha:0});
				
			}
			
			//move endline further down
			TweenMax.to(line,.5,{y:line.y - contractedHeight,onComplete:removeSubOptions});
			
			//expand main box
			FunctionBox(this.parent.parent).contactHeight(this, contractedHeight);
			
		}
		
		
		private function removeSubOptions():void {
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:FunctionOption = optionArray[i].bt;
				
				this.removeChild(item);
			}
			
			posY = this.height;
			
			optionArray = null;
			expanded = false;
		}
	
		
		
		private function showFactOpinion():void {
			optionArray = new Array;
			
			expanded = true;
			
			for (var i:int = 0; i < _options.length; i++) {
				
				button = new Button(_options[i],"Button Style",ColorSchema.getColor("filter"+filterID));
				button.x = posX - (subItemLevel * 30);
				this.addChild(button);
				
				button.addEventListener(MouseEvent.CLICK, _click);
				
				optionArray.push({label:_options[i], bt:button, selected:false});
				
				//update position
				posX += button.width + 2;
				
				//animation
				TweenMax.from(button,.3,{x:button.x - 10, alpha:0, delay:i * 0.1});
				
			}
			
		}
		
		private function hideFactOpinion():void {
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:Button = optionArray[i].bt;
				
				//animation
				if (i == optionArray.length-1) {
					TweenMax.to(item,.5,{x:item.x - 10, alpha:0,onComplete:removeFactOpinion});
				} else {
					TweenMax.to(item,.5,{x:item.x - 10, alpha:0});
				}
				
			}
			
		}
		
		private function removeFactOpinion():void {
			
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:Button = optionArray[i].bt;
				
				this.removeChild(item);
			}
			
			posX = 100;
			optionArray = null;
			expanded = false;
		}
		
		
		public function get selectedFunctions():Object {
			var citFunctions:Object = new Object; // model {label:String // parent:String // value:Boolean}
			
			//gatheing information
			var option:Object
			var functionParamenter:Object;
			
			
			if (label.text.toLowerCase() == "secondary source") {
				
				var subOptions:Array = new Array();
				
				for each (option in optionArray) {
					var subOption:FunctionOption = option.bt;
					subOptions.push(subOption.selectedFunctions);
				}
				
				citFunctions.options = subOptions;
				
			} else {
				
				citFunctions.options = getFactOpinionSelectedOpions();
				
			}
			
			citFunctions.label = label.text.toLowerCase();
			
			
			return citFunctions;
		}
		
		private function getFactOpinionSelectedOpions():Array {
			
			var selectedOptions:Array = new Array();
			
			for each (var option:Object in optionArray) {
				selectedOptions.push(option);
			}
			
			return selectedOptions;
		}
	}
}