package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.CitationFunction;
	
	import view.assets.Button;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	final public class FunctionBox extends OptionBox {
		
		//properties
		private var optionContainer:Sprite;
		private var functionOption:FunctionOption;
		
		private var button:Button;
		
		public function FunctionBox(fID:int) {
			super(fID);
			
		}
		
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) {
				hasSelectedOptions = true;
			}
			
			//label
			buildLabel("function");
			
			//list
			optionsList = new Sprite();
			optionsList.y = label.height - 3;
			this.addChild(optionsList);
			
			posY = 0;
			
			//get options
			var options:Array = citeLensController.getCitationFunctions();
			
			
			for each (var item:* in options) {
				//Functions
				functionOption = new FunctionOption(filterID, item.id, item.label, hasSelectedOptions);
				functionOption.options = item.options;
				functionOption.x = 10;
				functionOption.y = posY;
				
				//if it is not the last, add a dashed line
				if (item.label != "Further Reading") {
					functionOption.separateLine();
				}
				
				optionsList.addChild(functionOption);
				
				var info:Object = new Object();
				info.id = item.label;
				info.bt = functionOption;
				info.source = item;
				
				optionArray.push(info);
				
				
				//update position
				//optionsList.y = posY;
				posY = optionsList.height + 2;
				
			}
			
			//end line
			makeEndLine();	
		}
		
		public function expandHeight(target:FunctionOption, value:Number):void {
			
			//find the target item to expand
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:FunctionOption = optionArray[i].bt;
				if (item == target) {
					var optionArrayPart:Array = optionArray.slice(i+1);
					break;
				}
			}
			
			//animation to realocate
			if (optionArrayPart) {
				for (i = 0; i < optionArrayPart.length; i++) {
					item = optionArrayPart[i].bt;
					TweenLite.to(item,.5,{y:item.y + value});					//move up each line
				}
			}
			
			//move endline further down
			TweenLite.to(endLine,.5,{y:endLine.y + value});
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, value);
			
		}
		
		public function contactHeight(target:FunctionOption, value:Number):void {
			
			//find the target item to expand
			for (var i:int = 0; i < optionArray.length; i++) {
				var item:FunctionOption = optionArray[i].bt;
				if (item == target) {
					var optionArrayPart:Array = optionArray.slice(i+1);
					break;
				}
			}
			
			//animation to realocate
			if (optionArrayPart) {
				for (i = 0; i < optionArrayPart.length; i++) {
					item = optionArrayPart[i].bt;
					TweenLite.to(item,.5,{y:item.y - value});					//move up each line
				}
			}
			
			//move endline further down
			TweenLite.to(endLine,.5,{y:endLine.y - value});
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, -value);
			
		}
	
		
		//get selected data
		override public function selectedOptions():Array {
			var selOptions:Array = new Array();
			
			for each (var citationFuncton:Object in optionArray) {
				var option:FunctionOption = citationFuncton.bt;
				
				//initialize array
				if (!selOptions) {
					selOptions = new Array();
				}
				
				selOptions.push(option.selectedFunctions);
			}
			
			return selOptions;
		}
	}
}