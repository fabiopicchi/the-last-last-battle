package sat_collision
{
	/**
	 * ...
	 * @author 
	 */
	internal class Vec2 
	{
		private var _size : Number = 0;
		private var _angle : Number = 0;
		private var _x : Number = 0;
		private var _y : Number = 0;
		
		public function Vec2(x : Number, y : Number) 
		{
			_x = x;
			_y = y;
			_size = Math.sqrt (x * x + y * y);
			_angle = Math.atan (y / x);
		}
		
		public function get x () : Number
		{
			return _x;
		}
		
		public function get y () : Number
		{
			return _y;
		}
		
		public function set x (x : Number) : void
		{
			_x = x;
			_size = Math.sqrt (x * x + y * y);
			_angle = Math.atan2 (y, x);
		}
		
		public function set y (y : Number) : void
		{
			_y = y;
			_size = Math.sqrt (x * x + y * y);
			_angle = Math.atan2 (y, x);
		}
		
		public function get angle():Number 
		{
			return _angle;
		}
		
		public function rotate(angle : Number) : Vec2
		{
			_angle += angle;
			
			if (_angle >= 2 * Math.PI)
			{
				_angle -= 2 * Math.PI
			}
			else if (_angle < 0)
			{
				_angle += 2 * Math.PI;
			}
			
			var newX : Number = Math.floor(100 * (_x * Math.cos(angle) - _y * Math.sin(angle))) / 100;
			var newY : Number = Math.floor(100* (_x * Math.sin(angle) + _y * Math.cos(angle))) / 100;
			
			_x = newX;
			_y = newY;
			
			return this;
		}
		
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size(size: Number) : void
		{
			_size = size;
			_x = _size * Math.cos (_angle);
			_y = _size * Math.sin (_angle);
		}
		
		public function dot(v : Vec2) : Number
		{
			return _x * v.x + _y * v.y;
		}
		
		public function cross (v : Vec2) : Number
		{
			return _x * v.y - v.x * _y;
		}
		
		public function angleBetween (v : Vec2) : Number
		{
			return Math.acos (this.dot (v) / (_size + v.size));
		}
		
		public function normal () : Vec2
		{
			var vNormal : Vec2 = new Vec2 (-y, x);
			return vNormal;
		}
		
		public function normalize () : void
		{
			_x = _x / _size;
			_y = _y / _size;
		}
		
		public function add(v : Vec2) : Vec2
		{
			return new Vec2(v.x + _x, v.y + _y);
		}
	}

}