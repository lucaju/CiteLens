package util {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Utilities extends Sprite {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Utilities() {
			
		}
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param s
		 * @param regx
		 * @param regy
		 * @param showRegistration
		 * 
		 */
		static public function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean = false):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration) {
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}

	}
}