package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_BlowerData;
   import design.data.DO_BubbleData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.PM;
   import particle.units.P_Unit;
   
   public class P_Blower extends Particle
   {
      
      public static const MAIN:String = "blower_main";
      
      public static const SENSOR:String = "blower_sensor";
       
      
      protected var _data:DO_BlowerData;
      
      protected var _isWorking:Boolean;
      
      protected var _changeCounter:int;
      
      protected var _speed:Number;
      
      protected var _accel:Number;
      
      protected var _power:Number;
      
      protected var _effectSprite:Sprite;
      
      protected var _bubbles:Vector.<DO_BubbleData>;
      
      public function P_Blower(layerNo:int, data:DO_BlowerData)
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
         this._accel = 0;
         this._speed = 0;
         this._power = 1;
         this._changeCounter = 0;
         this._bubbles = new Vector.<DO_BubbleData>();
         this._isWorking = true;
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_staticBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var s1:b2CircleShape = new b2CircleShape(this._data.RADIUS / Constants.SCALE * this._data.scale);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         var sensorHeight:Number = 0.8 * this._data.RADIUS * 2 * this._data.scale;
         var sensorWidth:Number = this._data.max_distance * this._data.scale;
         var sensorX:Number = sensorWidth / 2;
         var sensorY:Number = 0.1 * this._data.RADIUS * 2 * this._data.scale;
         var s2:b2PolygonShape = new b2PolygonShape();
         s2.SetAsOrientedBox(sensorWidth / 2 / Constants.SCALE,sensorHeight / 2 / Constants.SCALE,new b2Vec2(sensorX / Constants.SCALE,sensorY / Constants.SCALE));
         var fix2:b2Fixture = _body.CreateFixture2(s2);
         fix2.SetUserData(SENSOR);
         fix2.SetSensor(true);
         this._effectSprite = new Sprite();
         GameCamera.ins.addChildTo(this._effectSprite,_layerNo);
         _costume = new MC_Blower();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation * 180 / Math.PI;
         _body.SetAngle(this._data.rotation);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(this._effectSprite);
         this._bubbles = new Vector.<DO_BubbleData>();
         super.remove();
      }
      
      override public function update() : void
      {
         var ce:b2ContactEdge = null;
         var b1:b2Body = null;
         var b2:b2Body = null;
         var f1:b2Fixture = null;
         var f2:b2Fixture = null;
         var p1:Particle = null;
         var p2:Particle = null;
         var d1:String = null;
         var d2:String = null;
         var p:Particle = null;
         var distance:Number = NaN;
         var force:Number = NaN;
         var xdir:Number = NaN;
         var ydir:Number = NaN;
         var xforce:Number = NaN;
         var yforce:Number = NaN;
         var impulse:b2Vec2 = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var radius:Number = NaN;
         var alpha:Number = NaN;
         var speed:Point = null;
         var bd:DO_BubbleData = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._isWorking && _step % 2 == 0)
         {
            this.addEffect();
         }
         this._effectSprite.graphics.clear();
         (_costume as MC_Blower).mc_circle.rotation += 20;
         ++this._changeCounter;
         this._speed += this._accel;
         if(this._isWorking)
         {
            for(ce = _body.GetContactList(); ce != null; ce = ce.next)
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
                  this._power = 1;
                  if((p1 is P_Unit || p1 is P_Wheel || p1 is P_Obstacle) && d2 == SENSOR || (p2 is P_Unit || p2 is P_Wheel || p2 is P_Obstacle) && d1 == SENSOR)
                  {
                     if(p1 is P_Wheel || p1 is P_Obstacle || p2 is P_Wheel || p2 is P_Obstacle)
                     {
                        this._power = 0.6;
                     }
                     if(d2 == SENSOR)
                     {
                        p = p1;
                     }
                     else
                     {
                        p = p2;
                     }
                     distance = CF.dist(new Point(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE),new Point(p.body.GetPosition().x * Constants.SCALE,p.body.GetPosition().y * Constants.SCALE)) + 25;
                     force = this._data.power * this._power * 12 / distance;
                     xdir = Math.cos(this._data.rotation);
                     ydir = Math.sin(this._data.rotation);
                     xforce = force;
                     yforce = force;
                     if(_body.GetLinearVelocity().x * xdir > 0)
                     {
                        xforce *= 0.75;
                     }
                     if(_body.GetLinearVelocity().y * ydir > 0)
                     {
                        yforce *= 0.75;
                     }
                     impulse = new b2Vec2(xforce * xdir,yforce * ydir);
                     p.body.ApplyForce(impulse,p.body.GetWorldCenter());
                  }
               }
            }
         }
         if(this._changeCounter == 60)
         {
            this._accel *= -1;
            this._changeCounter = 0;
         }
         for(var i:int = this._bubbles.length - 1; i > 0; i--)
         {
            speed = new Point();
            bd = this._bubbles[i];
            ++bd.current;
            if(bd.current >= bd.time)
            {
               this._bubbles.splice(i,1)[0] = null;
            }
            else
            {
               speed.x = Math.cos(this._data.rotation);
               speed.y = Math.sin(this._data.rotation);
               speed.normalize(bd.current * bd.speed);
               x = bd.startX + speed.x;
               y = bd.startY + speed.y;
               radius = bd.radius * (1 - bd.current / bd.time);
               alpha = 0.7 - 0.7 * bd.current / bd.time;
               this._effectSprite.graphics.beginFill(16777215,alpha);
               this._effectSprite.graphics.drawCircle(x,y,radius);
               this._effectSprite.graphics.endFill();
            }
         }
      }
      
      private function addEffect() : void
      {
         var bubbleData:DO_BubbleData = new DO_BubbleData();
         var offset:Number = 0.7 * this._data.RADIUS * 2 * this._data.scale * Math.random() - 0.2 * this._data.RADIUS * this._data.scale;
         var shortLeg:Number = 0.4 * this._data.RADIUS * this._data.scale;
         var longLeg:Number = this._data.RADIUS * this._data.scale;
         var x1:Number = this._data.x - longLeg * Math.sin(this._data.rotation);
         var x2:Number = this._data.x + shortLeg * Math.sin(this._data.rotation);
         var y1:Number = this._data.y - shortLeg * Math.cos(this._data.rotation);
         var y2:Number = this._data.y + longLeg * Math.cos(this._data.rotation);
         bubbleData.startX = x1 + Math.random() * (x2 - x1);
         bubbleData.startY = y1 + Math.random() * (y2 - y1);
         bubbleData.radius = (2 + 2.5 * Math.random()) * this._data.scale;
         bubbleData.time = 25 + Math.random() * 25;
         bubbleData.current = 0;
         bubbleData.speed = (Math.random() * 2.5 + 2) * this._data.power / 100 * this._data.scale;
         if(Math.random() < 0.2)
         {
            bubbleData.speed *= 2;
         }
         this._bubbles.push(bubbleData);
      }
      
      public function get data() : DO_BlowerData
      {
         return this._data;
      }
      
      public function get isWorking() : Boolean
      {
         return this._isWorking;
      }
   }
}
