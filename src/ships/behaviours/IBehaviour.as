package ships.behaviours 
{
	import core.Entity;
	import ships.Ship;
	
	/**
	 * ...
	 * @author fabio
	 */
	public interface IBehaviour 
	{
		function setTarget (e : Ship) : void;
		function update (dt : Number) : void;
		function loadData (data : Object) : void;
	}
	
}