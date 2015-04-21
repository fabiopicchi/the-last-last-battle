package core 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class Entity extends MovieClip 
	{
		public function Entity() 
		{
			
		}
		
		public function update (dt : Number) : void
		{
			
		}
		
		public function draw () : void
		{
			
		}
		
		public function removeSelf () : void
		{
			parent.removeChild(this);
		}
	}
}