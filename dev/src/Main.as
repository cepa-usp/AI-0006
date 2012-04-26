package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	import pipwerks.ScormComm;
	import pipwerks.ScormViewer;
	import view.Scene;
	import view.SceneEvent;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite 
	{

		
		private var scene:Scene = new Scene();
		private var round:Round;
		private var scorm2:ScormComm = new ScormComm();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//scrollRect = new Rectangle(round.WIDTH, round.HEIGHT);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.scrollRect = new Rectangle(0, 0, 700, 600);
			addChild(scene);
			//var viewer:ScormViewer = new ScormViewer(stage, scorm);
			if (ExternalInterface.available) {
				initLMSConnection();
			}
			startRound();
			
		}
		
		
		
		private function startRound():void {
			round = new Round();
			scene.changeRound(round);
			scene.addEventListener(SceneEvent.ELEMENTS_CREATED, onSceneElementsCreated);
			scene.addEventListener(SceneEvent.LABELS_CREATED, onSceneLabelsCreated);
			scene.addEventListener(SceneEvent.LABEL_CHANGED, onSceneLabelChanged);	
			scene.addEventListener(SceneEvent.REFRESH_REQUEST, onRefreshRequest);	
			scene.addEventListener(SceneEvent.ELEMENT_MOVED, onSceneElementMoved);	
			scene.addEventListener(SceneEvent.EVALUATE_REQUEST, onEvaluateRequest);	
			round.state = Round.STATE_CREATING;
			scene.drawCoordinates();
			scene.drawControls();
			
		}
		
		private function onEvaluateRequest(e:SceneEvent):void 
		{
			//round.evaluate();
			var userAnswer:Point = e.vars.useranswerPosition;
			trace("resposta do usuario", e.vars.useranswerPosition)
			var correctAnswer:Point = e.vars.correctAnswerPosition;
			
			var currentScore:Number = round.evaluate(Point.distance(userAnswer, correctAnswer));		
			nTentativas++;
			score = ((score * (nTentativas - 1)) + currentScore) / nTentativas
			if (score >= 50) {
				completed = true;
			}
			commit();
			
			
			//scorm.connectScorm()
			
			/*if (scorm.scormConnected) {
				var memento:Object = scorm.loadState();
				var numTentativas:Number = 0;
				if (memento != null) {
					if (memento.numTentativas != null) {
						numTentativas = memento.numTentativas;	
					} else {
						numTentativas = 0;	
					}					
				} else {
					numTentativas = 0;
				}
				var mediaAnterior:Number = scorm.getScore();				
				
				
				var val:Number = (mediaAnterior * numTentativas + score)/numTentativas+1;
				memento.numTentativas = numTentativas + 1;
				if (score >= 50) {
					scorm.setLessonStatus(ScormComm.LESSONSTATUS_COMPLETED);
				} else {
					scorm.setLessonStatus(ScormComm.LESSONSTATUS_INCOMPLETE);
				}
				scorm.setScore(val);
				
				scorm.saveState(memento);
				scorm.save();
				
				scorm.disconnectScorm()
			}*/

			
		}
		
		private function onSceneElementMoved(e:SceneEvent):void 
		{
			var element:Element = e.vars.element;
			var pos:Point = e.vars.position;
			element.x = pos.x;
			element.y = pos.y;
			scene.moveAxis();
			
		}
		
		private function onRefreshRequest(e:SceneEvent):void 
		{
			startRound();
		}
		
		private function onSceneLabelChanged(e:SceneEvent):void 
		{
			round.changeLabel(e.vars.changeLabelType, e.vars.closerElement);
		}
		
		private function onSceneLabelsCreated(e:Event):void 
		{
			round.state = Round.STATE_WAITINGLABELS;
		}
		
		private function onSceneElementsCreated(e:Event):void 
		{
			round.randomizeLabels();
		}
		
		
	/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:int;
		private var pingTimer:Timer;
		private var nTentativas:int = 0;
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				var stringScore:String = scorm.get("cmi.score.raw");
				var stringTentativas:String = scorm.get("cmi.suspend_data");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = 1;
				if (stringScore != "") score = Number(stringScore.replace(",", "."));
				else score = 0;
				
				if (stringTentativas != "") nTentativas = int(stringTentativas);
				else nTentativas = 0;
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit()
		{
			if (connected)
			{
				scorm.set("cmi.exit", "suspend");
				
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				success = scorm.set("cmi.suspend_data", String(nTentativas));

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent)
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		
	}
	
}