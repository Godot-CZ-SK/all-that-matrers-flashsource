package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_WheelData;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   
   public class P_Wheel extends Particle
   {
      
      public static const MAIN:String = "wheel_main";
       
      
      protected var _isBounced:int;
      
      protected var _data:DO_WheelData;
      
      public function P_Wheel(layerNo:int, data:DO_WheelData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(5,0.4,0.4);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_dynamicBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var s1:b2CircleShape = new b2CircleShape(this._data.RADIUS / Constants.SCALE * this._data.scale);
         var fix1:b2Fixture = _body.CreateFixture2(s1,_density);
         fix1.SetUserData(MAIN);
         fix1.SetFriction(_friction);
         fix1.SetRestitution(_restitution);
         _costume = new MC_Wheel();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         this._isBounced = 0;
      }
      
      override public function postHit(p:Particle, b:b2Body, angle:Number, power:Number, selfData:String, targetData:String) : void
      {
         var threshold:Number = 10 * this._data.scale * this._data.scale;
         if(power > threshold)
         {
            SM.ins.playSound(GameSound.WHEEL_DROP);
         }
         super.postHit(p,b,angle,power,selfData,targetData);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._isBounced > 0)
         {
            --this._isBounced;
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.95,_body.GetLinearVelocity().y * 0.95));
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         if(_area)
         {
            if(!_area.containsPoint(new Point(_costume.x,_costume.y)))
            {
               safeRemove();
            }
         }
      }
      
      public function get data() : DO_WheelData
      {
         return this._data;
      }
      
      public function get isBounced() : int
      {
         return this._isBounced;
      }
      
      public function set isBounced(value:int) : void
      {
         this._isBounced = value;
      }
   }
}
