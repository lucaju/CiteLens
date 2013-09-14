package view.style {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ColorSchema {
		
		//****************** Static Properties ****************** ****************** ******************
		
		//status
		static public const active		:uint = 0xBBBBBB;
		static public const selected		:uint = 0x333333;
		static public const inactive		:uint = 0xCCCCCC;
		
		//schema
		static public const filter1		:uint = 0x56AF17;
		static public const filter2		:uint = 0x843B9F;
		static public const filter3		:uint = 0x0092D0;
		
		//color
		static public const gray			:uint = 0x666666;
		static public const white			:uint = 0xFFFFFF;
		static public const RED				:uint = 0xCC092F;
		
		static public const DARK_GREY		:uint = 0x59595B;
		static public const MEDIUM_GREY		:uint = 0x999999;
		static public const LIGHT_GREY		:uint = 0xDADBDA;
		
		//array
		static private var colors:Object = {
											active:active,
											selected:selected,
											inactive:inactive,
											filter1:filter1,
											filter2:filter2,
											filter3:filter3,
											gray:gray,
											RED:RED,
											white:white};
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function ColorSchema() {
			
		}
		
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getColor(value:String = null):uint {
			return colors[value];	
		}
	}
}