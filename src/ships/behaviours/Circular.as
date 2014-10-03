package ships.behaviours 
{
	import core.Entity;
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class Circular extends Behaviour
	{
		private var _step : Number;
		private var _radius : Number;
		private var _x0 : Number;
		private var _y0 : Number;
		
		public function Circular() 
		{
			
		}
		
		/* INTERFACE ships.behaviours.IBehaviour */
		
		override public function setTarget(e:Ship):void 
		{
			super.setTarget(e);
			_x0 = _target.xStart;
			_y0 = _target.yStart;
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_step = 0;
			_radius = data.radius;
		}
		
		override public function update(dt:Number):void 
		{
			_target.vx = ((_x0 + _radius) - _radius * Math.cos(_timer / _period * 2 * Math.PI) - _target.x) / dt;
			_target.vy = (_y0 + _radius * Math.sin(_timer / _period * 2 * Math.PI) - _target.y) / dt;
			
			super.update(dt);
		}
	}

}