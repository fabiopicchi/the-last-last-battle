package cannons 
{
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class StrafeCannon extends Cannon 
	{
		private var _sweepAngle : Number;
		private var _period : Number;
		private var _steps : int;
		private var _waitInterval : Number;
		private var _aimedDirection : Number;
		
		private var _waitingTimer : Number = 0;
		private var _currentStep : Number = 0;
		private var _directionOffset : Number = 0;
		
		public static const RETURNNG : String = "returning";
		
		public function StrafeCannon() 
		{
			
		}
		
		override public function update(dt:Number):void 
		{
			if (_state.flagSet(ACTIVE))
			{
				if (!_state.flagSet(SHOOTING))
				{
					if (!_state.flagSet(RETURNNG))
					{
						_directionOffset += _sweepAngle / (_period / 2) * dt;
						if ((_sweepAngle > 0 && _directionOffset >= _sweepAngle * ( -0.5 + (_currentStep + 1) / _steps)) || 
								(_sweepAngle < 0 && _directionOffset <= _sweepAngle * ( -0.5 + (_currentStep + 1) / _steps)))
						{
							_directionOffset = _sweepAngle * ( -0.5 + (++_currentStep) / _steps);
							_waitingTimer += _waitInterval;
							_state.setFlag(SHOOTING);
							if (_currentStep == _steps)
								_state.setFlag(RETURNNG);
						}
					}
					else
					{
						_directionOffset -= _sweepAngle / (_period / 2) * dt;
						if ((_sweepAngle > 0 && _directionOffset <= _sweepAngle * ( -0.5 + (_currentStep - 1) / _steps)) || 
								(_sweepAngle < 0 && _directionOffset >= _sweepAngle * ( -0.5 + (_currentStep - 1) / _steps)))
						{
							_directionOffset = _sweepAngle * ( -0.5 + (--_currentStep) / _steps);
							_waitingTimer += _waitInterval;
							_state.setFlag(SHOOTING);
							if (_currentStep == 0)
								_state.resetFlag(RETURNNG);
						}
					}
				}
				else
				{
					_waitingTimer -= dt;
					if (_waitingTimer <= 0)
					{
						_state.resetFlag(SHOOTING);
					}
				}
			}
			
			_direction = _aimedDirection + _directionOffset;
			super.update(dt);
			
			if (_target) 
			{
				_aimedDirection = _direction;
				_direction = _aimedDirection + _directionOffset;
			}
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_sweepAngle = data.sweepAngle;
			_period = data.period;
			_steps = data.steps;
			_waitInterval = data.waitInterval;
			_waitingTimer = _waitInterval;
			_directionOffset = -_sweepAngle / 2;
			
			_state.addFlag(RETURNNG);
			_aimedDirection = _direction;
		}
	}

}