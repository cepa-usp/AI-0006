package 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
			scene.drawCoordinates()
			
		}
		
		private function startRound():void {
			round = new Round();
			scene.changeRound(round);
			scene.addEventListener(SceneEvent.ELEMENTS_CREATED, onSceneElementsCreated);
			scene.addEventListener(SceneEvent.LABELS_CREATED, onSceneLabelsCreated);
			scene.addEventListener(SceneEvent.LABEL_CHANGED, onSceneLabelChanged);	
			scene.addEventListener(SceneEvent.REFRESH_REQUEST, onRefreshRequest);	
			round.state = Round.STATE_CREATING;
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