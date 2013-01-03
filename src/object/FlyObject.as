package object
{
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FlyObject extends Sprite
	{
		private var objectResource:Image;
		
		public function FlyObject()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			createObject();
			
		}
		
		private function createObject():void
		{
			objectResource = new Image(Assets.getAtlas().getTexture("fly_object0000"));
			objectResource.x = Math.ceil(-objectResource.width/2);
			objectResource.y = Math.ceil(-objectResource.height/2);
			this.addChild(objectResource);
			
		}
	}
}