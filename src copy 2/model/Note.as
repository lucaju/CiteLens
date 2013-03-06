package model {
	
	public class Note {
		
		private var _id:int;
		private var _uniqueID:String;
		
		private var _chapter:String;
		private var _notePlace:String;
		private var _startLocation:int;
		private var _noteSpan:String;
		private var _citations:Array = new Array();
		private var _citation:RefBibliographic;
		
		public function Note(id:int) {
			_id = id;
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get uniqueID():String {
			return _uniqueID;
		}

		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}
		
		public function get chapter():String {
			return _chapter;
		}
		
		public function set chapter(value:String):void {
			_chapter = value;
		}
		
		public function get notePlace():String {
			return _notePlace;
		}
		
		public function set notePlace(value:String):void {
			_notePlace = value;
		}
		
		public function get startLocation():int {
			return _startLocation;
		}
		
		public function set startLocation(value:int):void {
			_startLocation = value;
		}
		
		public function get noteSpan():String {
			return _noteSpan;
		}
		
		public function set noteSpan(value:String):void {
			_noteSpan = value;
		}
		
		public function get citations():Array {
			return _citations;
		}
		
		public function addCitation(ref:RefBibliographic):void {
			_citations.push(ref);
		}
		
	}
}