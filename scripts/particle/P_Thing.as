package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_ThingData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Thing extends Particle
   {
      
      public static const MAIN:String = "thing_main";
       
      
      protected var _data:DO_ThingData;
      
      public function P_Thing(layerNo:int, data:DO_ThingData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(5,0.4,0.4);
      }
      
      override public function create() : void
      {
         var s2:b2CircleShape = null;
         var f2:b2Fixture = null;
         var s3:b2CircleShape = null;
         var f3:b2Fixture = null;
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
         _body.SetAngle(this._data.rotation);
         var w:Number = 20;
         var h:Number = 5;
         if(this._data.thingType == 1)
         {
            w = 12;
            h = 15;
         }
         else if(this._data.thingType == 2)
         {
            w = 40;
            h = 5;
         }
         else
         {
            w = 30;
            h = 20;
         }
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsBox(w * this._data.scale / 2 / Constants.SCALE,h * this._data.scale / 2 / Constants.SCALE);
         var fix1:b2Fixture = _body.CreateFixture2(s1,_density);
         fix1.SetUserData(MAIN);
         fix1.SetFriction(_friction);
         fix1.SetRestitution(_restitution);
         if(this._data.thingType == 3)
         {
            s2 = new b2CircleShape(10 / Constants.SCALE);
            s2.SetLocalPosition(new b2Vec2(0,-5 / Constants.SCALE));
            f2 = _body.CreateFixture2(s2,_density);
            f2.SetUserData(MAIN);
            f2.SetFriction(_friction);
            f2.SetRestitution(_restitution);
            s3 = new b2CircleShape(5 / Constants.SCALE);
            s3.SetLocalPosition(new b2Vec2(10 / Constants.SCALE,-10 / Constants.SCALE));
            f3 = _body.CreateFixture2(s3,_density);
            f3.SetUserData(MAIN);
            f3.SetFriction(_friction);
            f3.SetRestitution(_restitution);
         }
         var clName:String = "MC_Thing" + this._data.thingType.toString();
         var cl:Class = getDefinitionByName(clName) as Class;
         _costume = new cl() as MovieClip;
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.rotation = this._data.rotation * 180 / Math.PI;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
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
   }
}
