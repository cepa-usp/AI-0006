package  
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Element 
	{
		
		private var _hasLabel:Boolean = false;
		private var _x:int = 0;
		private var _y:int = 0;
		
		public function Element() 
		{
			
		}
		
		public function get x():int 
		{
			return _x;
		}
		
		public function set x(value:int):void 
		{
			_x = value;
		}
		
		public function get y():int 
		{
			return _y;
		}
		
		public function set y(value:int):void 
		{
			_y = value;
		}
		
		public function get hasLabel():Boolean 
		{
			return _hasLabel;
		}
		
		public function set hasLabel(value:Boolean):void 
		{
			_hasLabel = value;
		}
		
	}
	
}