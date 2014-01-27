package view.intro {
	
	// imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class ListDocuments extends Sprite {
		
		
		//****************** Properties ****************** ****************** ******************
		
		protected var docCollection				:Array;
		protected var listContainer				:Sprite;
		protected var background				:Sprite;
		protected var docItem					:DocItem;
		
		protected var numColumns				:int;
		protected var gap						:Number;
		
		protected var _selctedDoc				:String;
		
		//****************** Constructor ****************** ****************** ******************
	
		/**
		 * 
		 * 
		 */
		public function ListDocuments() {
			
			numColumns = 2;
			gap = 10;
			
			var urlRequest:URLRequest = new URLRequest("content/docColletion.xml");
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			
			urlLoader.addEventListener(Event.COMPLETE, init);
			
			
			docCollection = new Array();
			
		}
		
		//****************** INITIALIZE ****************** ****************** ******************

		/**
		 * 
		 * 
		 */
		public function init(event:Event):void {
			
			//data
			var data:XML = new XML(event.target.data);
			
			//bg
			background = new Sprite();
			background.graphics.beginFill(0xEEEEEE);
			background.graphics.drawRect(0,0,this.stage.stageWidth, 100);
			background.graphics.endFill();
			
			this.addChild(background);
			
			//list container
			listContainer = new Sprite();
			this.addChild(listContainer);
			
			//loop list
			var i:int = 0;
			var px:Number = 0;
			var py:Number = gap;
			
			
			for each (var item:XML in data.descendants("document")) {
				docItem = new DocItem(item);
				
				docItem.x = (docItem.width + gap) * (i%numColumns);
				docItem.y = py;
				
				docCollection.push(docItem);
				listContainer.addChild(docItem);
				
				if (i%numColumns == numColumns-1) py += docItem.height + gap;
				
				i++;
				
				docItem.addEventListener(MouseEvent.CLICK, docClick);
				
			}
			
			listContainer.x = (this.stage.stageWidth/2) - (listContainer.width/2);
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function hideItems():void {
			TweenMax.to(docCollection,.5,{x:this.stage.stageWidth});
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function docClick(event:MouseEvent):void {
			_selctedDoc = event.target.file;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		//****************** GETTERS AND SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selctedDoc():String {
			return _selctedDoc;
		}
	}
}