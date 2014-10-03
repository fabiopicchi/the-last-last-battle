package  
{
	import core.Context;
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class MenuContext extends Context 
	{
		private var _menuAsset : MenuAsset;
		private static const UP : String = "UP";
		private static const DOWN : String = "DOWN";
		private static const ENTER : String = "ENTER";
		
		private var _musicChannel : SoundChannel;
		private var _theme : MenuTheme = new MenuTheme;
		private var _select : ClickFx = new ClickFx;
		
		public function MenuContext() 
		{
			_inputFlagControl.addFlag(ENTER);
			_inputFlagControl.addFlag(UP);
			_inputFlagControl.addFlag(DOWN);
			
			addChild(new Background);
			addChild (_menuAsset = new MenuAsset);
			
			_menuAsset.stop();
			_menuAsset.cursorCredits.visible = false;
			
			_musicChannel = _theme.play();
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			if (_inputFlagControl.flagJustSet(ENTER))
			{
				if (_menuAsset.currentFrame == 1)
				{
					if (_menuAsset.cursorStart.visible)
					{
						_musicChannel.stop();
						_game.switchContext(new GameContext);
					}
					else if (_menuAsset.cursorCredits.visible)
					{
						_menuAsset.gotoAndStop(2);
					}
				}
				else
				{
					_menuAsset.gotoAndStop(1);
					_menuAsset.cursorStart.visible = false;
				}
			}
			
			if (_menuAsset.currentFrame == 1)
			{
				if (_inputFlagControl.flagJustSet(UP) || _inputFlagControl.flagJustSet(DOWN))
				{
					_select.play();
					if (_menuAsset.cursorStart.visible)
					{
						_menuAsset.cursorCredits.visible = true;
						_menuAsset.cursorStart.visible = false;
					}
					else
					{
						_menuAsset.cursorCredits.visible = false;
						_menuAsset.cursorStart.visible = true;
					}
				}
			}
		}
		
		override protected function getActionCode(keyCode:int):String 
		{			
			switch (keyCode)
				{
					case 38:
						return UP;
						
					case 40:
						return DOWN;
					default:
						return ENTER;
				}
		}
	}
}