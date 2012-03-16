package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class RoundEvent extends Event 
	{
		private var _labelChangedType:int = -1;
		public function RoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new RoundEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RoundEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get labelChangedType():int 
		{
			return _labelChangedType;
		}
		
		public function set labelChangedType(value:int):void 
		{
			_labelChangedType = value;
		}
		
		
	}
	
}