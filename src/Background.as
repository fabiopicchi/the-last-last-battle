package  
{
	import core.Entity;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author fabio
	 */
	public class Background extends Entity
	{
		private var _backgroundTimer : Number;
		private var _backgroundInterval : Number = 15;
		private var _arBackground : Vector.<MovieClip> = new Vector.<MovieClip> ();
		private var _lastBackgroundYPicked : Number;
		private static const BG_MIN_DIST : Number = 200;
		
		private var _static : StaticBG = new StaticBG;
		private var _stars1 : Stars_1 = new Stars_1;
		private var _stars1_ext : Stars_1 = new Stars_1;
		private var _stars1Period : Number = 60;
		private var _stars2 : Stars_2 = new Stars_2;
		private var _stars2_ext : Stars_2 = new Stars_2;
		private var _stars2Period : Number = 50;
		private var _baseCelestialPeriod : Number = 30;
		
		private static var _arPickedBgs : Vector.<Number> = new Vector.<Number> ();
		private static const BACKGROUND_LAYERS : int = 6;
		
		private var _arRecycledElements : Vector.<MovieClip> = new Vector.<MovieClip> ();
		
		public function Background() 
		{
			addChild(_static);
			addChild (_stars1);
			addChild (_stars1_ext);
			addChild (_stars2);
			addChild (_stars2_ext);
			
			_static.cacheAsBitmap = true;
			_stars1.cacheAsBitmap = true;
			_stars1_ext.cacheAsBitmap = true;
			_stars2.cacheAsBitmap = true;
			_stars2_ext.cacheAsBitmap = true;
			
			var el : MovieClip = getRandomBGElement();
			el.x = 450;
			el.y = -50 + GameContext.GAME_AREA_HEIGHT * Math.random();
			_lastBackgroundYPicked = el.y;
			addChild (el);
			_arBackground.push(el);
			
			el = getRandomBGElement();
			el.x = 900;
			el.y = -50 + GameContext.GAME_AREA_HEIGHT * Math.random();
			while (el.y >= _lastBackgroundYPicked - BG_MIN_DIST && el.y <= _lastBackgroundYPicked + BG_MIN_DIST)
			{
				el.y = -50 + GameContext.GAME_AREA_HEIGHT * Math.random();
			}
			_lastBackgroundYPicked = el.y;
			addChild (el);
			_arBackground.push(el);
			
			_backgroundTimer = _backgroundInterval;
			
			addEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_stars1_ext.x = stage.stageWidth;
			_stars2_ext.x = stage.stageWidth;
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			_stars1.x -= stage.stageWidth / _stars1Period * dt;
			_stars2.x -= stage.stageWidth  / _stars2Period * dt;
			_stars1_ext.x -= stage.stageWidth  / _stars1Period * dt;
			_stars2_ext.x -= stage.stageWidth  / _stars2Period * dt;
			
			if (_stars1.x <= - stage.stageWidth) _stars1.x += 2 * stage.stageWidth;
			if (_stars1_ext.x <= - stage.stageWidth) _stars1_ext.x += 2 * stage.stageWidth;
			if (_stars2.x <= - stage.stageWidth) _stars2.x += 2 * stage.stageWidth;
			if (_stars2_ext.x <= - stage.stageWidth) _stars2_ext.x += 2 * stage.stageWidth;
			
			if (_backgroundTimer < 0)
			{
				var el : MovieClip = getRandomBGElement();
				_arBackground.push(el);
				addChild(el);
				zOrder();
				
				el.x = stage.stageWidth;
				el.y = -50 - el.height / 2 + GameContext.GAME_AREA_HEIGHT * Math.random();
				while (el.y >= _lastBackgroundYPicked - BG_MIN_DIST && el.y <= _lastBackgroundYPicked + BG_MIN_DIST)
				{
					el.y = -50 - el.height / 2 + GameContext.GAME_AREA_HEIGHT * Math.random();
				}
				_lastBackgroundYPicked = el.y;
				_backgroundTimer = _backgroundInterval;
			}
			else
			{
				_backgroundTimer -= dt;
			}
			
			var arElementsOut : Vector.<MovieClip> = new Vector.<MovieClip>();
			for each (var bg : MovieClip in _arBackground)
			{
				bg.x -= (stage.stageWidth / (_baseCelestialPeriod + getBGLayer(bg) * 4)) * dt;
				if (bg.x < -bg.width)
				{
					arElementsOut.push(bg);
				}
			}
			recycle(arElementsOut);
		}
		
		private function zOrder():void 
		{
			var indexCount : int = 1;
			setChildIndex(_stars1, indexCount++);
			setChildIndex(_stars1_ext, indexCount++);
			setChildIndex(_stars2, indexCount++);
			setChildIndex(_stars2_ext, indexCount++);
			
			for (var j : int = BACKGROUND_LAYERS - 1; j >= 0; j--)
			{
				for (var i : int = 0; i < numChildren; i++)
				{
					if (getBGLayer(getChildAt(i) as MovieClip) == j)
					{
						setChildIndex(getChildAt(i), indexCount++);
					}
				}
			}
		}
		
		private function getRandomBGElement () : MovieClip
		{
			var rand : Number;
			var selected : MovieClip;
			var layer : int;
			
			if (_arPickedBgs.length >= BACKGROUND_LAYERS)
				_arPickedBgs = new Vector.<Number> ();
			
			while (_arPickedBgs.indexOf(rand = Math.floor (Math.random() * BACKGROUND_LAYERS)) >= 0) {}
			
			switch (rand)
			{
				case 0:
					selected = getRecycledBGElement(Planet1);
					selected.cacheAsBitmap = true;
					break;
				case 1:
					selected = getRecycledBGElement(Planet2);
					selected.cacheAsBitmap = true;
					break;
				case 2:
					selected = getRecycledBGElement(Planet3);
					selected.cacheAsBitmap = true;
					break;
				case 3:
					selected = getRecycledBGElement(Planet4);
					selected.cacheAsBitmap = true;
					break;
				case 4:
					selected = getRecycledBGElement(Galaxy);
					break;
				case 5:
					selected = getRecycledBGElement(SpaceCore);
					break;
			}
			
			_arPickedBgs.push(rand);
			return selected;
		}
		
		private function getRecycledBGElement (c : Class) : MovieClip
		{
			for each (var el : MovieClip in _arRecycledElements)
			{
				if (el is c)
				{
					return _arRecycledElements.splice(_arRecycledElements.indexOf(el), 1)[0];
				}
			}
			return new c;
		}
		
		private function recycle (ar : Vector.<MovieClip>) : void
		{
			for each (var bg : MovieClip in ar)
			{
				removeChild(bg);
				_arBackground.splice(_arBackground.indexOf(bg), 1);
				_arRecycledElements.push(bg);
			}
		}
		
		private function getBGLayer (c : MovieClip) : int
		{
			if (c is Galaxy)
			{
				return 5;
			}
			else if (c is Planet1)
			{
				return 4;
			}
			else if (c is Planet2)
			{
				return 3;
			}
			else if (c is Planet3)
			{
				return 2;
			}
			else if (c is Planet4)
			{
				return 1;
			}
			else if (c is SpaceCore)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		}
	}
}