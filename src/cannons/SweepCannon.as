package cannons 
{
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class SweepCannon extends Cannon 
	{
		private var _directionOffset : Number;
		private var _aimedDirection : Number;
		private var _sweepAngle : Number;
		private var _period : Number;
		
		public static const RETURNNG : String = "returning";
		
		public function SweepCannon() 
		{
			
		}
		
		override public function update(dt:Number):void 
		{
			if (_state.flagSet(SHOOTING))
			{
				if (!_state.flagSet(RETURNNG))
				{
					_directionOffset += _sweepAngle / (_period / 2) * dt;
					if ((_sweepAngle > 0 && _directionOffset >= _sweepAngle / 2) || 
							(_sweepAngle < 0 && _directionOffset <= _sweepAngle / 2))
					{
						_directionOffset = _sweepAngle / 2;
						_state.setFlag(RETURNNG);
					}
				}
				else
				{
					_directionOffset -= _sweepAngle / (_period / 2) * dt;
					if ((_sweepAngle > 0 && _directionOffset <= (-_sweepAngle / 2)) || 
							(_sweepAngle < 0 && _directionOffset >= (-_sweepAngle / 2)))
					{
						_directionOffset = -_sweepAngle / 2;
						_state.resetFlag(RETURNNG);
					}
				}
			}
			
			super.update(dt);
			if (_target) _aimedDirection = _direction;
			_direction = _aimedDirection + _directionOffset;
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_sweepAngle = data.sweepAngle;
			_period = data.period;
			_directionOffset = -_sweepAngle / 2;
			
			_state.addFlag(RETURNNG);
			_aimedDirection = _direction;
			
		}
	}

}