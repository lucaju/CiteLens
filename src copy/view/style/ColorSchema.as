package view.style {
	import flash.utils.Dictionary;
	
	
	public class ColorSchema {
		
		//status
		static private var active:uint = 0x333333;
		static private var selected:uint = 0xFFFFFF;
		static private var inactive:uint = 0xCCCCCC;
		
		//schema
		static private var filter1:uint = 0x56AF17;
		static private var filter2:uint = 0x843B9F;
		static private var filter3:uint = 0xA05444;
		
		//color
		static private var gray:uint = 0xCCCCCC;
		static private var red:uint = 0xFF0000
		
		//array
		static private var colors:Object = {
											active:active,
											selected:selected,
											inactive:inactive,
											filter1:filter1,
											filter2:filter2,
											filter3:filter3,
											gray:gray,
											red:red};
		
		
		public function ColorSchema() {
			
		}
		
		static public function getColor(value:String = null):uint {
			
			var color:uint = colors[value]
			
			return color;
			
		}
	}
}