package cepa.LO.view
{
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class LearningObjectScene extends Sprite
	{
		
		private var screenMessage:String = " ";
		protected var sprAboutScreen:AboutScreen = new AboutScreen();
		protected var sprInfoScreen:InstScreen = new InstScreen();
		
		public function LearningObjectScene() 
		{
			
		}
		
		public function workAsButton(o:MovieClip, displayText:String = ""):void {
				MovieClip(o).useHandCursor = true;
				MovieClip(o).buttonMode = true;
				MovieClip(o).mouseChildren = false;
				MovieClip(o).addEventListener(MouseEvent.MOUSE_OVER, buttonOnMouseOver);
				MovieClip(o).addEventListener(MouseEvent.MOUSE_OUT, buttonOnMouseOut);
				MovieClip(o).gotoAndStop(1);
				if (displayText.length > 0) {
					MovieClip(o).addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{ setMessage(displayText) });
					MovieClip(o).addEventListener(MouseEvent.MOUSE_OUT, info);
				}
		}
		private function buttonOnMouseOut(e:MouseEvent):void 
		{
			MovieClip(e.target).gotoAndStop(1);
		}
		
		private function buttonOnMouseOver(e:MouseEvent):void 
		{
			MovieClip(e.target).gotoAndStop(5);
		}

		protected function openPanel(d:MovieClip):void {
			d.visible = true;
			d.alpha = 0;
			d.gotoAndStop(1);						
			Actuate.tween(d, 0.5, { alpha:1 } );
		}
		
		protected function closePanel(e:MouseEvent):void 
		{
			e.target.gotoAndPlay(2);
			Actuate.tween(e.target, 0.5, { alpha:0.8 } ).onComplete(setPanelInvisbile, e.target);				

		}
		
		protected function setPanelInvisbile(d:DisplayObject):void 
		{
			d.visible = false;
		}
				
		
		protected function info(e:MouseEvent):void 
		{
			
			setMessage(screenMessage)
		}

		public function setMessage(tx:String, save:Boolean = false):void {
			if (save) screenMessage = tx;
			//sprLabel.legenda.texto.text = tx;
			changeMessageObject(tx);
		}
		
		
		public function changeMessageObject(tx:String):void {
			// override it
			
			
		}
		
	}
	
}