package cannons 
{
	import bullets.Bullet;
	import bullets.IBulletFactory;
	import core.Entity;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import ships.Ship;
	import utils.BitFlagControl;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class Cannon extends Entity
	{
		//Direction the cannon is aiming
		protected var _direction : Number = 0;
		
		//Offset relative to the center of the parent ship
		protected var _offset : Point = new Point (0, 0);
		
		//Entity that the cannon is aiming
		protected var _target : Entity;
		
		protected var _parentShip : Ship;
		
		protected var _bulletData : Object;
		
		/*
		 * Firing control variables
		*/
		protected var _fireRate : Number = 2;
		protected var _fireCooldown : Number = 0;
		protected var _continuous : Boolean = false;
		protected var _continuousBullet : Bullet = null;
		
		//Sound played when cannon is fired
		protected var _sfx : ShotFx = new ShotFx();
		protected static var _sfxChannel : SoundChannel;
		protected var _sfxChannelTransform : SoundTransform = new SoundTransform(0.1);
		
		protected var _bulletFactory : IBulletFactory;
		
		protected var _state : BitFlagControl = new BitFlagControl ();
		public static const SHOOTING : String = "shooting";
		public static const ACTIVE : String = "active";
		
		public function Cannon() 
		{
			
		}
		
		protected function shoot () : void
		{
			if (!_continuous)
			{
				_bulletData.shotDelay = -_fireCooldown;
				_bulletData.direction = _direction;
				_bulletFactory.createBullet(_bulletData, this);
			}
		}
		
		override public function update (dt : Number) : void
		{
			super.update(dt);
			_state.update();
			
			if (_state.flagJustSet(SHOOTING))
			{
				startShooting();
			}
			else if (_state.flagJustReset(SHOOTING))
			{
				stopShooting();
			}
			
			if (_state.flagSet(SHOOTING))
			{
				onShooting(dt);
			}
			
			scaleX = _parentShip.scaleX;
			scaleY = _parentShip.scaleY;
			
			x = _parentShip.x + _offset.x * scaleX;
			y = _parentShip.y + _offset.y * scaleY;
			
			if (_target) _direction = Math.atan2(_target.y + _target.height / 2 - y, _target.x  + _target.width / 2 - x);
			
			rotation = _direction / Math.PI * 180;
		}
		
		protected function onShooting (dt : Number) : void
		{
			if (!_continuous)
			{
				if (_fireCooldown > 0)
				{
					_fireCooldown -= dt;
				}
				else
				{
					shoot();
					_fireCooldown += 1 / _fireRate;
					if (_parentShip.side == GameContext.ALLY)
					{
						if (_sfxChannel) _sfxChannel.stop();
						_sfxChannel = _sfx.play();
						_sfxChannel.soundTransform = _sfxChannelTransform
					}
				}
			}
			else
			{
				shoot();
			}
		}
		
		public function loadData(data:Object) : void
		{
			_direction = data.direction;
			_fireRate = data.fireRate;
			_bulletData = data.bulletData;
			
			if (data.bulletData.type == GameContext.RAY)
			{
				_continuous = true;
			}
			else
			{
				_continuous = false;
			}
			
			rotation = _direction / Math.PI * 180;
			
			_state.addFlag(SHOOTING);
			_state.addFlag(ACTIVE);
		}
		
		public function setParentShip(ship:Ship)  : void
		{
			_parentShip = ship;
			_bulletData.side = _parentShip.side;
		}
		
		public function setBulletFactory(bF:IBulletFactory) : void
		{
			_bulletFactory = bF;
		}
		
		public function setTarget(e:Entity) : void
		{
			_target = e;
		}
		
		public function removeTarget() : void
		{
			_target = null;
		}
		
		public function get offset():Point 
		{
			return _offset;
		}
		
		public function set offset(value:Point):void 
		{
			_offset = value;
		}
		
		public function get direction():Number 
		{
			return _direction;
		}
		
		protected function startShooting () : void
		{
			if (_continuous)
			{
				_continuousBullet = _bulletFactory.createBullet(_bulletData, this);
			}
		}
		
		protected function stopShooting () : void
		{
			if (_continuous && _continuousBullet)
			{
				_continuousBullet.removeSelf();
				_continuousBullet = null;
			}
		}
		
		public function activate() : void
		{
			_state.setFlag(SHOOTING);
			_state.setFlag(ACTIVE);
			_fireCooldown = 0;
		}
		
		public function deactivate () : void
		{
			_state.resetFlag(SHOOTING);
			_state.resetFlag(ACTIVE);
		}
	}
}