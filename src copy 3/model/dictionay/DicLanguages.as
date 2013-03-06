package model.dictionay {
	
	
	public class DicLanguages {
		
		static private var dictionay:Array = [
			{alpha2_code:"", alpha3_code:"", name:""}, /// Null
			{alpha2_code:"en", alpha3_code:"eng", name:"English"},
			{alpha2_code:"fr", alpha3_code:"fra", name:"French"},
			{alpha2_code:"de", alpha3_code:"ger", name:"German"},
			{alpha2_code:"he", alpha3_code:"heb", name:"Hebrew"},
			{alpha2_code:"it", alpha3_code:"ita", name:"Italian"},
			{alpha2_code:"la", alpha3_code:"lat", name:"Latin"},
			{alpha2_code:"es", alpha3_code:"spa", name:"Spanish"}
			]
		
		public function DicLanguages() {
		
		}
		
		static public function getLangInfo(value:String):Object {
			
			var lang:Object;
			
			if (value.length == 2) {	//search for alpha2 correspondent
				for each (lang in dictionay) {
					if (value.toLowerCase() == lang.alpha2_code.toLowerCase()) {
						break;
					}
				}
			}
				
			else if (value.length == 3) {	//search for alpha3 correspondent
				for each (lang in dictionay) {
					if (value.toLowerCase() == lang.alpha3_code.toLowerCase()) {
						break;
					}
				}
			}
				
			else if (value.length > 3) {	//search for name correspondent
				for each (lang in dictionay) {
					
					if (value.toLowerCase() == lang.name.toLowerCase()) {
						break;
					}
				}
			}
			
			//error
			if (lang == null) {
				lang = dictionay[0];
			}
			
			return lang;
		}
	}
}