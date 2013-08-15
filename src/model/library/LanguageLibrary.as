package model.library {
	
	//imports
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class LanguageLibrary {
		
		//****************** Constructor ****************** ****************** ******************
		
		static private var library:Array;
		
			
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		static public function init():void {
			//load data
			var file:String = "model/library/languages.xml";
			
			var urlRequest:URLRequest = new URLRequest(file);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,processData);
			urlLoader.load(urlRequest);
			
			file = null;
			urlRequest = null;
			urlLoader = null;
		}
		
		
		//****************** STATIC PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		static protected function processData(event:Event):void {
			
			library = new Array();
			
			var xml:XML = new XML(event.target.data);
			var languages:XMLList = xml.children();
			xml = null;
			
			var language:Language;
			
			for each (var langXML:XML in languages) {
				language = new Language(library.length,
					langXML.attribute("name"),
					langXML.attribute("iso639-1"),
					langXML.attribute("iso639-2"));
				
				library.push(language);
			}
			
			//add other
			language = new Language(library.length, "Other", "**","***");
			library.push(language);
			
			//clean
			langXML = null;
			languages = null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getLanguageByName(value:String):Language {
			for each (var language:Language in library) {
				if (value.toLowerCase() == language.name.toLowerCase()) return language;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getLanguageIso6391(value:String):Language {
			for each (var language:Language in library) {
				if (value.toLowerCase() == language.iso6391.toLowerCase()) return language;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getLanguageIso6392(value:String):Language {
			for each (var language:Language in library) {
				if (value.toLowerCase() == language.iso6391.toLowerCase()) return language;
			}
			return null;
		}
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getLangInfo(value:String):Language {
			
			var lang:Language;
			
			if (value.length == 2) {						//search for iso6391 correspondent
				lang =  getLanguageIso6391(value);
			}
				
			else if (value.length == 3) {					//search for iso9362 correspondent
				lang =  getLanguageIso6392(value);
			}
				
			else if (value.length > 3) {					//search for name correspondent
				lang =  getLanguageByName(value);
			}
			
			return lang;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function getLanguages():Array {
			return library.concat();
		}
		
	}
}