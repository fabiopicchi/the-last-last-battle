package utils
{
	/**
	 * ...
	 * @author arthur e fabio
	 */
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class JSONLoader 
	{
		
		public function JSONLoader() 
		{
			
		}
		
		
		public static function loadFile (file : String) : Object
		{
			var jsonFile:File = File.applicationDirectory.resolvePath(file);
			var fStream:FileStream = new FileStream();
			fStream.open(jsonFile, FileMode.READ);
			var data:String = fStream.readUTFBytes(fStream.bytesAvailable);
			fStream.close();
			
			return JSON.parse(data);
		}
	}

}