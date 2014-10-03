package bullets 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author fabio
	 */
	public class SenoidalBullet extends Bullet 
	{
		private var _phase : Number = 0;
		private var _senoidal : Number = 0;
		private var _linear : Number = 0;
		
		private var _xStart : Number;
		private var _yStart : Number;
		private var _period : Number;
		private var _radius : Number;
		private var _clockWise : Boolean;
		
		public function SenoidalBullet() 
		{
			
		}
		
		override protected function updateMotion(dt : Number):void 
		{
			if (_clockWise)
				_phase += 2 * Math.PI / _period * dt;
			else
				_phase -= 2 * Math.PI / _period * dt;
			
			_senoidal = _radius * Math.sin (_phase);
			_linear += _speed * dt;
			
			x = _xStart + _linear * Math.cos (-_direction) + _senoidal * Math.sin (_direction);
			y = _yStart - _linear * Math.sin (-_direction) - _senoidal * Math.cos (_direction);
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			
			_radius = data.radius;
			_period = data.period;
			_clockWise = data.clockWise;
			_xStart = x;
			_yStart = y;
			_senoidal = 0;
			_phase = 0;
			_linear = 0;
		}
	}

}