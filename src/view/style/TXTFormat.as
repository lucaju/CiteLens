package view.style {
	
	//imports
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import font.HelveticaNeue;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TXTFormat {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TXTFormat() {
			
		}
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param styleName
		 * @param statusColor
		 * @return 
		 * 
		 */
		static public function getStyle(styleName:String = "standard", statusColor:String = "standard"):TextFormat {
			
			var style:TextFormat = new TextFormat();
			style.font = HelveticaNeue.REGULAR;
			style.color = ColorSchema.getColor(statusColor);
			style.leading = 2;
			
			switch (styleName) {
				
				case "Main Button Style":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 12;
					break;
				
				case "Title Header":
					
					style.font = HelveticaNeue.MEDIUM;
					style.leading = 2;
					style.size = 12;
					break;
				
				case "Author Header":
					
					//style.font = HelveticaNeue.MEDIUM;
					style.size = 12;
					//style.align = "right";
					//style.color = ColorSchema.getColor("gray");
					break;
				
				case "General Label":
					style.font = HelveticaNeue.MEDIUM;
					style.size = 11;
					break;
				
				case "Button Style":
					style.font = HelveticaNeue.BOLD;
					style.size = 11;
					break;
				
				//bibliography
				
				case "Item List Title":
					
					style.font = HelveticaNeue.ITALIC;
					style.size = 11;
					break;
				
				case "Item List Author":
					
					style.size = 11;
					break;
				
				case "Item List Date":
					
					style.size = 11;
					break;
				
				case "Item List Note Count":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 11;
					style.align = TextFormatAlign.CENTER;
					break;
				
				case "Item List Note Info":
					
					style.font = HelveticaNeue.REGULAR;
					style.size = 11;
					style.leading = 4;
					style.color = ColorSchema.white;
					break;
				
				case "AutoComplete Text":
					
					style.size = 11;
					break;
				
				case "AutoComplete Bold":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 11;
					break;
				
				case "Count Total":
					
					style.font = HelveticaNeue.BOLD;
					style.size = 9;
					break;
				
				
				//filter
				
				case "filter header":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 11;
					style.color = 0xFFFFFF;
					style.align = TextFormatAlign.CENTER;
					break;
				
				case "filter header result":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 12;
					style.color = 0xFFFFFF;
					break;
				
				case "Period Label":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 11;
					//style.align = "right";
					break;
				
				case "Input Period":
					
					style.size = 11;
					style.align = TextFormatAlign.CENTER;
					style.letterSpacing = .7;
					break;
				
				case "Input Author Name":
					style.size = 11;
					break;
				
				case "Empty Style":
					
					style.font = HelveticaNeue.MEDIUM;
					style.size = 16;
					style.color = 0xCCCCCC;
					break;
				
				
				default:
					
					style.size = 12;
					break;
				
			}
		
			return style;
		}
		 
	}
}