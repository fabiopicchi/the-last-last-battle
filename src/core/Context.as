package core 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import utils.BitFlagControl;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class Context extends MovieClip 
	{
		protected var _inputFlagControl : BitFlagControl = new BitFlagControl();
		protected var _game : Game;
		
		public function Context() 
		{
		}
		
		public function init () : void
		{
			
		}
		
		public function update (dt : Number) : void
		{
			_inputFlagControl.update();
			
			for (var i : int = 0; i < numChildren; i++)
			{
				var c : DisplayObject = getChildAt(i);
				if (c is Entity)
				{
					updateEntity(c as Entity, dt);
				}
			}
		}
		
		public function updateEntity (e : Entity, dt : Number) : void
		{
			e.update(dt);
		}
		
		public function draw () : void
		{
			for (var i : int = 0; i < numChildren; i++)
			{
				var c : DisplayObject = getChildAt(i);
				if (c is Entity)
				{
					drawEntity(c as Entity);
				}
			}
		}
		
		public function drawEntity (e : Entity) : void
		{
			e.draw();
		}
		
		public final function translateRawInput (keyCode : int, pressed : Boolean) : void
		{
			var strCode : String = getActionCode (keyCode);
			
			if (_inputFlagControl.isFlagRegistered(strCode))
			{
				if (pressed)
				{
					_inputFlagControl.setFlag(strCode);
				}
				else
				{
					_inputFlagControl.resetFlag(strCode);
				}
			}
		}
		
		protected function getActionCode (keyCode : int) : String
		{
			return "";
		}
		
		public function set game(value:Game):void 
		{
			_game = value;
		}
	}

}