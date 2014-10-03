package ships.behaviours 
{
	import ships.Ship;
	import utils.BitFlagControl;
	/**
	 * ...
	 * @author fabio
	 */
	public class Behaviour implements IBehaviour 
	{
		protected var _shootingPatterns : Array;
		protected var _period : Number;
		protected var _shootingPatternStep : int;
		protected var _target : Ship;
		protected var _state : BitFlagControl = new BitFlagControl();
		protected var _timer : Number;
		protected static const STEP : String = "step";
		
		public function Behaviour() 
		{
			
		}
		
		/* INTERFACE ships.behaviours.IBehaviour */
		
		public function setTarget(e:Ship):void 
		{
			_target = e;
		}
		
		public function update(dt:Number):void 
		{
			_state.update();
			_shootingPatternStep = Math.floor(_timer  / (_period / _shootingPatterns.length));
			
			if (!_state.flagSet(STEP + _shootingPatternStep))
			{
				for (var i : int = 0; i < _shootingPatterns.length; i++)
				{
					_state.resetFlag(STEP + i);
				}
				_target.stopShooting();
				_state.setFlag(STEP + _shootingPatternStep);
				_target.startShooting(_shootingPatterns[_shootingPatternStep]);
			}
			
			_timer += dt;
			if (_timer >= _period) _timer -= _period;
		}
		
		public function loadData(data:Object):void 
		{
			_shootingPatterns = data.shootingPatterns;
			_timer = 0;
			_period = data.period;
			
			for (var i : int = 0; i < _shootingPatterns.length; i++)
			{
				_state.addFlag(STEP + i);
			}
		}
		
	}

}