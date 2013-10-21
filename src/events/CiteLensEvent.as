package events{
	
	//imports
	import flash.events.Event;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CiteLensEvent extends Event {
		
		//****************** Properties ****************** ****************** ******************
		
		public static const DRAG					:String = "drag";
		public static const FILTER					:String = "filter";
		public static const REMOVE_FILTER			:String = "remove_filter";
		public static const SORT					:String = "sort";
		public static const CHANGE_VISUALIZATION	:String = "change_visualization";
		public static const READER_SCROLL			:String = "reader_scroll";
		public static const READER_CLICK			:String = "reader_click";
		
		public var parameters						:Object; 
			
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param type
		 * @param parameters
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function CiteLensEvent(type:String,
								  parameters:Object = null,
								  bubbles:Boolean = true,
								  cancelable:Boolean = false) {
			
			
			super(type, bubbles, cancelable);
			this.parameters = parameters;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function clone():Event {
			return new CiteLensEvent(type, parameters, bubbles, cancelable);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString():String {
			return formatToString("BibliographyEvent", "type", "parameters", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}