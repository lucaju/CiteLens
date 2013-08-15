package settings {
	
	//impors
	import util.DeviceInfo;
	
	/**
	 * Settings.
	 * This class holds configuration settings of this app.
	 * 
	 * @author lucaju
	 * 
	 */
	public class Settings {
		
		//****************** Properties ****************** ****************** ******************
		
		//general
		private static var _platformTarget					:String;			//["air","mobile","web"]
		private static var _debug							:Boolean;			//Debug
		
		private static var _languageFilterNotationOptions	:Array;
		private static var _languageFilterNotation			:String;
		private static var _showAllLanguages				:Boolean;
		
		private static var _countryFilterNotationOptions	:Array;
		private static var _countryFilterNotation			:String;
		private static var _showAllCountries				:Boolean;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//--------default values
			
			//-- General
			_platformTarget = "air";
			_debug = false;
			
			//Language filter filter
			_languageFilterNotationOptions = new Array("name","iso6391","iso6392");
			languageFilterNotation = languageFilterNotationOptions[1];
			showAllLanguages = false;
			
			//Country filter filter
			_countryFilterNotationOptions = new Array("name","alpha2","alpha3");
			countryFilterNotation = countryFilterNotationOptions[2];
			showAllCountries = false;
				
		}
		
		//****************** GETTERS & SETTERS - GENERAL ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get platformTarget():String {
			return _platformTarget;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get debug():Boolean {
			return _debug;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set platformTarget(value:String):void {
			_platformTarget = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set debug(value:Boolean):void {
			_debug = value;
		}
		
		
		//****************** GETTERS & SETTERS - FILTER COUNTRY ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get languageFilterNotationOptions():Array {
			return _languageFilterNotationOptions;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get languageFilterNotation():String {
			return _languageFilterNotation;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set languageFilterNotation(value:String):void {
			_languageFilterNotation = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get showAllLanguages():Boolean {
			return _showAllLanguages;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set showAllLanguages(value:Boolean):void {
			_showAllLanguages = value;
		}

		
		//****************** GETTERS & SETTERS - FILTER COUNTRY ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get countryFilterNotationOptions():Array {
			return _countryFilterNotationOptions;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get countryFilterNotation():String {
			return _countryFilterNotation;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set countryFilterNotation(value:String):void {
			_countryFilterNotation = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get showAllCountries():Boolean {
			return _showAllCountries;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set showAllCountries(value:Boolean):void {
			_showAllCountries = value;
		}

	}
}