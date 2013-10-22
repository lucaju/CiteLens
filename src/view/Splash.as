package view {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import settings.Settings;
	
	public class Splash extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var container			:Sprite;
		
		//****************** Properties ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function Splash() {
			var loader:Loader = new Loader();
			
			if (Settings.platformTarget == "mobile") {
				loader.load(new URLRequest("/images/splash_1024x768.png"));
			} else {
				loader.load(new URLRequest("/images/splash_1150x640.png"));
			}
			
			this.addChild(loader);
		}
	}
}