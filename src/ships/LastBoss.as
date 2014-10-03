package ships 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author fabio
	 */
	public class LastBoss extends Ship 
	{
		private var _upHand : Ship;
		
		private var _downHand : Ship;
		
		private var _head : Ship;
		
		private var _mouth : Ship;
		
		public function LastBoss() 
		{
			
		}
		
		override public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean 
		{
			return (_upHand.hitTestPoint(x, y, shapeFlag) ||
					_downHand.hitTestPoint(x, y, shapeFlag) ||
					_head.hitTestPoint(x, y, shapeFlag) ||
					_mouth.hitTestPoint(x, y, shapeFlag));
		}
		
		override public function update(dt : Number):void 
		{
			if (_state.flagSet(DEFEATED))
			{
				trace ("");
			}
			super.update(dt);
			_upHand.update(dt);
			_downHand.update(dt);
			_head.update(dt);
			_mouth.update(dt);
		}
		
		override protected function onDefeat():void 
		{
			stopShooting();
			TweenLite.to(_mouth, 3.0, { y : 114, ease : Linear.easeInOut} );
		}
		
		override public function hit(damage:Number):void 
		{
			if (_state.noFlagSet())
			{
				_health -= damage;
				_upHand.hit(0);
				_downHand.hit(0);
				_head.hit(0);
				_mouth.hit(0);
				
				if (_health <= 0)
				{
					_health = 0;
					_state.setFlag (DEFEATED);
					trace ("DEFEAT");
				}
			}
		}
		
		override public function get defeated():Boolean 
		{
			return (_state.flagSet (DEFEATED) && _mouth.y == 114);
		}
		
		override public function loadData(data:Object):void 
		{
			super.loadData(data);
			_upHand = new Ship ();
			_downHand = new Ship ();
			_head = new Ship ();
			_mouth = new Ship ();
			
			_upHand.loadData({type : UP_HAND, xStart:-216, yStart :-220});
			_head.loadData({type : HEAD, xStart:-153, yStart :-220});
			_mouth.loadData( { type : MOUTH, xStart:-161, yStart :35 } );
			_downHand.loadData({type : DOWN_HAND, xStart:-201, yStart :148});
			
			addChild(_mouth);
			addChild(_head);
			addChild(_upHand);
			addChild(_downHand);
		}
	}
}