package view.style {
	
	//imports
	import flash.text.Font;
	import flash.text.TextFormat;

	public class TXTFormat {
		
		public function TXTFormat() {
			
		}
		
		static public function getStyle(styleName:String, statusColor:String = "standard"):TextFormat {
			
			var style:TextFormat = new TextFormat();
			style.font = "Helvetica Neue";
			style.color = ColorSchema.getColor(statusColor);
			style.leading = 2;
			
			switch (styleName) {
				
				case "Main Button Style":
					
					style.bold = true;
					style.size = 20;
					break;
				
				case "Title Header":
					
					style.bold = true;
					style.leading = 2;
					style.size = 24;
					break;
				
				case "Author Header":
					
					style.size = 12;
					style.bold = true;
					style.align = "right";
					style.color = ColorSchema.getColor("gray");
					break;
				
				case "General Label":
					
					style.size = 11;
					style.bold = true;
					break;
				
				case "Button Style":
					
					style.bold = true;
					style.size = 11;
					break;
				
				case "Item List Title":
					
					style.bold = true;
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
				
				case "filter header":
					
					style.bold = true;
					style.size = 10;
					style.italic = true;
					style.bold = true;
					style.color = 0xFFFFFF;
					break;
				
				case "Period Label":
					
					style.size = 11;
					style.align = "right";
					break;
				
				default:
					
					style.size = 12;
					break;
				
			}
		
			return style;
		}
		 
	}
}