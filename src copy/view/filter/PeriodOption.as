package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.MinusBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class PeriodOption extends OptionBox {
		
		//properties
		private var _id:int;
		
		private var fromLabel:TextField;
		private var toLabel:TextField;
		private var inputFromTF:TextField;
		private var inputToTF:TextField;
		private var deleteButton:MinusBT;
		
		public function PeriodOption(fID:int, id_:int) {
			
			super(fID)
			
			id = id_;
			
			//label from
			var labelText:String;
			labelText = (id === 0) ? "from" : "and from";
			
			fromLabel = labelField(labelText);
			this.addChild(fromLabel);
			
			//field from
			inputFromTF = buildInput();
			inputFromTF.x = fromLabel.x + fromLabel.width + 2;
			this.addChild(inputFromTF);
			
			//label to
			toLabel = labelField("to");
			toLabel.x = inputFromTF.x + inputFromTF.width + 2;
			this.addChild(toLabel);
			
			//field to
			inputToTF = buildInput();
			inputToTF.x = toLabel.x + toLabel.width + 2;
			this.addChild(inputToTF);
			
			//add button
			deleteButton = new MinusBT(ColorSchema.getColor("red"));
			deleteButton.x = inputToTF.x + inputToTF.width + 2 + deleteButton.width;
			deleteButton.y = deleteButton.height - 2;
			this.addChild(deleteButton);
			
			deleteButton.buttonMode = true;
			deleteButton.addEventListener(MouseEvent.CLICK, removePeriodRange);;
		}
		
		private function labelField(l:String):TextField {
			var TF:TextField = new TextField();
			TF.selectable = false;
			TF.mouseEnabled = false;
			TF.autoSize = "right";
			TF.antiAliasType = "Advanced";
			
			TF.text = l;
			TF.setTextFormat(TXTFormat.getStyle("Period Label","filter"+filterID));
			
			return TF;
		}
		
		public function setFromLabelText(value:String):void {
			fromLabel.text = value;
			fromLabel.setTextFormat(TXTFormat.getStyle("Period Label","filter"+filterID));
		}
		
		public function set activeDeleteButton(value:Boolean):void {
			if(value) {
				deleteButton.buttonMode = true;
				deleteButton.addEventListener(MouseEvent.CLICK, removePeriodRange);
				TweenMax.to(deleteButton,.5,{removeTint:true});
			} else {
				deleteButton.buttonMode = false;
				deleteButton.removeEventListener(MouseEvent.CLICK, removePeriodRange);
				TweenMax.to(deleteButton,.5,{tint:0xCCCCCC});
			}
		}

		private function buildInput():TextField {
			var input:TextField = new TextField();
			
			input.antiAliasType = "Advanced";
			input.type = "input";
			input.defaultTextFormat = TXTFormat.getStyle("General Label");
			input.maxChars = 4;
			input.width = 30;
			input.height = 15;
			input.border = true;
			input.borderColor = 0xcccccc;
			input.restrict = "0-9"; 
			
			return input;
		}
		
		public function removePeriodRange(e:MouseEvent):void {
			var box:PeriodBox = PeriodBox(this.parent.parent);
			
			//animation
			TweenMax.to(this,.5,{x:this.x - 10, alpha:0, onComplete:box.deletePeriodRange, onCompleteParams:[this]});
			TweenMax.to(deleteButton, .5, {rotation:-90});
		}

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}
		
		public function get periodDate():Object {
			
			var date:Object = new Object()
			date.from = inputFromTF.text;
			date.to = inputToTF.text;
			
			return date;
		}
		
		public function set periodDate(date:Object):void {
			
			inputFromTF.text = date.from;
			inputToTF.text = date.to;
		}

	}
}