package utils 
{
	/**
	 * ...
	 * @author fabio
	 */
	public class BitFlagControl 
	{
		private var _status : int;
		private var _nextStatus : int;
		private var _changedStatus : int;
		private var _arFlags : Vector.<String>;
		
		/*
		 * BitFlagControl Constructor
		 * @arFlags : Vector of Strings, length should be less or equal to 32 as it is the bit length of an int
		*/ 
		public function BitFlagControl (arFlags : Vector.<String> = null) 
		{
			if (arFlags)
			{
				_arFlags = arFlags;
			}
			else
			{
				_arFlags = new Vector.<String> ();
			}
		}
		
		/*
		 * Method to optionally add flags later to the BitFlagControl object
		*/ 
		public function addFlag (flagId : String) : void
		{
			_arFlags.push (flagId);
		}
		
		/*
		 * The update method applies the changes made to the object's status via the setFlag and resetFlag methods
		 * In case there were any changes they are stored on the _changedStatus property
		*/
		public function update () : void
		{
			_changedStatus = _status ^ _nextStatus;
			_status = _nextStatus;
		}
		
		/*
		 * Sets a flag (change won't be applied until a call to update is made)
		*/ 
		public function setFlag (id : String) : void
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				_nextStatus |= flag;
			}
		}
		
		/*
		 * Sets a flag instantly
		*/ 
		public function forceSetFlag (id : String) : void
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				_nextStatus |= flag;
				update();
			}
		}
		
		/*
		 * Resets a flag (change won't be applied until a call to update is made)
		*/ 
		public function resetFlag (id : String) : void
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				_nextStatus &= (~flag);
			}
		}
		
		/*
		 * Resets a flag instantly
		*/ 
		public function forceResetFlag (id : String) : void
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				_nextStatus &= (~flag);
				update();
			}
		}
		
		/*
		 * @id : string identifier of the flag
		 * returns true if flag is set to the curret status and false otherwise
		 * in case the flag id isnot found, returns false
		*/ 
		public function flagSet (id : String) : Boolean
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				return ((_status & flag) == flag);
			}
			return false;
		}
		
		/*
		 * @id : string identifier of the flag
		 * returns true if flag was set after the last update call and false otherwise
		 * in case the flag id isnot found, returns false
		*/ 
		public function flagJustSet (id : String) : Boolean
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				return ((_status & flag) == flag && (_changedStatus & flag) == flag);
			}
			return false;
		}
		
		/*
		 * @id : string identifier of the flag
		 * returns true if flag was reset after the last update call and false otherwise
		 * in case the flag id isnot found, returns false
		*/ 
		public function flagJustReset (id : String) : Boolean
		{
			var i : int = _arFlags.indexOf(id);
			if (i >= 0)
			{
				var flag : int = (1 << i);
				return ((_status & flag) != flag && (_changedStatus & flag) == flag);
			}
			return false;
		}
		
		/*
		 * returns true if the flag id passed as parameter belongs to the flag vector
		*/
		public function isFlagRegistered (id : String) : Boolean
		{
			return (_arFlags.indexOf(id) >= 0);
		}
		
		/*
		 * returns true if any of the flags are set and flase otherwise
		*/ 
		public function noFlagSet () : Boolean
		{
			return (_status == 0);
		}
	}

}