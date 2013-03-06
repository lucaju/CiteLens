package view.bibliography {
	
	//imports
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.RefBibliographic;
	
	import view.style.*;
	
	public class ItemRef extends Sprite {
		
		//properties
		private static var _origWidth:Number;
		private var _id:int;
		private var _uniqueID:String;
		private var base:Sprite;
		private var bg:Sprite;
		private var line:Sprite;
		private var textTF:TextField;
		private var countTF:TextField;
		
		private var margin:Number = 3;
		private var noteAreaWidth:Number = 12;
		
		public var authorship:String;
		private var _title:String;
		public var date:int;
		
		private var refBibl:RefBibliographic;
		
		public function ItemRef(refBib:RefBibliographic, i:int = 0) {
			
			refBibl = refBib;
			id = i;
			_uniqueID = refBib.uniqueID;
			
			super();
		
			//Text Field
			textTF = new TextField();
			textTF.x = margin + noteAreaWidth;
			textTF.y = margin;
			textTF.selectable = false;
			textTF.multiline = true;
			textTF.mouseEnabled = false;
			textTF.wordWrap = true;
			textTF.autoSize = "left";
			textTF.antiAliasType = "Advanced";
			textTF.width = _origWidth - ( 2 * margin ) - noteAreaWidth;
			
			this.addChild(textTF);
			
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
			addChild(line);
			
			bg = new Sprite();
			bg.graphics.beginGradientFill("linear",[0xBBBBBB,0xEEEEEE],[1,1],[0,255]);
			bg.graphics.drawRect(0,0,255,10);
			bg.graphics.endFill();
			bg.alpha = .2
			bg.width = textTF.height + 5;
			bg.height = _origWidth
			bg.rotation = -90;
			bg.y = bg.height;
			
			addChildAt(bg,0);
			
			//base
			base = new Sprite();
			//base.graphics.beginFill(0x648EC9,.5);
			base.graphics.beginGradientFill("linear",[0x000000,0xFFFFFF],[.3,.3],[100,200]);
			base.graphics.drawRect(0,0,255,10);
			base.graphics.endFill();
		
			base.width = textTF.height + 5;
			base.height = _origWidth
			base.rotation = -90;
			base.y = base.height;
			
			base.alpha = 0;
			addChild(base);
			
			
			if (refBib.notes.length > 0) {
				//text
				countTF = new TextField();
				countTF.selectable = false;
				countTF.antiAliasType = "Advanced";
				countTF.autoSize = "left";
				
				countTF.text = refBib.notes.length.toString();
				countTF.setTextFormat(TXTFormat.getStyle("Item List Note Count"));
				
				countTF.x = margin;
				countTF.y = margin;
				
				this.addChild(countTF);
				
				//trace (refBib.notes)
				
				for each (var note:Object in refBib.notes) {
					
					if (note.reason == "") {
						addBullet("reason");
					}
					
					if (note.contentType == "") {
						addBullet("contentType");
					}
				}
				
			}
			
			//textTF.cacheAsBitmap = true;
			
			//interaction
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			
		}
		
		private function addBullet(type:String):void {
			
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
		
		private function _over(e:MouseEvent):void {
			TweenLite.to(base, .3, {alpha: .4})
		}
		
		private function _out(e:MouseEvent):void {
			TweenLite.to(base, .5, {alpha: 0})
		}
		
		public function select():void {
			
			//text color
			if (countTF) {
				TweenLite.to(countTF, 0, {tint: 0xFFFFFF})
			}
			TweenLite.to(textTF, 0, {tint: 0xFFFFFF})
			
			//ng
			bg = new Sprite();
			bg.graphics.beginFill(ColorSchema.getColor("red"));
			bg.graphics.drawRect(0,0,_origWidth,textTF.height + 5);
			bg.graphics.endFill();

			this.addChildAt(bg,0);
			
			TweenLite.to(base, .3, {alpha: .6})
		}
		
		public function deselect():void {
			this.removeChild(bg);
			TweenLite.to(base, .5, {alpha: 0})
				
			//text color
			if (countTF) {
				TweenLite.to(countTF, .3, {removeTint: true})
			}
			TweenLite.to(textTF, .3, {removeTint: true})
		}
		

		public static function set origWidth(value:Number):void {
			_origWidth = value;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}
		
		public function get titles():Array {
			return refBibl.titles;
		}
		
		public function get authors():Array {
			return refBibl.authors;
		}

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}

		public function get uniqueID():String {
			return _uniqueID;
		}

		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}


	}
}