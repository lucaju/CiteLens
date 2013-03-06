package view.bibliography {
	
	//imports
	import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	
	import events.CiteLensEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.RefBibliographic;
	
	import view.assets.ShadowLine;
	import view.assets.scroll.Scroll;
	
	public class List extends BibliographyView {
		
		//properties
		private var origWidth:Number;
		private var origHeight:Number;
		
		private var _filtered:Boolean = false;
		
		private var item:ItemRef;
		private var selectedItem:ItemRef;
		
		private var itemsArray:Array;
		private var actualItemsArray:Array;
		private var filteredItemsArray:Array;
		private var partialItemsArray:Array;
		
		
		private var container:Sprite;
		private var containerMask:BlitMask;
		
		private var scroll:Scroll;
		
		public function List() {
			
			super();
			
		}
		
		public function get filtered():Boolean {
			return _filtered;
		}
		
		public function set filtered(value:Boolean):void {
			_filtered = value;
		}
		
		override public function initialize():void {
			
			//events
			this.addEventListener(CiteLensEvent.SORT, sort);
			
			//global size
			//origWidth = Global.globalWidth/5;
			//origHeight = Global.globalHeight - 50;
			origWidth = this.parent.width - super.margin;
			origHeight = this.parent.height - 64;			
			
			
			//list container
			container = new Sprite();
			this.addChild(container);
			
			//shadow line
			var lineStart:ShadowLine = new ShadowLine(origWidth);
			addChild(lineStart);
			
			//shadow line
			/*
			var lineEnd:ShadowLine = new ShadowLine(origWidth);
			lineEnd.rotation = 180;
			lineEnd.x = lineEnd.width;
			lineEnd.y = origHeight;
			addChild(lineEnd);
			*/
			
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
				item = new ItemRef(citeLensController.getBibByIndex(i), i);
				item.y = posY;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				
				//push to array
				itemsArray.push(item);
				
				container.addChild(item);
				
				//update next Position
				posY += item.height;
			}
			
			
			//fullItemsArray = itemsArray;
			actualItemsArray = itemsArray;
			
			
			//scroll
			applyScrollMask();
			
			//animation
			TweenMax.from(this, 2, {alpha:0, delay:2});
			
		}
		
		private function applyScrollMask():void {
			
			if (container.height > origHeight) {
				
				if (!scroll) {

					//mask for container
					containerMask = new BlitMask(container, container.x, container.y, origWidth, origHeight, true);
					containerMask.disableBitmapMode();
					
					//add scroll system
					scroll = new Scroll();
					addChild(scroll);
					scroll.x = this.parent.width - 10;
					scroll.y = 0;
					
					scroll.maskContainer = containerMask;
				}
				
				//update container
				scroll.target = container;
				
				
			} else {
				if (scroll) {
					containerMask.dispose()
					containerMask = null;
					
					scroll.removeHandlers();
					this.removeChild(scroll);
					scroll = null;
				}
			}
		}
		
		public function filter(filterResult:Array, type:String):void {
			
			switch (type) {
				
				case "search":
					narrowBySearch(filterResult);
					break;
				
				case "filter":
					narrowByFilter(filterResult)
					break;
				
			}
			
		}
		
		private function narrowByFilter(filterResult:Array):void {
			
			if (filterResult.length > 0) {
				filteredItemsArray = new Array();
				
				for each (var item:ItemRef in itemsArray) {
					for each (var ref:RefBibliographic in filterResult) {
						if (item.uniqueID == ref.uniqueID) {
							filteredItemsArray.push(item);
						}
					}
				}
				
				///replace list
				actualItemsArray = filteredItemsArray
				filtered = true;
				
			} else {
				actualItemsArray = itemsArray;
				filteredItemsArray = null;
				filtered = false;
			}
			
			updateAnimation();
			
		}
		
		private function narrowBySearch(filterResult:Array):void {
			if (filterResult[0] == "~all") {
				
				var posY:Number = 0;
				var i:int = 0;
				
				if (filtered) {
					actualItemsArray = filteredItemsArray;
				} else {
					actualItemsArray = itemsArray;
				}
				
				filteredItemsArray = null;
				
			} else {
			
				//trace (filterResult.length)
				
				partialItemsArray = new Array();
				var hit:Boolean = false;
				
				for each (var item:ItemRef in actualItemsArray) {
					
					hit = false;
					
					for each (var filter:Object in filterResult) {
						
						switch (filter.type) {
							
							case "title":
								
								var titles:Array = item.titles;
								
								for each (var titl:Object in titles) {
								
									var titleName:String = titl.name;
									
									if (titleName.toLowerCase() == filter.label.toLowerCase()) {
										partialItemsArray.push(item);
										hit = true;
										//trace ("**Tit")
										break;
									}
									
									
									//trace ("----Title")
								}
								
								
								break;
							
							case "author":
								
								var authors:Array = item.authors;
								
								for each (var author:Object in authors) {
								
									var fullName:String = author.firstName + " " + author.lastName;
								
									if (fullName.toLowerCase() == filter.label.toLowerCase()) {
										partialItemsArray.push(item);
										hit = true;
										//trace ("**Auth")
										break;
									}
									//trace ("----Author")
								}
								
								
								break;
							
							if (hit) {
								break;
							}
							
						}
						
						if (hit) {
							break;
						}
						//trace ("##########")
					}
					//trace ("@@@@@@@@@@@")
				}
				
				//trace (partialItemsArray.length)
				
				///replace list	
				actualItemsArray = partialItemsArray;
			}
			
			//animation
			updateAnimation()
			
			
		}
		
		private function updateAnimation():void {
				
			//hide non listed items
			var nonListedArray:Array = itemsArray.filter(nonListedFilter);

			for each (item in nonListedArray) {
				TweenMax.to(item,1,{autoAlpha:0, y:0});
			}
			
			//animation in actual items
			var posY:int = 0;
			var i:int = 0;
			for each (var filteredItem:ItemRef in actualItemsArray) {
				
				if (i == actualItemsArray.length-1) {
					TweenMax.to(filteredItem,2,{y:posY, autoAlpha:1, onUpdate:applyScrollMask});
				} else {
					TweenMax.to(filteredItem,2,{y:posY, autoAlpha:1});
				}

				posY += filteredItem.height;
				i++;
			}
			
			//move the list to the top
			container.y = 0;
		}
		
		private function nonListedFilter(element:*, index:int, arr:Array):Boolean {
			
			var itemToHide:Boolean = false;
			
			for each (var item:ItemRef in actualItemsArray) {
				if (element == item) {
					itemToHide = false;
					break;
				} else {
					itemToHide = true;
				}
			}
			
			return itemToHide;
		}
		
		private function _itemClick(e:MouseEvent):void {
			
			var itemCLicked:ItemRef = ItemRef(e.currentTarget);
			
			if (selectedItem == itemCLicked) {
				itemCLicked.deselect();
				selectedItem = null;
				
			} else if (selectedItem) {
				selectedItem.deselect();
				itemCLicked.select();
				selectedItem = itemCLicked;
			} else {
				itemCLicked.select();
				selectedItem = itemCLicked;
			}
			
			
		}
		
		
		public function sort(parameter:String, asc:Boolean):void {
			
			if (parameter == "author") {
				parameter = "authorship"
			}
			
			if (parameter == "") {
				actualItemsArray.sortOn("id");
			} else {
				actualItemsArray.sortOn(parameter);
			}
			
			//loop
			var posY:Number = 0;
			var i:int = 0;
			for each (item in actualItemsArray) {
				//item.y = posY;
				TweenMax.to(item, 1, {y:posY});
				posY += item.height;
				i++;
			}
			
			//move the list to the top
			TweenMax.to(container,0,{y:0});
		}
		
		public function getTotalCount():int {
			return itemsArray.length;
		}
		
		public function getActualCount():int {
			if (actualItemsArray) {
				return actualItemsArray.length;
			} else {
				return 0;
			}
		}

	}
}