package view.bibliography {
	
	//imports
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	
	import events.SortEvent;
	
	import flash.display.Sprite;
	
	//import util.Global;
	
	import view.assets.ShadowLine;
	import view.assets.scroll.Scroll;
	
	public class List extends BibliographyView {
		
		//properties
		private var origWidth:Number;
		private var origHeight:Number;
		
		private var item:ItemRef;
		private var itemsArray:Array;
		
		private var container:Sprite;
		private var containerMask:BlitMask;
		
		private var scroll:Scroll;
		
		
		public function List() {
			
			super();
			
		}
		
		override public function initialize():void {
			
			//events
			this.addEventListener(SortEvent.SORT, sort);
			
			//global size
			//origWidth = Global.globalWidth/5;
			//origHeight = Global.globalHeight - 50;
			origWidth = this.parent.width - super.margin;
			origHeight = this.parent.height - 52;			
			
			
			//list container
			container = new Sprite();
			this.addChild(container);
			
			//shadow line
			var lineStart:ShadowLine = new ShadowLine(origWidth);
			addChild(lineStart);
			
			//shadow line
			var lineEnd:ShadowLine = new ShadowLine(origWidth);
			lineEnd.rotation = 180;
			lineEnd.x = lineEnd.width;
			lineEnd.y = origHeight;
			addChild(lineEnd);
			
			//action
			list();
			
		}
		
		private function list():void {
			
			//init
			ItemRef.origWidth = this.parent.width;
			
			itemsArray = new Array();
			var posY:Number = 0;
			
			//get number of itens
			var bibTotal:int = citeLensController.getBibliographyLenght();
			
			//loop - populate
			
			for (var i:int = 0; i< bibTotal; i++) {
				
				//create item
				item = new ItemRef(citeLensController.getBibByIndex(i));
				item.y = posY;
				
				//push to array
				itemsArray.push(item);
				
				container.addChild(item);
				
				//update next Position
				posY += item.height;
			}
			
			
			
			//scroll
			if (container.height > origHeight) {
				//mask for container
				containerMask = new BlitMask(container, container.x, container.y, origWidth, origHeight, true);
				containerMask.disableBitmapMode();
				
				//add scroll system
				scroll = new Scroll();
				scroll.x = this.parent.width - 10;
				scroll.y = 0;
				addChild(scroll);
				
				scroll.target = container;
				scroll.maskContainer = containerMask;
				
			}
			//animation
			TweenLite.from(this, 2, {alpha:0, delay:2});
			
		}
		
		public function sort(parameter:String, asc:Boolean):void {
			if (parameter == "author") {
				parameter = "authorship"
			}
			
			itemsArray.sortOn(parameter);
			
			//loop
			var posY:Number = 0;
			var i:int = 0;
			for each (item in itemsArray) {
				//item.y = posY;
				TweenLite.to(item, 1, {y:posY});
				posY += item.height;
				i++
			}
			
		}
		
	}
}