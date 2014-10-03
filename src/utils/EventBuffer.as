package utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class EventBuffer 
	{
		private var _parent : EventDispatcher;
		private var _buffer : Array = [];
		private var _callbackMap : Dictionary = new Dictionary ();
		private var _locked : Boolean = false;
		
		public function EventBuffer(parent : EventDispatcher) 
		{
			_parent = parent;
		}
		
		public function registerEvent (eventCode : String, callback : Function) : void
		{
			_callbackMap[eventCode] = callback;
			_parent.addEventListener(eventCode, addToBuffer);
		}
		
		private function addToBuffer(e:Event):void 
		{
			_buffer.push(e);
		}
		
		public function update () : void
		{
			if (!_locked)
			{
				if (_buffer.length > 0)
				{
					var e : Event = _buffer.shift();
					if (_callbackMap[e.type] != null)
						_callbackMap[e.type](e);
					else
					{
						
					}
				}
			}
		}
		
		public function get locked():Boolean 
		{
			return _locked;
		}
		
		public function lock():void 
		{
			_locked = true;
		}
		
		public function unlock():void 
		{
			_locked = false;
		}
	}

}