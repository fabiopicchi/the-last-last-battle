package bullets 
{
	import cannons.Cannon;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import sat_collision.CollidableEntity;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class Ray extends Bullet 
	{
		private var _warn : Sprite;
		private var _parentCannon : Cannon;
		private var _directionOffset : Number;
		
		public function Ray() 
		{
			var s : Shape = new Shape ();
			s.graphics.beginFill(0xFF00FF);
			s.graphics.drawRect(0, 0, 1100, 10);
			s.graphics.endFill();
			
			s.x = 0;
			s.y = -5;
			
			addChild(s);
		}
		
		override public function update(dt : Number):void 
		{
			//if (_warn.width >= 1100)
			//{
				//super.update(dt);
			//}
			//else
			//{
				//
			//}
			_direction = _parentCannon.direction + _directionOffset;
			x = _parentCannon.x;
			y = _parentCannon.y;
			rotation = _direction / Math.PI * 180;
		}
		
		public function setParentCannon (c : Cannon) : void
		{
			_parentCannon = c;
			_direction = c.direction;
			_targetDirection = _direction;
		}
		
		override public function loadData(data:Object):void 
		{
			if (data.direction != _direction)
			{
				_directionOffset = data.direction - _direction;
			}
			else
			{
				_directionOffset = 0;
			}
			super.loadData(data);
			
			_speed = 0;
		}
	}
}