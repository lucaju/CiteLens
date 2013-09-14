package view.bibliography {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import model.RefBibliographic;
	
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ItemRef extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected static var _origWidth		:Number;
		protected var _id					:int;
		protected var _uniqueID				:String;
		
		protected var bg					:Sprite;
		protected var content				:Sprite
		protected var contentMask			:Sprite;
		
		protected var _originalHeight		:Number;
		
		protected var line					:Sprite;
		protected var textTF				:TextField;
		protected var countTF				:TextField;
		
		internal var margin					:Number = 3;
		internal var noteAreaWidth			:Number = 12;
		
		public var authorship				:String;
		protected var _title				:String;
		public var date						:int;
		
		protected var _selected				:Boolean = false;
		
		protected var refBibl				:RefBibliographic;
		
		protected var citationInfo			:ItemCitationInfo;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param refBib
		 * @param i
		 * 
		 */
		public function ItemRef(refBib:RefBibliographic, i:int = 0) {
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			content = new Sprite();
			this.addChild(content);
			
			refBibl = refBib;
			id = i;
			_uniqueID = refBib.uniqueID;
		
			//Text Field
			textTF = new TextField();
			textTF.x = margin + noteAreaWidth;
			textTF.y = margin;
			textTF.selectable = false;
			textTF.multiline = true;
			textTF.mouseEnabled = false;
			textTF.wordWrap = true;
			textTF.autoSize = TextFieldAutoSize.LEFT;
			textTF.antiAliasType = AntiAliasType.ADVANCED;
			textTF.width = _origWidth - ( 2 * margin ) - noteAreaWidth;
			
			textTF.embedFonts = true;
			
			content.addChild(textTF);
			
			//content style divider
			var partial:int = 0;
		
			//authorship
			authorship = refBib.getAuthorship()
			textTF.appendText(authorship + ". ");
			textTF.setTextFormat(TXTFormat.getStyle("Item List Author"),partial,textTF.length);
			partial = textTF.length;
			
			//--------------
			
			//Title
			if (refBib.title) {
				title = refBib.title;
			} else {
				title = " ";
			}
			
			textTF.appendText(title + ". ");
			textTF.setTextFormat(TXTFormat.getStyle("Item List Title"),partial,textTF.length);
			partial = textTF.length;
			
			
			//Date
			if (refBib.date) {
				date = refBib.date;
				textTF.appendText(refBib.date + ".");
				textTF.setTextFormat(TXTFormat.getStyle("Item List Date"),partial,textTF.length);
				partial = textTF.length;
			} else {
				textTF.appendText("n.d.");
				textTF.setTextFormat(TXTFormat.getStyle("Item List Date"),partial,textTF.length);
				partial = textTF.length;
			}
			
			//separate line
			line = new Sprite();
			line.graphics.lineStyle(1,0xE6E7E8);
			line.graphics.beginFill(0x000000);
			line.graphics.moveTo(1, 0);
			line.graphics.lineTo(_origWidth - 3, 0);
			line.graphics.endFill();
			content.addChild(line);
			
			bg = new Sprite();
			bg.graphics.beginFill(0xFFFFFF);;
			bg.graphics.drawRect(0,0,_origWidth,textTF.height + 5);
			bg.graphics.endFill();
			
			content.addChildAt(bg,0);
			
			if (refBib.notes.length > 0) {
				//text
				countTF = new TextField();
				countTF.selectable = false;
				countTF.antiAliasType = AntiAliasType.ADVANCED;
				countTF.autoSize = TextFieldAutoSize.LEFT;
				countTF.embedFonts = true;
				
				countTF.text = refBib.notes.length.toString();
				countTF.setTextFormat(TXTFormat.getStyle("Item List Note Count"));
				
				countTF.x = margin;
				countTF.y = margin;
				
				content.addChild(countTF);
				
				//trace (refBib.notes)
				
				//debug
				for each (var note:Object in refBib.notes) {
					if (note.reason == "") addBullet("reason");
					if (note.contentType == "") addBullet("contentType");
				}
				
			}
			
			//mask
			contentMask = new Sprite();
			contentMask.graphics.beginFill(0xFFFFFF);
			contentMask.graphics.drawRect(0,0,_origWidth,this.height);
			contentMask.graphics.endFill();
			
			this.addChild(contentMask);		
			content.mask = contentMask;
			
			//textTF.cacheAsBitmap = true;
			
			originalHeight = this.height;
			
			//interaction
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param type
		 * 
		 */
		protected function addBullet(type:String):void {
			
			var color:uint;
			
			if (type == "reason") {
				color = 0xFBAF3F;
			} else if (type == "contentType") {
				color = 0xEF4036;
			}
			
			var bullet:Sprite = new Sprite();
			bullet.graphics.beginFill(color);
			bullet.graphics.drawCircle(0,0,10);
			bullet.graphics.endFill();
			
			var posX:Number;
			if (type == "reason") {
				posX = (this.width/2) - bullet.width - 5;
			} else if (type == "contentType") {
				posX = (this.width/2) + bullet.width + 5;
			}
		
			bullet.x = posX;
			bullet.y = (this.height/2);
			
			bullet.alpha = .7;
			
			this.addChild(bullet);
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _over(e:MouseEvent):void {
			TweenLite.to(bg, .4, {alpha:.2, tint: ColorSchema.LIGHT_GREY})
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _out(e:MouseEvent):void {
			TweenLite.to(bg, .2, {alpha: 1, removeTint: true})
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function select():void {
			
			selected = true;
			
			//text color
			if (countTF) TweenLite.to(countTF, 0, {tint: ColorSchema.white});
			TweenLite.to(textTF, 0, {tint: ColorSchema.white});
			
			//animation
			TweenLite.to(contentMask, 1, {height: this.height});
			TweenLite.to(bg, 1, {alpha:1, height: this.height, tint: ColorSchema.RED});
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, _over);
			this.removeEventListener(MouseEvent.MOUSE_OUT, _out);
		}
		
		/**
		 * 
		 * 
		 */
		public function deselect():void {
			
			//deselect
			selected = false;
			removeCitationInfo();
			
			//animation
			TweenLite.to(bg, 1, {height: this.originalHeight, removeTint: true});
			TweenLite.to(contentMask, 1, {height: this.originalHeight});
			
			//text color
			if (countTF) TweenLite.to(countTF, .3, {removeTint: true});
			TweenLite.to(textTF, .3, {removeTint: true});
				
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
		}
		
		/**
		 * 
		 * @param citeInfo
		 * 
		 */
		public function addCitationInfo(citeInfo:Array):void {
			if (!citationInfo) {
				citationInfo = new ItemCitationInfo(this, citeInfo);
				citationInfo.x = margin + noteAreaWidth;
				citationInfo.y = this.height;
				content.addChild(citationInfo);
				TweenLite.from(citationInfo,1,{y:citationInfo.y-5, alpha:0});
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getCitationsIDs():Array {
			if (!citationInfo) {
				return citationInfo.citations;
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function removeCitationInfo():void {
			if (citationInfo) {
				content.removeChild(citationInfo);
				citationInfo = null;
			}
		}

		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set origWidth(value:Number):void {
			_origWidth = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get origWidth():Number {
			return _origWidth;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			_title = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get titles():Array {
			return refBibl.titles;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get authors():Array {
			return refBibl.authors;
		}

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
		public function get uniqueID():String {
			return _uniqueID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get originalHeight():Number {
			return _originalHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set originalHeight(value:Number):void {
			_originalHeight = value;
		}


	}
}