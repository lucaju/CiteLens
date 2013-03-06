package view.filter {
	
	//import
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.CitationFunction;
	import model.Country;
	import model.Language;
	import model.PubType;
	
	import view.CiteLensView;
	import view.assets.Button;
	import view.assets.CrossBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class OptionsPanel extends CiteLensView  {
		
		//properties
		internal var maxW:int = 185;
		internal var margin:Number = 5;
		
		internal var filterID:int;
		
		private var checkSelectedOptions:Boolean;								// switch: Filter active or inactive
		
		private var optionBoxesArray:Array;
		
		private var languagesBox:OptionBox;
		private var countriesBox:OptionBox;
		private var pubTypeBox:OptionBox;
		private var periodBox:OptionBox;
		private var functionBox:OptionBox;
		private var authorBox:OptionBox;
		
		public function OptionsPanel(fID:int) {
			
			super(citeLensController);
			
			filterID = fID;
			
			
		}
		
		public function init(active:Boolean):void {
			
			optionBoxesArray = new Array();
			
			//general
			var posYBoxes:Number = 0;
			
			//Languages
			languagesBox = new OptionBox(filterID, "Language");
			languagesBox.x = margin;
			languagesBox.y = posYBoxes;
			this.addChild(languagesBox);
			
			languagesBox.init(active);
			
			optionBoxesArray.push(languagesBox);
			posYBoxes = languagesBox.y + languagesBox.height + margin;
			
			//Countries
			countriesBox = new OptionBox(filterID, "Country");
			countriesBox.x = margin;
			countriesBox.y = posYBoxes;
			this.addChild(countriesBox);
			
			countriesBox.init(active);
			
			optionBoxesArray.push(countriesBox);
			posYBoxes = countriesBox.y + countriesBox.height + margin;
			
			//Pub Type
			pubTypeBox = new OptionBox(filterID, "Publication Type");
			pubTypeBox.x = margin;
			pubTypeBox.y = posYBoxes;
			this.addChild(pubTypeBox);
			
			pubTypeBox.init(active);
			
			optionBoxesArray.push(pubTypeBox);
			posYBoxes = pubTypeBox.y + pubTypeBox.height + margin;
			
			//-----------------Period
			
			periodBox = new PeriodBox(filterID);
			
			periodBox.x = margin;
			periodBox.y = posYBoxes;
			this.addChild(periodBox);
			
			periodBox.init(active);
			
			optionBoxesArray.push(periodBox);
			posYBoxes = periodBox.y + periodBox.height + margin;
			
			//-----------------Functions
			
			functionBox = new FunctionBox(filterID);
			functionBox.x = margin;
			functionBox.y = posYBoxes;
			this.addChild(functionBox);
			
			functionBox.init(active);
			
			optionBoxesArray.push(functionBox);
			posYBoxes = functionBox.y + functionBox.height + margin;
			
			//-----------------author
			
			authorBox = new AuthorBox(filterID);
			authorBox.x = margin;
			authorBox.y = posYBoxes;
			this.addChild(authorBox);
			
			authorBox.init(active);
			optionBoxesArray.push(authorBox);
			
			
		}
		
		private function buildLabel(l:String):TextField {
			var label:TextField = new TextField();
			label.selectable = false;
			label.mouseEnabled = false;
			label.autoSize = "left";
			label.antiAliasType = "Advanced";
			label.width = 20;
			
			label.text = l;
			label.setTextFormat(TXTFormat.getStyle("General Label","filter"+filterID));
			
			return label;
		}
		
		public function moveBoxes(target:*, value:Number):void {
			//find the slice point
			for (var i:int = 0; i < optionBoxesArray.length; i++) {
				if (optionBoxesArray[i].label == target.label) {
					var partOfBoxes:Array = optionBoxesArray.slice(i+1);
					break;
				}
			}
			
			//moving parts
			if (partOfBoxes) {
				for each (var box:OptionBox in partOfBoxes) {
					TweenMax.to(box,.5,{y:box.y + value});					//move up each line
				}
			}
			
			//Resize outer box
			FilterPanel(this.parent).resizeBorder(value);
		}
		
		private function _click(e:MouseEvent):void {
			var button:Button = Button(e.target);
			
			//select option clicked
			if (button.status == "selected") {
				button.status = "active";
			} else {
				button.status = "selected";
			}
		}
		
		//getter
		public function getSelectedOptions():Object {
			var data:Object = new Object();
			
			data.languages = languagesBox.selectedOptions();
			data.countries = countriesBox.selectedOptions();
			data.pubTypes = pubTypeBox.selectedOptions();
			data.periods = periodBox.selectedOptions();
			data.functions = functionBox.selectedOptions();
			data.auhtors = authorBox.selectedOptions();
			
			//traceSelectedOption(data)
			
			
			
			return data;
		}
		
		private function traceSelectedOption(data:Object):void {
			
			//Language
			trace ("LANGUAGES:")
			var selecLang:Array = data.languages;
			for each (var language:Language in selecLang) {
				trace (language.name)
			}
			
			trace ("------------")
			
			//Countries
			trace ("COUNTRIES:")
			var selecCountries:Array = data.countries;
			for each (var country:Country in selecCountries) {
				trace (country.name)
			}
			
			trace ("------------")
			
			//Pub Type
			trace ("PUBLICATION TYPE:")
			var selecPubType:Array = data.pubTypes;
			for each (var pubType:PubType in selecPubType) {
				trace (pubType.name)
			}
			
			trace ("------------")
			
			//periods
			trace ("PERIODS:")
			var selecPeriods:Array = data.periods;
			for each (var periods:Object in selecPeriods) {
				trace ("From: " + periods.from + " - To: " + periods.to)
			}
			
			trace ("------------")
			
			//functions
			trace ("FUNCTIONS:")
			var selecFunctions:Array = data.functions;
			
			var opt:Object;
			
			for each (var func:Object in selecFunctions) {
				
				trace (func.label)
				var options:Array = func.options;
				
				if (func.label == "secondary source") {
					
					for each (opt in options) {
			
						trace (" - " + opt.label)

						//suboptions
						var subOptions:Array = opt.options;
						
						for each (var subOpt:Object in subOptions) {
							
							var subParams:Array = subOpt.options;
							
							trace (" ---- " + subOpt.label + ": " + subOpt.selected);

						}
						
					}
						
					
				} else {
					for each (opt in options) {
						trace (" - " + opt.label + ": " + opt.selected)
					}

				}
				
				trace ("==============")
				
			}
			
			trace ("------------")
			
			//Authors
			trace ("AUTHORS:")
			var selecAuthors:Array = data.auhtors;
			for each (var author:String in selecAuthors) {
				trace (author)
			}
			
			trace ("------------")
		}

	}
}