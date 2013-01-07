package
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import object.FlyObject;
	import object.GameBackGround;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.deg2rad;
	
	public class Game extends Sprite
	{
		private const INIT_OBJECT_POSITION:Point = new Point(250, 300);
		private const WIND_FORCE_TABLE:Array = [10, 15, 20, 25, 30];
		private var flyObject:FlyObject;
		private var bg:GameBackGround;
		private var info:Information;
		
		private var setting:GameSetting;
		private var playBtn:Button;
		
		private var vx:Number;
		private var vy:Number;
		private var initForce:Number;
		private var initDegree:Number = 0;
		private var gravity:Number;
		private var massive:Number;
		private var tick:Number = 0;
		private var windForce:Number = 10;
		private var prevX:Number;
		private var prevY:Number;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			bg = new GameBackGround();
			this.addChild(bg);
			info = new Information();
			this.addChild(info);
			
			flyObject = new FlyObject();
			this.addChild(flyObject);
			flyObject.x = flyObject.width /2;
			flyObject.y = stage.stageHeight - flyObject.height;
			
			setting = new GameSetting();
			this.addChild(setting);
			setting.massive = 1;
			setting.gravity = 9.8;
			setting.degree = -45;
			setting.force = 20;
			
			playBtn = new Button(Assets.getTexture("PlayButton"));
			playBtn.x = 560;
			playBtn.y = 250;
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			this.addChild(playBtn);
			
			
			
		}
		
		private function onPlayClick(e:Event):void
		{
			// game setting view and play button remove on the screen
			// and get setting value from GameSetting and set values
			setting.temporaryDipose();
			playBtn.visible = false;
			info.distance = 0;
			info.speed = 0;
			info.altitude = 0;
			
			vx = vy = 0;
			tick = 0;
			
			initForce = setting.force > 0 ? setting.force : 20;
			initDegree = setting.degree;
			gravity = setting.gravity > 0 ? setting.gravity : 9.8;
			massive = setting.massive > 0 ? setting.massive : 1;
			
			trace("force: ", initForce);
			trace("degree: ", initDegree);
			trace("gravity: ", gravity);
			trace("massice: ", massive);
			flyObject.x = flyObject.width /2;
			flyObject.y = stage.stageHeight - flyObject.height;
			flyObject.rotation = deg2rad(initDegree);
			
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
						
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
			vx = (initForce/massive) * Math.cos(deg2rad(-initDegree)) + tick * windForce * Math.cos(deg2rad(180)) / massive;
			vy = (initForce/massive) * Math.sin(deg2rad(-initDegree)) - gravity * tick - tick * windForce * Math.sin(deg2rad(180)) / massive;
			
			//until flying object get to init position move flying object and then move background
			//fly object land off 
			trace("vy: ", vy);
			if(flyObject.x < INIT_OBJECT_POSITION.x)
			{
				flyObject.x += vx;
			}else
			{
				bg.speedX = vx;
			}
			trace(flyObject.y);
			if(vy > 0) //상승 중
			{
				if(flyObject.y > INIT_OBJECT_POSITION.y)
					flyObject.y -= vy;
				else
					bg.speedY = vy;
			}
			else //하강 중
			{
				if(bg.isGround)
					flyObject.y -= vy;
				else
					bg.speedY = vy;
			}
			
//			if(flyObject.y > INIT_OBJECT_POSITION.y || flyObject.y < INIT_OBJECT_POSITION.y)
//			{
//				flyObject.y -= vy;
//			}
//			if(!bg.isGround)
//			{
//				trace("move");
//				bg.speedY = vy;
//			}
//			trace(flyObject.y, bg.y);
			bg.update();
			if(flyObject.y > stage.stageHeight - flyObject.height/2)
			{
				this.removeEventListener(Event.ENTER_FRAME, onGameTick);
				initialize();
				return;
			}
			if(vy < 0)
			{
				initDegree += 0.4;
				if(initDegree >= 30) initDegree = 30;
				flyObject.rotation = deg2rad(initDegree)
			}
			prevX = flyObject.x;
			prevY = flyObject.y;
			
//			flyObject.rotation = -(Math.atan2(diffY, diffX) * 180 / Math.PI);
//			trace(flyObject.rotation);
			info.distance += vx;
			info.altitude += vy;;
			tick += 0.01;
		}
		
		private function initialize():void
		{
			setting.initialize();
			bg.isGround = false;
			playBtn.visible = true;
			
			
		}
		
	}
}