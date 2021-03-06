package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import events.CiteLensEvent;
	
	import font.HelveticaNeue;
	
	import view.assets.CrossBT;
	import view.style.ColorSchema;
	
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WindowHeader extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		public static const STANDARD	:String = "standard";
		public static const FILTER		:String = "filter";
		
		protected var _id				:int;
		protected var _type				:String;
		protected var color				:uint = 0xCCCCCC;
		
		protected var w					:Number = 155;
		protected var h					:Number = 20;
		protected var r					:Number = 6;
		
		protected var box				:Sprite;
		protected var labelID			:TextField;
		protected var titleTF			:TextField;
		protected var style				:TextFormat;
		
		protected var eraseBT			:CrossBT;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * @param typ
		 * 
		 */
		public function WindowHeader(id_:int = 0, typ:String = "standard") {
			
			id = id_;
			_type  = typ;
			
			//color
			if (_type == "filter") color = ColorSchema.getColor("filter"+id)
			
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		public function init():void {
			
			//backgorund box
			box = new Sprite();
			box.graphics.beginFill(color);
			box.graphics.drawRoundRectComplex(0,0,w,h,r,r,0,0);
			box.graphics.endFill();
			
			box.scale9Grid = new Rectangle(1,1,w-r,h-r);
			
			this.addChild(box);
			
			
			//title
			if (_type == "filter") {
			
				//Label ID field
				/*
				labelID = new TextField();
				labelID.selectable = false;
				labelID.mouseEnabled = false;
				labelID.embedFonts = true;
				labelID.autoSize = TextFieldAutoSize.LEFT;
				labelID.antiAliasType = AntiAliasType.ADVANCED;

				labelID.text = id.toString();
				labelID.setTextFormat(TXTFormat.getStyle("filter header"));
				
				labelID.x = (box.width/2) - (labelID.width/2);
				labelID.y = 1;
				
				this.addChild(labelID);
				*/

			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function setTitle(value:String, color:uint = 0):void {
			
			if (!titleTF) {
				
				style = new TextFormat();
				style.font = HelveticaNeue.MEDIUM;
				style.size = 11;
				style.align = TextFormatAlign.CENTER;
				style.color = (color != 0) ? color : ColorSchema.white;
				
				titleTF = new TextField();
				titleTF.selectable = false;
				titleTF.mouseEnabled = false;
				titleTF.embedFonts = true;
				//titleTF.autoSize = "TextFieldAutoSize.LEFT;
				titleTF.antiAliasType = AntiAliasType.ADVANCED;
				
				titleTF.defaultTextFormat = style;
				
				titleTF.text = value;
				
				//position and dimension
				if (labelID) {
					titleTF.width = box.width - (labelID.width * 2)
					titleTF.x = labelID.x + labelID.width;
					labelID.x = 4;	//move label ID
				} else {
					titleTF.width = box.width;
				}
				
				titleTF.height = 20;
				titleTF.y = 1;
				
				this.addChild(titleTF);
			}
			
			titleTF.text = value;
		}
		
		/**
		 * 
		 * 
		 */
		public function clear():void {
			for (var i:int = numChildren-1; i >= 0; i--) {
				removeChild(this.getChildAt(i));
			}
		}
		
		/**
		 * 
		 * @param valueW
		 * @param valueH
		 * @param valueRound
		 * 
		 */
		public function setDimensions(valueW:Number, valueH:Number = 20, valueRound:Number = 6):void {
			w = valueW;
			h = valueH;
			r = valueRound;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addEraseButton(value:Boolean):void {
			
			if (value) {
			
				eraseBT = new CrossBT(0xFFFFFF);
				eraseBT.x = box.width - 10;
				eraseBT.y = box.height/2;
				this.addChild(eraseBT);
				eraseBT.buttonMode = true;
				eraseBT.addEventListener(MouseEvent.CLICK, eraseClick);
				TweenMax.from(eraseBT, .5, {alpha: 0, delay:.5})
			
			} else {
			
				eraseBT.removeEventListener(MouseEvent.CLICK, eraseClick);
				this.removeChild(eraseBT)
				eraseBT = null;
				
			}
			
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function update(data:int):void {
			
			var results:String;
			
			if (data == 1) {
				results = data.toString() + " citation";
			} else {
				results = data.toString() + " citations";
			}
			
			if (titleTF.text != results) {
				
				if (data == -1) {	
					TweenMax.to(titleTF, .5, {y:"5", alpha: 0, onComplete:updateData});
				} else {
					TweenMax.to(titleTF, .5, {y:"-5", alpha: 0, onComplete:updateData});
				}
			}
			
			function updateData():void {
				
				titleTF.y = 1;
				titleTF.alpha = 1;
				
				if (data == -1) {
					setTitle("Add comparison set");
					TweenMax.from(titleTF, .5, {y:"-5", alpha: 0, delay:.2})
				} else {
					setTitle(results);
					TweenMax.from(titleTF, .5, {y:"5", alpha: 0})
				}
			}
			
			//add a erase button
			//erase BT
			//if (!eraseBT) addEraseButton;
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function eraseClick(e:MouseEvent):void {
			
			//update title
			update(-1);
			
			//remove erase button
			eraseBT.removeEventListener(MouseEvent.CLICK, eraseClick);
			this.removeChild(eraseBT)
			eraseBT = null;
			
			//send reset informatiom
			var obj:Object = new Object();
			obj.reset = true;
			obj.filterID = this.id;
			//dispatchEvent(new CiteLensEvent(CiteLensEvent.CHANGE_VISUALIZATION,obj));
			dispatchEvent(new CiteLensEvent(CiteLensEvent.REMOVE_FILTER,obj));
			
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
		public function get type():String {
			return _type;
		}

	}
}