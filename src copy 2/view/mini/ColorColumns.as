package view.mini {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import events.CiteLensEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import view.CiteLensView;
	import view.PanelHeader;
	import view.style.ColorSchema;
	
	
	public class ColorColumns extends CiteLensView  {
		
		//properties
		private var _id:int;
		private var plainTextLength:int;											//store text length in character number
		private var refsId:Array;													//Store the refereces
		private var positions:Array;												//store refrence positions
		
		private var chunkCollection:Array;											//store chunks
		private var chunk:Shape;													//iterate chunk
		
		private var _hMax:int = 550;												//max height
		private var _wMax:int = 28;													//max width
		private var _numColumns:int = 1;												//number of columns
		
		private var numLines:int = hMax/2;											//max number of lines = height / 2 (one line of chunk and one line of separation)
		
		private var lineWeight:Number = 1;												//line weigth
		private var columnGap:int = 5;												//gap between columns
		
		private var pixRate:Number;													//pixelrate - store the sample rate based in the text length and the max parameters
		
		private var generalColor:uint = 0xCCCCCC;
		private var highlightColor:uint = 0x999999;
		
		private var filterID:int = 0;
		
		private var viz:Sprite;
		private var header:PanelHeader;									//header
		
		private var animation:Boolean = false;
		
		private var _originalPosition:Object;
		private var _endPoint:Boolean = false;
		
		public function ColorColumns(fID:int = 0) {
			super(citeLensController);
			
			filterID = fID;
			
			if (filterID != 0) {
				highlightColor = ColorSchema.getColor("filter"+filterID);
				header = new PanelHeader(filterID,"filter");
			} else {
				header = new PanelHeader();
			}
			
			//header
			header.setDimensions(_wMax);
			header.init();
			addChild(header);
			
			//header.buttonMode = true;
			//header.addEventListener(MouseEvent.MOUSE_DOWN, _drag);
			
			hMax = hMax - header.height - 2;
		}
		
		private function _drag(e:MouseEvent):void {
			dispatchEvent(new CiteLensEvent(CiteLensEvent.DRAG));
			//this.startDrag(false, new Rectangle(this.x,this.y,this.y + 300,0));
		}
		
		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		public function get originalPosition():Object {
			return _originalPosition;
		}
		public function get numColumns():int {
			return _numColumns;
		}

		public function set numColumns(value:int):void {
			_numColumns = value;
		}

		public function get wMax():int {
			return _wMax;
		}

		public function set wMax(value:int):void {
			_wMax = value;
		}

		public function get hMax():int {
			return _hMax;
		}

		public function set hMax(value:int):void {
			_hMax = value;
		}
		
		public function get endPoint():Boolean {
			return _endPoint;
		}
		
		public function set endPoint(value:Boolean):void {
			_endPoint = value;
		}
		
		override public function initialize():void {
			
			//save orignal position
			_originalPosition = new Object();
			_originalPosition.x = this.x;
			_originalPosition.y = this.y;
		}
			
		public function updateViz(refsId:Array):void {
			
			//if width change
			if (wMax != header.width) {
				header.clear();
				header.setDimensions(_wMax);
				header.init();
			}
			
			//clear previous
			clear();
			
			//container
			viz = new Sprite();
			viz.y = header.height + 2;
			this.addChild(viz);
			
			var widthUtil:Number = wMax - ((numColumns-1) * columnGap);				//define the width util for the visualiation
			var columnWidth:Number = widthUtil / numColumns;						//define column width
				
				
			plainTextLength = citeLensController.getPlainTextLength();				//store text length in character number
			
			pixRate = Math.round(plainTextLength / (numLines * widthUtil));			//pixelrate - store the sample rate based on the text length and the max parameters
			
			positions = new Array();												//array to store references start and end position
			
			//loop in the references
			if (refsId.length > 0) {
				for (var i:int = 0; i < refsId.length; i++) {
					var refId:String = refsId[i];	
					//get Reference id
					positions.push(citeLensController.getRefLocationByID(refId));			//get reference start and end position
				}
			} else {
				//get thr first and the last char
				positions.push({start:0, end: 0 });
			}
			
			///////---------
			
			var pixColorArray:Array = new Array();									//Array of sample pixels in the visualization
			var color:uint = generalColor;											//iteration color bucker
			
			//loop on every character in the text
			var noCitation:Boolean = false;
			for (var char:int = 0; char <= plainTextLength; char++) {
				
				for (var iRef:int = 0; iRef < positions.length; iRef++) {							//loop in teh references start and end position
					
					//check and change color when a reference start or end
					if (char == positions[iRef].start) {
						color = highlightColor;
						
					} else if (char == positions[iRef].end) {
						color = generalColor;
						
					}
				}

				//create the sample pixels in the visualizaion
				if (char % pixRate == 0) {
					pixColorArray.push(color);
				}
			}
			
			//trace(pixRate)
			
			chunkCollection = new Array()
			var actualColumn:int = 0;												//column position
			var px:int = 0;															//carret - Drawer x postion - used to start a chunk								
			var py:int = 0;															//drawer y position - used to break lines when the chunk is to long
			var cx:int = 0;															//chunk x position - used to start a new chunk
			var cy:int = 0;															//chunk y position - used to start a new chunk
			var l:int = 0;															//chunk length counter
			var currentColor:uint = pixColorArray[0];								//chunk color - store the current color
			
			//loop columns

			for each(var cor:uint in pixColorArray) {
				
				if (cor == currentColor) { 											//adding pixels for a chunk
					l++;
					
				} else {															//draw chunk
					
					chunk = new Shape();
					chunk.x = cx;
					chunk.y = cy;
					chunk.graphics.lineStyle(lineWeight,currentColor,1,true);
					chunk.graphics.beginFill(generalColor);
					chunk.graphics.moveTo(px,0);
					
					
					var lineRelLength:int = px + l;									//relative size of the chunk to be draw. Sum of the current possiton and length.
					var numLinesNeed:int = Math.ceil(lineRelLength/columnWidth);	//number of lines necessary to draw the current chunk
					var lineDrawing:int;											//chunk to draw use in the iteration
					var pxOffset:Number = 0;
					
					for (i = 0; i < numLinesNeed; i++) {
						
						if (i==1) {  												//first line
							var spaceInCurrentLine:int = columnWidth - px;			//space available in current line to begin to draw the chunk
							lineDrawing = spaceInCurrentLine;						//use available space in current line to begin to draw the chunk
						}
						
						if (lineRelLength > columnWidth) {							//if chunk to be draw is greater than the max width
							lineDrawing = columnWidth;								//Take the max width size
						} else {									
							lineDrawing = lineRelLength;							//else, take the rest
						}
						
						//draw the line
						chunk.graphics.moveTo(px + pxOffset,py)
						chunk.graphics.lineTo(lineDrawing + pxOffset,py);
						
						lineRelLength -= lineDrawing;								//update chunk to be draw
						
						//update variables id the loops continues
						if (numLinesNeed > 1 && i != numLinesNeed-1) {
							cy += lineWeight * 2;
							px = 0;
							py += lineWeight * 2;
						}
						
						//update px in the last iteration
						if (i == numLinesNeed-1) {
							px = lineDrawing;
						}
						
						if (cy >= _hMax) {
							actualColumn++;
							cx = (columnWidth + columnGap) * (actualColumn);
							cy = 0;
							pxOffset = columnWidth + columnGap;
							px = 0;
							py = -chunk.y;
						}
						
					}
					
					//end chunk draw
					chunk.graphics.endFill();
					
					//add chunk to the screen and the array
					viz.addChild(chunk);	
					chunkCollection.push(chunk);
					
					//update variables
					currentColor = cor;
					l = 0;
					py = 0;
					
				}
				
				//trace(chunkCollection.length)
			}
			
			
			if (animation == true) {
				//animation
				for (i = 0; i < chunkCollection.length; i++) {
					
					if (i % 2 == 0) {
						TweenMax.from(chunkCollection[i], 2,{colorMatrixFilter:{brightness:-3}, ease:Back.easeOut, delay:i *  0.01});
						//TweenMax.to(chunkCollection[i], 2, {glowFilter:{color:highlightColor, alpha:.4, blurX:4, blurY:4},repeat:1,yoyo:true, delay:i *  0.1});
						
						
					} else {
						//TweenMax.from(chunkCollection[i],2,{alpha:0, delay:i *  0.1});
						TweenMax.from(chunkCollection[i], 2,{colorMatrixFilter:{brightness:-3}, ease:Back.easeOut, delay:i *  0.01});
						//TweenMax.from(chunkCollection[i], 2,{tint:0xCCCCCC, ease:Back.easeOut, delay:i *  0.1});
						
					}
					
					//TweenMax.from(chunkCollection[i],2,{width:0, delay:i *  0.2, ease:SlowMo.ease.config(0.7, 0.7)});
					//TweenMax.from(chunkCollection[i],2,{width:0, delay:i *  0.2, ease:Back.easeOut});
				}
			}
			
			
			//turn on animation
			animation = true;
			
		}
	
		public function clear():void {
			
			if (viz) {
				this.removeChild(viz);
				viz = null;
				chunkCollection = null;
			}
			
			/*
			for each (var c:Shape in chunkCollection) {
				this.removeChild(c);
			}
			
			chunkCollection = null;
			*/
		}
	
	}
}