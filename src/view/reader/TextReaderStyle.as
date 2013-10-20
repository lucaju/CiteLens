package view.reader {
	
	//imports
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.TextAlign;
	import font.HelveticaNeueCFF;
	import view.style.ColorSchema;
	import flash.text.engine.FontLookup;
	import flash.text.engine.CFFHinting
	import flash.text.engine.RenderingMode
	
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
		static public function getStyle(styleName:String, statusColor:String = "standard"):TextLayoutFormat {
			
			var style:TextLayoutFormat = new TextLayoutFormat();
			style.fontFamily = HelveticaNeueCFF.LIGHT;
			style.fontLookup = FontLookup.EMBEDDED_CFF;
			style.renderingMode = RenderingMode.CFF;
			style.cffHinting = CFFHinting.HORIZONTAL_STEM;
			style.fontSize = 12;
			style.lineHeight = 18;
			style.textAlign = TextAlign.LEFT;
			style.paragraphSpaceAfter = 16;
			
			
			switch (styleName) {
				
				case "body":
					style.paddingLeft = 10;
					style.paddingRight = 10;
					style.paddingTop = 10;
					style.paddingBottom = 10;
					style.color = ColorSchema.DARK_GREY;
					break;
				
				case "chapter":
					style.fontFamily = HelveticaNeueCFF.BOLD;
					style.fontSize = 16;
					style.lineHeight = 24;
					style.color = ColorSchema.DARK_GREY;
					style.textIndent = 0;
					style.paragraphSpaceBefore = 32;
					style.paragraphSpaceAfter = 6;
					break;
				
				case "chapterSection":
					style.fontFamily = HelveticaNeueCFF.MEDIUM;
					style.fontSize = 14;
					style.lineHeight = 22;
					style.color = ColorSchema.DARK_GREY;
					style.textIndent = 0;
					style.paragraphSpaceBefore = 32;
					style.paragraphSpaceAfter = 6;
					break;
				
				case "label":
					style.fontFamily = HelveticaNeueCFF.REGULAR;
					style.fontSize = 13;
					style.lineHeight = 20;
					style.color = ColorSchema.DARK_GREY;
					style.textIndent = 0;
					style.paragraphSpaceAfter = 6;
					break;
				
				case "noteSpan":
					style.color = ColorSchema.BLACK;
					style.paddingLeft = 10;
					style.paddingRight = 10;
					break;
				
				case "selectedNoteSpan":
					style.color = ColorSchema.RED;
					break;
				
				case "superScript":
					style.fontFamily = HelveticaNeueCFF.REGULAR;
					style.fontSize = 8;
					style.baselineShift = 3;
					break;
				
				case "footnote":
					style.fontFamily = HelveticaNeueCFF.LIGHT;
					style.fontSize = 11;
					style.lineHeight = 16;
					break;
				
				case "selectedFootnote":
					style.fontFamily = HelveticaNeueCFF.LIGHT;
					style.color = ColorSchema.RED;
					style.fontSize = 11;
					style.lineHeight = 16;
					break;
				
			}
		
			return style;
		}
		 
	}
}