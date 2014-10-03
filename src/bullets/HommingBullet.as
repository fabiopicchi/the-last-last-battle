package bullets 
{
	import core.Entity;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class HommingBullet extends Bullet 
	{
		private var _target : Entity;
		
		private var _hommingTimer : Number = 0;
		private var _timer : Number = 0;
		
		private var _startingSpeed : Number;
		private var _targetSpeed : Number;
		private var _acc : Number;
		
		private var _angularVelocity : Number;
		private var _angularAcc : Number;
		
		public function HommingBullet() 
		{
			
		}
		
		override public function update(dt : Number):void 
		{
			if (_timer >= _hommingTimer)
			{
				var nextTargetDir : Number = Math.atan2((_target.y - y), (_target.x - x)) % (2 * Math.PI);
				
				if (nextTargetDir - _targetDirection > Math.PI)
					_direction += 2 * Math.PI;
				else if (nextTargetDir - _targetDirection < -Math.PI)
					_direction -= 2 * Math.PI;
				
				_targetDirection = nextTargetDir;
				
				if (_speed < _targetSpeed)
					_speed += _acc * dt;
				else
					_speed = _targetSpeed;
				
				super.update(dt);
			}
			else
			{
				_timer += dt;
				
				rotation += _angularVelocity * dt;
				_angularVelocity += (_angularAcc / _hommingTimer) * dt;
				_speed -= (0.9 * _startingSpeed / _hommingTimer) * dt;
				
				super.updateMotion(dt);
				
				if (_timer >= _hommingTimer)
				{
					_acc = (_targetSpeed - _speed) / 0.5;
				}
			}
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			
			_targetSpeed = _speed;
			_speed = data.startingSpeed;
			_startingSpeed = _speed;
			
			if (_direction > Math.PI)
			{
				_angularVelocity = 1050;
				_angularAcc = -1000 / _hommingTimer;
			}
			else
			{
				_angularVelocity = -1050;
				_angularAcc = 1000 / _hommingTimer;
			}
			
			if (data.hommingTimer)
			{
				_hommingTimer = data.hommingTimer;
			}
			else
			{
				_acc = _targetSpeed / 0.5;
			}
		}
		
		public function setTarget (e : Entity) : void
		{
			_target = e;
		}
	}

}