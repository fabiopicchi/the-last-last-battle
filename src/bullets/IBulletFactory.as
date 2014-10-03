package bullets 
{
	import cannons.Cannon;
	
	/**
	 * ...
	 * @author fabio
	 */
	public interface IBulletFactory 
	{
		function createBullet (objData : Object, c : Cannon) : Bullet
		 function recycleBullet (b : Bullet) : void
	}
	
}