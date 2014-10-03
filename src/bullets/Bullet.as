package bullets 
{
	import core.Entity;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import sat_collision.CollidableEntity;
	/**
	 * ...
	 * @author fabio
	 */
	public class Bullet extends CollidableEntity
	{
		public static const SHOT : String = "shot";
		public static const MISSILE : String = "missile";
		public static const CIRCULAR : String = "circular";
		public static const LONG : String = "long";
		
		protected var _direction : Number = 0;
		protected var _targetDirection : Number = 0;
		protected static const SMOOTHNESS : Number = 0.1;
		
		protected var _speed : Number;
		protected var _damage : Number;
		private var _asset : MovieClip;
		private var _bulletFactory:IBulletFactory;
		
		public function Bullet() 
		{
			
		}
		
		override public function update(dt : Number):void 
		{
			super.update(dt);
			
			updateDirection(dt);
			updateMotion(dt);
			
			if (x > stage.stageWidth || x + width < 0 || y > stage.stageHeight || y + height < 0)
			{
				removeSelf();
			}
		}
		
		protected function updateMotion (dt : Number) : void
		{
			x += _speed * Math.cos (-_direction) * dt;
			y -= _speed * Math.sin (-_direction) * dt;
		}
		
		protected function updateDirection (dt : Number) : void
		{
			_direction += (_targetDirection - _direction) * SMOOTHNESS;
			rotation = _direction / Math.PI * 180;
		}
		
		public function get damage():Number 
		{
			return _damage;
		}
		
		public function get asset():MovieClip 
		{
			return _asset;
		}
		
		public function loadData (data : Object) : void
		{
			_damage = data.damage;
			_direction = data.direction;
			_speed = data.speed;
			
			x += _speed * Math.cos (-_direction) * data.shotDelay;
			y -= _speed * Math.sin (-_direction) * data.shotDelay;
			rotation = _direction / Math.PI * 180;
			
			_asset = data.asset;
			addChild(_asset);
			
			if (data.targetDirection)
			{
				_targetDirection = data.targetDirection;
			}
			else
			{
				_targetDirection = _direction;
			}
		}
		
		public function setBulletFactory (bF : IBulletFactory) : void
		{
			_bulletFactory = bF;
		}
		
		override public function removeSelf():void 
		{
			super.removeSelf();
			removeChild(_asset);
			_bulletFactory.recycleBullet(this);
		}
	}
}