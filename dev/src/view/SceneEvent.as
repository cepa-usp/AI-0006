package view 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class SceneEvent extends Event 
	{
		private var _vars:Object = new Object();
		
		public function SceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SceneEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SceneEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get vars():Object 
		{
			return _vars;
		}
		
		public function set vars(value:Object):void 
		{
			_vars = value;
		}
		
		static public const LABELS_CREATED:String = "labelsCreated";
		static public const ELEMENTS_CREATED:String = "elementsCreated";
		static public const LABEL_CHANGED:String = "labelChanged";
		static public const REFRESH_REQUEST:String = "refreshRequest";
		
	}
	
}