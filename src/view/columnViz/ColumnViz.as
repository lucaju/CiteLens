package view.columnViz {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	
	import controller.CiteLensController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.WindowHeader;
	import view.columnViz.scroll.Roll;
	import view.style.ColorSchema;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ColumnViz extends AbstractView  {
		
		//****************** Properties ****************** ****************** ******************
		
		static protected var pixelArray		:Array
		static protected var columnWidth	:Number;
		static protected var pixRate		:Number;						//pixelrate - store the sample rate based in the text length and the max parameters
		
		protected var _id					:int;
		
		protected var _hMax					:int	 = 560;					//max height
		protected var _wMax					:int	 = 34;					//max width
		
		protected var _numColumns			:int	 = 1;					//number of columns
		protected var numLines				:int	 = hMax/2;				//max number of lines = height / 2 (one line of chunk and one line of separation)
		
		protected var lineWeight			:Number	 = 1;					//line weigth
		protected var columnGap				:int	 = 5;					//gap between columns
		
		protected var chunkCollection		:Array;							//store chunks
		
		protected var viz					:Sprite;
		protected var header				:WindowHeader;					//header
		
		
		protected var textColor				:uint	 = ColorSchema.LIGHT_GREY;
		protected var highlightedColor		:uint	 = ColorSchema.MEDIUM_GREY;
		protected var selectedColor			:uint	 = ColorSchema.RED;
		
		protected var animation				:Boolean = true;
		
		protected var _roll					:Roll;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * @param fID
		 * 
		 */
		public function ColumnViz(c:IController, fID:int = 0) {
			super(c);
			
			_id = fID;
			
			if (id != 0) {
				highlightedColor = ColorSchema.getColor("filter"+id);
				header = new WindowHeader(id,"filter");
			} else {
				header = new WindowHeader();
			}
			
			//header
			header.setDimensions(_wMax);
			header.init();
			addChild(header);
			
			header.buttonMode = true;

			_hMax = _hMax - (header.height + 2);
			
			_roll = new Roll();
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function initialize():void {
			
			//container
			viz = new Sprite();
			viz.y = header.height + 2;
			this.addChild(viz);
			
			if (!pixelArray) {
			
				//generate data
				var notesData:Array = CiteLensController(this.getController()).getNoteSpanData();
				var plainTextLength:int = CiteLensController(this.getController()).getPlainTextLength();				//store text length in character number
				
				//calculating size and proportions
				var widthUtil:Number = wMax - ((numColumns-1) * columnGap);				//define the width util for the visualiation
				columnWidth = widthUtil / numColumns;						//define column width
				pixRate = Math.round(plainTextLength / (numLines * widthUtil));			//pixelrate - store the sample rate based on the text length and the max parameters
				
				//Supporting vars
				pixelArray = new Array();
				var pixel:SamplePixel;
				var type:String = SamplePixelType.TEXT;
				var charNoteID:int = 0;
				
				//loop char text
				for (var char:int = 0; char <= plainTextLength; char++) {
					
					// loop notes
					for each (var note:Object in notesData) {
						
						//check and change char type when a reference start or end
						if (char == note.start) {
							type = SamplePixelType.CITATION;
							charNoteID = note.id;
							break;
							
						} else if (char == note.end) {
							type = SamplePixelType.TEXT;
							charNoteID = 0;
							break;
						}
	
					}
					
					//create sample pixel
					if (char % pixRate == 0) {
						pixel = new SamplePixel(pixelArray.length,type,charNoteID);
						pixelArray.push(pixel);
					}
					
				}
			}
			
			//draw
			this.draw();
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param pixelArray
		 * 
		 */
		protected function draw():void {
			
			//Supporting vars
			chunkCollection = new Array()
			var chunk:Chunk;
			var actualColumn:int = 0;												//column position
			var px:int = 0;															//carret - Drawer x postion - used to start a chunk								
			var py:int = 0;															//drawer y position - used to break lines when the chunk is to long
			var cx:int = 0;															//chunk x position - used to start a new chunk
			var cy:int = 0;															//chunk y position - used to start a new chunk
			var l:int = 0;															//chunk length counter
			var currentType:String = SamplePixelType.TEXT;							//Pixel Type - store current pixel type
			
			// Loop Sample Pixel
			for each (var pixel:SamplePixel in pixelArray) {
				
				//if chunk exists and pixel is the same type, add pixel in the chunk
				if (pixel.type == currentType && chunk) {
					l++;
					chunk.numPixels = chunk.numPixels++;
				
				// else, create new chunk
				} else {
					
					//Creating new chunk
					chunk = new Chunk(pixel.noteID);
					chunk.type = pixel.type;
					chunk.numPixels = 1;
					
					if (chunk.type == SamplePixelType.CITATION) chunk.highlighted = true;
					
					//grapjical settings
					chunk.x = cx;
					chunk.y = cy;
					chunk.graphics.lineStyle(lineWeight,getColor(pixel.type),1,true);
					chunk.graphics.beginFill(textColor);
					chunk.graphics.moveTo(px,0);
					
					//Supporting vars
					var lineRelLength:int = px + l;									//relative size of the chunk to be draw. Sum of the current possiton and length.
					var numLinesNeed:int = Math.ceil(lineRelLength/columnWidth);	//number of lines necessary to draw the current chunk
					var lineDrawing:int;											//chunk to draw use in the iteration
					var pxOffset:Number = 0;
					
					// Loop sample pixel in a chunk
					for (var i:int = 0; i < numLinesNeed; i++) {
						
						if (i==1) {  												//first line
							var spaceInCurrentLine:int = columnWidth - px;			//space available in current line to begin to draw the chunk
							lineDrawing = spaceInCurrentLine;						//use available space in current line to begin to draw the chunk
						}
						
						if (lineRelLength > columnWidth) {							//if chunk to be draw is greater than the max width
							lineDrawing = columnWidth;								//Take the max width size
						} else {									
							lineDrawing = lineRelLength;							//else, take the rest
						}
						
						//draw line
						chunk.graphics.moveTo(px + pxOffset,py)
						chunk.graphics.lineTo(lineDrawing + pxOffset,py);
						
						lineRelLength -= lineDrawing;								//update chunk to be draw
						
						//update variables if the loop continues
						if (numLinesNeed > 1 && i != numLinesNeed-1) {
							cy += lineWeight * 2;
							px = 0;
							py += lineWeight * 2;
						}
						
						//update px in the last iteration
						if (i == numLinesNeed-1) px = lineDrawing;
						
						//create a new column if chunk exeed the max size for this viz. 
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
					currentType = pixel.type;
					l = 0;
					py = 0;
					
				}
				
			}
			
			//animation
			if (animation == true) this.initialAnimation();
			
			//scroll.
			this.addScroll();
		}
		
		/**
		 * 
		 * 
		 */
		protected function initialAnimation():void {
			var delay:int = 0;
			for each (var chunk:Chunk in chunkCollection) {
				TweenMax.from(chunk,2,{width:0, delay:delay *  0.05, ease:Back.easeOut});
				delay++;
			}
		}
		
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */
		protected function getColor(type:String):uint {
			
			var color:uint;
			
			switch (type) {
				case SamplePixelType.TEXT:
					color = textColor;
					break;
				
				case SamplePixelType.CITATION:
					color =  highlightedColor;
					break;
				
				default:
					color = textColor;
					break;
			}
			
			return color;
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function addScroll():void {
			//Scroll
			//if (id > 0) roll.color = ColorSchema.getColor("filter"+id)
			roll.offset = header.height + 2;
			roll.hMax = viz.height;
			roll.init(wMax);
			this.addChild(roll);	
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param chunkID
		 * 
		 */
		public function selectChunks(chunkID:*):void {
			
			this.clearSelectedChunks();
			
			var chunk:Chunk;
			
			if (chunkID is int) {
				chunk = this.getChunckByID(chunkID);
				if (chunk) {
					if (!chunk.selected) {
						chunk.selected = true;
						TweenMax.to(chunk, 1, {tint:this.selectedColor});
					}
				}
			
			} else if (chunkID is Array) {
				for each (var id:int in chunkID) {
					chunk = this.getChunckByID(id);
					if (chunk) {
						if (!chunk.selected) {
							TweenMax.to(chunk, 1, {tint:this.selectedColor});
							chunk.selected = true;
						}
					}
				}
			}
			
		}
		
		/**
		 * 
		 * @param highlightChunks
		 * 
		 */
		public function highlightChunks(highlightChunks:Array):void {
			
			for each (var chunk:Chunk in chunkCollection) {
				
				if (chunk.highlighted) {
					chunk.highlighted = false;
					TweenMax.to(chunk, 1, {colorTransform:{tint:this.textColor, tintAmount:1}});
				}
				
				for each (var highlightChunkID:Object in highlightChunks) {
					if (chunk.id == highlightChunkID.id) {
						chunk.highlighted = true;
						TweenMax.to(chunk, 1, {colorTransform:{tint:this.highlightedColor, tintAmount:1}});
						break;
					}
					
				}
				
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		public function clearSelectedChunks():void {
			for each (var chunk:Chunk in chunkCollection) {
				if (chunk.selected) {
					chunk.selected = false;
					TweenMax.to(chunk, 1, {removeTint:true});
				}
			}
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getChunckByID(id:int):Chunk {
			for each (var chunk:Chunk in chunkCollection) {
				if (chunk.id == id) return chunk;
			}
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedChunks():Array {
			var array:Array = new Array();
			for each (var chunk:Chunk in chunkCollection) {
				if (chunk.selected) array.push(chunk);
			}
			return array;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedChunks():Array {
			var array:Array = new Array();
			for each (var chunk:Chunk in chunkCollection) {
				if (chunk.highlighted) array.push(chunk);
			}
			return array;
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function updateRoll(data:Object):void {
			roll.update(data);
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

		public function get roll():Roll {
			return _roll;
		}


	
	}
}