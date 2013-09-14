package view.assets.autoComplete {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AutoCompleteBox extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _content				:Array;
		protected var _userTyping			:String;
		
		protected var _searchQuery			:String		 = "";
		protected var _searchTarget			:String		 = "";
		
		protected var listArray				:Array;
		protected var _numSugestions		:int = 6;
		protected var itemHeight			:Number		 = 18;
		protected var _boxWidth				:Number		 = 100;
		
		protected var bg					:Sprite;
		protected var listMask				:Sprite;
		protected var list					:Sprite
		protected var listItem				:AutoCompleteItem;
		protected var _showType				:Boolean	 = true;
		
		protected var selectedID			:int		 = -1;
		
		public var newHeight				:Number;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function AutoCompleteBox() {
			_content = new Array();
			listArray = new Array();
			bg = new Sprite();
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//box
			bg = new Sprite();
			bg.graphics.lineStyle(1,0xCCCCCC,1,true,"none");
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0,boxWidth, itemHeight*numSugestions, 6);
			bg.graphics.endFill();
			
			//bg.height = 0;
			this.addChild(bg);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .2);
			fxs.push(fxGlow);
			bg.filters = fxs;

			//mask
			listMask = new Sprite();
			listMask.graphics.lineStyle(1,0xCCCCCC,1,true);
			listMask.graphics.beginFill(0xFFFFFF);
			listMask.graphics.drawRoundRect(0,0,boxWidth, itemHeight*numSugestions, 6);
			listMask.graphics.endFill();
			
			this.addChild(listMask);
			
			//list
			list = new Sprite();
			this.addChild(list);
			
			list.mask = listMask;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param AutoCompList
		 * @param partial
		 * 
		 */
		public function updateList(AutoCompList:Array, partial:String):void {
			
			content = AutoCompList;
			
			if (numSugestions > content.length) numSugestions = content.length;
			
			userTyping = partial;
			
			//fetch options
			var yPos:Number = 0;
			
			//remove previous list
			if (listArray.length > 0) {
				for each (listItem in listArray) {
					list.removeChild(listItem);
				}
				listArray = new Array();
			}
			
			var i:int = 0;
			for each (var item:Object in content) {
				
				listItem = new AutoCompleteItem(item.label, item.type, userTyping);
				listItem.itemWidth = _boxWidth;
				listItem.showType = _showType;
				list.addChild(listItem);
				
				listItem.init();
				listItem.y = yPos;
				
				listArray.push(listItem);
				
				yPos += listItem.height;
				
				TweenMax.from(listItem, .2, {alpha: 0, delay:.3});
				
				listItem.addEventListener(MouseEvent.CLICK, _click);
				
				i++;
				if (i >= numSugestions) {
					break;
				}
				
			}
			
			//redefine box height
			newHeight = yPos;
			TweenMax.to([bg,listMask], .5, {height: yPos});
			
		}
		
		/**
		 * 
		 * @param arrow
		 * 
		 */
		public function keyboardSelection(arrow:String):void {
			
			//roll out current selected
			if (selectedID > -1 && selectedID < listArray.length) {
				listArray[selectedID]._rollOut();
			}
			
			switch (arrow) {
				
				case "down":
					if (selectedID + 1 < listArray.length) {
						selectedID++;
						listArray[selectedID]._rollOver();
						_searchQuery = listArray[selectedID].getLabel();
						_searchTarget = listArray[selectedID].getType();
					} else {
						selectedID = listArray.length;
						_searchQuery = "";
						_searchTarget = "";
					}
					
					break;
				
				case "up":
					
					if (selectedID > 0) {
						selectedID--;
						listArray[selectedID]._rollOver();
						_searchQuery = listArray[selectedID].getLabel();
						_searchTarget = listArray[selectedID].getType();
					} else if (selectedID == -1) {
						selectedID = listArray.length-1;
						listArray[selectedID]._rollOver();
						_searchQuery = listArray[selectedID].getLabel();
						_searchTarget = listArray[selectedID].getType();
					} else {
						selectedID = -1;
						_searchQuery = "";
						_searchTarget = "";
					}
					break;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFirstOnTheList():String {
			if (listArray.length > 0) {
				return listArray[0].getLabel();
			} else {
				return null;
			}
			
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _click(e:MouseEvent):void {
			listItem = AutoCompleteItem(e.target);
			_searchQuery = listItem.getLabel();
			_searchTarget = listItem.getType();
			
			dispatchEvent(new Event(Event.SELECT));
		}
	
		
		//****************** INTERNAL METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @return 
		 * 
		 */
		internal function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set showType(value:Boolean):void {
			_showType = value
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get showType():Boolean {
			return _showType;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get content():Array {
			return _content;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set content(value:Array):void {
			_content = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get boxWidth():Number {
			return _boxWidth;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set boxWidth(value:Number):void {
			_boxWidth = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get userTyping():String {
			return _userTyping;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set userTyping(value:String):void {
			_userTyping = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get numSugestions():int {
			return _numSugestions;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set numSugestions(value:int):void {
			_numSugestions = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get searchQuery():String {
			return _searchQuery;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get searchTarget():String {
			return _searchTarget;
		}

	}
}