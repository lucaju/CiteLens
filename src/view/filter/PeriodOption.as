package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import view.assets.MinusBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PeriodOption extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;
		
		protected var fromLabel			:TextField;
		protected var toLabel			:TextField;
		protected var inputFromTF		:TextField;
		protected var inputToTF			:TextField;
		protected var deleteButton		:MinusBT;
		
		protected var _empty				:Boolean = false;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * @param id_
		 * 
		 */
		public function PeriodOption(id_:int) {
			
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
			inputFromTF.y = -1;
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
			inputToTF.y = -1;
			this.addChild(inputToTF);
			
			border = buildBorder(inputToTF);
			border.x = inputToTF.x;
			this.addChild(border);
			
			//add button
			deleteButton = new MinusBT(ColorSchema.RED);
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
			inputFromTF.addEventListener(KeyboardEvent.KEY_UP, keyUp);
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
			TF.autoSize = TextFieldAutoSize.LEFT;
			TF.antiAliasType = AntiAliasType.ADVANCED;
			TF.embedFonts = true;
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
			
			input.embedFonts = true;
			input.antiAliasType = AntiAliasType.ADVANCED;
			input.type = TextFieldType.INPUT;
			input.defaultTextFormat = TXTFormat.getStyle("Input Period");
			input.maxChars = 4;
			input.width = 45;
			input.height = 16;
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
		
		/**
		 * 
		 * 
		 */
		protected function resetFields():void {
			inputFromTF.text = "year";
			inputFromTF.alpha = .2;
			inputToTF.text = "year";
			inputToTF.alpha = .2;
			toLabel.alpha = .2;
			
			activeDeleteButton = false;
			inputFromTF.addEventListener(Event.CHANGE, _addField);		
			inputToTF.addEventListener(Event.CHANGE, _addField);
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
				PeriodPanel(this.parent.parent).addPeriodRange();
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
			var box:PeriodPanel = PeriodPanel(this.parent.parent);
			
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
				empty = true;
				this.resetFields();
				//this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT)); 	
			} else {
				empty = false;
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function keyUp(event:KeyboardEvent):void {
			if (event.keyCode == 13) {
				if (inputToTF.text == "") inputToTF.text = "2009";
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

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get empty():Boolean {
			return _empty;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set empty(value:Boolean):void {
			_empty = value;
		}


	}
}