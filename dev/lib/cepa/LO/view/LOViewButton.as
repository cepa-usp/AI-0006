package cepa.LO.view 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class LOViewButton extends Sprite
	{
		private var _buttonIcon:MovieClip;
		private var _onMouseOverText:String = "";
		
		public function LOViewButton(icon:MovieClip, displayMessage:String = "") 
		{
			
			icon.useHandCursor = true;
			icon.buttonMode = true;
			icon.mouseChildren = false;
			icon.addEventListener(MouseEvent.MOUSE_OVER, buttonOnMouseOver);
			icon.addEventListener(MouseEvent.MOUSE_OUT, buttonOnMouseOut);
			icon.gotoAndStop(1);
			_buttonIcon = icon;
			onMouseOverText = displayMessage;

		}
		
		public function get buttonIcon():MovieClip 
		{
			return _buttonIcon;
		}
		
		public function set buttonIcon(value:MovieClip):void 
		{
			_buttonIcon = value;
		}
		
		public function get onMouseOverText():String 
		{
			return _onMouseOverText;
		}
		
		public function set onMouseOverText(value:String):void 
		{
			_onMouseOverText = value;
		}
		
	}
	
}