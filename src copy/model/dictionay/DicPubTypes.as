package model.dictionay {
	
	
	public class DicPubTypes {
		
		static private var dictionay:Array = [
			{code:"book", code3:"bok", name:"Book"},
			{code:"bookSection", code3:"bks", name:"Book Section"},
			{code:"codex", code3:"cod", name:"Codex"},
			{code:"commentary", code3:"cmt", name:"Commentary"},
			{code:"conferenceproceedings", code3:"cfp", name:"Conference Proceeding"},
			{code:"corpus", code3:"cps", name:"Corpus"},
			{code:"excavationReport", code3:"exp", name:"Excavation Report"},
			{code:"journalArticle", code3:"jra", name:"Journal Article"},
			{code:"letter", code3:"let", name:"Letter"},
			{code:"manuscript", code3:"mns", name:"Manuscript"},
			{code:"other", code3:"oth", name:"Other"},
			{code:"PhD disertation", code3:"phd", name:"PhD Dissertation"},				///if have to check the spelling in the xml
			{code:"review", code3:"rev", name:"Review"},
			{code:"scholarlyEdition", code3:"sce", name:"Scholarly Edition"}
			]
		
		public function DicPubTypes() {
		
		}
		
		static public function getPubTypeInfo(value:String):Object {
			
			var pubType:Object;
			
			for each (pubType in dictionay) {
				if (value.toLowerCase() == pubType.code.toLowerCase() || value.toLowerCase() == pubType.code3.toLowerCase() || value.toLowerCase() == pubType.name.toLowerCase()) {
					break;
				}
			}
			
			return pubType;
		}
	}
}