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
	public class CountryLibrary {
		
		//****************** static Properties ****************** ****************** ******************
		
		static private var library:Array;
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		static public function init():void {
			 //load data
			 var file:String = "model/library/countries.xml";
			 
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
			var countries:XMLList = xml.children();
			xml = null;
			
			var country:Country;
			
			for each (var countryXML:XML in countries) {
				country = new Country(library.length,
									  countryXML.attribute("name"),
									  countryXML.attribute("alpha-2"),
									  countryXML.attribute("alpha-3"));
				
				library.push(country);
			}
			
			//add other
			country = new Country(library.length, "Other", "**","***");
			library.push(country);
			
			//clean
			countryXML = null;
			countries = null;
			
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getCountryByName(value:String):Country {
			for each (var country:Country in library) {
				if (value.toLowerCase() == country.name.toLowerCase()) return country;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getCountryByAlpha2(value:String):Country {
			for each (var country:Country in library) {
				if (value.toLowerCase() == country.alpha2.toLowerCase()) return country;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function getCountryByAlpha3(value:String):Country {
			for each (var country:Country in library) {
				if (value.toLowerCase() == country.alpha3.toLowerCase()) return country;
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static protected function testForException(value:String):Country {
			
			var country:Country;
			
			switch (value) {
				case "United States of America":
					country = getCountryByName("United States");
					break
				
				case "Vatican":
					country = getCountryByAlpha3("VAT");
					break;
			}
			
			return country;
		}
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getCountryInfo(value:String):Country {
			
			var country:Country;
			
			if (value.length == 2) {	//search for alpha2 correspondent
				country =  getCountryByAlpha2(value);
			}
			
			else if (value.length == 3) {	//search for alpha3 correspondent
				country =  getCountryByAlpha3(value);
			}
			
			else if (value.length > 3) {	//search for name correspondent
				country =  getCountryByName(value);
			}
			
			if (!country) {
				country = testForException(value);
			}
			
			return country;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function getCountries():Array {
			return library.concat();
		}
		
	}
}