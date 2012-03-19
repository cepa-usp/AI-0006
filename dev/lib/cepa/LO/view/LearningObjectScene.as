package cepa.LO.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class LearningObjectScene extends Sprite
	{
		
		private var screenMessage:String;
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
		
		private function info(e:MouseEvent):void 
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
			//trace("LearningObjectScene message: ", tx);
			
		}
		
	}
	
}