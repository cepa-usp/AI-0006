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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import tutorial.CaixaTexto;
	import tutorial.Tutorial;
	import tutorial.TutorialEvent;
	
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
		private var sprControls2:Sprite;
		private var sprAnswers:Sprite = new Sprite();
		private var sprRulers:Sprite = new Sprite();
		private var regua:Tool_Regua = new Tool_Regua();
		private var transferidor:Tool_Transferidor = new Tool_Transferidor();
		private var elements:Vector.<ElementSprite>;
		private var _round:Round;
		private var selectedLabel:Sprite;
		private var isLabelPositioned:Boolean = false;
		private var axis:Sprite = null;
		private var reguaOnStage:Boolean = false;
		private var transferOnStage:Boolean = false;
		private var dragElement:ElementSprite = null;
		private var lbPosDif:Point;
		private var lbMove:Sprite = null;
		private var answerUser:Sprite = new Sprite;
		private var answerRound:Sprite = new Sprite;
		private var blockelements:Boolean = false;
		private var message:TextoExplicativo = new TextoExplicativo();
		
		public function Scene() 
		{
		addChild(new Background());
		addChild(sprCoordinates)	
		addChild(sprElements)
		addChild(sprGhosts)
		addChild(sprRulers)	
		
		addChild(sprAnswers);
		makeAnswer();


		addMessage();
		addChild(sprControls);		
		
		
		addTools()
		
		}
		
		private function makeScreens():void 
		{
		addChild(sprAboutScreen);		
		addChild(sprInfoScreen);
		
		sprInfoScreen.x = Config.WIDTH / 2
		sprInfoScreen.y = Config.HEIGHT / 2
		sprAboutScreen.x = Config.WIDTH / 2
		sprAboutScreen.y = Config.HEIGHT / 2
		
		sprAboutScreen.addEventListener(MouseEvent.CLICK, closePanel);
		sprInfoScreen.addEventListener(MouseEvent.CLICK, closePanel);
		sprAboutScreen.visible = false;	
		sprInfoScreen.visible = false;

		}
		
		private function addMessage():void 
		{
			addChild(message);
			message.x = 0;
			message.y = Config.HEIGHT - message.height;
			message.texto.text = " ";
			
		}
		
		private function makeAnswer():void {
			answerUser.graphics.beginFill(0xFF0000);
			answerUser.graphics.drawCircle(0, 0, 4)
			
		}
		
		private function addTools():void 
		{
			sprRulers.addChild(regua);
			regua.x = Config.WIDTH / 2
			regua.y = Config.HEIGHT * 2;
			
			regua.ruler.base.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("Arraste para mover a régua") } );
			regua.ruler.base.addEventListener(MouseEvent.MOUSE_OUT, info)			
			regua.ruler.mov.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("Arraste para girar a régua") } );
			regua.ruler.mov.addEventListener(MouseEvent.MOUSE_OUT, info)						
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
			var arrowX:ArrowX = new ArrowX();
			arrowX.name = "arrowX"			
			var arrowY:ArrowY = new ArrowY();
			arrowY.name = "arrowY"
			axis.addChild(arrowX)
			axis.addChild(arrowY)
			arrowX.x = 1000;
			arrowY.y = -1000;
			
			sprAnswers.addChild(answerUser);
			sprAnswers.addChild(answerRound);
			drawAxis()
		}
		
		public function drawAxis():void {
			axis.graphics.clear();
			axis.graphics.lineStyle(2, 0x400040, 0.6);
			var w:int = Config.WIDTH;
			var h:int = Config.HEIGHT;

			axis.graphics.moveTo(0-w*2, 0);
			axis.graphics.lineTo(axis.getChildByName("arrowX").x, 0);
			axis.graphics.moveTo(0, h*2);
			axis.graphics.lineTo(0, axis.getChildByName("arrowY").y);
			axis.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { 
																			if (Math.abs(e.localX)<5) {
																				setMessage("Eixo Y") 
																			} else {
																				setMessage("Eixo X") 
																				} 																
																			} );
			axis.addEventListener(MouseEvent.MOUSE_OUT, info);
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
			
			var ax:ArrowX = ArrowX(axis.getChildByName("arrowX"));
			var ay:ArrowY = ArrowY(axis.getChildByName("arrowY"));
			Actuate.tween(ax, 1, { x:posX} ).ease(Quad.easeOut).onUpdate(drawAxis);
			Actuate.tween(ay, 1, { y: -posY } ).ease(Quad.easeOut);
		}
		
		private function drawNewRound():void {
			clearSprite(sprGhosts);
			clearSprite(sprAnswers);
			answerUser.visible = false;
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
			for (var i:int = 0; i < 2; i++) {
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
			makeTargetLabel();
			
		}
		
		private function makeTargetLabel():void {
				var i:int = 2;
				var l:ElementLabel2 = new ElementLabel2();				
				l.name = "lbl_" + i;
				sprElements.addChild(l);
				var es:ElementSprite = findElementSprite(Label(round.labels[i]).element);
				l.x = stage.width/2 //es.x;
				l.y = stage.height // es.y - es.height / 2;
				l.addEventListener(MouseEvent.MOUSE_DOWN, onLabelMouseDown);
				l.mouseChildren = false;
				l.textfield.text = "meu objeto";
				l.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("O objeto cujas coordenadas você deve medir") } );
				l.addEventListener(MouseEvent.MOUSE_OUT, info)				

		}
		
		private function onLabelChanged(e:RoundEvent):void 
		{
			var l:Sprite;
			if (e.labelChangedType==2) {
				l = ElementLabel2(sprElements.getChildByName("lbl_" + e.labelChangedType.toString()));
			} else {
				l = ElementLabel(sprElements.getChildByName("lbl_" + e.labelChangedType.toString()));
			}				
				var es:ElementSprite = findElementSprite(Label(round.labels[e.labelChangedType]).element);
				Actuate.tween(l, Math.min(0.1 + Math.random(), 0.3), { x:es.x, y:es.y - es.height / 2 } ).ease(Elastic.easeOut).onComplete(function() { dispatchEvent(new Event(SceneEvent.LABELS_CREATED)) } );			
			
		}
		
		private function onLabelMouseDown(e:MouseEvent):void 
		{
			if (blockelements) return;
			stage.addEventListener(MouseEvent.MOUSE_UP, onLabelMouseUp);
			selectedLabel = Sprite(e.target);
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
					el.textfield.text = "origem";					
					el.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("Origem do sistema de referência") } );
					el.addEventListener(MouseEvent.MOUSE_OUT, info)
					
					break;
				case Label.TYPE_AXIS:
					el.textfield.text = "orientação";
					el.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("Orientação do sistema de referência") } );
					el.addEventListener(MouseEvent.MOUSE_OUT, info)					
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
				Actuate.tween(el, 0.8 + Math.random(), { scaleX:0.6, scaleY:0.6 } ).ease(Elastic.easeInOut).onComplete(onElCreationTweenCompleted, el); 
				setMessage("Meça as coordenadas do 'meu objeto' usando a régua", true);
			}
		}
		
		private function onElementStartDrag(e:MouseEvent):void 
		{
			if (blockelements) return;
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
			if (elements.indexOf(el) == elements.length - 1) {
				//el.filters = [new DropShadowFilter()]
				dispatchEvent(new Event(SceneEvent.ELEMENTS_CREATED));	
			}
			
		}
		
		
		public function drawControls():void 
		{
			if (getChildByName("sprControls2") != null) {
				removeChild(getChildByName("sprControls2"));
			}
			sprControls2 = new Sprite()
			sprControls2.name = "sprControls2";
			addChild(sprControls2);
			sprControls2.alpha = 0;
			var mp:MenuPrincipal = new MenuPrincipal()
			mp.name = "menuPrincipal";
			sprControls.addChild(mp);
			mp.x = Config.WIDTH - mp.width - 15;
			mp.y = Config.HEIGHT - mp.height - 15;
			workAsButton(mp.btAbout, "Créditos");
			workAsButton(mp.btInstructions, "Instruções");
			workAsButton(mp.btRefresh, "Reiniciar atividade");
			mp.btAbout.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { openPanel(sprAboutScreen) } );
			//mp.btInstructions.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { openPanel(sprInfoScreen) } );
			mp.btInstructions.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { startTutorial() } );
			//workAsButton(mp.btTutorial, "Tutorial")
			mp.btRefresh.addEventListener(MouseEvent.CLICK, onBtRefreshClick);
			mp.filters = [new DropShadowFilter()]
			
			var ma:MenuAtividade = new MenuAtividade();
			ma.name = "menuAtividade"
			sprControls2.addChild(ma);
			ma.filters = [new DropShadowFilter()]
			ma.x = 10;
			ma.y = 10;
			
			workAsButton(ma.btOk, "Avaliar");
			ma.btOk.addEventListener(MouseEvent.CLICK, onBtOkClick)
			workAsButton(ma.btRegua, "Adicione uma régua no palco");
			workAsButton(ma.btTransferidor, "Adicione um transferidor no palco");
			ma.btRegua.addEventListener(MouseEvent.MOUSE_DOWN, onReguaClick)
			ma.btTransferidor.addEventListener(MouseEvent.MOUSE_DOWN, onTransferidorClick)
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varX).restrict = "0-9,\\-"
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varY).restrict = "0-9,\\-"
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varX).addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) { setMessage("Digite a coordenada x de 'meu objeto'") } );
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varY).addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) { setMessage("Digite a coordenada y de 'meu objeto'") } );
			ma.btOk.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { setMessage("Pressione 'terminei' para avaliar sua resposta") } );
			ma.btOk.addEventListener(MouseEvent.MOUSE_OUT, info)
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varX).addEventListener(MouseEvent.MOUSE_OUT, info);
			TextField(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varY).addEventListener(MouseEvent.MOUSE_OUT, info);
			
			makeScreens()
			//sprAboutScreen.visible = false;
			//s/prInfoScreen.visible = false;
			
		}
		
		private function hideControls():void {
			Actuate.tween(sprControls2, 0.6, {alpha:0})
		}
		
		private function showControls():void {
			Actuate.tween(sprControls2, 0.6, {alpha:1})
		}
		

		private function convertSceneToRound(val:Number):Number {
			return val * 21.6;
		}
		private function convertRoundToScene(val:Number):Number {
			return val / 21.6;
		}		
		
		private function onBtOkClick(e:MouseEvent):void 
		{
			var ev:SceneEvent = new SceneEvent(SceneEvent.EVALUATE_REQUEST);
			var es:ElementSprite = findElementSprite(Label(round.labels[Label.TYPE_TARGET]).element);
			
			var p:Point = axis.globalToLocal(new Point(es.x, es.y));
			p.y = - p.y;

			var objpos:Point = new Point(Label(round.labels[Label.TYPE_TARGET]).element.x, Label(round.labels[Label.TYPE_TARGET]).element.y)
			ev.vars.targetPosition = objpos;
			answerRound.x = objpos.x;
			answerRound.y = objpos.y;
			
			ev.vars.correctAnswerPosition = p;
			var up:Point = new Point(0, 0);
			if (checkFields() == false) return;
			up.x = Number(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varX.text.replace(",", "."))						
			up.y = Number(MenuAtividade(sprControls2.getChildByName("menuAtividade")).varY.text.replace(",", "."))			
			up.x = convertSceneToRound(up.x)
			up.y = convertSceneToRound(up.y);
			
			var pp:Point = up.clone();
			pp.y = -pp.y;
			pp = axis.localToGlobal(pp);
			//pp = sprAnswers.globalToLocal(pp);
			answerUser.x = pp.x;			
			answerUser.y = pp.y
			answerUser.filters = [new DropShadowFilter() ];
			answerUser.alpha = 0;
			ev.vars.useranswerPosition = up;
			
			
			
			dispatchEvent(ev);
		}
		

		

		
		private function checkFields():Boolean {
			if (MenuAtividade(sprControls2.getChildByName("menuAtividade")).varX.text.length == 0) {
				return false;
			}
			if (MenuAtividade(sprControls2.getChildByName("menuAtividade")).varY.text.length == 0) {
				return false;
			}		
			return true;
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
			showAnswer();
		}
		
		private function showAnswer():void 
		{
			var r:Sprite;
			var junta:Sprite = new Sprite();
			if (round.score == 0) {
				r = new lbErrado();
			} else {
				r = new lbCorreto();
			}
			sprAnswers.addChild(r);
			r.x = Config.WIDTH / 2
			r.y = -100;

			var btVerCorreta:BtRespostaCorreta = new BtRespostaCorreta();
			var btSuaResposta:BtSuaResposta = new BtSuaResposta();
			var btNovo:BtNovo = new BtNovo();
			workAsButton(btNovo)
			workAsButton(btVerCorreta);
			workAsButton(btSuaResposta);
			sprAnswers.addChild(junta);
			junta.addChild(btVerCorreta)
			junta.addChild(btSuaResposta)
			junta.addChild(btNovo)
			btVerCorreta.x = 100
			btSuaResposta.x = 100
			btNovo.x = 100
			btVerCorreta.addEventListener(MouseEvent.CLICK, onVerCorreta);
			btSuaResposta.addEventListener(MouseEvent.CLICK, onSuaResposta);
			btNovo.addEventListener(MouseEvent.CLICK, onBtRefreshClick);
			junta.y = 1000;			
			btVerCorreta.y = 50
			btVerCorreta.visible = false;
			btSuaResposta.y = 80
			btNovo.y = 110
			
			Actuate.tween(r, 0.6, { y:Config.HEIGHT / 2 } ).ease(Elastic.easeOut).onComplete(function():void {
				Actuate.tween(r, 1, { y:Config.HEIGHT / 2 } ).ease(Linear.easeNone).onComplete(function():void {
					Actuate.tween(r, 0.5, { y:Config.HEIGHT * 2 } ).ease(Elastic.easeIn)
					Actuate.tween(junta, 1, { y:0 } ).ease(Quad.easeOut)
				})
			});			
		}
		
		private function onSuaResposta(e:MouseEvent):void 
		{
			answerUser.visible = true;
			answerUser.alpha = 1;
			answerUser.scaleX = 0.01;
			answerUser.scaleY = 0.01;
			
			Actuate.tween(answerUser, 0.6, { scaleX:2, scaleY:2 } ).ease(Elastic.easeOut).onComplete(function():void {
				Actuate.tween(answerUser, 0.6, { scaleX:1, scaleY:1  } ).ease(Linear.easeNone)
			});	
			
		}
		
		private function onVerCorreta(e:MouseEvent):void 
		{
			
		}
		
		private function onWaitingLabels(e:Event):void 
		{
			blockelements = false;
			isLabelPositioned = true;
			moveAxis();
			showControls();
		}
		
		private function onEvaluating(e:Event):void 
		{
			hideControls();
			blockelements = true;
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
		
		public override function changeMessageObject(tx:String):void {
			message.texto.text = tx;
			
			
		}

		private function startTutorial():void {
			var tut:Tutorial = new Tutorial();
			tut.addEventListener(TutorialEvent.BALAO_ABRIU, onBalaoAbriu)
			tut.addEventListener(TutorialEvent.FIM_TUTORIAL, onFinishTutorial)
			
			var p1:Point = new Point(Sprite(sprElements.getChildByName("lbl_2")).x, Sprite(sprElements.getChildByName("lbl_2")).y - 30);
			var p2:Point = new Point(Sprite(sprElements.getChildByName("lbl_0")).x, Sprite(sprElements.getChildByName("lbl_0")).y - 30);
			var p3:Point = new Point(Sprite(sprElements.getChildByName("lbl_1")).x, Sprite(sprElements.getChildByName("lbl_1")).y - 30);			
			tut.adicionarBalao("Escolha um objeto qualquer arrastando para cima dele a bandeira 'meu objeto'.", 
				p1,  CaixaTexto.BOTTOM, CaixaTexto.CENTER);
			tut.adicionarBalao("Seu objetivo é determinar as coordenadas desse objeto.", 
				new Point(100, 40), CaixaTexto.LEFT, CaixaTexto.FIRST);
			tut.adicionarBalao("Para isso, você deve antes definir o 'sistema de referência'.", 
				new Point(300, 300), CaixaTexto.CENTER, 0);
			tut.adicionarBalao("Primeiramente, escolha um objeto para ser a origem do sistema de referência, arrastando para cima dele a bandeira 'origem do sistema de referência'.", 
				p2,  CaixaTexto.BOTTOM, CaixaTexto.CENTER);
			tut.adicionarBalao("Finalmente, escolha um 'outro' objeto para definir a orientação do eixo x, arrastando para cima dele a bandeira 'orientação do sistema de referência'.", 
				p3,  CaixaTexto.BOTTOM, CaixaTexto.CENTER);				
			tut.adicionarBalao("Estes dois objetos definem o eixo x, que passa por eles, e o eixo y, perpendicular ao eixo x.", 
				new Point(300, 300), CaixaTexto.CENTER, 0);
			tut.adicionarBalao("Utilize a régua para medir as coordenadas.", 
				new Point(40, 150), CaixaTexto.LEFT, CaixaTexto.FIRST);
			tut.adicionarBalao("Preencha as coordenadas e pressione 'terminei' para conferir sua resposta.", 
				new Point(100, 100), CaixaTexto.LEFT, CaixaTexto.FIRST);				
				
			tut.iniciar(stage);
			
			
			
		}		
		
		private function onFinishTutorial(e:TutorialEvent):void 
		{
			
		}
		
		private function onBalaoAbriu(e:TutorialEvent):void 
		{
			
		}
		
		
	}
	
}