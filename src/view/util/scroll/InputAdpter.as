package view.util.scroll {
	
	//imports
	import view.util.scroll.Scroll;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InputAdpter {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var source		:Scroll
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function InputAdpter() {
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Scroll Event Listeners
		 * 
		 */
		public function addEvents():void {
			//to override
		}
		
		/**
		 * Remove Scroll Event Listeners
		 * 
		 */
		public function removeEvents():void {
			//to override
		}
		
	}
}