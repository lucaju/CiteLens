package view.mini {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	
	import view.CiteLensView;
	
	public class ColorColumn extends CiteLensView {
		
		//properties
		private var plainTextLength:int;											//store text length in character number
		private var refsId:Array;													//Store the refereces
		private var positions:Array;												//store refrence positions
		
		private var chunkCollection:Array;											//store chunks
		private var chunk:Shape;													//iterate chunk
		
		private var hMax:int = 550;													//max height
		private var wMax:int = 28;													//max width
		private var numLines:int = hMax/2;											//max number of lines = height / 2 (one line of chunk and one line of separation)
		private var pixRate:Number;													//pixelrate - store the sample rate based in the text length and the max parameters
		private var lineWeight:int = 1;												//line weigth
		
		public function ColorColumn() {
			
			super(citeLensController);
			
		}
		
		override public function initialize():void {
			plainTextLength = citeLensController.getPlainTextLength();				//store text length in character number
			pixRate = Math.round(plainTextLength / (numLines * wMax));				//pixelrate - store the sample rate based in the text length and the max parameters
			
			positions = new Array();												//array to store references start and end position
			refsId = citeLensController.getRefsId();								//Store the refereces
			
																					//loop in the references
			for (var i:int = 0; i < refsId.length; i++) {
				var id:String = refsId[i];											//get Reference id
				positions.push(citeLensController.getRefLocationByID(id));			//get reference start and end position
			}
			
			
			var pixColorArray:Array = new Array();									//Array of sample pixels in the visualization
			var color:uint = 0x000000;												//iteration color bucker
			
																					//loop on every character in the text
			for (var char:int = 0; char < plainTextLength; char++) {
			
				for each(var refPos:Object in positions) {							//loop in teh references start and end position
					
																					//check and change color when a reference start or end
					if (char == refPos.start) {
						color = 0xFF00FF;
					} else if (char == refPos.end) {
						color = 0x000000;
					}
				}
				
																					//create the sample pixels n the visualizaion
				if (char % pixRate == 0) {
					pixColorArray.push(color);
					
				}
			}
			
			chunkCollection = new Array()
			var px:int = 0;															//carret - Drawer x postion - used to start a chunk								
			var py:int = 0;															//drawer y position - used to break lines when the chunk is to long
			var cy:int = 0;															//chunk y position - used to start a new chunk
			var l:int = 0;															//chunk length counter
			var currentColor:uint = pixColorArray[0];								//chunk color - store the current color
				
			for each(var cor:uint in pixColorArray) {
				
				if (cor == currentColor) { 											//adding pixels for a chunk
					l++;
					
				} else {															//draw chunk
					
					chunk = new Shape();
					chunk.y = cy;
					chunk.graphics.lineStyle(lineWeight,currentColor);
					chunk.graphics.beginFill(0x000000);
					chunk.graphics.moveTo(px,0);
					
					
					var lineRelLength:int = px + l;									//relative size of the chunk to be draw. Sum of the current possiton and length.
					var numLinesNeed:int = Math.ceil(lineRelLength/wMax);			//number of lines necessary to draw the current chunk
					var lineDrawing:int;											//chunk to draw use in the iteration
					
					for (i = 0; i < numLinesNeed; i++) {
						if (i==1) {  												//first line
							var spaceInCurrentLine:int = wMax - px;					//space availablein current line to begin to draw the chunk
							lineDrawing = spaceInCurrentLine;						//use available space in current line to begin to draw the chunk
						}
						
						if (lineRelLength > wMax) {									//if chunk to be draw is greater than the max width
							lineDrawing = wMax;										//Take the max width size
						} else {									
							lineDrawing = lineRelLength;							//else, take the rest
						}
						
						//draw the line
						chunk.graphics.moveTo(px,py)
						chunk.graphics.lineTo(lineDrawing,py);
						
						lineRelLength -= lineDrawing;								//update chunk to be draw
						
																					//update variables id the loops continues
						if (numLinesNeed > 1 && i != numLinesNeed-1) {
							py += lineWeight * 2;
							cy += lineWeight * 2;
							px = 0;
						}
						
																					//update px in the last iteration
						if (i == numLinesNeed-1) {
							px = lineDrawing;
						}
					}
					
					//end chunk draw
					chunk.graphics.endFill();
					
					//add chunk to the screen and the array
					this.addChild(chunk);	
					chunkCollection.push(chunk);
						
					//update variables
					currentColor = cor;
					l = 0;
					py = 0;
					
				}
				
			}
			
			//animation
			for (i = 0; i < chunkCollection.length; i++) {
				
				if (i % 2 == 0) {
					TweenMax.from(chunkCollection[i],2,{width:0, ease:Back.easeOut, delay:i *  0.1});
				} else {
					TweenMax.from(chunkCollection[i],2,{x:20, width:0, ease:Back.easeOut, delay:i *  0.1});
				}
				
				//TweenMax.from(chunkCollection[i],2,{width:0, delay:i *  0.2, ease:SlowMo.ease.config(0.7, 0.7)});
				//TweenMax.from(chunkCollection[i],2,{width:0, delay:i *  0.2, ease:Back.easeOut});
			}
			
			//trace (this.height)
		}
	}
}