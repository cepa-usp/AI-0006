package view 
{
	import cepa.LO.tools.Tool_Regua;
	import cepa.LO.tools.Tool_Transferidor;
	import cepa.LO.view.LearningObjectScene;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Cubic;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Scene extends LearningObjectScene
	{
		
		private var sprElements:Sprite = new Sprite();
		private var sprCoordinates:Sprite = new Sprite();
		private var sprGhosts:Sprite = new Sprite();
		private var sprControls:Sprite = new Sprite();
		private var sprRulers:Sprite = new Sprite();
		private var regua:Tool_Regua = new Tool_Regua();
		private var transferidor:Tool_Transferidor = new Tool_Transferidor();
		private var elements:Vector.<ElementSprite>;
		private var _round:Round;
		private var selectedLabel:ElementLabel;
		private var isLabelPositioned:Boolean = false;
		private var axis:Sprite = null;
		private var reguaOnStage:Boolean = false;
		private var transferOnStage:Boolean = false;
		private var dragElement:ElementSprite = null;
		private var lbPosDif:Point;
		private var lbMove:Sprite = null;
		
		public function Scene() 
		{
		addChild(sprCoordinates)	
		addChild(sprElements)
		addChild(sprGhosts)
		addChild(sprRulers)		
		addChild(sprControls);		
		addTools()
		}
		
		private function addTools():void 
		{
			sprRulers.addChild(regua);
			regua.x = Config.WIDTH / 2
			regua.y = Config.HEIGHT * 2;
			sprRulers.addChild(transferidor);
			transferidor.width = 40;  //Config.WIDTH / 2
			transferidor.height = 40;  //Config.HEIGHT * 2;
		}
		
		
		
		public function drawCoordinates():void {			
			axis = new Sprite();
			axis.alpha = 1;
			var w:int = Config.WIDTH;
			var h:int = Config.HEIGHT;
			sprCoordinates.addChild(axis);
			axis.graphics.lineStyle(2, 0x400040, 0.6);
			axis.graphics.moveTo(0-w*2, 0);
			axis.graphics.lineTo(w * 2, 0);
			axis.graphics.moveTo(0, 0-h*2);
			axis.graphics.lineTo(0, h * 2);
			var arrowX:ArrowX = new ArrowX();
			arrowX.name = "arrowX"			
			var arrowY:ArrowY = new ArrowY();
			arrowY.name = "arrowY"
			axis.addChild(arrowX)
			axis.addChild(arrowY)
			arrowX.x = 1000;
			arrowY.y = -1000;
			
		}
		
		

		
		public function moveAxis():void {
			if (isLabelPositioned == false) return;
			var ax:ArrowX = ArrowX(axis.getChildByName("arrowX"));
			var ay:ArrowY = ArrowY(axis.getChildByName("arrowY"));
			//Actuate.tween(ax, 0.3, { x:1000} ).ease(Quad.easeIn);
			//Actuate.tween(ay, 0.3, { y:-1000} ).ease(Quad.easeIn);
			
			var el:ElementSprite = findElementSprite(Label(round.labels[Label.TYPE_CENTER]).element);
			//axis.x = el.x;
			//axis.y = el.y;
			//axis.rotation = round.getAngle();
			Actuate.tween(axis, 1.5, { x:el.x, y:el.y, rotation:round.getAngle() } ).ease(Quad.easeInOut).onComplete(returnArrows);
		}
		
		private function returnArrows():void {
			var posX:int = 1000;
			var posY:int = -1000;
			var ptX:Point;
			var ptY:Point;
			var rect:Rectangle = new Rectangle(0, 0, Config.WIDTH, Config.HEIGHT)
			for (var i:int = 0; i < 1500;i+=30) {
				var j:int = 0;
				ptX = axis.localToGlobal(new Point(i, 0));
				ptY = axis.localToGlobal(new Point(0, -i));
				if (rect.containsPoint(ptX)) {
					posX = i;
					j++;
					//trace(ptX, "posX=", posX)
				} else {
					//trace("saiu: ", ptX)
				}
				if (rect.containsPoint(ptY)) {
					posY = i;
					j++;
				}
				if (j == 0) break;
			}
			trace(ptX, posX)
			var ax:ArrowX = ArrowX(axis.getChildByName("arrowX"));
			var ay:ArrowY = ArrowY(axis.getChildByName("arrowY"));
			Actuate.tween(ax, 1, { x:posX} ).ease(Quad.easeOut);
			Actuate.tween(ay, 1, { y:-posY} ).ease(Quad.easeOut);
		}
		
		private function drawNewRound():void {
			clearSprite(sprGhosts);
			clearSprite(sprCoordinates);
			clearSprite(sprElements);
		}
		
		private function clearSprite(spr:Sprite):void {
			if (spr == null) return;
			spr.graphics.clear();
			for (var i:int = spr.numChildren-1; i >= 0; i--) {
				spr.removeChildAt(i);				
			}
		}
		
		public function changeRound(rnd:Round):void 
		{
			isLabelPositioned = false;			
			if (reguaOnStage) onReguaClick();
			if (transferOnStage) onTransferidorClick();
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
				el.mouseChildren = false;
				el.graphicalSymbol.gotoAndStop(Math.floor(Math.random() * el.graphicalSymbol.totalFrames));				
				elements.push(el);
				sprElements.addChild(el);
				el.x = ee.x;
				el.y = ee.y;
				el.addEventListener(MouseEvent.MOUSE_DOWN, onElementStartDrag);
				el.scaleX = 0.01;
				el.scaleY = 0.01;
				var qt:Number = 0;
				Actuate.tween(el, 0.8 + Math.random(), { scaleX:1, scaleY:1 } ).ease(Elastic.easeInOut).onComplete(onElCreationTweenCompleted, el); 
				
			}
		}
		
		private function onElementStartDrag(e:MouseEvent):void 
		{
			var el:ElementSprite = ElementSprite(e.target);
			dragElement = el;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onElementMouseUp);
			if (el.element.hasLabel) {
				for (var i:int = 0; i < 3; i++) {
					if (Label(round.labels[i]).element == el.element) {
						 lbMove = Sprite(sprElements.getChildByName("lbl_" + i.toString()));
						 lbPosDif = new Point(lbMove.x - el.x, lbMove.y - el.y);				 
						 stage.addEventListener(Event.ENTER_FRAME, moveAttachedLabel)
						break;
					}
				}
				
			}
			
			el.startDrag(true);			
		}
		
		private function moveAttachedLabel(e:Event):void 
		{
			lbMove.x = dragElement.x + lbPosDif.x;
			lbMove.y = dragElement.y + lbPosDif.y;
		}
		
		
		
		private function onElementMouseUp(e:MouseEvent):void 
		{
			dragElement.stopDrag();
			var ev:SceneEvent = new SceneEvent(SceneEvent.ELEMENT_MOVED);
			ev.vars.element = dragElement.element;
			ev.vars.position = new Point(dragElement.x, dragElement.y);			
			dispatchEvent(ev);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onElementMouseUp);
			stage.removeEventListener(Event.ENTER_FRAME, moveAttachedLabel)
			//moveAxis();
		}
		
		private function onElCreationTweenCompleted(el:ElementSprite):void {
			if (elements.indexOf(el) == elements.length-1) {
				dispatchEvent(new Event(SceneEvent.ELEMENTS_CREATED));	
			}
			
		}
		
		
		public function drawControls():void 
		{
			var mp:MenuPrincipal = new MenuPrincipal()
			sprControls.addChild(mp);
			mp.x = Config.WIDTH - mp.width - 15;
			mp.y = Config.HEIGHT - mp.height - 15;
			workAsButton(mp.btAbout, "Créditos");
			workAsButton(mp.btInstructions, "Instruções");
			workAsButton(mp.btRefresh, "Reiniciar atividade");
			mp.btAbout.addEventListener(MouseEvent.CLICK, onBtAboutClick);
			mp.btInstructions.addEventListener(MouseEvent.CLICK, onBtInstructionsClick);
			mp.btRefresh.addEventListener(MouseEvent.CLICK, onBtRefreshClick);
			
			
			var ma:MenuAtividade = new MenuAtividade();
			sprControls.addChild(ma);
			ma.x = 10;
			ma.y = 10;
			workAsButton(ma.btOk, "Avaliar");
			ma.btOk.addEventListener(MouseEvent.CLICK, onBtOkClick)
			workAsButton(ma.btRegua, "Adicione uma régua no palco");
			workAsButton(ma.btTransferidor, "Adicione um transferidor no palco");
			ma.btRegua.addEventListener(MouseEvent.MOUSE_DOWN, onReguaClick)
			ma.btTransferidor.addEventListener(MouseEvent.MOUSE_DOWN, onTransferidorClick)

		}
		
		private function onBtOkClick(e:MouseEvent):void 
		{
			var ev:SceneEvent = new SceneEvent(SceneEvent.EVALUATE_REQUEST);
			var es:ElementSprite = findElementSprite(Label(round.labels[Label.TYPE_TARGET]).element);
			
			var p:Point = axis.globalToLocal(new Point(es.x, es.y));
			trace(p);
			//dispatchEvent(ev);
		}
		
		private function onTransferidorClick(e:MouseEvent = null):void 
		{
			if (!transferOnStage) {
				Actuate.tween(transferidor, 0.8, { x:(Config.WIDTH / 4)*3, y:Config.HEIGHT / 2 } ).ease(Cubic.easeOut);
				transferOnStage = true;
				
			} else {
				Actuate.tween(transferidor, 0.8, { x:Config.WIDTH / 2, y:Config.HEIGHT * 2 } ).ease(Cubic.easeOut);
				transferOnStage = false;
			}			
		}
		
		private function onReguaClick(e:MouseEvent = null):void 
		{
			if (!reguaOnStage) {
				Actuate.tween(regua, 0.5, { x:Config.WIDTH / 4, y:Config.HEIGHT / 2 } ).ease(Cubic.easeOut);
				reguaOnStage = true;
				
			} else {
				Actuate.tween(regua, 0.8, { x:Config.WIDTH / 2, y:Config.HEIGHT * 2 } ).ease(Cubic.easeOut);
				reguaOnStage = false;
			}
		}
		
		private function onBtRefreshClick(e:MouseEvent):void 
		{

			dispatchEvent(new SceneEvent(SceneEvent.REFRESH_REQUEST));	
		}
		
		private function onBtInstructionsClick(e:MouseEvent):void 
		{
			
		}
		
		private function onBtAboutClick(e:MouseEvent):void 
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