package tutorial 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Tutorial extends Sprite
	{
		private var baloes:Vector.<CaixaTexto> = new Vector.<CaixaTexto>();
		private var position:int = -1;
		private var balaoatual:CaixaTexto = null;
		
		
		
		public function Tutorial() 
		{
			
		}
		
		public function adicionarBalao(texto:String, pos:Point, ladoSeta:int, posicaoSeta:int):CaixaTexto {
			var balao:CaixaTexto = new CaixaTexto();			
			balao.setText(texto, ladoSeta, posicaoSeta);
			balao.setPosition(pos.x, pos.y);
			//balao.addEventListener(Event.CLOSE, closeBalao);			
			balao.visible = true;
			baloes.push(balao);
			return balao;
		}
		
		
		public function iniciar(stage:Stage):void {			
			stage.addChild(this);						
			position = -1;
			dispatchEvent(new TutorialEvent(-1, TutorialEvent.INICIO_TUTORIAL, true));			
			proximo();
			
			
		}
		
		public function proximo(e:Event = null):void {
			position++;			
			if (position == baloes.length) {
				finalize()
				return;
			}
			if (balaoatual != null) {
				removeChild(balaoatual)
			}
			balaoatual = baloes[position];
			balaoatual.visible = true;
			balaoatual.alpha = 0;
			addChild(balaoatual);
			dispatchEvent(new TutorialEvent(position, TutorialEvent.BALAO_ABRIU, true));
			Actuate.tween(balaoatual, 0.5, { alpha:1 } ).onComplete(giveControl);
			
		}
		
		
		private function giveControl():void {
			if(position==0) stage.addEventListener(MouseEvent.CLICK, proximo);
		}
		
		private function finalize():void 
		{
			stage.removeEventListener(MouseEvent.CLICK, proximo);			
			stage.removeChild(this);			
			position = -1;
			dispatchEvent(new TutorialEvent(-1, TutorialEvent.FIM_TUTORIAL, true));			
		}
		
		
		
	}
	
}