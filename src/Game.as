package
{
	import flash.ui.Keyboard;
	
	import object.FlyObject;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.deg2rad;
	
	public class Game extends Sprite
	{
		private var flyObject:FlyObject;
		private var vx:Number;
		private var vy:Number;
		private var theta:Number = 0.45;
		private var initForce:Number = 10000;
		private var initDegree:Number = -30;
		private var gravity:Number = 9.8;
		private var massive:Number = 1000;
		private var tick:Number = 0;
		private var prevX:Number;
		private var prevY:Number;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			flyObject = new FlyObject();
			flyObject.x = prevX = 0;
			flyObject.y = prevY = stage.stageHeight /2;
			flyObject.rotation = deg2rad(initDegree);
			this.addChild(flyObject);
			
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			switch(e.keyCode)
			{
				case Keyboard.UP:
					trace("up");
					initDegree--;
					flyObject.rotation = deg2rad(initDegree);
					break;
				case Keyboard.DOWN:
					trace("down");
					initDegree++;
					flyObject.rotation = deg2rad(initDegree);
					break;
			}
			trace(initDegree);
		}
		
		private function onGameTick(e:Event):void
		{
			vx = (initForce/massive) * Math.cos(deg2rad(-initDegree)) + tick*10*Math.cos(deg2rad(270)) / massive;
			vy = (initForce/massive) * Math.sin(deg2rad(-initDegree)) - gravity*tick - tick*10*Math.sin(deg2rad(270)) / massive;
			
			flyObject.x += vx;
			flyObject.y -= vy;
			
			var diffX:Number = flyObject.x - prevX;
			var diffY:Number = flyObject.y - prevY;
			prevX = flyObject.x;
			prevY = flyObject.y;
			
//			flyObject.rotation = -(Math.atan2(diffY, diffX) * 180 / Math.PI);
//			trace(flyObject.rotation);
			tick += 0.01;
		}
	}
}