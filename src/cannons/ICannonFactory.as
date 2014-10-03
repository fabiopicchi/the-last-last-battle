package cannons 
{
	import ships.Ship;
	
	/**
	 * ...
	 * @author fabio
	 */
	public interface ICannonFactory 
	{
		function createCannon (data : Object, parentShip : Ship, slot : int) : Cannon;
	}
	
}