package {
	
	//imports
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import controller.CiteLensController;
	
	import model.CiteLensModel;
	
	import net.hires.debug.Stats;
	
	import settings.Settings;
	
	import util.Global;
	
	import view.CiteLensView;
	import view.MainView;
	
	
	[SWF(width="1150", height="650", backgroundColor="#ffffff", frameRate="30")]
	
	public class CiteLens extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var citeLensModel					:CiteLensModel;					//Model - CiteLens data
		protected var citeLensController			:CiteLensController;			//Controller - CiteLens Controller
		protected var citeLensView					:CiteLensView;					//View - CiteLens View
		protected var mainView						:MainView;						//View - CiteLens View
		
		protected var configure						:Settings;						//Settings
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function CiteLens() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//settings
			setting();
			
			//global
			Global.globalWidth = stage.stageWidth;
			Global.globalHeight = stage.stageHeight;
			
			//Starting models
			//citeLensModel = new CiteLensModel();
			//citeLensModel.addEventListener(Event.COMPLETE, _init);
			
			//starting controler
			//citeLensController = new CiteLensController([citeLensModel]);
			
			//Starting View
			//citeLensView = new CiteLensView(citeLensController);
			//this.addChild(citeLensView);
			
			mainView = new MainView(citeLensController);
			this.addChild(mainView);
			mainView.init();
			
			//debug stat
			if (Settings.debug == true) this.addChild(new Stats());
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _init(event:Event):void {
			//citeLensModel.removeEventListener(Event.COMPLETE, _init);
			//citeLensView.initialize();
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		private function setting():void {
			configure = new Settings();
			//default values
			Settings.platformTarget = "air";
			Settings.debug = false;
		}
	}
}