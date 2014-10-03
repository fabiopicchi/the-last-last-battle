package cannons 
{
	import bullets.Bullet;
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class SpreadCannon extends Cannon 
	{
		private var _nBullets : uint;
		private var _spreadAngle : Number;
		private var _arContinuosBullet : Array = [];
		
		public function SpreadCannon() 
		{
			
		}
		
		override protected function shoot():void 
		{
			if (_nBullets <= 1)
			{
				super.shoot();
			}
			else
			{
				var i : int;
				if (_spreadAngle / (_nBullets - 1) <= 2 * Math.PI - _spreadAngle)
				{
					for (i = 0; i < _nBullets; i++)
					{
						_bulletData.direction = (_direction - _spreadAngle / 2) + i * _spreadAngle / (_nBullets - 1);
						if (!_continuous)
						{
							_bulletData.shotDelay = -_fireCooldown;
							_bulletFactory.createBullet(_bulletData, this);
						}
					}
				}
				else
				{
					for (i = 0; i < _nBullets; i++)
					{
						_bulletData.direction = _direction + i * 2 * Math.PI / _nBullets;
						if (!_continuous)
						{
							_bulletData.shotDelay = -_fireCooldown;
							_bulletFactory.createBullet(_bulletData, this);
						}
					}
				}
			}
		}
		
		//TODO : review this copy pasted code
		
		override protected function startShooting():void 
		{
			if (_nBullets <= 1)
			{
				super.startShooting();
			}
			else if (_continuous)
			{
				var i : int;
				if (_spreadAngle / (_nBullets - 1) <= 2 * Math.PI - _spreadAngle)
				{
					for (i = 0; i < _nBullets; i++)
					{
						_bulletData.direction = (_direction - _spreadAngle / 2) + i * _spreadAngle / (_nBullets - 1);
						_arContinuosBullet.push(_bulletFactory.createBullet(_bulletData, this));
					}
				}
				else
				{
					for (i = 0; i < _nBullets; i++)
					{
						_bulletData.direction = _direction + i * 2 * Math.PI / _nBullets;
						_arContinuosBullet.push(_bulletFactory.createBullet(_bulletData, this));
					}
				}
			}
		}
		
		override protected function stopShooting():void 
		{
			if (_nBullets <= 1)
			{
				super.stopShooting();
			}
			else
			{
				if (_continuous && _arContinuosBullet.length)
				{
					for each (var b : Bullet in _arContinuosBullet)
					{
						b.removeSelf();
					}
					_arContinuosBullet = [];
				}
			}
		}
		
		private function spreadShot (direction : Number) : void
		{
			if (!_continuous)
			{
				_bulletData.shotDelay = -_fireCooldown;
				_bulletData.direction = direction;
				_bulletFactory.createBullet(_bulletData, this);
			}
			else
			{
				if (_state.flagJustSet(SHOOTING))
				{
					_arContinuosBullet.push(_bulletFactory.createBullet(_bulletData, this));
				}
			}
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_spreadAngle = data.spreadAngle;
			_nBullets = data.nBullets;
		}
	}

}