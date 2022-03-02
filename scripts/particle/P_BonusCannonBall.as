package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_CannonBallData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   
   public class P_BonusCannonBall extends Particle
   {
      
      public static const MAIN:String = "bonus_cannon_ball_main";
       
      
      protected var _data:DO_CannonBallData;
      
      public function P_BonusCannonBall(layerNo:int, data:DO_CannonBallData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bDef:b2BodyDef = new b2BodyDef();
         bDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         bDef.type = b2Body.b2_kinematicBody;
         _body = PM.ins.world.CreateBody(bDef);
         _body.SetUserData(this);
         var s1:b2CircleShape = new b2CircleShape(this._data.radius * this._data.scale / Constants.SCALE);
         var f1:b2Fixture = _body.CreateFixture2(s1,this._data.density);
         var fd:b2FilterData = new b2FilterData();
         fd.categoryBits = 22;
         fd.maskBits = ~8;
         f1.SetUserData(MAIN);
         var speed:b2Vec2 = new b2Vec2(this._data.speed * Math.cos(this._data.angle),this._data.speed * Math.sin(this._data.angle));
         _body.SetLinearVelocity(speed);
         _body.SetAngularVelocity(5);
         _costume = new MC_CannonBall();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.filters.push(new GlowFilter(13369344,0.6,10,10,2));
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         setLifeTime(500);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         var transform:b2Transform = new b2Transform(_body.GetPosition(),new b2Mat22());
         PM.ins.world.QueryShape(this.queryCallback,_body.GetFixtureList().GetShape(),transform);
      }
      
      private function queryCallback(fix:b2Fixture) : Boolean
      {
         var p:Particle = fix.GetBody().GetUserData();
         if(p == this || fix.IsSensor())
         {
            return true;
         }
         this.die();
         return true;
      }
      
      override public function die() : void
      {
         if(!_isCreated || isDead)
         {
            return;
         }
         var mc1:MC_CannonCloud1 = new MC_CannonCloud1();
         mc1.x = -5;
         mc1.y = -5;
         var mc2:MC_CannonCloud2 = new MC_CannonCloud2();
         mc2.x = 5;
         mc2.y = -5;
         var mc3:MC_CannonCloud3 = new MC_CannonCloud3();
         mc3.x = 5;
         mc3.y = 5;
         var mc4:MC_CannonCloud4 = new MC_CannonCloud4();
         mc4.x = -5;
         mc4.y = 5;
         _costume.addChild(mc1);
         _costume.addChild(mc2);
         _costume.addChild(mc3);
         _costume.addChild(mc4);
         mc1.addEventListener("end",this.removeCloudHandler);
         mc2.addEventListener("end",this.removeCloudHandler);
         mc3.addEventListener("end",this.removeCloudHandler);
         mc4.addEventListener("end",this.removeCloudHandler);
         safeRemove();
         _isFading = true;
         TweenLite.to(_costume,0.8,{"alpha":0});
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_costume);
         },0.8);
         SM.ins.playSound(GameSound.CANNON_SHOOT);
         super.die();
      }
      
      private function removeCloudHandler(e:Event) : void
      {
         CF.removeDisplayObject(e.currentTarget as MovieClip);
      }
   }
}
