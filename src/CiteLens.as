package {
	
	//imports
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import controller.CiteLensController;
	
	import net.hires.debug.Stats;
	
	import settings.Settings;
	
	import util.Global;
	
	import view.MainView;
	
	
	[SWF(width="1150", height="650", backgroundColor="#ffffff", frameRate="30")]
	
	public class CiteLens extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var citeLensController			:CiteLensController;			//Controller - CiteLens Controller
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
			
			//starting controler
			//citeLensController = new CiteLensController([citeLensModel]);
			
			mainView = new MainView(citeLensController);
			this.addChild(mainView);
			mainView.init();
			
			//debug stat
			if (Settings.debug == true) this.addChild(new Stats());
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