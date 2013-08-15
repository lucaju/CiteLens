package view.mini {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.CiteLensEvent;
	
	import view.CiteLensView;
	import view.PanelHeader;
	import view.style.ColorSchema;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ColorColumns extends CiteLensView  {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int;
		protected var plainTextLength		:int;							//store text length in character number
		protected var refsId				:Array;							//Store the refereces
		protected var positions				:Array;							//store refrence positions
		
		protected var chunkCollection		:Array;							//store chunks
		protected var chunk					:Shape;							//iterate chunk
		
		protected var _hMax					:int	 = 560;					//max height
		protected var _wMax					:int	 = 34;					//max width
		protected var _numColumns			:int	 = 1;					//number of columns
		
		protected var numLines				:int	 = hMax/2;				//max number of lines = height / 2 (one line of chunk and one line of separation)
		
		protected var lineWeight			:Number	 = 1;					//line weigth
		protected var columnGap				:int	 = 5;					//gap between columns
		
		protected var pixRate				:Number;						//pixelrate - store the sample rate based in the text length and the max parameters
		
		protected var generalColor			:uint	 = 0xCCCCCC;
		protected var highlightColor		:uint	 = 0x999999;
		
		protected var filterID				:int	 = 0;
		
		private var viz						:Sprite;
		private var header					:PanelHeader;					//header
		
		protected var animation				:Boolean = false;
		
		protected var _originalPosition		:Object;
		protected var _endPoint				:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param fID
		 * 
		 */
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

			_hMax = _hMax - (header.height + 2);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function initialize():void {
			
			//save orignal position
			_originalPosition = new Object();
			_originalPosition.x = this.x;
			_originalPosition.y = this.y;
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _drag(e:MouseEvent):void {
			dispatchEvent(new CiteLensEvent(CiteLensEvent.DRAG));
			//this.startDrag(false, new Rectangle(this.x,this.y,this.y + 300,0));
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
			
		/**
		 * 
		 * @param notes
		 * 
		 */
		public function updateViz(notes:Array):void {
			
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
			var refPosition:Object;
			
			//loop in the notes
			if (notes.length > 0) {
				for (var i:int = 0; i < notes.length; i++) {
					
					//get ref id
					//If came directily from the docBody (full list of citations) it is a string - ref.id)
					//if came from Filter process (Filter list of citations) it is a Object with note.id (related to ref.id in docBodyModel)
					var refId:String;
					
					if (notes[i] is String) {
						refId = notes[i];	
					} else if (notes[i] is Object) {
						refId = notes[i].id;
					}
						
					//trace (notes[i])
					
					//get Reference id
					refPosition = citeLensController.getRefLocationByID(refId)
					positions.push(refPosition);									//get reference start and end position
					
					
					//add one extra in the end - the final chunk
					/*
					if (i == notes.length-1 && refPosition.end < plainTextLength) {
						var endText:Object = new Object();
						endText.start = refPosition.end + 1;
						endText.end = plainTextLength;
						
						positions.push(endText);
						
						endText = null;
					}
					*/
				}
			} else {
				//get thr first and the last char
				positions.push({start:0, end: plainTextLength });
			}
			/*
			trace ("Start >>>" + positions[0].start)
			trace ("End >>>" + positions[positions.length-1].end)
			trace ("total >>>" + plainTextLength)
			trace ("-------")
			
			*/
			///////---------
			
			var pixColorArray:Array = new Array();									//Array of sample pixels in the visualization
			var color:uint = generalColor;											//iteration color bucker
			
			//loop on every character in the text
			var noCitation:Boolean = false;
			for (var char:int = 0; char <= plainTextLength; char++) {
				
				for (var iRef:int = 0; iRef < positions.length; iRef++) {							//loop in the references start and end position
					
					//check and change color when a reference start or end
					if (char == positions[iRef].start) {
						color = highlightColor;
						
						//trace ("start highlight: " + char)
						
					} else if (char == positions[iRef].end) {
						color = generalColor;
						//trace ("end highlight: " + char)
						//trace ("----------")
					}
				}
				
				
				
				

				//create the sample pixels in the visualizaion
				if (char % pixRate == 0) {
					pixColorArray.push(color);
				}
			}
			
			//trace ("total >>>" + plainTextLength)
			//trace ("-!!!!!!!!!!----")
			
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
			// this loop has one extra "lap" in order to close the circuit
			for (var pc:int; pc <= pixColorArray.length; pc++) {
				
				var cor:uint = pixColorArray[pc];
				
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
						
						
						//trace (_hMax)
						
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
				
				//trace (currentColor.toString(16))
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
	
		/**
		 * 
		 * 
		 */
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
		public function get originalPosition():Object {
			return _originalPosition;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get numColumns():int {
			return _numColumns;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set numColumns(value:int):void {
			_numColumns = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get wMax():int {
			return _wMax;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set wMax(value:int):void {
			_wMax = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hMax():int {
			return _hMax;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hMax(value:int):void {
			_hMax = value - (header.height + 2);
			numLines = _hMax/2
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get endPoint():Boolean {
			return _endPoint;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set endPoint(value:Boolean):void {
			_endPoint = value;
		}
	
	}
}