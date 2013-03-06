package events{
	
	import flash.events.Event;
	
	public class SortEvent extends Event {
		
		public static const SORT:String = "sort";
		
		public var parameter:String = "";   
		public var asc:Boolean = true;
			
		public function SortEvent(type:String,
								  parameter:String="",
								  asc:Boolean = true,
								  bubbles:Boolean = true,
								  cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			this.parameter = parameter;
			this.asc = asc;
		}
		
		public override function clone():Event {
			return new SortEvent(type, parameter, asc, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("SortEvent", "type", "parameter", "asc", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}