package  
{
	import bullets.BackNForthBullet;
	import bullets.Bullet;
	import bullets.CircularBullet;
	import bullets.HommingBullet;
	import bullets.IBulletFactory;
	import bullets.Ray;
	import bullets.SenoidalBullet;
	import cannons.Cannon;
	import cannons.ICannonFactory;
	import cannons.SpreadCannon;
	import cannons.StrafeCannon;
	import cannons.SweepCannon;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import core.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import ships.LastBoss;
	import ships.Ship;
	import utils.BitFlagControl;
	import utils.JSONLoader;
	
	/**
	 * ...
	 * @author fabio
	 */
	public class GameContext extends Context implements ICannonFactory, IBulletFactory
	{
		private var _hud : HUD;
		
		private var _playerShip : Ship;
		private var _playerSpeedX : Number = 233.33;
		private var _playerSpeedY : Number = 233.33;
		
		private var _enemyShip : Ship;
		private var _arEnemyShips : Array;
		private var _arEnemyCannos : Array;
		private var _enemyCount : int = 0;
		
		private var _allyBullets : Vector.<Bullet> = new Vector.<Bullet> ();
		private var _enemyBullets : Vector.<Bullet> = new Vector.<Bullet> ();
		
		private var _arDialogs : Array;
		private const DIALOG_INTERVAL : Number = 30;
		private var _enemyDialogDamageTimer : Number = 30;
		private var _playerDialogDamageTimer : Number = 30;
		
		//Action Codes
		public static const LEFT : String = "LEFT";
		public static const RIGHT : String = "RIGHT";
		public static const UP : String = "UP";
		public static const DOWN : String = "DOWN";
		public static const SHOOT : String = "SHOOT";
		
		public static const NORMAL : String = "normal";
		public static const SPREAD : String = "spread";
		public static const STRAFE : String = "strafe";
		public static const SWEEP : String = "sweep";
		
		public static const HOMMING : String = "homming";
		public static const CIRCULAR : String = "circular";
		public static const BACKNFORTH : String = "backnforth";
		public static const SIN : String = "sin";
		public static const RAY : String = "ray";
		
		public static const ALLY : String = "ally";
		public static const ENEMY : String = "enemy";
		
		public static const GAME_AREA_HEIGHT : Number = 440;
		
		private static const INTRO : String = "intro";
		private static const ENEMY_DAMAGE : String = "enemyDamage";
		private static const PLAYER_DAMAGE : String = "playerDamage";
		private static const LAST_BOSS_DEFEAT : String = "lastBossDefeat";
		private static const NEXT_BOSS : String = "nextBoss";
		private static const VICTORY : String = "victory";
		private static const VICTORY_THEME_COMPLETE : String = "victoryThemeComplete";
		private static const LOOP_TRANSITION : String = "loopTransition";
		private static const LOOP_TRANSITION_SCROLL : String = "loopTransitionScroll";
		private static const GAME_OVER : String = "gameOver";
		private var _state : BitFlagControl = new BitFlagControl ();
		
		private var _loopTransitionTimer : Number;
		private static const LOOP_TRANSITION_INTERVAL : Number = 10;
		
		private var _musicChannel : SoundChannel;
		private var _battleTheme_1 : BattleTheme1 = new BattleTheme1 ();
		private var _battleTheme_2 : BattleTheme2 = new BattleTheme2 ();
		private var _victoryTheme : VictoryTheme = new VictoryTheme ();
		private var _twistTheme : Twist = new Twist ();
		private var _insideBg : InsideBG = new InsideBG ();
		
		public function GameContext() 
		{
			_inputFlagControl.addFlag (LEFT);
			_inputFlagControl.addFlag (RIGHT);
			_inputFlagControl.addFlag (UP);
			_inputFlagControl.addFlag (DOWN);
			_inputFlagControl.addFlag (SHOOT);
			
			_state.addFlag(INTRO);
			_state.addFlag(VICTORY);
			_state.addFlag(NEXT_BOSS);
			_state.addFlag(LOOP_TRANSITION);
			_state.addFlag(LOOP_TRANSITION_SCROLL);
			_state.addFlag(VICTORY_THEME_COMPLETE);
			_state.addFlag(GAME_OVER);
		}
		
		override protected function getActionCode(keyCode:int):String 
		{
			switch (keyCode)
			{
				case 37:
					return LEFT;
					
				case 39:
					return RIGHT;
				
				case 38:
					return UP;
					
				case 40:
					return DOWN;
					
				case 90:
					return SHOOT;
					
				default:
					return "";
			}
		}
		
		override public function init():void 
		{
			super.init();
			
			addChild(new Background());
			
			_hud = new HUD();
			_hud.x = -2;
			_hud.y = 440;
			
			_playerShip = new Ship();
			addChild(_playerShip);
			_playerShip.loadData (
			{
				type : "player",
				health : 10,
				xStart : 100,
				yStart : 200,
				side : "ally",
				slotData : [ 
					{x : 202, y : 30},
					{x : 214, y : 48},
					{x : 205, y : 65}
				]
			});
			
			var objData : Object = JSONLoader.loadFile("enemies.json");
			
			_arEnemyShips = objData.ships;
			_arEnemyCannos = objData.cannons;
			
			_arDialogs = (JSONLoader.loadFile("dialogs.json") as Array);
			
			var playerCannonData : Object = 
			{
				type : "normal",
				direction :  0,
				fireRate : 5,
				bulletData : {
					type : "normal",
					damage : 0.1,
					speed : 500
				}
			};
			
			createCannon(playerCannonData, _playerShip, 0);
			createCannon(playerCannonData, _playerShip, 1);
			createCannon(playerCannonData, _playerShip, 2);
			
			addChild(_hud);
			
			_state.setFlag (INTRO);
			_hud.displayDialog(getDialog (INTRO));
		}
		
		private function getDialog(trigger:String):Array
		{
			for (var i : int = 0; i < _arDialogs.length; i++)
			{
				if (_arDialogs[i].trigger == trigger)
				{
					return _arDialogs[i].arDialogs[Math.floor(_arDialogs[i].arDialogs.length * Math.random())];
				}
			}
			
			return [];
		}
		
		override public function update(dt:Number):void 
		{
			_state.update();
			if (!_state.flagSet(GAME_OVER))
			{
				if (_inputFlagControl.flagJustSet(SHOOT))
				{
					_playerShip.startShooting();
				}
				else if (_inputFlagControl.flagJustReset(SHOOT))
				{
					_playerShip.stopShooting();
				}
				
				
				_playerShip.vx = _playerShip.vy = 0;
				if (_inputFlagControl.flagSet(UP))
				{
					_playerShip.vy -= _playerSpeedY;
				}
				if (_inputFlagControl.flagSet(DOWN))
				{
					_playerShip.vy += _playerSpeedY;
				}
				if (_inputFlagControl.flagSet(LEFT))
				{
					_playerShip.vx -= _playerSpeedX;
				}
				if (_inputFlagControl.flagSet(RIGHT))
				{
					_playerShip.vx += _playerSpeedX;
				}
				
				if (_playerShip.vx && _playerShip.vy)
				{
					_playerShip.vx *= Math.SQRT1_2;
					_playerShip.vy *= Math.SQRT1_2;
				}
				
				super.update(dt);
				
				if (_playerShip.x <= 0) _playerShip.x = 0;
				if (_playerShip.x + 210 * _playerShip.scaleX >= stage.stageWidth) _playerShip.x = stage.stageWidth - 210 * _playerShip.scaleX;
				if (_playerShip.y <= 0) _playerShip.y = 0;
				if (_playerShip.y + _playerShip.height * _playerShip.scaleY >= GAME_AREA_HEIGHT) _playerShip.y = GAME_AREA_HEIGHT - _playerShip.height * _playerShip.scaleY;
				
				if (!_state.flagSet(INTRO) && !_state.flagSet(LOOP_TRANSITION))
				{
					_playerDialogDamageTimer -= dt;
					_enemyDialogDamageTimer -= dt;
					var i : int = 0;
					for (i = 0; i < _allyBullets.length; i++)
					{
						if (_enemyShip.hitTestPoint(_allyBullets[i].x, _allyBullets[i].y))
						{
							if (!_state.flagSet (VICTORY))
							{
								_enemyShip.hit(_allyBullets[i].damage);
								_hud.setHP(_enemyShip.health / _enemyShip.maxHealth, HUD.NEZLE);
								if (!_state.flagSet(NEXT_BOSS))
								{
									if (_enemyDialogDamageTimer <= 0 && !_hud.displayingText)
									{
										_enemyDialogDamageTimer += DIALOG_INTERVAL;
										_hud.displayDialog(getDialog(ENEMY_DAMAGE));
									}
									
									if (_enemyShip.health <= 0)
									{
										_state.setFlag(VICTORY);
										if (!(_enemyShip is LastBoss))
										{										
											TweenLite.to(_musicChannel , 2.0, { soundTransform: { volume:0 }, onComplete : function () : void
											{
												_musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopTheme);
												_musicChannel = _victoryTheme.play();
												_musicChannel.addEventListener(Event.SOUND_COMPLETE, function onComplete (e : Event) : void
												{
													_musicChannel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
													_state.setFlag(VICTORY_THEME_COMPLETE)
												});
												TweenLite.from(_musicChannel , 2.0, { soundTransform: { volume:0 }} );
											}});
											_hud.displayDialog(getDialog(VICTORY));
										}
										else
											_hud.displayDialog(getDialog("lastBossDefeat"));
									}
								}
							}
							_allyBullets[i].removeSelf();
						}
					}
					
					for (i = 0; i < _enemyBullets.length; i++)
					{
						if (_playerShip.hitTestPoint(_enemyBullets[i].x, _enemyBullets[i].y))
						{
							if (!_state.flagSet (VICTORY))
							{
								_playerShip.hit(_enemyBullets[i].damage);
								_hud.setHP(_playerShip.health / _playerShip.maxHealth, HUD.SIRENA);
								if (_playerShip.health <= 0)
								{
									_state.setFlag(GAME_OVER);
									_hud.displayDialog(getDialog(GAME_OVER));
								}
								if (!_state.flagSet(NEXT_BOSS))
								{
									if (_playerDialogDamageTimer <= 0 && !_hud.displayingText)
									{
										_playerDialogDamageTimer += DIALOG_INTERVAL;
										_hud.displayDialog(getDialog(PLAYER_DAMAGE));
									}
								}
							}
							_enemyBullets[i].removeSelf();
						}
					}
					
					if (_enemyShip.y > stage.stageHeight && _state.flagSet(VICTORY_THEME_COMPLETE) && !_state.flagSet(NEXT_BOSS))
					{
						nextBoss();
					}
					
					if (_enemyShip is LastBoss && _enemyShip.defeated)
					{
						if (_playerShip.x <= stage.stageWidth &&
							_playerShip.x + _playerShip.width * _playerShip.scaleX >= 775 &&
							_playerShip.y <= 330 &&
							_playerShip.y + _playerShip.height * _playerShip.scaleY >= 245)
						{
							loopTransition();
						}
					}
				}
				else if (_state.flagSet(INTRO))
				{
					if (!_hud.displayingText)
					{
						nextBoss();
						_state.resetFlag(INTRO);
					}
				}
			}
			else
			{
				super.update(dt);
				
				if (!_hud.displayingText && _playerShip.y > stage.stageHeight)
				{
					_musicChannel.stop();
					if (_musicChannel.hasEventListener(Event.SOUND_COMPLETE))
					{
						_musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopTheme);
					}
					_game.switchContext(new MenuContext);
				}
			}
			
			if (_state.flagSet(LOOP_TRANSITION_SCROLL))
			{
				_loopTransitionTimer += dt;
				if (!_state.flagSet(NEXT_BOSS))
				{
					_enemyShip.x = _enemyShip.xStart - _loopTransitionTimer * ((_insideBg.width + stage.stageWidth) / LOOP_TRANSITION_INTERVAL);
				}
				_insideBg.x = stage.stageWidth - _loopTransitionTimer * ((_insideBg.width + stage.stageWidth) / LOOP_TRANSITION_INTERVAL);
				
				if (_loopTransitionTimer >= LOOP_TRANSITION_INTERVAL - 5 && !_state.flagSet(NEXT_BOSS))
				{
					_enemyShip.x = 0;
					nextBoss();
					_state.resetFlag(LOOP_TRANSITION);
				}
				
				if (_loopTransitionTimer >= LOOP_TRANSITION_INTERVAL)
				{
					_loopTransitionTimer = LOOP_TRANSITION_INTERVAL;
					removeChild(_insideBg);
					_state.resetFlag(LOOP_TRANSITION_SCROLL);
				}
			}
		}
		
		private function loopTransition():void 
		{
			_state.setFlag(LOOP_TRANSITION);
			_loopTransitionTimer = 0;
			TweenLite.to (_enemyShip, 1.0, {ease : Linear.easeInOut, scaleX : 2.37, scaleY : 2.37 } );
			TweenLite.to (_playerShip, 1.0, { ease : Linear.easeInOut, scaleX : 1.0, scaleY : 1.0, onComplete : function () : void
			{
				_state.setFlag(LOOP_TRANSITION_SCROLL);
				addChild(_insideBg);
				addChild(_enemyShip);
				addChild(_playerShip);
				addChild(_hud);
				_insideBg.x = 900;
			}} );
		}
		
		private function nextBoss () : void
		{
			var shipDelay : Number = 1.0;
			
			if (_enemyCount >= _arEnemyShips.length)
				_enemyCount = 0;
			
			if (!_state.flagSet(INTRO) && !_state.flagSet(LOOP_TRANSITION))
			{
				_state.resetFlag(VICTORY);
				_state.resetFlag(VICTORY_THEME_COMPLETE);
				_hud.displayDialog(getDialog(NEXT_BOSS));
				TweenLite.to(_playerShip, 3.0, { delay : 1.0, ease : Linear.easeInOut, scaleX : Math.pow (0.75, _enemyCount % 4), scaleY : Math.pow (0.75, _enemyCount % 4) } );
				shipDelay = 4.0;
				_enemyShip.removeSelf();
				_musicChannel = _twistTheme.play();
				_musicChannel.addEventListener(Event.SOUND_COMPLETE, function onComplete (e : Event) : void
				{
					_musicChannel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
					loopTheme();
				});
			}
			else if (_state.flagSet(INTRO))
			{
				loopTheme();
			}
			else if (_state.flagSet(LOOP_TRANSITION))
			{
				_state.resetFlag(VICTORY);
				_state.resetFlag(VICTORY_THEME_COMPLETE);
			}
			
			if (_arEnemyShips[_enemyCount].type != "lastBoss")
			{
				_enemyShip = new Ship();
			}
			else
			{
				_enemyShip = new LastBoss();
			}
			_state.setFlag(NEXT_BOSS);
			_enemyDialogDamageTimer = DIALOG_INTERVAL;
			_playerDialogDamageTimer = DIALOG_INTERVAL;
			_enemyShip.loadData(_arEnemyShips[_enemyCount++]);
			
			for (var i : int = 0; i < _enemyShip.slotData.length; i++)
			{
				if (!isNaN(_enemyShip.slotData[i].cannon))
				{
					createCannon(_arEnemyCannos[_enemyShip.slotData[i].cannon], _enemyShip, i);
				}
			}
			addChild(_enemyShip);
			addChild(_playerShip);
			addChild(_hud);
			_enemyShip.x = 900;
			_enemyShip.y = _enemyShip.yStart;
			_hud.setHP (1, HUD.NEZLE);
			
			if (_enemyShip is LastBoss)
			{
				_enemyShip.x += 216;
			}
			
			TweenLite.to(_enemyShip, 5.0, {delay : shipDelay, x : _enemyShip.xStart, ease : Linear.easeInOut, onComplete : function () : void
			{
				_state.resetFlag(NEXT_BOSS);
			}});
		}
		
		/* INTERFACE cannons.ICannonFactory */
		
		public function createCannon(data:Object, parentShip:Ship, slot : int):Cannon 
		{
			var c : Cannon;
			switch (data.type)
			{
				case NORMAL:
					c = new Cannon ();
					break;
				case SPREAD:
					c = new SpreadCannon ();
					break;
				case STRAFE:
					c = new StrafeCannon ();
					break;
				case SWEEP:
					c = new SweepCannon ();
					break;
			}
			c.loadData(data);
			c.setBulletFactory(this);
			parentShip.addCannon(c, slot);
			if (data.aim)
			{
				if (parentShip == _playerShip)
					c.setTarget(_enemyShip);
				else
					c.setTarget(_playerShip);
			}
			addChild(c);
			addChild(_hud);
			return c;
		}
		
		/* INTERFACE bullets.IBulletFactory */
		
		public function createBullet(data:Object, c : Cannon):Bullet 
		{
			var b : Bullet;
			
			switch (data.type)
			{
				case HOMMING:
					b = getRecycledBullet(HommingBullet);
					if (data.side == ENEMY)
					{
						(b as HommingBullet).setTarget(_playerShip);
					}
					else
					{
						(b as HommingBullet).setTarget(_enemyShip);
					}
					break;
				case NORMAL:
					b = getRecycledBullet(Bullet);
					break;
				case CIRCULAR:
					b = getRecycledBullet(CircularBullet);
					break;
				case BACKNFORTH:
					b = getRecycledBullet(BackNForthBullet);
					break;
				case SIN:
					b = getRecycledBullet(SenoidalBullet);
					break;
				case RAY:
					b = getRecycledBullet(Ray);
					(b as Ray).setParentCannon(c);
					break;
			}
			
			if (data.side == ALLY)
			{
				_allyBullets.push(b);
				switch (data.type)
				{
					case GameContext.NORMAL:
						data.asset = getRecycledAsset (Shot);
						break;
					case GameContext.CIRCULAR:
					case GameContext.BACKNFORTH:
					case GameContext.SIN:
						data.asset = getRecycledAsset (CircularShot);
						break;
					case GameContext.HOMMING:
						data.asset = getRecycledAsset (Missile);
						break;
					default:
						break;
				}
			}
			else
			{
				_enemyBullets.push(b);
				switch (data.type)
				{
					case GameContext.NORMAL:
						data.asset = getRecycledAsset (EvilShot);
						break;
					case GameContext.CIRCULAR:
					case GameContext.BACKNFORTH:
					case GameContext.SIN:
						data.asset = getRecycledAsset (EvilCircularShot);
						break;
					case GameContext.HOMMING:
						data.asset = getRecycledAsset (EvilMissile);
						break;
					default:
						break;
				}
			}
			
			b.x = c.x;
			b.y = c.y;
			b.loadData(data);
			b.setBulletFactory(this);
			b.scaleX = c.scaleX;
			b.scaleY = c.scaleY;
			addChild(b);
			addChild(_hud);
			
			return b;
		}
		
		private var _arRecycledBullets : Vector.<Bullet> = new Vector.<Bullet> ();
		private var _arRecycledAssets : Vector.<MovieClip> = new Vector.<MovieClip> ();
		public function recycleBullet (b : Bullet) : void
		{
			var index : int;
			if ((index = _allyBullets.indexOf(b)) >= 0) _allyBullets.splice(index, 1);
			else if ((index = _enemyBullets.indexOf(b)) >= 0) _enemyBullets.splice(index, 1);
			
			_arRecycledBullets.push(b);
			_arRecycledAssets.push(b.asset);
		}
		
		private function getRecycledBullet (c : Class) : Bullet
		{
			for each (var b : Bullet in _arRecycledBullets)
			{
				if (getDefinitionByName(getQualifiedClassName(b)) == c)
				{
					return _arRecycledBullets.splice(_arRecycledBullets.indexOf(b), 1)[0];
				}
			}
			return new c;
		}
		
		private function getRecycledAsset (c: Class) : MovieClip
		{
			for each (var mc : MovieClip in _arRecycledAssets)
			{
				if (mc is c)
				{
					return _arRecycledAssets.splice(_arRecycledAssets.indexOf(mc), 1)[0];
				}
			}
			
			return new c;
		}
		
		private function loopTheme (e : Event = null) : void
		{
			_musicChannel = (_enemyCount % 2 ? _battleTheme_1.play() : _battleTheme_2.play());
			if (!_musicChannel.hasEventListener(Event.SOUND_COMPLETE)) _musicChannel.addEventListener(Event.SOUND_COMPLETE, loopTheme);
		}
	}
}