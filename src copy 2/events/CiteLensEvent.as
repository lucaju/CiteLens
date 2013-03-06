package events{
	
	import flash.events.Event;
	
	public class CiteLensEvent extends Event {
		
		public static const DRAG:String = "drag";
		public static const FILTER:String = "filter";
		public static const SORT:String = "sort";
		public static const CHANGE_VISUALIZATION:String = "change_visualization";
		
		public var parameters:Object; 
			
		public function CiteLensEvent(type:String,
								  parameters:Object = null,
								  bubbles:Boolean = true,
								  cancelable:Boolean = false) {
			
			
			//sort
		
			super(type, bubbles, cancelable);
			this.parameters = parameters;
		}
		
		public override function clone():Event {
			return new CiteLensEvent(type, parameters, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("BibliographyEvent", "type", "parameters", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}