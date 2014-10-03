package sat_collision
{	
	import core.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class CollidableEntity extends Entity 
	{
		private var _rotationVector : Array;
		private var _pAngle : Number;
		private var _hitboxWidth : Number = -1;
		private var _hitboxHeight : Number = -1;
		private var _hitboxInitialWidth : Number = -1;
		private var _hitboxInitialHeight : Number = -1;
		private var _offsetX : Number = -1;
		private var _offsetY : Number = -1;
		
		public function CollidableEntity() 
		{
			setHitbox(width, height, 0, 0);
		}
		
		public function setHitbox(width:int, height:int, offsetX:int, offsetY:int):void 
		{
			_hitboxWidth = _hitboxInitialWidth = width;
			_hitboxHeight = _hitboxInitialHeight = height;
			_offsetX = offsetX; _offsetY = offsetY;
		}
		
		public static function collide (c1 : CollidableEntity, c2 : CollidableEntity) : Boolean
		{
			if (c1.hitboxWidth == 0 || c1.hitboxHeight == 0
				|| c2.hitboxWidth == 0 || c2.hitboxHeight == 0)
			{
				return false;
			}
			//Polygon vertices
			var arVerticesC1 : Array = c1.getAABBVertices();
			var arVerticesC2 : Array = c2.getAABBVertices();
			//Polygon sides
			var arSidesC1 : Array = c1.getAABBSides();
			var arSidesC2 : Array = c2.getAABBSides();
			
			//Result of the collision
			var result : CollisionResult = new CollisionResult ();
			result.collided = true;
			
			var nSidesC1 : int = arSidesC1.length;
			var nSidesC2 : int = arSidesC2.length;
			
			//Varibles used in the collision algorithm
			var intervalIntersection : Number;
			
			var side : Vec2;
			var axis : Vec2;
			
			var sideIndex : int = 0;
			
			var projectionMe : Interval;
			var projectionC : Interval;
			
			for (sideIndex = 0; sideIndex < nSidesC1 + nSidesC2; sideIndex++)
			{
				if (sideIndex < nSidesC1)
				{
					side = arSidesC1[sideIndex];
				}
				else
				{
					side = arSidesC2[sideIndex - nSidesC1];
				}
				
				axis = new Vec2 ( -side.y, side.x);
				axis.normalize();
				
				projectionMe = projectPolygonOverAxis(axis, arVerticesC1, arSidesC1);
				projectionC = projectPolygonOverAxis(axis, arVerticesC2, arSidesC2);
				
				if (Interval.intervalIntersection(projectionMe, projectionC) >= 0)
				{
					result.collided = false;
				}
				
				if (!result.collided)
				{
					break;
				}
			}
			
			return result.collided;
		}
		
		internal function getAABBVertices () : Array
		{
			if (rotation == 0)
			{
				return [
					new Vec2 (x - _offsetX, y - _offsetY),
					new Vec2 (x - _offsetX + _hitboxWidth, y - _offsetY),
					new Vec2 (x - _offsetX + _hitboxWidth, y - _offsetY + _hitboxHeight),
					new Vec2 (x - _offsetX, y - _offsetY + _hitboxHeight)
				];
			}
			else
			{
				var vPos : Vec2 = new Vec2 (x, y);
				if (_rotationVector == null || rotation != _pAngle)
				{
					_pAngle = rotation;
					_rotationVector = [
						new Vec2 ( - _offsetX, - _offsetY).rotate(- _pAngle / 180 * Math.PI),
						new Vec2 ( - _offsetX + _hitboxWidth, - _offsetY).rotate(- _pAngle / 180 * Math.PI),
						new Vec2 ( - _offsetX + _hitboxWidth, - _offsetY + _hitboxHeight).rotate(- _pAngle / 180 * Math.PI),
						new Vec2 ( - _offsetX, - _offsetY + _hitboxHeight).rotate(- _pAngle / 180 * Math.PI)
					];
				}
				return [
					vPos.add(_rotationVector[0]),
					vPos.add(_rotationVector[1]),
					vPos.add(_rotationVector[2]),
					vPos.add(_rotationVector[3])
				];
			}
		}
		
		internal function getAABBSides () : Array
		{
			if (rotation == 0)
			{
				return [
					new Vec2 (_hitboxWidth, 0),
					new Vec2 (0, _hitboxHeight)
				];
			}
			else
			{
				return [
					new Vec2 (_hitboxWidth, 0).rotate(- rotation / 180 * Math.PI),
					new Vec2 (0, _hitboxHeight).rotate(- rotation / 180 * Math.PI)
				];
			}
		}
		
		internal static function projectPolygonOverAxis (axis:Vec2, arVertices : Array, arSides : Array) : Interval
		{
			var projection : Number;
			
			projection = axis.dot (arVertices[0]);
			
			var interval : Interval = new Interval (projection, projection);
			var length : Number = arVertices.length;
			
			for (var i : int = 1; i < length; i++)
			{
				projection = arVertices[i].dot(axis);
				
				if (projection < interval.beggining)
				{
					interval.beggining = projection;
				}
				else if (projection > interval.end)
				{
					interval.end = projection;
				}
			}
			
			return interval;
		}
		
		public function get hitboxWidth():Number 
		{
			return _hitboxWidth;
		}
		
		public function get hitboxHeight():Number 
		{
			return _hitboxHeight;
		}
	}
}