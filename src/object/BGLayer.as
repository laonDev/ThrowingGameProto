package object
{
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BGLayer extends Sprite
	{
		private var _layer:int;
		private var image1:Image;
		private var image2:Image;
		
		public function BGLayer($layer:int = 0)
		{
			super();
			_layer = $layer;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if(_layer == 1)
			{
				image1 = new Image(Assets.getTexture("BgLayer" + _layer));
				image2 = new Image(Assets.getTexture("BgLayer" + _layer));
			}else
			{
				trace("layer " + _layer + "need additional layer resources");
			}
			image1.x = 0;
			image1.y = stage.stageHeight - image1.height;
			
			image2.x = image2.width;
			image2.y = image1.y;
			
			this.addChild(image1);
			this.addChild(image2);
		}
		
		
		public function get layer():int
		{
			return _layer;
		}

		public function set layer(value:int):void
		{
			_layer = value;
		}

	}
}