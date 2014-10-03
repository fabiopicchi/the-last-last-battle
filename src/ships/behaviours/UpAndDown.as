package ships.behaviours 
{
	import core.Entity;
	import ships.Ship;
	/**
	 * ...
	 * @author fabio
	 */
	public class UpAndDown extends Behaviour 
	{
		private var _vy : Number;
		private var _step : Number;
		private var _radius : Number;
		
		public function UpAndDown() 
		{
		}
		
		override public function setTarget(e:Ship):void 
		{
			super.setTarget(e);
		}
		
		override public function update(dt:Number):void 
		{
			_step = Math.floor(_timer  / (_period / 8));
			_vy = _radius / (_period / 8);
			if (_step % 2 != 0)
			{
				if (_step == 3 || _step == 5)
				{
					_vy *= -1;
				}
			}
			else
			{
				_vy = 0;
			}
			
			_target.vy = _vy;
			
			super.update(dt);
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_step = 0;
			_radius = data.radius;
		}
		
	}

}