package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_PistonPlateData;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_PistonPlate extends Particle
   {
      
      public static const MAIN:String = "piston_plate_main";
      
      public static const SENSOR:String = "piston_plate_sensor";
       
      
      protected var _data:DO_PistonPlateData;
      
      protected var _sensorBody:b2Body;
      
      protected var _isPushed:Boolean;
      
      public function P_PistonPlate(layerNo:int, data:DO_PistonPlateData)
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
         bodyDef.type = b2Body.b2_kinematicBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         _body.SetAngle(this._data.rotation / 180 * Math.PI);
         var sensorBodyDef:b2BodyDef = new b2BodyDef();
         sensorBodyDef.type = b2Body.b2_kinematicBody;
         sensorBodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         this._sensorBody = PM.ins.world.CreateBody(sensorBodyDef);
         this._sensorBody.SetUserData(this);
         this._sensorBody.SetAngle(this._data.rotation / 180 * Math.PI);
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsBox(this._data.WIDTH / 2 / Constants.SCALE * this._data.scale,this._data.HEIGHT / 2 / Constants.SCALE * this._data.scale);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         var s2:b2PolygonShape = new b2PolygonShape();
         s2.SetAsOrientedBox(this._data.WIDTH / 2 / Constants.SCALE * this._data.scale * 0.8,10 / 2 / Constants.SCALE * this._data.scale,new b2Vec2(0,-this._data.HEIGHT / 2 / Constants.SCALE * this._data.scale));
         var fix2:b2Fixture = this._sensorBody.CreateFixture2(s2,1);
         fix2.SetUserData(SENSOR);
         fix2.SetSensor(true);
         _costume = new MC_PistonPlate();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation;
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         PM.ins.world.DestroyBody(this._sensorBody);
         this._sensorBody = null;
      }
      
      override public function update() : void
      {
         var b1:b2Body = null;
         var b2:b2Body = null;
         var f1:b2Fixture = null;
         var f2:b2Fixture = null;
         var p1:Particle = null;
         var p2:Particle = null;
         var d1:String = null;
         var d2:String = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         var pushIt:Boolean = false;
         for(var ce:b2ContactEdge = this._sensorBody.GetContactList(); ce != null; ce = ce.next)
         {
            if(ce.contact.IsTouching())
            {
               b1 = ce.contact.GetFixtureA().GetBody();
               b2 = ce.contact.GetFixtureB().GetBody();
               f1 = ce.contact.GetFixtureA();
               f2 = ce.contact.GetFixtureB();
               p1 = b1.GetUserData() as Particle;
               p2 = b2.GetUserData() as Particle;
               d1 = f1.GetUserData() as String;
               d2 = f2.GetUserData() as String;
               if(p2 == this && d2 == SENSOR && (p1 is P_Unit || p1 is P_Wheel || p1 is P_Obstacle) || p1 == this && d1 == SENSOR && (p2 is P_Unit || p2 is P_Wheel || p2 is P_Obstacle))
               {
                  pushIt = true;
                  break;
               }
            }
         }
         if(pushIt)
         {
            this.push();
         }
         else
         {
            this.unpush();
         }
      }
      
      public function push() : void
      {
         if(this._isPushed || !_isCreated)
         {
            return;
         }
         this._isPushed = true;
         var rot:Number = this._data.rotation / 180 * Math.PI + Math.PI / 2;
         _body.SetPosition(new b2Vec2((this._data.x + this._data.HEIGHT * this._data.scale / 2 * Math.cos(rot)) / Constants.SCALE,(this._data.y + this._data.HEIGHT * this._data.scale / 2 * Math.sin(rot)) / Constants.SCALE));
         GM.ins.cl.pushPlates();
         TweenLite.to(_costume.mc_top,0.2,{"y":0});
         SM.ins.playSound(GameSound.PLATE_PUSHED);
      }
      
      public function unpush() : void
      {
         if(!this._isPushed || !_isCreated)
         {
            return;
         }
         this._isPushed = false;
         _body.SetPosition(new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE));
         GM.ins.cl.unpushPlates();
         TweenLite.to(_costume.mc_top,0.2,{"y":-4});
      }
      
      public function get data() : DO_PistonPlateData
      {
         return this._data;
      }
      
      public function get isPushed() : Boolean
      {
         return this._isPushed;
      }
   }
}
