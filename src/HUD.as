package  
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import core.Entity;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import utils.BitFlagControl;
	/**
	 * ...
	 * @author fabio
	 */
	public class HUD extends Entity 
	{
		private var _hudVisual : GameHUD;
		
		private var _text : String;
		private var _textTime : Number = 0;
		private var _textCounter : int = 0;
		private static const _LETTER_INTERVAL : Number = 0.035;
		private static const _DISPLAY_LASTING : Number = 2.0;
		
		public static const SIRENA : String = "s";
		public static const NEZLE : String = "n";
		public static const POLVEELO : String = "p";
		
		private var _currentSpeaker : String;
		private var _speakerStatus : String;
		
		private static const TYPING_TEXT : String = "tt";
		private static const DISPLAYING_TEXT : String = "dt";
		private var _state : BitFlagControl = new BitFlagControl ();
		
		private var _arDialog : Array;
		private var _currentText : int;
		
		public function HUD() 
		{
			_hudVisual = new GameHUD;
			addChild(_hudVisual);
			_hudVisual.textDisplay.text = "";
			_hudVisual.polveelo.visible = false;
			
			_hudVisual.polveelo.addEventListener(Event.COMPLETE, animationComplete);
			_hudVisual.sirena.addEventListener(Event.COMPLETE, animationComplete);
			_hudVisual.nezle.addEventListener(Event.COMPLETE, animationComplete);
			
			_hudVisual.polveelo.gotoAndStop(1);
			_hudVisual.sirena.gotoAndStop(1);
			_hudVisual.nezle.gotoAndStop(1);
			
			_state.addFlag(TYPING_TEXT);
			_state.addFlag(DISPLAYING_TEXT);
		}
		
		private function animationComplete(e:Event):void 
		{
			switch (_currentSpeaker)
			{
				case NEZLE:
					_hudVisual.nezle.gotoAndPlay(_speakerStatus);
					break;
				case SIRENA:
					_hudVisual.sirena.gotoAndPlay(_speakerStatus);
					break;
				case POLVEELO:
					_hudVisual.polveelo.visible = true;
					_hudVisual.polveelo.gotoAndPlay(_speakerStatus);
					break;
			}
		}
		
		public function displayDialog (ar : Array) : void
		{
			if (_state.flagSet(DISPLAYING_TEXT))
			{
				closeText();
				_hudVisual.nezle.gotoAndStop("happy");
				_hudVisual.sirena.gotoAndStop("normal");
				_hudVisual.polveelo.visible = false;
				_hudVisual.polveelo.gotoAndStop("normal");
			}
			
			_arDialog = ar;
			_currentText = 0;
			nextText();
		}
		
		private function nextText () : void
		{
			if (_currentText < _arDialog.length)
			{
				displayText(_arDialog[_currentText].text, _arDialog[_currentText].speaker, _arDialog[_currentText].speakerStatus);
			}
			else
			{
				_hudVisual.nezle.gotoAndStop("happy");
				_hudVisual.sirena.gotoAndStop("normal");
				_hudVisual.polveelo.visible = false;
				_hudVisual.polveelo.gotoAndStop("normal");
			}
			_currentText++;
		}
		
		private function displayText(text : String, speaker : String, speakerStatus : String) : void
		{
			_textCounter = 0;
			_textTime = 0;
			_currentSpeaker = speaker;
			_speakerStatus = speakerStatus;
			_text = text.split("#lb").join('\n');
			_textCounter = 0;
			_textTime = 0;
			_state.setFlag(TYPING_TEXT);
			_state.setFlag(DISPLAYING_TEXT);
			
			switch (_currentSpeaker)
			{
				case NEZLE:
					_hudVisual.nezle.gotoAndPlay(_speakerStatus);
					break;
				case SIRENA:
					_hudVisual.sirena.gotoAndPlay(_speakerStatus);
					break;
				case POLVEELO:
					_hudVisual.polveelo.visible = true;
					_hudVisual.polveelo.gotoAndPlay(_speakerStatus);
					break;
			}
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			_state.update();
			
			if (_state.flagSet(DISPLAYING_TEXT))
			{
				_textTime += dt;
				if (_state.flagSet(TYPING_TEXT))
				{
					if (_textTime >= _LETTER_INTERVAL)
					{
						_textTime = 0;
						_hudVisual.textDisplay.text = _text.slice(0, _textCounter);
						_textCounter++;
						if (_textCounter > _text.length)
						{
							_state.resetFlag(TYPING_TEXT);
							switch (_currentSpeaker)
							{
								case NEZLE:
									_hudVisual.nezle.gotoAndStop(_speakerStatus);
									break;
								case SIRENA:
									_hudVisual.sirena.gotoAndStop(_speakerStatus);
									break;
								case POLVEELO:
									_hudVisual.polveelo.gotoAndStop(_speakerStatus);
									break;
							}
						}
					}
				}
				else
				{
					if (_textTime >= _DISPLAY_LASTING)
					{
						closeText();
						nextText();
					}
				}
			}
		}
		
		private function closeText() : void
		{
			_hudVisual.textDisplay.text = "";
			_state.resetFlag(DISPLAYING_TEXT);
			if (_currentSpeaker == POLVEELO)
			{
				_hudVisual.polveelo.visible = false;
				_hudVisual.polveelo.gotoAndStop(_speakerStatus);
			}
		}
		
		public function get displayingText () : Boolean
		{
			return _state.flagSet(DISPLAYING_TEXT);
		}
		
		public function setHP (value : Number, character : String) : void
		{
			switch (character)
			{
				case SIRENA:
				case POLVEELO:
					TweenLite.to(_hudVisual.sirenaAvatarContainer.hpMask, 1.0, {scaleX : value, ease : Linear.easeInOut});
					break;
				case NEZLE:
					TweenLite.to(_hudVisual.nezleAvatarContainer.hpMask, 1.0, {scaleX : value, ease : Linear.easeInOut});
					break;
			}
		}
	}
}