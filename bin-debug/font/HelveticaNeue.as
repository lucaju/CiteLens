package font {
	
	//imports
	import flash.text.Font;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HelveticaNeue {
		
		//****************** Properties ****************** ****************** ******************
		
		[Embed(source="../font/helvetica_neue/HelveticaNeue.ttf",
				fontName="HelveticaNeue",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _regular:Class;
		
		[Embed(source="../font/helvetica_neue/HelveticaNeueItalic.ttf",
				fontName="HelveticaNeueItalic",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _italic:Class;
		
		[Embed(source="../font/helvetica_neue/HelveticaNeueBold.ttf",
				fontName="HelveticaNeueBold",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _bold:Class;
		
		[Embed(source="../font/helvetica_neue/HelveticaNeueLight.ttf",
				fontFamily="HelveticaNeueLight",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _light:Class;
		
		[Embed(source="../font/helvetica_neue/HelveticaNeueLightItalic.ttf",
				fontFamily="HelveticaNeueLightItalic",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _lightItalic:Class;
		
		[Embed(source="../font/helvetica_neue/HelveticaNeueMedium.ttf",
				fontFamily="HelveticaNeueMedium",
				mimeType="application/x-font",
				advancedAntiAliasing="true",
				embedAsCFF="false")]
		protected var _medium:Class;
		
		public static const NAME:String = "HelveticaNeue"
		public static const REGULAR:String = "HelveticaNeue";
		public static const ITALIC:String = "HelveticaNeueItalic";
		public static const BOLD:String = "HelveticaNeueBold";
		public static const LIGHT:String = "HelveticaNeueLight";
		public static const LIGHT_ITALIC:String = "HelveticaNeueLightItalic";
		public static const MEDIUM:String = "HelveticaNeueMedium";
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function HelveticaNeue() {
			Font.registerFont(_regular);
			Font.registerFont(_italic);
			Font.registerFont(_bold);
			Font.registerFont(_light);
			Font.registerFont(_lightItalic);
			Font.registerFont(_medium);
		}
		
	}
}