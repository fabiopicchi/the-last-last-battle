package 
{
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import core.Game;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class TheLastLastBattle extends Game 
	{
		public function TheLastLastBattle ():void 
		{
			TweenPlugin.activate([SoundTransformPlugin]);
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
			switchContext (new MenuContext);
		}
		
	}
	
}