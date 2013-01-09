package object
{
	import events.UIEvent;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class UserInterface extends Sprite
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const BOOST:String = "boost";
		
		private var btnUp:Button;
		private var btnDown:Button;
		private var btnBoost:Button;
		
		public function UserInterface()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			
			btnUp = new Button(Assets.getTexture("UpButton"));
			btnUp.alpha = .5;
			btnUp.x = 10;
			btnUp.y = stage.stageHeight - btnUp.height * 2;
			btnUp.addEventListener(Event.TRIGGERED, onUpClick);
			
			btnDown = new Button(Assets.getTexture("DownButton"));
			btnDown.alpha = .5;
			btnDown.x = 10;
			btnDown.y = stage.stageHeight - btnDown.height;
			btnDown.addEventListener(Event.TRIGGERED, onDownClick);
			
			btnBoost = new Button(Assets.getTexture("BoostButton"));
			btnBoost.alpha = .5;
			btnBoost.x = stage.stageWidth - btnBoost.width;
			btnBoost.y = stage.stageHeight - btnBoost.height;
			btnBoost.addEventListener(Event.TRIGGERED, onBoostClick);
			
			addChild(btnUp);
			addChild(btnDown);
			addChild(btnBoost);
			
		}
		
		private function onBoostClick(e:Event):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.BUTTON_CLICK, true, {id:BOOST}));
		}
		
		private function onDownClick(e:Event):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.BUTTON_CLICK, true, {id:DOWN}));
		}
		
		private function onUpClick(e:Event):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.BUTTON_CLICK, true, {id:UP}));
		}
	}
}