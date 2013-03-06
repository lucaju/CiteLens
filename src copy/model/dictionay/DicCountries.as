package model.dictionay {
	
	
	public class DicCountries {
		
		static private var dictionay:Array = [
			{alpha2_code:"au", alpha3_code:"aut", name:"Austria"},
			{alpha2_code:"be", alpha3_code:"bel", name:"Belgium"},
			{alpha2_code:"fr", alpha3_code:"fra", name:"France"},
			{alpha2_code:"de", alpha3_code:"deu", name:"Germany"},
			{alpha2_code:"it", alpha3_code:"ita", name:"Italy"},
			{alpha2_code:"il", alpha3_code:"isr", name:"Israel"},
			{alpha2_code:"nl", alpha3_code:"nld", name:"Netherlands"},
			{alpha2_code:"va", alpha3_code:"vat", name:"Vatican"},
			{alpha2_code:"gb", alpha3_code:"gbr", name:"United Kingdom"},
			{alpha2_code:"us", alpha3_code:"usa", name:"United States"}
			]
		
		public function DicCountries() {
		
		}
		
		static public function getCountryInfo(value:String):Object {
			
			var country:Object;
			
			if (value.length == 2) {	//search for alpha2 correspondent
				for each (country in dictionay) {
					if (value.toLowerCase() == country.alpha2_code) {
						break;
					}
				}
			}
			
			else if (value.length == 3) {	//search for alpha3 correspondent
				for each (country in dictionay) {
					if (value.toLowerCase() == country.alpha3_code) {
						break;
					}
				}
			}
			
			else if (value.length > 3) {	//search for name correspondent
				for each (country in dictionay) {
					
					if (value.toLowerCase() == country.name.toLowerCase()) {
						break;
					}
				}
			}
			
			return country;
		}
	}
}