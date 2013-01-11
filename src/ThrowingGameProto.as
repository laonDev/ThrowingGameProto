package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", height="640", width="960")]
	public class ThrowingGameProto extends Sprite
	{
		private var stats:Stats;
		private var star:Starling;
		
		public function ThrowingGameProto()
		{
			super();
			stats = new Stats();
			addChild(stats);
			star = new Starling(Main, stage);
			star.antiAliasing = 1;
			star.start();
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		private function onContextCreated(e:Event):void
		{
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			(star.stage.getChildAt(0) as Main).setDebugDraw(debugSprite);
		}
	}
}