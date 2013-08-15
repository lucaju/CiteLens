package util {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class LoadFile extends Sprite{
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param file
		 * 
		 */
		public function LoadFile(file:String) {
			var url:URLRequest = new URLRequest(file);
			var loader:Loader = new Loader();
			loader.load(url);
			this.addChild(loader)
		}
	}
}