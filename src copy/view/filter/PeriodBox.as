package view.filter {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.CrossBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class PeriodBox extends OptionBox {
		
		//properties
		private var period:PeriodOption;
		private var addBT:CrossBT;
		
		public function PeriodBox(fID:int) {
			super(fID);
		}
		
		override public function init(active:Boolean):void {
			
			//define if it must check for selected itens
			if (active) {
				hasSelectedOptions = citeLensController.filterHasSelectedOptions(filterID, "period");
			}
			
			//label
			buildLabel("period");
			
			//add button
			var addBT:CrossBT = new CrossBT(ColorSchema.getColor("filter"+filterID));
			addBT.rotation = 45;
			addBT.x = addBT.width;
			addBT.y = label.height + ((addBT.height/2) - 1);
			this.addChild(addBT);
			
			addBT.buttonMode = true;
			addBT.addEventListener(MouseEvent.CLICK, _click);
			
			//list
			optionsList = new Sprite();
			optionsList.y = label.height - 3;
			this.addChild(optionsList);
			
			//end line
			//separate line
			makeEndLine();
			
			//looking for preselected authors, otherwise add the first one
			if (hasSelectedOptions) {
				var selectedPeriods:Array = citeLensController.getFilterOptionsByType(filterID, "period");
				
				for each (var periodRange:Object in selectedPeriods) {
					addPeriodRange(periodRange);
				}	
				
			} else {
				addPeriodRange();
				optionArray[0].activeDeleteButton = false; //disble remove button
			}
			
		}
		
		override internal function _click(e:MouseEvent):void {
			addPeriodRange();
		}
		
		private function addPeriodRange(periodRange:Object = null):void {
			period = new PeriodOption(filterID, optionCount++);
			if (periodRange) {
				period.periodDate = periodRange;
			}
			period.x = -25;
			period.y = posY;
			
			optionsList.addChild(period);
			
			optionArray.push(period);
			
			//update vertical space 
			posY += period.height + 3;
			
			//move endline further down
			TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, period.height + 3);
			
			//animation
			//TweenLite.from(period,.5,{y:period.y - 10, alpha:0});
			TweenLite.from(period,.5,{alpha:0});
			
			//if there are more than one in the option list
			if (optionArray.length > 1) {
				optionArray[0].activeDeleteButton = true; //enable remove button in the first one
			}
			
			
			
		}
		
		public function deletePeriodRange(target:PeriodOption):void {
			
			//test for target
			for (var i:int = 0; i < optionArray.length; i++) {	
				if (optionArray[i] == target) {								
					var gap:Number = optionArray[i].height + 3;				//calculate the gap
					optionsList.removeChild(optionArray[i]); 					//remove period range from the screen

					//if the option is the first, change the the second option label and tag for futher change\ing													
					if (i == 0) {
						optionArray[i+1].setFromLabelText("from");
						var isFIrst:Boolean = true;
					}
					
					// if the option is not the last, select those after the delete option
					if (i < optionArray.length-1) {						
						var partOfPeriods:Array = optionArray.slice(i);
					}
					
					optionArray.splice(i,1);									//remove target from collection
					
					break;
				}
			}
			
			//animation to realocate
			if (partOfPeriods) {												//if the option removed was in the middle
				for each (period in partOfPeriods) {
					TweenLite.to(period,.5,{y:period.y - gap});					//move up each line
				}
				
				//update posY and move up the end line 
				if (isFIrst) {
					posY = optionsList.height + 3;
					TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
				} else {
					posY = optionsList.height - gap + 3;
					TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height - gap + 3});
				}
				
			} else {															//if was the last one
				//update posY and move up the end line  
				posY = optionsList.height + 3;
				TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
			}
			
			//if there is just one option in the list - disable remove button, move end line and update posY
			if (optionArray.length == 1) {
				optionArray[0].activeDeleteButton = false;
				TweenLite.to(endLine,.5,{y:optionsList.y + optionsList.height + 3});
				posY = optionsList.height + 3;
			}
			
			//move box in optionPanel
			OptionsPanel(this.parent).moveBoxes(this, -gap);
			
		}
		
		
		//get selected data
		override public function selectedOptions():Array {
			var selOptions:Array;
			
			for each (var period:PeriodOption in optionArray) {
				
				var periodDate:Object = period.periodDate;
				
				if (periodDate.from != "" || periodDate.to != "") {
					
					//initialize array
					if (!selOptions) {
						selOptions = new Array();
					}
					
					
					selOptions.push(period.periodDate);
				
				}
				
				
			}
			
			return selOptions;
		}
	}
}