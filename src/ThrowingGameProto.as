package
{
	import flash.display.Sprite;
	
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
			star = new Starling(Game, stage);
			star.antiAliasing = 1;
			star.start();
			
		}
	}
}