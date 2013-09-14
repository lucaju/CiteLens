package view.columnViz {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class SamplePixel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id			:int;
		protected var _type			:String;
		protected var _noteID		:int;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param type
		 * @param noteID
		 * 
		 */
		public function SamplePixel(id:int, type:String = SamplePixelType.TEXT, noteID:int = 0) {
			_id = id;
			_type = type;
			_noteID = noteID;
		}
		
		
		//****************** GETTETRS // SETTERS ****************** ****************** ******************

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
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get noteID():int {
			return _noteID;
		}


	}
}