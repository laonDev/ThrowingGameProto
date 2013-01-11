package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import object.FlyObject;
	import object.GameBackGround;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Main extends starling.display.Sprite
	{
		private var m_world:b2World;
		private var worldScale:int=10;
		
		private var bodyDef:b2BodyDef;
		private var arrowVector:Vector.<b2Body>=new Vector.<b2Body>();
		public var m_velocityIterations:int = 10;
		public var m_positionIterations:int = 10;
		public var m_timeStep:Number = 1.0/30.0;
		
		private var touch:Touch;
		
		private var flyObject:FlyObject;
		private var bg:GameBackGround;
		private var prevPosition:b2Vec2;
		private var theWall:b2Body;
		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
						
		}
		
		
		private function onAddedToStage(e:Event):void
		{
			
			bg = new GameBackGround();
			this.addChild(bg);
			prevPosition = new b2Vec2();
			
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			var doSleep:Boolean = true;
			m_world = new b2World(gravity, doSleep);
			
			var body:b2Body;
			var boxShape:b2PolygonShape;
			var circleShape:b2CircleShape;
			
			wall(stage.stageWidth,stage.stageHeight-20,stage.stageWidth *2,20);
//			wall(630,240,20,480);
			//add ground body
//			bodyDef = new b2BodyDef();
//			bodyDef.position.Set(10, 28);
//			
//			boxShape = new b2PolygonShape();
//			boxShape.SetAsBox(30, 3);
//			var fixtureDef:b2FixtureDef = new b2FixtureDef();
//			fixtureDef.shape = boxShape;
//			fixtureDef.friction = 0.3;
//			fixtureDef.density = 0;
//			
//			var box:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0xcccccc);
//			box.pivotX = box.width / 2.0;
//			box.pivotY = box.height / 2.0;
//			bodyDef.userData = box;
//			bodyDef.userData.width = 34 * 2 * 30;
//			bodyDef.userData.height = 30 * 2 * 3;
//			addChild(bodyDef.userData);
//			body = m_world.CreateBody(bodyDef);
//			body.CreateFixture(fixtureDef);
			
			
//			
//			var quad:Quad;
//			// Add some objects
//			for (var i:int = 1; i < 100; i++)
//			{
//				bodyDef = new b2BodyDef();
//				bodyDef.type = b2Body.b2_dynamicBody;
//				bodyDef.position.x = Math.random() * 15 + 5;
//				bodyDef.position.y = Math.random() * 10;
//				var rX:Number = Math.random() + 0.5;
//				var rY:Number = Math.random() + 0.5;
//				// Box
//				boxShape = new b2PolygonShape();
//				boxShape.SetAsBox(rX, rY);
//				fixtureDef.shape = boxShape;
//				fixtureDef.density = 1.0;
//				fixtureDef.friction = 0.5;
//				fixtureDef.restitution = 0.2;
//				// create the quads
//				quad = new Quad(100, 100, Math.random()*0xFFFFFF);
//				quad.pivotX = quad.width / 2.0;
//				quad.pivotY = quad.height / 2.0;
//				// this is the key line, we pass as a userData the 
//				starling.display.Quad
//				bodyDef.userData = quad;
//				bodyDef.userData.width = rX * 2 * 30;
//				bodyDef.userData.height = rY * 2 * 30;
//				body = m_world.CreateBody(bodyDef);
//				body.CreateFixture(fixtureDef);
//				// show each quad (acting as a skin of each body)
//				addChild(bodyDef.userData);
//			}
			this.addEventListener(TouchEvent.TOUCH, onTouch);
//			this.addEventListener(Event.ENTER_FRAME, update);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		public function setDebugDraw(debugSprite:flash.display.Sprite):void{
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			m_world.SetDebugDraw(debugDraw);
			
		}
		private function wall(pX:Number, pY:Number, w:Number, h:Number):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX / worldScale, pY / worldScale);
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(w / 2 / worldScale, h / 2 / worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			theWall = m_world.CreateBody(bodyDef);
			theWall.CreateFixture(fixtureDef);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if(e.keyCode == Keyboard.SPACE)
			{
	//			touch = e.getTouch(stage);
				flyObject = new FlyObject();
				var angle:Number=0;
//				var angle:Number=Math.atan2(240,600);
				var vertices:Vector.<b2Vec2>=new Vector.<b2Vec2>();
				vertices.push(new b2Vec2(-1.4,0));
				vertices.push(new b2Vec2(0,-0.1));
				vertices.push(new b2Vec2(0.6,0));
				vertices.push(new b2Vec2(0,0.1));
				var bodyDef:b2BodyDef= new b2BodyDef();
				bodyDef.position.Set(50/worldScale,240/worldScale);
				bodyDef.type=b2Body.b2_dynamicBody;
				bodyDef.userData=flyObject;
				bodyDef.bullet=true;
				var polygonShape:b2PolygonShape = new b2PolygonShape();
				polygonShape.SetAsVector(vertices,4);
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.shape=polygonShape;
				fixtureDef.density=1;
				fixtureDef.friction=0.5;
				fixtureDef.restitution=0.5;
				var body:b2Body=m_world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
//				body.set
				body.SetLinearVelocity(new b2Vec2(20*Math.cos(angle),20*Math.sin(angle)));
				body.SetAngle(angle);
//				for (var i:Number=0; i<arrowVector.length; i++) {
//					arrowVector[i].GetUserData().follow=false;
//				}
				addChild(bodyDef.userData);
				arrowVector.push(body);
			}
		}
		private function onTouch(e:TouchEvent):void 
		{
			touch = e.getTouch(stage);
			if(touch.phase == TouchPhase.BEGAN)
			{
				var angle:Number=Math.atan2(touch.globalY-240,touch.globalX-50);
				var vertices:Vector.<b2Vec2>=new Vector.<b2Vec2>();
				vertices.push(new b2Vec2(-4.4,0));
				vertices.push(new b2Vec2(0,-2.1));
				vertices.push(new b2Vec2(4.6,0));
				vertices.push(new b2Vec2(0,2.1));
				var bodyDef:b2BodyDef= new b2BodyDef();
				bodyDef.position.Set(50/worldScale,240/worldScale);
				bodyDef.type=b2Body.b2_dynamicBody;
				bodyDef.userData= new FlyObject();
				bodyDef.bullet=true;
				var polygonShape:b2PolygonShape = new b2PolygonShape();
				polygonShape.SetAsVector(vertices,4);
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.shape=polygonShape;
				fixtureDef.density=1;
				fixtureDef.friction=0.5;
				fixtureDef.restitution=0.1;
				var body:b2Body=m_world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
				body.SetLinearVelocity(new b2Vec2(30*Math.cos(angle),30*Math.sin(angle)));
				body.SetAngle(angle);
				addChild(bodyDef.userData);
				arrowVector.push(body);
				this.addEventListener(Event.ENTER_FRAME, update);
			}
		}
		private function update(e:Event):void
		{
//			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces();
			
			m_world.Step(1/60,5,5);
//			world.ClearForces();
//			for (var i:Number=arrowVector.length-1; i>=0; i--) {
//				var body:b2Body=arrowVector[i];
//				if (body.GetType()==b2Body.b2_dynamicBody) {
//					if (! body.GetUserData().freeFlight) {
//						var flyingAngle:Number=Math.atan2(body.GetLinearVelocity().y,body.GetLinearVelocity().x);
//						body.SetAngle(flyingAngle);
//					}
//				}
//				else {
//					arrowVector.splice(i,1);
//					body.SetBullet(false);
//					body.GetUserData().follow=false;
//				}
//				if (body.GetUserData().follow) {
//					var posX:Number=body.GetPosition().x*worldScale;
//					posX=stage.stageWidth/2-posX;
//					if (posX>0) {
//						posX=0;
//					}
//					if (posX<-640) {
//						posX=-640;
//					}
//					x=posX;
//				}
//			}
			m_world.DrawDebugData();
			for(var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext())
			{
				if(bb.GetUserData() is DisplayObject)
				{
//					trace(bb.GetLinearVelocity().x, bb.GetLinearVelocity().y);
//					if(bb.GetLinearVelocity().x == 0 && bb.GetLinearVelocity().y == 0) //move end
//					{
//						this.removeEventListener(Event.ENTER_FRAME, update);
//						removeChild(bb.GetUserData() as DisplayObject);
//						m_world.DestroyBody(bb);
//						bg.initialize();
//					}
						
					var sprite:DisplayObject = bb.GetUserData() as DisplayObject;
					sprite.x = bb.GetPosition().x * 10 < 250 ? bb.GetPosition().x * 10 : sprite.x;
					sprite.y = bb.GetPosition().x * 10 > 250 ? bb.GetPosition().y * 10 : sprite.y;
//					trace(bb.GetPosition().x, bb.GetPosition().y);
					bg.speedX = bb.GetPosition().x * 10 < 250 ? bg.x : -(bb.GetPosition().x *10);
					bg.speedY = bb.GetPosition().x * 10 > 250 ? bg.y :-(bb.GetPosition().y*10);
					bg.update();
					theWall.SetPosition(new b2Vec2(theWall.GetPosition().x -1, theWall.GetPosition().y));
					if(theWall.GetPosition().x < 0) theWall.SetPosition(new b2Vec2(0, theWall.GetPosition().y));
					if(theWall.GetPosition().x < -stage.stageWidth) theWall.SetPosition(new b2Vec2(-stage.stageWidth, theWall.GetPosition().y));
//					trace(bg.x, theWall.GetPosition().x);
//					theWall.SetPosition(new b2Vec2(bg.x, stage.stageHeight-20));
//					trace(bg.x, theWall.GetPosition().x);
					prevPosition = bb.GetPosition();
					sprite.rotation = bb.GetAngle();
				}
			}
//			bodyDef.position.Set(10, 28);
			
		}
	}
}