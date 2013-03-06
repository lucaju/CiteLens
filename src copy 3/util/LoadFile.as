package util {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class LoadFile extends Sprite{
		
		//properties
		private var url:URLRequest;
		private var loader:Loader;
		
		
		public function LoadFile(file:String) {
			url = new URLRequest(file);
			loader = new Loader();
			loader.load(url);
			addChild(loader)
		}
	}
}