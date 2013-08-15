package view.util.scroll {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.PanGestureDirection;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class GestouchIput extends InputAdpter {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var panGesture	:PanGesture
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param _source
		 * 
		 */
		public function GestouchIput(_source:Scroll) {
			
			trace ("??")
			
			source = _source;
			
			panGesture = new PanGesture(source.target.parent);
			panGesture.maxNumTouchesRequired = 1;
			
			switch(source.direction) {
				
				case source.HORIZONTAL:
					panGesture.direction = PanGestureDirection.HORIZONTAL;
					break;
				
				case source.VERTICAL:
					panGesture.direction = PanGestureDirection.VERTICAL;
					break;
				
			}

		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * Add Scroll Event Listeners
		 * 
		 */
		override public function addEvents():void {
			panGesture.addEventListener(GestureEvent.GESTURE_BEGAN, gesturePanBegan);
			panGesture.addEventListener(GestureEvent.GESTURE_CHANGED, gesturePanChange);
			panGesture.addEventListener(GestureEvent.GESTURE_ENDED, gesturePanEnd);
		}
		
		/**
		 * Remove Scroll Event Listeners
		 * 
		 */
		override public function removeEvents():void {
			panGesture.removeEventListener(GestureEvent.GESTURE_BEGAN, gesturePanBegan);
			panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED, gesturePanChange);
			panGesture.removeEventListener(GestureEvent.GESTURE_ENDED, gesturePanEnd);
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function gesturePanBegan(event:GestureEvent):void {
			var panGesture:PanGesture = event.target as PanGesture;
			
			source.removeEventListener(Event.ENTER_FRAME, source.throwObject);
			TweenMax.killChildTweensOf(source);
			if (source.roll) source.roll.alpha = 1;
			if (source.track) source.track.alpha = 1;
			
			if (source.speed.x * -panGesture.offsetX <= 0) source.speed.x = 0;
			if (source.speed.y * -panGesture.offsetY <= 0) source.speed.y = 0;
			
			//dispatch event
			source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"begin",source.target.x, source.target.y, source.speed.x, source.speed.y));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function gesturePanChange(event:GestureEvent):void {
			
			var panGesture:PanGesture = event.target as PanGesture;
			
			switch (panGesture.direction) {
				case PanGestureDirection.HORIZONTAL:
					source.target.x += panGesture.offsetX;
					if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
					source.speed.x = panGesture.offsetX;
					break;
				
				case PanGestureDirection.VERTICAL:
					source.target.y += panGesture.offsetY;
					if (source.roll) source.roll.y = -source.target.y / source.ratePageY;
					source.speed.y = panGesture.offsetY;
					break;
				
				default:
					source.target.x += panGesture.offsetX;
					source.target.y += panGesture.offsetY;
					if (source.roll) source.roll.x = -source.target.x / source.ratePageX;
					if (source.roll) source.roll.y = -source.target.y / source.ratePageY;
					source.speed.x = panGesture.offsetX;
					source.speed.y = panGesture.offsetY;
					break;
				
			}
			
			event.stopImmediatePropagation();
			
			
			source.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"update",source.target.x, source.target.y, source.speed.x, source.speed.y));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function gesturePanEnd(event:GestureEvent):void {
			
			if (source.speed.x == 0 && source.speed.y == 0) {
				if (source.roll) TweenMax.to(source.roll,.3,{alpha:0,delay:.4});
				if (source.track) TweenMax.to(source.track,.3,{alpha:0,delay:.6});
			}
			
			source.addEventListener(Event.ENTER_FRAME, source.throwObject);
			source.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"start", source.target.x, source.target.y, source.speed.x, source.speed.y));
		}
		
	}
}