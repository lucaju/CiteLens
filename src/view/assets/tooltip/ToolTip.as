package view.assets.tooltip {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTip extends Sprite{	
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id				:int;							// Article's id

		protected var maxWidth			:Number 		= 150;			// Balloon max width
		protected var minHeight			:Number 		= 20;			// Balloom min height
		protected var round				:Number 		= 10;			// Round corners
		protected var margin			:Number 		= 2;			// Margin size
		protected var _arrowDirection	:String			 = "bottom";		// Arrow point direction

		protected var shapeBox			:Balloon;						//Shape of the balloon;
		
		protected var titleTF			:TextField;						// Title Textfield
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param idValue
		 * 
		 */
		public function ToolTip(idValue:int = 0) {
			
			//save properties
			_id = idValue;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function initialize(data:Object):void {
			
			var target:Sprite = data.target;
			
			//set position
			var targetPoint:Point = new Point(this.x, this.y)
			var targetGlobalPos:Point = target.localToGlobal(targetPoint);

			this.x = targetGlobalPos.x + (target.width/2)			
			
			switch (_arrowDirection) {
				case "top":
					this.y = targetGlobalPos.y + target.height;
					break;
				
				default:
					this.y = targetGlobalPos.y;
					break;
			}
			
			//----------title
			titleTF = new TextField();
			titleTF.antiAliasType = AntiAliasType.ADVANCED;
			titleTF.embedFonts = true;
			titleTF.selectable = false;
			titleTF.autoSize = TextFieldAutoSize.CENTER;
			titleTF.text = " " + data.title + " ";
			titleTF.setTextFormat(TXTFormat.getStyle("General Label"));
			
			titleTF.x = margin;
			titleTF.y = margin;
			
			addChild(titleTF);
			
			//shape
			shapeBox = new Balloon(titleTF.width + (2 * margin), titleTF.height + (1 * margin));
			addChildAt(shapeBox,0);
			
			//elements Position
			shapeBox.x = -shapeBox.width/2;
			shapeBox.y = -shapeBox.height;
			
			titleTF.x = shapeBox.x + margin;
			titleTF.y = shapeBox.y + margin;
			
			TweenMax.from(this,.5,{autoAlpha:0, y:this.y + 5, delay:2});
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _closebutton(e:MouseEvent):void {
			//workflowController.killBalloon(id)
		}
		
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function kill():void {
			this.parent.removeChild(this);
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
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
	}
}