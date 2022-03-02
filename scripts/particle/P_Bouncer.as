package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_BouncerData;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_Bouncer extends Particle
   {
      
      public static const MAIN:String = "bouncer_main";
       
      
      protected var _data:DO_BouncerData;
      
      public function P_Bouncer(layerNo:int, data:DO_BouncerData)
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
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_staticBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsOrientedBox(this._data.scale * this._data.WIDTH / Constants.SCALE / 2,this._data.scale * this._data.HEIGHT * 0.8 / 2 / Constants.SCALE,new b2Vec2(0,this._data.HEIGHT * 0.1 * this._data.scale / Constants.SCALE));
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         _costume = new MC_Bouncer();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         var u:P_Unit = null;
         var w:P_Wheel = null;
         var o:P_Obstacle = null;
         var pow:Number = 0;
         if(p is P_Unit && targetData == P_Unit.FOOT && (p as P_Unit).isBounced == 0)
         {
            u = p as P_Unit;
            u.isBounced = 5;
            this.bounce();
            pow = this._data.power * u.scale * u.scale * 6;
            u.body.SetLinearVelocity(new b2Vec2(u.body.GetLinearVelocity().x,0));
            u.body.ApplyImpulse(new b2Vec2(0,-pow / Constants.SCALE),u.body.GetWorldCenter());
            SM.ins.playSound(GameSound.BOUNCER_BOUNCE);
         }
         else if(p is P_Wheel && (p as P_Wheel).isBounced == 0)
         {
            w = p as P_Wheel;
            w.isBounced = 5;
            this.bounce();
            pow = this._data.power * w.data.scale * w.data.scale * 3;
            w.body.SetLinearVelocity(new b2Vec2(w.body.GetLinearVelocity().x,0));
            w.body.ApplyImpulse(new b2Vec2(0,-pow / Constants.SCALE),w.body.GetWorldCenter());
            SM.ins.playSound(GameSound.BOUNCER_BOUNCE);
         }
         else if(p is P_Obstacle && (p as P_Obstacle).isBounced == 0)
         {
            o = p as P_Obstacle;
            o.isBounced = 5;
            this.bounce();
            pow = this._data.power * o.body.GetMass() * 7;
            o.body.SetLinearVelocity(new b2Vec2(o.body.GetLinearVelocity().x,0));
            o.body.ApplyImpulse(new b2Vec2(0,-pow / Constants.SCALE),o.body.GetWorldCenter());
            SM.ins.playSound(GameSound.BOUNCER_BOUNCE);
         }
         super.preHit(p,b,angle,selfData,targetData);
      }
      
      public function bounce() : void
      {
         if(!_isCreated)
         {
            return;
         }
         _costume.gotoAndPlay("bounce");
      }
      
      public function get data() : DO_BouncerData
      {
         return this._data;
      }
   }
}
