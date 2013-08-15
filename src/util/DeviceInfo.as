package util {
	
	//imports
	import flash.system.Capabilities;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DeviceInfo {
		
		//****************** PUBLIC STATIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function device():String {
			// Manufacturer is formatted as "Adobe OSName"
			var manufacturer:String = Capabilities.manufacturer;
			// Explode the text
			var deviceArr:Array = manufacturer.split(" ");
			// Last part is the device information
			return deviceArr[deviceArr.length-1];
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function os():String {
			var os:String = Capabilities.os;
			// First part is the OS name
			var osArr:Array = os.split(" ");
			return osArr[0];
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function osVersion():String {
			// We are getting the os
			var os:String = Capabilities.os;
			// First part is the os name
			var osArr:Array = os.split(" ");
			// Remove the os name
			var osVersion:String = os.split( osArr[0]+" " ).join();
			// Clean the version text
			osVersion = osVersion.replace(/[^0-9._-]+/gi, "");
			// Return the version
			return osVersion;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function carrier():String {
			// There is no carrier information in here
			// If you have any use for this method, return your desired information
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function resolution():String {
			return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function locale():String {
			return Capabilities.language;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function metrics():String {
			var result:String = "{";
			result += '"_device":"' + DeviceInfo.device() + '",';
			result += '"_os":"' + DeviceInfo.os() + '",';
			result += '"_os_version":"' + DeviceInfo.osVersion() + '",';
			
			if(DeviceInfo.carrier()) {
				result += '"_carrier":"' + DeviceInfo.carrier() + '",';
			}
			
			result += '"_resolution":"' + DeviceInfo.resolution() + '",';
			result += '"_locate":"' + DeviceInfo.locale() + '",';
			result += "}";
			
			return result;
		}
	}
}