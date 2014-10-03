package sat_collision 
{
	/**
	 * ...
	 * @author 
	 */
	internal class Interval 
	{
		public var beggining : Number;
		public var end : Number;
		
		public function Interval(beggining : Number, end : Number) 
		{
			this.beggining = beggining;
			this.end = end;
		}
		
		/*
		 * Calculates interval intersection
		 * negative if intervals intersect 
		 * positive otherwhise
		*/
		public static function intervalIntersection (a : Interval, b : Interval) : Number
		{
			if (a.beggining < b.beggining)
			{
				return b.beggining - a.end;
			}
			else
			{
				return a.beggining - b.end;
			}
		}
	}

}