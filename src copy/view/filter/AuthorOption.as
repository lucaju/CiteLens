package view.filter {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.assets.MinusBT;
	import view.style.ColorSchema;
	import view.style.TXTFormat;
	
	public class AuthorOption extends OptionBox {
		
		//properties
		private var _id:int;
		
		private var input:TextField;
		private var deleteButton:MinusBT;
		
		public function AuthorOption(fID:int, id_:int) {
			
			super(fID)
			
			id = id_;
			
			//input
			input = new TextField();
			
			input.antiAliasType = "Advanced";
			input.type = "input";
			input.defaultTextFormat = TXTFormat.getStyle("General Label");
			input.width = 110;
			input.height = 15;
			input.border = true;
			input.borderColor = 0xcccccc;
			this.addChild(input);
			
			//add button
			deleteButton = new MinusBT(ColorSchema.getColor("red"));
			deleteButton.x = input.x + input.width + 2 + deleteButton.width;
			deleteButton.y = deleteButton.height - 2;
			this.addChild(deleteButton);
			
			deleteButton.buttonMode = true;
			deleteButton.addEventListener(MouseEvent.CLICK, removeAuthorName);
		}
		
		public function set activeDeleteButton(value:Boolean):void {
			if(value) {
				deleteButton.buttonMode = true;
				deleteButton.addEventListener(MouseEvent.CLICK, removeAuthorName);
				TweenMax.to(deleteButton,.5,{removeTint:true});
			} else {
				deleteButton.buttonMode = false;
				deleteButton.removeEventListener(MouseEvent.CLICK, removeAuthorName);
				TweenMax.to(deleteButton,.5,{tint:0xCCCCCC});
			}
		}
		
		public function removeAuthorName(e:MouseEvent):void {
			var box:AuthorBox = AuthorBox(this.parent.parent);
			
			//animation
			TweenMax.to(this,.5,{x:this.x - 10, alpha:0, onComplete:box.deleteAuthorName, onCompleteParams:[this]});
			TweenMax.to(deleteButton, .5, {rotation:-90});
		}

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}
		
		public function get authorName():String {
			var name:String = input.text;
			
			return name;
		}
		
		public function set authorName(value:String):void {
			input.text = value;
		}

	}
}