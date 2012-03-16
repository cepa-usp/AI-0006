package view 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Scene extends Sprite
	{
		
		private var sprElements:Sprite = new Sprite();
		private var sprCoordinates:Sprite = new Sprite();
		private var sprGhosts:Sprite = new Sprite();
		private var sprControls:Sprite = new Sprite();
		private var elements:Vector.<ElementSprite>;
		private var _round:Round;
		private var selectedLabel:ElementLabel;
		private var isLabelPositioned:Boolean = false;
		private var axis:Sprite = null;
		
		
		public function Scene() 
		{
		addChild(sprCoordinates)	
		addChild(sprElements)
		addChild(sprGhosts)
		addChild(sprControls);
		
		}
		
		public function drawCoordinates():void {			
			axis = new Sprite();
			axis.alpha = 0.4;
			var w:int = stage.width;
			var h:int = stage.height;
			sprCoordinates.addChild(axis);
			axis.graphics.lineStyle(2, 0x400040, 1);
			axis.graphics.moveTo(0-w*2, 0);
			axis.graphics.lineTo(w * 2, 0);
			axis.graphics.moveTo(0, 0-h*2);
			axis.graphics.lineTo(0, h*2);
		}
		
		public function moveAxis():void {
			if (isLabelPositioned == false) return;
			var el:ElementSprite = findElementSprite(Label(round.labels[Label.TYPE_CENTER]).element);
			//axis.x = el.x;
			//axis.y = el.y;
			//axis.rotation = round.getAngle();
			Actuate.tween(axis, 1.5, { x:el.x, y:el.y, rotation:round.getAngle() } ).ease(Quad.easeInOut);
		}
		
		
		
		private function drawNewRound():void {
			clearSprite(sprGhosts);
			clearSprite(sprCoordinates);
			clearSprite(sprElements);
		}
		
		private function clearSprite(spr:Sprite):void {
			if (spr == null) return;
			spr.graphics.clear();
			for (var i:int = spr.numChildren; i > 0; i--) {
				spr.removeChildAt(i);				
			}
		}
		
		public function changeRound(rnd:Round):void 
		{
			this.round = rnd;
			rnd.eventDispatcher.addEventListener(Round.EV_CREATING_ELEMENTS, onCreatingElements);
			rnd.eventDispatcher.addEventListener(Round.EV_EVALUATING, onEvaluating);
			rnd.eventDispatcher.addEventListener(Round.EV_WAITING_LABELS, onWaitingLabels);
			rnd.eventDispatcher.addEventListener(Round.EV_ELEMENTS_CREATED, onElementsCreated);
			rnd.eventDispatcher.addEventListener(Round.EV_LABEL_CREATED, onLabelCreated);
			rnd.eventDispatcher.addEventListener(Round.EV_LABEL_CHANGED, onLabelChanged);
			rnd.eventDispatcher.addEventListener(Round.EV_FINISHED, onFinished);			
			drawNewRound();
		}
		
		private function onLabelCreated(e:Event):void 
		{
			for (var i:int = 0; i < 3; i++) {
				var l:ElementLabel = new ElementLabel();
				l.name = "lbl_" + i;
				sprElements.addChild(l);
				var es:ElementSprite = findElementSprite(Label(round.labels[i]).element);
				l.x = stage.width/2 //es.x;
				l.y = stage.height // es.y - es.height / 2;
				l.addEventListener(MouseEvent.MOUSE_DOWN, onLabelMouseDown);
				l.mouseChildren = false;
				setLabelText(l, Label(round.labels[i]));	
				
			}
			
		}
		
		private function onLabelChanged(e:RoundEvent):void 
		{
			var l:ElementLabel = ElementLabel(sprElements.getChildByName("lbl_" + e.labelChangedType.toString()));
			var es:ElementSprite = findElementSprite(Label(round.labels[e.labelChangedType]).element);
			Actuate.tween(l, Math.min(0.1 + Math.random(), 0.3), { x:es.x, y:es.y - es.height / 2 } ).ease(Elastic.easeOut).onComplete(function() { dispatchEvent(new Event(SceneEvent.LABELS_CREATED)) } );
				//moveAxis();
			
		}
		
		private function onLabelMouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onLabelMouseUp);
			selectedLabel = ElementLabel(e.target);
			selectedLabel.startDrag();
			
		}
		
		private function onLabelMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onLabelMouseUp);
			selectedLabel.stopDrag();
			var ev:SceneEvent = new SceneEvent(SceneEvent.LABEL_CHANGED);
			var sel:Element = null;
			var dist:Number = 99999;
			ev.vars.changeLabelType = int(selectedLabel.name.charAt(4));
			for each(var es:ElementSprite in elements) {
				var newd:Number = Point.distance(new Point(es.x, es.y), new Point(selectedLabel.x, selectedLabel.y)) ;
				if (newd < dist && !es.element.hasLabel) {
					dist = newd;
					sel = es.element;
				}
			}
			if (sel == null) {
				sel = Label(round.labels[ev.vars.changeLabelType]).element;
			}
			ev.vars.closerElement = sel;	
			dispatchEvent(ev);
		}
		
		private function setLabelText(el:ElementLabel, l:Label):void {
			switch(l.type) {
				case Label.TYPE_CENTER:
					//el.textfield.text = "centro";					
					break;
				case Label.TYPE_AXIS:
					//el.textfield.text = "eixo";
					break;
				case Label.TYPE_TARGET:
					//el.textfield.text = "alvo";
					break;
			}
		}
		
		private function findElementSprite(el:Element):ElementSprite {
			for each (var es:ElementSprite in elements) {
				if (es.element == el) return es;
			}
			return null;
		}
		
		private function onElementsCreated(e:RoundEvent):void 
		{
			elements = new Vector.<ElementSprite>();
			for each (var ee:Element in _round.elements) {				
				var el:ElementSprite = new ElementSprite(new SpritePack1(), ee);
				el.graphicalSymbol.gotoAndStop(Math.floor(Math.random() * el.graphicalSymbol.totalFrames));				
				elements.push(el);
				sprElements.addChild(el);
				el.x = ee.x;
				el.y = ee.y;
				el.scaleX = 0.01;
				el.scaleY = 0.01;
				var qt:Number = 0;
				Actuate.tween(el, 0.8 + Math.random(), { scaleX:1, scaleY:1 } ).ease(Elastic.easeInOut).onComplete(onElCreationTweenCompleted, el); 
				
			}
		}
		
		private function onElCreationTweenCompleted(el:ElementSprite):void {
			if (elements.indexOf(el) == elements.length-1) {
				dispatchEvent(new Event(SceneEvent.ELEMENTS_CREATED));	
			}
			
		}
		
		
		public function drawControls():void 
		{
		
		}
		
		private function onFinished(e:Event):void 
		{
			
		}
		
		private function onWaitingLabels(e:Event):void 
		{
			isLabelPositioned = true;
			moveAxis();
		}
		
		private function onEvaluating(e:Event):void 
		{
			
		}
		
		private function onCreatingElements(e:Event):void 
		{
			
		}
		
		public function get round():Round 
		{
			return _round;
		}
		
		public function set round(value:Round):void 
		{
			_round = value;
		}
		

		
	}
	
}