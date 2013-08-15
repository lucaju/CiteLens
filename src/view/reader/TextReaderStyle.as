package view.reader {
	
	//imports
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import view.style.ColorSchema;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TextReaderStyle {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function TextReaderStyle() {
			
		}
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param styleName
		 * @param mini
		 * @param statusColor
		 * @return 
		 * 
		 */
		static public function getStyle(styleName:String, mini:Boolean = false, statusColor:String = "standard"):TextLayoutFormat {
			
			var style:TextLayoutFormat = new TextLayoutFormat();
			style.color = ColorSchema.getColor(statusColor);
			style.fontFamily = "Helvetica Neue";
			style.lineHeight = 16;
			style.paragraphSpaceAfter = 16;
			style.textAlign = "left";
			style.textIndent = 10;
			
			switch (styleName) {
				
				case "body":
					
					style.fontSize = 11;
					break;
				
				case "noteSpan":
					
					style.color = ColorSchema.getColor("filter1");
					style.fontSize = 11;
					break;
				
				case "superScript":
					
					style.fontSize = 6;
					style.baselineShift = 6;
					break;
				
				default:
					
					style.fontSize = 11;
					break;
				
			}
			
			if (mini) {
				style.fontSize = 1;
				style.fontWeight = "bold";
				style.lineHeight = 2;
				style.paragraphSpaceBefore = 0;
				style.paragraphSpaceAfter = 3;
			}
		
			return style;
		}
		 
	}
}