package view 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class ElementSprite  extends Sprite
	{
		private var _graphicalSymbol:MovieClip;
		private var _element:Element;
		public function ElementSprite(graphicalSymbol:MovieClip, element:Element)
		{
			super();
			this.graphicalSymbol = graphicalSymbol;
			this.element = element;
			addChild(graphicalSymbol);
		}
		
		public function get graphicalSymbol():MovieClip 
		{
			return _graphicalSymbol;
		}
		
		public function set graphicalSymbol(value:MovieClip):void 
		{
			_graphicalSymbol = value;
		}
		
		public function get element():Element 
		{
			return _element;
		}
		
		public function set element(value:Element):void 
		{
			_element = value;
		}
		
	}
	
}