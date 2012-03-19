package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import pipwerks.SCORM;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Round
	{
		
		
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		private var _elements:Vector.<Element>;
		private var _state:int = -1;
		private var _score:Number = 0;
		private var _labels:Array = [new Label(0), new Label(1), new Label(2)];
		public const MARGIN:int = 40;
		private var AMNT_ELEMENTS:int = 8;
		
			
		public static const STATE_CREATING:int = 0;
		public static const STATE_WAITINGLABELS:int = 1;
		public static const STATE_EVALUATING:int = 2;
		public static const STATE_FINISHED:int = 3;
		
		static public const EV_CREATING_ELEMENTS:String = "evCreatingElements";
		static public const EV_WAITING_LABELS:String = "evWaitingLabels";
		static public const EV_EVALUATING:String = "evEvaluating";
		static public const EV_FINISHED:String = "evFinished";
		static public const EV_ELEMENTS_CREATED:String = "evElementsCreated";
		static public const EV_LABEL_CREATED:String = "evLabelCreated";
		static public const EV_LABEL_CHANGED:String = "evLabelChanged";		
		
			
		
		public function Round() 
		{
			
		}
		
		
		public function changeLabel(labelType:int, element:Element):void {
			var l:Label = labels[labelType];
			l.element = element;
			var ev:RoundEvent = new RoundEvent(EV_LABEL_CHANGED)
			ev.labelChangedType = labelType;
			_eventDispatcher.dispatchEvent(ev);			
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function createElements():void {
			elements = new Vector.<Element>();
			for (var i:int = 0; i < AMNT_ELEMENTS; i++) {
				var el:Element = new Element();
				findPosition(el, Config.WIDTH/10);
				elements.push(el);
			}
			
		}
		
		private function findPosition(el:Element, minDist:int, depth:int=0):void 
		{
				el.x = Math.floor((Math.random() * (Config.WIDTH  - MARGIN*2))) + MARGIN;
				el.y = Math.floor((Math.random() * (Config.HEIGHT - MARGIN*2))) + MARGIN;
				for each (var e:Element in elements) {
					if (Math.abs(Point.distance(new Point(e.x, e.y), new Point(el.x, el.y))) < minDist && depth<10) {
						findPosition(el, minDist, depth++);
					} 
				}				
		}
		
		public function set state(value:int):void 
		{
			_state = value;
			switch(state) {
				case STATE_CREATING:
					eventDispatcher.dispatchEvent(new RoundEvent(EV_CREATING_ELEMENTS));	
					createElements();					
					eventDispatcher.dispatchEvent(new RoundEvent(EV_ELEMENTS_CREATED));	
					
					break;
				case STATE_WAITINGLABELS:
					eventDispatcher.dispatchEvent(new RoundEvent(EV_WAITING_LABELS));	
					break;
				case STATE_EVALUATING:
					eventDispatcher.dispatchEvent(new RoundEvent(EV_EVALUATING));
					evaluate();
					break;					
				case STATE_FINISHED:
					eventDispatcher.dispatchEvent(new RoundEvent(EV_FINISHED));		
					break;										
			}
		}
		
		public function evaluate():void {
			var evalObj:Element = Label(labels[Label.TYPE_TARGET]).element;
			
		}
		
		public function randomizeLabels():void 
		{
			var ev:RoundEvent = new RoundEvent(EV_LABEL_CREATED)
			_eventDispatcher.dispatchEvent(ev);
			
			rndLabel(0);
			rndLabel(1);
			rndLabel(2);

		}
		
		private function rndLabel(type:int):void {
			var elmIndex:int = Math.floor(Math.random() * elements.length);
			if (elements[elmIndex].hasLabel) {
				rndLabel(type);
				return;
			} 
			changeLabel(type, elements[elmIndex]);
			if(type==2) state = STATE_WAITINGLABELS;

		}
		
		public function getAngle():Number {
			var ptE:Point = new Point(Label(labels[Label.TYPE_AXIS]).element.x, Label(labels[Label.TYPE_AXIS]).element.y);
			var ptC:Point = new Point(Label(labels[Label.TYPE_CENTER]).element.x, Label(labels[Label.TYPE_CENTER]).element.y);			
			var n:Number = (Math.atan2(ptE.y - ptC.y, ptE.x - ptC.x)*180)/Math.PI;

			return n;
		}
		
		
		public function get elements():Vector.<Element> 
		{
			return _elements;
		}
		
		public function set elements(value:Vector.<Element>):void 
		{
			_elements = value;
		}
		
		public function get eventDispatcher():EventDispatcher 
		{
			return _eventDispatcher;
		}
		
		public function set eventDispatcher(value:EventDispatcher):void 
		{
			_eventDispatcher = value;
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function get labels():Array 
		{
			return _labels;
		}
		
		public function set labels(value:Array):void 
		{
			_labels = value;
		}
		
	}
	
}