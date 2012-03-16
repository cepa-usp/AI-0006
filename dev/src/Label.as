package  
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Label 
	{
		
		private var _element:Element = null;
		private var _type:int;
		
		public function Label(type:int) 
		{
			this.type = type;
		}
		
		public function get element():Element 
		{
			return _element;
		}
		
		public function set element(value:Element):void 
		{
			if(element!=null) _element.hasLabel = false;
			_element = value;
			_element.hasLabel = true;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
		public static const TYPE_CENTER:int = 0;
		public static const TYPE_AXIS:int = 1;
		public static const TYPE_TARGET:int = 2;
		
	}
	
}