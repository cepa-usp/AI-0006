package pipwerks 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class ScormViewer extends Sprite
	{
		
		public var bg:Sprite = new Sprite();
		public var tx:TextField = new TextField();
		private var scorm:ScormComm;
		public function ScormViewer(stage:Stage, scorm:ScormComm) 
		{
			addChild(bg)
			this.scorm = scorm;
			bg.graphics.beginFill(1, 0.7);
			bg.graphics.drawRect(0, 0, 400, 500);
			addChild(tx)
			var tf:TextFormat = new TextFormat(); 
            tf.font = "Courier New"; 
            tf.color = 0x00FF00; 
            tf.size = 12; 
            tx.defaultTextFormat = tf;
			tx.selectable = false;
			tx.setTextFormat(tf); 
			tx.width = 380
			tx.height = 400
			//tx.textWidth = 350
			tx.x = 10;
			tx.y = 10;
			//tx.textHeight = 450;
			
			stage.addChild(this);
			scorm.eventDispatcher.addEventListener(Event.CHANGE, onScormChange)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			tx.text = scorm.log;
			this.visible = false;
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			startDrag()
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			stopDrag()
		}
		
		private function onScormChange(e:Event):void 
		{
			tx.text = scorm.log;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.ctrlKey== true) {
				//if (e.keyCode == Keyboard.BACKSPACE) {
					this.visible = !this.visible;
				//}
			}
		}
		
	}
	
}