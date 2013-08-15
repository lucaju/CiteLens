package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.MinusBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PeriodOption extends OptionBox {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;
		
		protected var fromLabel			:TextField;
		protected var toLabel			:TextField;
		protected var inputFromTF		:TextField;
		protected var inputToTF			:TextField;
		protected var deleteButton		:MinusBT;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * @param id_
		 * 
		 */
		public function PeriodOption(fID:int, id_:int) {
			
			super(fID)
			
			id = id_;
			/*
			//label from
			var labelText:String;
			//labelText = (id === 0) ? "from" : "and from";
			labelText = "from";
			
			fromLabel = labelField(labelText);
			this.addChild(fromLabel);
			*/
			//field from
			inputFromTF = buildInput();
			//inputFromTF.x = fromLabel.x + fromLabel.width + 4;
			this.addChild(inputFromTF);
			
			var border:Shape = buildBorder(inputFromTF);
			border.x = inputFromTF.x;
			this.addChild(border);
			
			//label to
			toLabel = labelField("to");
			toLabel.x = inputFromTF.x + inputFromTF.width + 7;
			this.addChild(toLabel);
			
			//field to
			inputToTF = buildInput();
			inputToTF.x = toLabel.x + toLabel.width + 7;
			this.addChild(inputToTF);
			
			border = buildBorder(inputToTF);
			border.x = inputToTF.x;
			this.addChild(border);
			
			//add button
			deleteButton = new MinusBT(ColorSchema.getColor("red"));
			deleteButton.x = inputToTF.x + inputToTF.width + 4 + deleteButton.width;
			deleteButton.y = deleteButton.height - 2;
			this.addChild(deleteButton);
			
			deleteButton.buttonMode = true;
			TweenMax.to(deleteButton,.0,{tint:0xCCCCCC});
			
			//add another field if the user start to type in the current field
			inputFromTF.addEventListener(Event.CHANGE, _addField);		
			inputToTF.addEventListener(Event.CHANGE, _addField);
			inputFromTF.addEventListener(FocusEvent.FOCUS_IN, focusIn)		//Focus IN
			inputFromTF.addEventListener(FocusEvent.FOCUS_OUT, _focusOff)	//Focus OFF
			inputToTF.addEventListener(FocusEvent.FOCUS_IN, focusIn)		//Focus IN
			inputToTF.addEventListener(FocusEvent.FOCUS_OUT, _focusOff)	//Focus OFF
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * @return 
		 * 
		 */
		protected function labelField(l:String):TextField {
			var TF:TextField = new TextField();
			TF.selectable = false;
			TF.mouseEnabled = false;
			TF.autoSize = "left";
			TF.antiAliasType = "Advanced";
			TF.alpha = .2;
			TF.text = l;
			TF.setTextFormat(TXTFormat.getStyle("Period Label"));
			
			return TF;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		protected function buildInput():TextField {
			var input:TextField = new TextField();
			
			input.antiAliasType = "Advanced";
			input.type = "input";
			input.defaultTextFormat = TXTFormat.getStyle("Input Period");
			input.maxChars = 4;
			input.width = 45;
			input.height = 15;
			input.text = "year";
			input.alpha = .2;
			input.restrict = "0-9"; 
			
			return input;
		}
		
		/**
		 * 
		 * @param target
		 * @return 
		 * 
		 */
		protected function buildBorder(target:TextField):Shape {
			var brd:Shape = new Shape();
			brd.graphics.lineStyle(1,0xCCCCCC,1,true);
			brd.graphics.beginFill(0x000000,0.05);
			brd.graphics.drawRoundRect(0,0,target.width,target.height,6,6);
			brd.graphics.endFill();
			return brd;
		}

		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/*
		public function setFromLabelText(value:String):void {
		fromLabel.text = value;
		fromLabel.setTextFormat(TXTFormat.getStyle("Period Label","filter"+filterID));
		}
		*/
		
		/**
		 * 
		 * @param value
		 * 
		 */
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
		
		
		//****************** PUBLIC EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _addField(e:Event):void {
			if (inputFromTF.text.length == 1 || inputToTF.text.length == 1) {
				PeriodBox(this.parent.parent).addPeriodRange();
				inputFromTF.removeEventListener(Event.CHANGE, _addField);		
				inputToTF.removeEventListener(Event.CHANGE, _addField);
				
			} else if (inputFromTF.text.length == 0 || inputToTF.text.length == 0) {
				//AuthorBox(this.parent.parent).deleteAuthorName(this);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function removePeriodRange(e:MouseEvent):void {
			var box:PeriodBox = PeriodBox(this.parent.parent);
			
			//animation
			TweenMax.to(this,.5,{x:this.x - 10, alpha:0, onComplete:box.deletePeriodRange, onCompleteParams:[this]});
			TweenMax.to(deleteButton, .5, {rotation:-90});
		}

		/**
		 * 
		 * @param e
		 * 
		 */
		public function focusIn(e:FocusEvent = null):void {
			if (inputFromTF.text == "year") inputFromTF.text = "";
			if (inputToTF.text == "year") inputToTF.text = "";
			
			inputFromTF.alpha = 1;
			inputToTF.alpha = 1;
			toLabel.alpha = 1;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _focusOff(e:FocusEvent):void {
			if (inputFromTF.text.length == 0 && inputToTF.text.length == 0) {
				inputFromTF.text = "year";
				inputFromTF.alpha = .2;
				inputToTF.text = "year";
				inputToTF.alpha = .2;
				toLabel.alpha = .2;
				
				activeDeleteButton = false;
				inputFromTF.addEventListener(Event.CHANGE, _addField);		
				inputToTF.addEventListener(Event.CHANGE, _addField);
				
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT)); 
			}
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
		public function get periodDate():Object {
			
			var date:Object = new Object()
			date.from = inputFromTF.text;
			date.to = inputToTF.text;
			
			return date;
		}
		
		/**
		 * 
		 * @param date
		 * 
		 */
		public function set periodDate(date:Object):void {
			
			inputFromTF.text = date.from;
			inputToTF.text = date.to;
		}

	}
}