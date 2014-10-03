package core 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class Game extends Sprite 
	{
		protected var _dt : int = 0;
		protected var _time : int = 0;
		protected var _step : int = 1000 / 60;
		protected var _maxAccumulation : int;
		protected var _accumulator : int;
		protected var _currentContext : Context;
		
		public function Game() 
		{
			addEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_time = getTimer();
			
			stage.frameRate = 30;
			_maxAccumulation = 2000 / stage.frameRate - 1;
			
			stage.addEventListener(Event.ENTER_FRAME, run);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
		}
		
		protected function run(e:Event):void 
		{	
			var cTime : int = getTimer();
			_dt = cTime - _time;
			_time = cTime;
			
			_accumulator += _dt;
			if (_accumulator > _maxAccumulation)
				_accumulator = _maxAccumulation;
			
			while (_accumulator >= _step)
			{
				_currentContext.update(_step / 1000);
				_currentContext.draw();
				_accumulator -= _step;
			}
		}
		
		protected function onKeyReleased(e:KeyboardEvent):void 
		{
			if (_currentContext)
			{
				_currentContext.translateRawInput(e.keyCode, false);
			}
		}
		
		protected function onKeyPressed(e:KeyboardEvent):void 
		{
			if (_currentContext)
			{
				_currentContext.translateRawInput(e.keyCode, true);
			}
		}
		
		public function switchContext (c : Context) : void
		{
			if (_currentContext)
			{
				removeChild(_currentContext);
			}
			_currentContext = c;
			_currentContext.game = this;
			_currentContext.init();
			addChild (_currentContext);
		}
	}

}