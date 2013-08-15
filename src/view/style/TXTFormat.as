package view.style {
	
	//imports
	import flash.text.TextFormat;

	
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
			style.font = "Helvetica Neue";
			style.color = ColorSchema.getColor(statusColor);
			style.leading = 2;
			
			switch (styleName) {
				
				case "Main Button Style":
					
					style.bold = true;
					style.size = 12;
					break;
				
				case "Title Header":
					
					style.bold = true;
					style.leading = 2;
					style.size = 12;
					break;
				
				case "Author Header":
					
					style.size = 12;
					//style.bold = true;
					//style.align = "right";
					//style.color = ColorSchema.getColor("gray");
					break;
				
				case "General Label":
					
					style.size = 11;
					style.bold = true;
					break;
				
				case "Button Style":
					
					style.bold = true;
					style.size = 11;
					break;
				
				//bibliography
				
				case "Item List Title":
					
					style.italic = true;
					style.size = 11;
					break;
				
				case "Item List Author":
					
					style.size = 11;
					break;
				
				case "Item List Date":
					
					style.size = 11;
					style.bold = false;
					break;
				
				case "Item List Note Count":
					
					style.bold = true;
					style.size = 11;
					style.align = "center";
					style.bold = true;
					break;
				
				case "AutoComplete Text":
					
					style.size = 11;
					break;
				
				case "AutoComplete Bold":
					
					style.size = 11;
					style.bold = true;
					break;
				
				case "Count Total":
					
					style.size = 9;
					style.bold = true;
					break;
				
				
				//filter
				
				case "filter header":
					
					style.bold = true;
					style.size = 12;
					style.color = 0xFFFFFF;
					style.align = "center";
					break;
				
				case "filter header result":
					
					style.size = 12;
					style.color = 0xFFFFFF;
					break;
				
				case "Period Label":
					
					style.size = 11;
					style.bold = true;
					//style.align = "right";
					break;
				
				case "Input Period":
					
					style.size = 11;
					style.align = "center";
					style.letterSpacing = .7;
					break;
				
				case "Input Author Name":
					style.size = 11;
					break;
				
				case "Empty Style":
					style.size = 16;
					style.bold = true;
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