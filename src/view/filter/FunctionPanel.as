package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import controller.CiteLensController;
	
	import flash.display.Sprite;
	
	import model.citation.CitationFunction;
	import model.citation.CitationCategory;
	
	import view.assets.Button;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	final public class FunctionPanel extends AbstractPanel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var optionContainer			:Sprite;
		protected var functionOption			:FunctionOption;
		
		protected var button					:Button;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
		public function FunctionPanel(source:FilterPanels) {
			super(source);
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param active
		 * 
		 */
		override public function init(active:Boolean):void {
			
			var citeFuncs:Array = new Array();
			
			//define if it must check for selected itens
			if (active) {
				citeFuncs = CiteLensController(this.getController()).getFilterOptionsByType(source.filterID, "function")
			} else {
				citeFuncs = CiteLensController(this.getController()).getCitationFunctions();
			}
			
			//label
			buildLabel("function");
			
			//list
			optionsList = new Sprite();
			optionsList.y = labelTF.height - 2;
			this.addChild(optionsList);
			
			posY = 0;
			
			//get options
			
			for each (var item:CitationFunction in citeFuncs) {
				//Functions
				
				functionOption = new FunctionOption(source, item.label, item.id, item.category);
				
				//position
				functionOption.x = 10;
				functionOption.y = posY;
				
				optionsList.addChild(functionOption);
				
				//if it is not the last, add a dashed line
				if (item != citeFuncs[citeFuncs.length-1]) //functionOption.separateLine();
				
				//show options // subfunctions
				if (item.hasSubFunctions) functionOption.subFunctions = item.subFunctions;
				if (item.hasOptions) functionOption.options = item.options;
				if (item.category == CitationCategory.UNIQUE) functionOption.selected = item.value;
				
				
				//store info
				var info:Object = new Object();
				info.id = item.label;
				info.bt = functionOption;
				info.source = item;
				
				optionArray.push(info);
				
				//update position
				//optionsList.y = posY;
				posY += functionOption.height + 2
				//posY = optionsList.height + 2;
				
			}
			
			//end line
			makeEndLine();	
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param value
		 * 
		 */
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
			if (endLine) TweenLite.to(endLine,.5,{y:endLine.y + value});
			
			//move box in optionPanel
			FilterPanels(this.parent).moveBoxes(this, value);
			
		}
		
		/**
		 * 
		 * @param target
		 * @param value
		 * 
		 */
		public function contractHeight(target:FunctionOption, value:Number):void {
			
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
			FilterPanels(this.parent).moveBoxes(this, -value);
			
		}
	
		/**
		 * 
		 * @return 
		 * 
		 */
		override public function getSelectedOptions():Array {
			
			var selOptions:Array = new Array();																							//Array to store Citation Functions
			var citationFunction:CitationFunction;																						//Citation Function: Recreate the model to send for processing.
			var itemOptions:Array																										//Options array of each citation
			var itemOption:Object																										//Option label (Fact/Opinion) and value (true/false)
			
			for each (var item:Object in optionArray) {																					//Loop in the functions
				
				itemOptions = null;
				itemOption = null;
				
				functionOption = item.bt;	
				citationFunction = new CitationFunction(functionOption.label);									//Create the function: id, name
				
				//Test if the function is complex
				
				switch (functionOption.category) {
				
					case CitationCategory.COMPLEX:																	//If the function has subfunctions
						
						//Get subfunctions in the current functions
						var subFunctionOptions:Array;
						var subFunctionOption:FunctionOption;																					//Function Option: Recreate the option for procesing 
						
						citationFunction.value = functionOption.selected;																		//save functons selection value
						
						//test if the function is selected.
						if (functionOption.selected) {
							
							subFunctionOptions = functionOption.optionArray;
							var subItem:Object
							
							
							for each(subItem in subFunctionOptions) {
								
								subFunctionOption = subItem.bt;																						//Get the button related to the subfunction
								citationFunction.addSubFunction(subFunctionOption.label);														//Add subfunction to the Citation Model
								
								citationFunction.setSubFunctionValue(subFunctionOption.label, subFunctionOption.selected);
								
								if (subFunctionOption.selected) {
	
									itemOptions = subFunctionOption.optionArray;																		//Get the option Array in the subFunction
									
									for each(itemOption in itemOptions) {																				//Loop in the option
										citationFunction.addOptionToSubFunction(subFunctionOption.label,itemOption.label, itemOption.selected);		//Get the option: Label and Value
									}
									
								}
								
							}
			
							
						}
						
						break;
					
					
					case CitationCategory.SIMPLE:																		//Test if it is a SIMPLE function
						
						citationFunction.value = functionOption.selected;																		//save subfunctons selection value
						
						//Get the options Array
						if (functionOption.selected) {
							itemOptions = functionOption.optionArray;
						
							for each(itemOption in itemOptions) {																					//Loop in the options
								citationFunction.addOption(itemOption.label, itemOption.selected);														//Get the option: Label and Value
							}
						}
						
						break;
					
				}
			
				selOptions.push(citationFunction);																					//Store citation function in the array
			}
					
			return selOptions;	
			
		}
		
	}
}