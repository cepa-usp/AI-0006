package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//scrollRect = new Rectangle(round.WIDTH, round.HEIGHT);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(scene);
			scene.drawControls();
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
		}
		
		private function onEvaluateRequest(e:SceneEvent):void 
		{
			//round.evaluate();
			var userAnswer:Point = e.vars.useranswerPosition;
			var correctAnswer:Point = e.vars.correctAnswerPosition;
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
		
		
		
		
		
	}
	
}