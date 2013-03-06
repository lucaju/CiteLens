package {
	
	//imports
	import controller.CiteLensController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import model.CiteLensModel;
	
	import net.hires.debug.Stats;
	
	import view.CiteLensView;
	
	import util.Global;
	
	[SWF(width="1150", height="650", backgroundColor="#ffffff", frameRate="30")]
	
	public class CiteLens extends Sprite {
		
		//properties
		private var citeLensModel:CiteLensModel;					//Model - CiteLens data
		private var citeLensController:CiteLensController;			//Controller - CiteLens Controller
		private var citeLensView:CiteLensView;						//View - CiteLens View
		
		public function CiteLens() {
			
			//global
			Global.globalWidth = stage.stageWidth;
			Global.globalHeight = stage.stageHeight;
		
			//Starting models
			citeLensModel = new CiteLensModel();
			citeLensModel.addEventListener(Event.COMPLETE, _init);
			
			//starting controler
			citeLensController = new CiteLensController([citeLensModel]);
			
			//Starting View
			citeLensView = new CiteLensView(citeLensController);
			addChild(citeLensView);
			
			//debug stat
			//addChild(new Stats());
		}
		
		
		private function _init(e:Event):void {
			citeLensModel.removeEventListener(Event.COMPLETE, _init);
			
			citeLensView.initialize();
		}
	}
}