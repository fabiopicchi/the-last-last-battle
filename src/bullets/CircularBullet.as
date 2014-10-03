package bullets 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author fabio
	 */
	public class CircularBullet extends Bullet 
	{
		private var _phase : Number = 0;
		private var _curcular : Number = 0;
		private var _linear : Number = 0;
		
		private var _xC : Number;
		private var _yC : Number;
		private var _period : Number;
		private var _radius : Number;
		private var _clockWise : Boolean;
		
		public function CircularBullet() 
		{
			
		}
		
		override protected function updateMotion(dt : Number):void 
		{
			if (_clockWise)
				_phase += 2 * Math.PI / _period * dt;
			else
				_phase -= 2 * Math.PI / _period * dt;
			
			_xC += _speed * Math.cos(-_direction) * dt;
			_yC -= _speed * Math.sin(-_direction) * dt;
			
			x = _xC + (_radius * Math.cos(_phase) * Math.cos (-_direction) - _radius * Math.sin(_phase) * Math.sin(-_direction));
			y = _yC - (_radius * Math.cos(_phase) * Math.sin (-_direction) + _radius * Math.sin(_phase) * Math.cos(-_direction));
		}
		
		override public function loadData(data:Object):void 
		{	
			super.loadData(data);
			
			_period = data.period;
			_radius = data.radius;
			_clockWise = data.clockWise;
			
			_phase = Math.PI;
			_curcular = 0;
			_linear = 0;
			
			_xC = x + _radius * Math.cos(-_direction);
			_yC = y - _radius * Math.sin(-_direction);
		}
	}

}