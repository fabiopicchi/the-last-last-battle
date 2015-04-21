package ships 
{
	import cannons.Cannon;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import core.Entity;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ships.behaviours.Behaviour;
	import ships.behaviours.Circular;
	import ships.behaviours.EightShape;
	import ships.behaviours.IBehaviour;
	import ships.behaviours.UpAndDown;
	import utils.BitFlagControl;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class Ship extends Entity 
	{
		protected var _arCannons : Vector.<Cannon> = new Vector.<Cannon> ();
		protected var _health : Number;
		protected var _maxHealth : Number;
		protected var _slotData : Array;
		protected var _cannonMap : Dictionary = new Dictionary ();
		
		protected var _behaviour : IBehaviour;
		
		public static const UP_DOWN : String = "upDown";
		public static const EIGHT_SHAPE : String = "eightShape";
		public static const CIRCULAR : String = "circular";
		
		protected static const PLAYER : String = "player";
		protected static const NORMAL : String = "normal";
		protected static const FANG : String = "fang";
		protected static const SKULL : String = "skull";
		static protected const HEAD:String = "head";
		static protected const UP_HAND:String = "upHand";
		static protected const DOWN_HAND:String = "downHand";
		static protected const MOUTH:String = "mouth";
		
		public var vx : Number = 0;
		public var vy : Number = 0;
		
		protected var _asset : MovieClip;
		protected static const ASSET_NORMAL : String = "normal";
		protected static const ASSET_UP : String = "up";
		protected static const ASSET_DOWN : String = "down";
		protected var _side : String;
		protected var _xStart : Number = 0;
		protected var _yStart : Number = 0;
		
		protected var _state : BitFlagControl = new BitFlagControl ();
		protected static const INTRO : String = "intro";
		protected static const DEFEATED : String = "defeated";
		
		protected var _defaultColorTransform : ColorTransform = new ColorTransform ();
		protected var _damageColorTransform : ColorTransform = new ColorTransform ();
		
		public function Ship() 
		{
			_state.addFlag(INTRO);
			_state.addFlag(DEFEATED);
			_damageColorTransform.color = 0xEEEEEE;
		}
		
		protected function addBehaviour (behaviourData : Object) : void
		{
			switch (behaviourData.type)
			{
				case UP_DOWN:
					_behaviour = new UpAndDown ();
					break;
				case EIGHT_SHAPE:
					_behaviour = new EightShape ();
					break;
				case CIRCULAR:
					_behaviour = new Circular ();
					break;
				default:
					_behaviour = new Behaviour ();
					break;
			}
			_behaviour.loadData(behaviourData);
			_behaviour.setTarget(this);
		}
		
		public function addCannon (c : Cannon, slot : int) : void
		{
			for (var i : int = 0; i < _slotData.length; i++)
			{
				if (i == slot)
				{
					c.offset = new Point (_slotData[i].x, _slotData[i].y);
					c.setParentShip(this);
					_arCannons[slot] = c;
					break;
				}
			}
		}
		
		public function startShooting (arSlots : Array = null) : void
		{
			for (var i : int = 0; i < _arCannons.length; i++)
			{
				if (!arSlots || arSlots.indexOf(i) >= 0)
				{
					if (_arCannons[i])
						_arCannons[i].activate();
				}
			}
		}
		
		public function stopShooting (arSlots : Array = null) : void
		{
			for (var i : int = 0; i < _arCannons.length; i++)
			{
				if (!arSlots || arSlots.indexOf(i) >= 0)
				{
					if (_arCannons[i])
						_arCannons[i].deactivate();
				}
			}
		}
		
		override public function update(dt : Number):void 
		{
			_state.update();
			super.update(dt);
			
			if (_asset && _asset.transform.colorTransform != _defaultColorTransform)
			{
				_asset.transform.colorTransform = _defaultColorTransform;
			}
			
			if (!_state.flagSet(INTRO))
			{
				if (!_state.flagSet(DEFEATED))
				{
					if (_behaviour)
					{
						_behaviour.update(dt);
					}
					
					x += vx * dt;
					y += vy * dt;
					
					if (_asset)
					{
						if (vy > 0)
						{
							_asset.gotoAndStop(ASSET_DOWN);
						}
						else if (vy < 0)
						{
							_asset.gotoAndStop(ASSET_UP);
						}
						else
						{
							_asset.gotoAndStop(ASSET_NORMAL);
						}
					}
				}
				else
				{
					if (_state.flagJustSet(DEFEATED))
					{
						onDefeat();
					}
				}
			}
			else
			{
				if (x == _xStart && y == _yStart)
				{
					_state.resetFlag(INTRO);
				}
			}
		}
		
		public function get defeated () : Boolean
		{
			return _state.flagSet(DEFEATED);
		}
		
		protected function onDefeat () : void
		{
			stopShooting();
			if (_asset)
			{
				_asset.gotoAndPlay("falling");
			}
			TweenLite.to (this, 5.0, { ease : Linear.easeInOut, x : stage.stageWidth / 2 - width / 2, y : stage.stageHeight + height } );
		}
		
		public function hit (damage : Number) : void
		{
			if (_state.noFlagSet())
			{
				_health -= damage;
				if (_asset)
				{
					_asset.transform.colorTransform = _damageColorTransform;
				}
				
				if (_health <= 0)
				{
					_health = 0;
					_state.setFlag (DEFEATED);
				}
			}
		}
		
		public function get health():Number 
		{
			return _health;
		}
		
		public function get maxHealth():Number 
		{
			return _maxHealth;
		}
		
		public function get side():String 
		{
			return _side;
		}
		
		public function get slotData():Array 
		{
			return _slotData;
		}
		
		public function get xStart():Number 
		{
			return _xStart;
		}
		
		public function get yStart():Number 
		{
			return _yStart;
		}
		
		public function loadData (data : Object) : void
		{
			_maxHealth = data.health;
			_health = _maxHealth;
			_side = data.side;
			
			if (_side == GameContext.ENEMY)
			{
				_xStart = data.xStart;
				_yStart = data.yStart;
				_state.setFlag(INTRO);
				
				if (data.behaviourData)
				{
					addBehaviour(data.behaviourData);
				}
			}
			else
			{
				x = data.xStart;
				y = data.yStart;
			}
			
			switch (data.type)
			{
				case PLAYER:
					addChild(_asset = new PlayerShip());
					break;
				case NORMAL:
					addChild(_asset = new NormalShip());
					break;
				case FANG:
					addChild(_asset = new FangShip());
					break;
				case SKULL:
					addChild(_asset = new SkullShip());
					break;
				case HEAD:
					addChild(_asset = new Head());
					break;
				case UP_HAND:
					addChild(_asset = new UpHand());
					break;
				case DOWN_HAND:
					addChild(_asset = new DownHand());
					break;
				case MOUTH:
					addChild(_asset = new Mouth());
					break;
				default:
					break;
			}
			
			if (_asset)
			{
				_asset.gotoAndStop(ASSET_NORMAL);
				_asset.addEventListener(Event.COMPLETE, animationComplete);
			}
			
			_slotData = (data.slotData as Array);
			if (!_slotData) _slotData = [];
			
			for (var i : int = 0; i < _slotData.length; i++)
			{
				_arCannons.push(null);
			}
		}
		
		private function animationComplete(e:Event):void 
		{
			_asset.gotoAndPlay("falling");
		}
		
		override public function removeSelf():void 
		{
			super.removeSelf();
			
			for each (var c : Cannon in _arCannons)
			{
				c.removeSelf();
			}
		}
	}
}