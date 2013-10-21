package view.filter {
	
	//import
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.citation.CitationFunction;
	
	import mvc.IController;
	
	import view.assets.Button;
	import view.assets.ButtonStatus;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FilterPanels extends Sprite  {
		
		//****************** Properties ****************** ****************** ******************
		
		internal var maxW					:int	 = 155; 		// 185 original
		internal var margin					:Number	 = 7;
		
		protected var _source				:FilterWindow;
		
		protected var checkSelectedOptions	:Boolean;				// switch: Filter active or inactive
		
		protected var optionBoxesArray		:Array;
		
		protected var languagesPanel		:AbstractPanel;
		protected var countriesPanel		:AbstractPanel;
		protected var pubTypePanel			:AbstractPanel;
		protected var periodPanel			:AbstractPanel;
		protected var functionPanel			:AbstractPanel;
		protected var authorPanel			:AbstractPanel;
		
		protected var debug					:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
		public function FilterPanels(source:FilterWindow) {
			_source = source;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param active
		 * 
		 */
		public function init(active:Boolean):void {
			
			optionBoxesArray = new Array();
			
			//general
			var posYBoxes:Number = 0;
			
			//-----------------Languages
			languagesPanel = new CheckBoxPanel(this,"Language");
			languagesPanel.maxW = maxW;
			languagesPanel.margin = margin;
			languagesPanel.x = margin;
			languagesPanel.y = posYBoxes;
			this.addChild(languagesPanel);
			
			languagesPanel.init(active);
			
			optionBoxesArray.push(languagesPanel);
			posYBoxes = languagesPanel.y + languagesPanel.height + (margin/2);
			
			
			//-----------------Countries
			countriesPanel = new CheckBoxPanel(this,"Country");
			countriesPanel.maxW = maxW;
			countriesPanel.margin = margin;
			countriesPanel.x = margin;
			countriesPanel.y = posYBoxes;
			this.addChild(countriesPanel);
			
			countriesPanel.init(active);
			
			optionBoxesArray.push(countriesPanel);
			posYBoxes = countriesPanel.y + countriesPanel.height + (margin/2);
			
			
			//-----------------Pub Type
			pubTypePanel = new CheckBoxPanel(this,"Publication Type");
			pubTypePanel.maxW = maxW;
			pubTypePanel.margin = margin;
			pubTypePanel.x = margin;
			pubTypePanel.y = posYBoxes;
			this.addChild(pubTypePanel);
			
			pubTypePanel.init(active);
			
			optionBoxesArray.push(pubTypePanel);
			posYBoxes = pubTypePanel.y + pubTypePanel.height + (margin/2);
			
			
			//-----------------Period
			
			periodPanel = new PeriodPanel(this);
			periodPanel.maxW = maxW;
			periodPanel.margin = margin;
			periodPanel.x = margin;
			periodPanel.y = posYBoxes;
			this.addChild(periodPanel);
			
			periodPanel.init(active);
			
			optionBoxesArray.push(periodPanel);
			posYBoxes = periodPanel.y + periodPanel.height + (margin/2) + 4;
			
			//-----------------Functions
			
			functionPanel = new FunctionPanel(this);
			functionPanel.maxW = maxW;
			functionPanel.margin = margin;
			functionPanel.x = margin;
			functionPanel.y = posYBoxes;
			this.addChild(functionPanel);
			
			functionPanel.init(active);
			
			optionBoxesArray.push(functionPanel);
			posYBoxes = functionPanel.y + functionPanel.height + (margin/2);
			
			
			//-----------------author
			
			authorPanel = new AuthorPanel(this);
			authorPanel.maxW = maxW;
			authorPanel.margin = margin;
			authorPanel.x = margin;
			authorPanel.y = posYBoxes;
			this.addChild(authorPanel);
			
			authorPanel.init(active);
			optionBoxesArray.push(authorPanel);
				
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * @return 
		 * 
		 */
		protected function buildLabel(l:String):TextField {
			var label:TextField = new TextField();
			label.selectable = false;
			label.mouseEnabled = false;
			label.autoSize = "left";
			label.antiAliasType = "Advanced";
			label.width = 20;
			
			label.text = l;
			label.setTextFormat(TXTFormat.getStyle("General Label","filter"+_source.filterID));
			
			return label;
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _click(e:MouseEvent):void {
			var button:Button = Button(e.target);
			
			//select option clicked
			if (button.status == ButtonStatus.SELECTED) {
				button.status = ButtonStatus.ACTIVE;
			} else {
				button.status = ButtonStatus.SELECTED;
			}
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * @param value
		 * 
		 */
		public function moveBoxes(target:*, value:Number):void {
			//find the slice point
			for (var i:int = 0; i < optionBoxesArray.length; i++) {
				if (optionBoxesArray[i].labelTF == target.labelTF) {
					var partOfBoxes:Array = optionBoxesArray.slice(i+1);
					break;
				}
			}
			
			//moving parts
			if (partOfBoxes) {
				for each (var box:AbstractPanel in partOfBoxes) {
					TweenMax.to(box,.5,{y:box.y + value});					//move up each line
				}
			}
			
			//Resize outer box
			FilterWindow(this.parent).resizeBorder(value);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedOptions():Object {
			var data:Object = new Object();
			
			data.languages = languagesPanel.getSelectedOptions();
			data.countries = countriesPanel.getSelectedOptions();
			data.pubTypes = pubTypePanel.getSelectedOptions();
			data.periods = periodPanel.getSelectedOptions();
			data.functions = functionPanel.getSelectedOptions();
			data.auhtors = authorPanel.getSelectedOptions();
			
			//test data - If not option is selected, send reset;
			if (!data.languages && !data.countries && !data.pubTypes && !data.periods && !data.auhtors) {
				
				var functionAtivated:Boolean = false;
				
				for each (var func:CitationFunction in data.functions) {
					if (func.value) {
						functionAtivated = true;
						break;
					}
					
				}
				
				if (!functionAtivated) {
					data.reset = true;
				}
			}
			
			if (debug) FilterPanelOutput.traceSelectedOption(data);
			
			return data;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get filterID():int {
			return _source.filterID;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getControler():IController {
			return _source.getController();
		}

	}
}