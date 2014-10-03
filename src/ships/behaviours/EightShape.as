package ships.behaviours 
{
	import core.Entity;
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class EightShape extends Behaviour 
	{
		private var _vx : Number;
		private var _vy : Number;
		private var _step : Number;
		private var _radius : Number;
		private var _x0 : Number;
		
		public function EightShape() 
		{
			
		}
		
		override public function setTarget(e:Ship):void 
		{
			super.setTarget(e);
			_x0 = _target.xStart;
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_step = 0;
			_radius = data.radius;
		}
		
		override public function update(dt:Number):void 
		{
			_step = Math.floor(_timer  / (_period / 4));
			_vx = _radius * Math.sin(_timer / (_period / 2) * 2 * Math.PI);
			_vy = _radius / (_period / 4);
			if (_step == 0 || _step == 3)
			{
				_vy *= -1;
			}
			
			_target.vx = (_x0 + _vx - _target.x) / dt;
			_target.vy = _vy;
			
			super.update(dt);
		}
	}

}