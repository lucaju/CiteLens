package model.dictionay {
	
	
	public class DicPubTypes {
		
		static private var dictionay:Array = [
			{code:"book", code3:"bok", code4:"Book", name:"Book"},
			{code:"bookSection", code3:"bks", code4:"BSec", name:"Book Section"},
			{code:"codex", code3:"cod", code4:"Codx", name:"Codex"},
			{code:"commentary", code3:"cmt", code4:"Comm", name:"Commentary"},
			{code:"conferenceproceedings", code3:"cfp", code4:"Conf", name:"Conference Proceeding"},
			{code:"corpus", code3:"cps", code4:"Corp", name:"Corpus"},
			{code:"excavationReport", code3:"exr", code4:"Excv", name:"Excavation Report"},
			{code:"journalArticle", code3:"jra", code4:"JArt", name:"Journal Article"},
			{code:"letter", code3:"let", code4:"Letr", name:"Letter"},
			{code:"manuscript", code3:"mns", code4:"Mnsc", name:"Manuscript"},
			{code:"other", code3:"oth", code4:"Othr", name:"Other"},
			{code:"PhD disertation", code3:"phd", code4:"Diss", name:"PhD Dissertation"},
			{code:"review", code3:"rev", code4:"Revw", name:"Review"},
			{code:"scholarlyEdition", code3:"sce", code4:"SchE", name:"Scholarly Edition"}
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