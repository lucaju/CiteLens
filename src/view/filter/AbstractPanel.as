package view.filter {
	
	//imports
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import events.CiteLensEvent;
	
	import mvc.AbstractView;
	
	import view.assets.Button;
	import view.assets.ButtonStatus;
	import view.assets.tooltip.ToolTip;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractPanel extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var source 				:FilterPanels;
		
		protected var _maxW					:int		= 155; 		// 185 original
		protected var _margin				:Number	= 7;
		
		protected var posY					:Number		= 0;
		
		protected var _labelTF				:TextField;
		
		protected var _optionArray			:Array;
		protected var optionsList			:Sprite;		
		
		protected var endLine				:Sprite;
		
		protected var optionCount			:int		= 0;
		protected var hasSelectedOptions	:Boolean	= false;
		
		protected var toolTip				:ToolTip;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * @param t
		 * 
		 */
		public function AbstractPanel(s:FilterPanels) {
			source = s;
			super(source.getControler());
			
			optionArray = new Array();
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param active
		 * 
		 */
		 public function init(active:Boolean):void {
			//to override		
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedOptions():Array {
			//to overrride
			return optionArray;
		}

		
		//****************** INTERNAL METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param l
		 * 
		 */
		internal function buildLabel(l:String):void {
			
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.mouseEnabled = false;
			labelTF.autoSize = TextFieldAutoSize.LEFT;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.embedFonts = true;
			labelTF.width = 20;
			
			labelTF.text = l;
			labelTF.setTextFormat(TXTFormat.getStyle("General Label","filter"+source.filterID));
			
			this.addChild(labelTF);
			
		}
		
		/**
		 * 
		 * 
		 */
		internal function makeEndLine():void {
			endLine = new Sprite();
			endLine.graphics.lineStyle(1);
			endLine.graphics.lineStyle(1,ColorSchema.getColor("filter"+source.filterID));
			endLine.graphics.beginFill(0x000000);
			//endLine.graphics.moveTo(margin, 0);
			endLine.graphics.lineTo( maxW - (2 * margin), 0);
			endLine.graphics.endFill();
			
			endLine.y = this.height;
			this.addChild(endLine);
		}
		
		/**
		 * 
		 * @param target
		 * @param status
		 * 
		 */
		internal function switchClick(target:Button, status:String):void {
			target.status = status;
		}
		
		/**
		 * 
		 * 
		 */
		internal function updatePanel():void {
			//dispatch visualization change
			var obj:Object = new Object()
			obj.filterID = source.filterID;
			
			this.dispatchEvent(new CiteLensEvent(CiteLensEvent.CHANGE_VISUALIZATION,obj));
		}
		
		/**
		 * 
		 * @param target
		 * 
		 */
		internal function deleteOption(target:*):void {
			//Override
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _click(e:MouseEvent):void {
			var button:Button = Button(e.target);
			
			//identify button in the collection
			
			for each (var option:Object in optionArray) {
				if (option.bt == button) {
					break;
				}
			}
			
			if (option.selected == false) {
				switchClick(button, ButtonStatus.SELECTED)
				option.selected = true;
				
			} else {
				switchClick(button, ButtonStatus.ACTIVE)
				option.selected = false;
			}
			
			
			//dispatch visualization change
			var obj:Object = new Object()
			obj.filterID = source.filterID;
			
			this.dispatchEvent(new CiteLensEvent(CiteLensEvent.CHANGE_VISUALIZATION,obj));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function addOption(e:MouseEvent = null):void {
			//override
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _over(e:MouseEvent):void{
			
			var data:Object = new Object();
			data.target = e.target;
			
			for each(var option:Object in optionArray) {
				if (e.target == option.bt) {
					data.title = option.source.name
					break;
				}
			}
			
			if (data) {
				toolTip = new ToolTip();
				toolTip.initialize(data)
				stage.addChild(toolTip)
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _out(e:MouseEvent):void{
			if (toolTip) {
				stage.removeChild(toolTip);
				toolTip = null;
			}
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxW():int {
			return _maxW;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxW(value:int):void {
			_maxW = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get margin():Number {
			return _margin;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set margin(value:Number):void {
			_margin = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get labelTF():TextField {
			return _labelTF;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set labelTF(value:TextField):void {
			_labelTF = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get optionArray():Array {
			return _optionArray;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set optionArray(value:Array):void {
			_optionArray = value;
		}

		
	}
}