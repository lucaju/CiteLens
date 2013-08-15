package view.util.scroll {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	
	import util.DeviceInfo;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class NativeInput extends InputAdpter {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _source
		 * 
		 */
		public function NativeInput(_source:Scroll) {
			source = _source;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Scroll Event Listeners
		 * 
		 */
		override public function addEvents():void {
			source.target.parent.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);			
			source.target.parent.addEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);
			source.target.parent.addEventListener(MouseEvent.MOUSE_WHEEL, scrollList);
		}
		
		/**
		 * Remove Scroll Event Listeners
		 * 
		 */
		override public function removeEvents():void {
			source.target.parent.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);			
			source.target.parent.removeEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);
			source.target.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollList);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * Manage MouseDown Event
		 *  
		 * @param event:Event
		 * 
		 */
		protected function handleMouseDown(event:MouseEvent):void {
			
			source.speed.y = 0;
			source.speed.x = 0;
			source.tweenComplete();
			
			//dispatch event
			source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"stop", source.target.x, source.target.y));
		}
		
		/**
		 * Manage Pan Gesture Event
		 * 
		 * @param e:transformGestureEvent
		 * 
		 */
		protected function handlePan(event:TransformGestureEvent):void {
			
			//1.
			switch (source.direction) {
				
				case "vertical":
					if (DeviceInfo.os() != "Mac") {
						source.target.y += 2 * (event.offsetY);
						if (source.roll) source.roll.y = source.target.y / source.ratePageY;
					} else {
						source.target.y -= 2 * (event.offsetY);
						if (source.roll) {
							if (source.roll.y >= 0) {
								source.roll.y = -source.target.y / source.ratePageY;
							}
						}
					}
					break;
				
				
				case "horizontal":
					if (DeviceInfo.os() != "Mac") {
						source.target.x += 2 * (event.offsetX);
						if (source.roll) source.roll.x = source.target.x / source.ratePageX;
					} else {
						source.target.x -= 2 * (event.offsetX);
						if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
					}
					break;
				
				
				case "both":
					if (DeviceInfo.os() != "Mac") {
						
						source.target.x += 2 * (event.offsetX);
						source.target.y += 2 * (event.offsetY);
						
						if (source.roll) source.roll.x = source.target.x / source.ratePageX;
						if (source.roll) source.roll.y = source.target.y / source.ratePageY;
						
					} else {
						
						source.target.x -= 2 * (event.offsetX);
						source.target.y -= 2 * (event.offsetY);
						
						if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
						if (source.roll) source.roll.y = -source.target.y / source.ratePageY;
					}
					break;
				
			}
			
			//2. Event Phases
			switch (event.phase) {
				
				case "begin":
					source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
					TweenMax.killChildTweensOf(source);
					if (source.roll) source.roll.alpha = 1;
					if (source.track) source.track.alpha = 1;
					
					if (source.speed.x * -event.offsetX <= 0) source.speed.x = 0;
					if (source.speed.y * -event.offsetY <= 0) source.speed.y = 0;
					
					//dispatch event
					source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, event.phase, source.target.x, source.target.y, source.speed.x, source.speed.y));
					
					break;
				
				case "update":
					source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
					
					if (DeviceInfo.os() != "Mac") {
						source.speed.x += event.offsetX;
						source.speed.y += event.offsetY;
					} else {
						
						if (event.offsetX == 0) {
							source.speed.x = 0;
						} else {
							source.speed.x -= event.offsetX;
						}
						
						if (event.offsetY == 0) {
							source.speed.y = 0;
						} else {
							source.speed.y -= event.offsetY;
						}
						
						//dispatch event
						source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, event.phase, source.target.x, source.target.y, source.speed.x, source.speed.y));
					}
					
					break;
				
				case "end":
					//target.parent.mouseChildren = false;
					source.addEventListener(Event.ENTER_FRAME, source.throwObject);
					source.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA, "start", source.target.x, source.target.y, source.speed.x, source.speed.y));
					break;
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function scrollList(event:MouseEvent):void {
			
			source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
			TweenMax.killChildTweensOf(source);
			
			if (source.roll) source.roll.alpha = 1;
			if (source.track) source.track.alpha = 1;
			
			source.speed.y += event.delta;													//define scroll speed
			
			source.addEventListener(Event.ENTER_FRAME, source.throwObject);
			source.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA, "start", source.target.x, source.target.y, source.speed.x, source.speed.y));
		}
	}
	
}