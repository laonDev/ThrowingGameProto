package
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import events.UIEvent;
	
	import object.FlyObject;
	import object.GameBackGround;
	import object.UserInterface;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.deg2rad;
	
	public class Game extends Sprite
	{
		private const HORIZONTAL_MEASURE:Number = 5;
		private const VERTICAL_MEASURE:Number = 2;
		private const INIT_OBJECT_POSITION:Point = new Point(250, 300);
		private const WIND_FORCE_TABLE:Array = [10, 15, 20, 25, 30];
		private const DEGREES:Array = [11.25, 22.5, 45];
		
		private var flyObject:FlyObject;
		private var bg:GameBackGround;
		private var info:Information;
		private var ui:UserInterface;
		
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
		private var moveX:Number;
		private var moveY:Number;
		private var prevX:Number;
		private var prevY:Number;
		private var degreeChangeCount:int;
		
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
			
			ui = new UserInterface();
			this.addChild(ui);
			this.addEventListener(UIEvent.BUTTON_CLICK, onUIButtonClick);
			
		}
		
		private function onUIButtonClick(e:UIEvent):void
		{
			trace(e.data.id);
			
			switch(e.data.id)
			{
				case UserInterface.UP:
					initDegree -= 11.25
					TweenLite.to(flyObject, 0.5, {rotation: deg2rad(initDegree)});
					break;
				case UserInterface.DOWN:
					initDegree += 11.25
					TweenLite.to(flyObject, 0.5, {rotation: deg2rad(initDegree)});
					break;
				case UserInterface.BOOST:
					break;
			}
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
		
		private function initialize():void
		{
			setting.initialize();
			bg.isGround = false;
			playBtn.visible = true;
			moveX = moveY = 0;
			degreeChangeCount = 0;
			
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
			
			degreeChangeCount = 0;
			moveX = moveY = 0;
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
		
		private function onGameTick(e:Event):void
		{
			vx = (initForce/massive) * Math.cos(deg2rad(-initDegree)) + 0.015 * windForce * Math.cos(deg2rad(180)) / massive;
			vy = (initForce/massive) * Math.sin(deg2rad(-initDegree)) - gravity * tick - 0.015 * windForce * Math.sin(deg2rad(180)) / massive;
			
//			vx = vx < 0 ? 0 : vx;
			//until flying object get to init position move flying object and then move background
			//fly object land off 
			trace("vy: ", vy);
			trace("vx: ", vx);
			trace("wf: ", 0.015 * windForce * Math.cos(deg2rad(180)) / massive);
			
			
			if(flyObject.x < INIT_OBJECT_POSITION.x)
			{
				flyObject.x += vx;
			}else
			{
				bg.speedX = vx;
			}
			
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
				{
					vy = flyObject.y < stage.stageHeight - flyObject.height/2 ? vy : 0;
					flyObject.y -= vy;
				}
				else
					bg.speedY = vy;
				
				if(vx <= 0 && flyObject.y > stage.stageHeight - flyObject.height/2)
				{
					trace("----------");
					this.removeEventListener(Event.ENTER_FRAME, onGameTick);
					initialize();
					return;
				}
//				
			}
			bg.update();
			//디바이스 별 치환
//			meterToPixel(vx, vy);
			setInfo();
//			info.distance += vx;
//			info.altitude += vy;;
			tick += 0.015;
			//speed
//			var dx:Number = flyObject.x - (flyObject.x + vx);
//			var dy:Number = vy - prevY;
			var distance:Number = Math.sqrt((vx*vx) + (vy*vy));
			var speed:Number = Math.abs(distance / tick);
			info.speed = speed;
			prevX = vx;
			prevY = vy;
			if(vy < 0)
			{
				initDegree += 0.4;
				if(initDegree >= 30) initDegree = 30;
				flyObject.rotation = deg2rad(initDegree);
			}
			
		}
		
		private function setInfo():void
		{
			// TODO Auto Generated method stub
			moveX += vx;
			moveY += vy;
			info.distance = moveX / stage.stageWidth * HORIZONTAL_MEASURE;
			info.altitude = moveY / stage.stageHeight * VERTICAL_MEASURE;
		}
		
		private function meterToPixel($vx:Number, $vy:Number):void
		{
			// TODO Auto Generated method stub
			vx = $vx * HORIZONTAL_MEASURE / stage.stageWidth;
			vy = $vy * VERTICAL_MEASURE / stage.stageHeight;
			trace("after : ", vx, vy);
		}
		
		
		
	}
}