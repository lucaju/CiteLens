package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Note {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;
		protected var _uniqueID			:String;
		
		protected var _chapter			:String;
		protected var _notePlace		:String;
		protected var _noteAnchor		:int
		protected var _startLocation	:int;
		protected var _noteSpan			:String;
		
		protected var _citations		:Array = new Array();
		protected var _citation			:RefBibliographic;

		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function Note(id:int) {
			_id = id;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param ref
		 * 
		 */
		public function addCitation(ref:RefBibliographic):void {
			_citations.push(ref);
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uniqueID():String {
			return _uniqueID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get chapter():String {
			return _chapter;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set chapter(value:String):void {
			_chapter = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get notePlace():String {
			return _notePlace;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set notePlace(value:String):void {
			_notePlace = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get noteAnchor():int {
			return _noteAnchor;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set noteAnchor(value:int):void {
			_noteAnchor = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get startLocation():int {
			return _startLocation;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set startLocation(value:int):void {
			_startLocation = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get noteSpan():String {
			return _noteSpan;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set noteSpan(value:String):void {
			_noteSpan = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get citations():Array {
			return _citations;
		}

	}
}