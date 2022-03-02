package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_LaserData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_Laser extends Particle
   {
      
      public static const MAIN:String = "laser_main";
       
      
      protected var _data:DO_LaserData;
      
      protected var _pointer:b2RayCastInput;
      
      protected var _laserSprite:Sprite;
      
      protected var _closestPoint:Point;
      
      protected var _closestFraction:Number;
      
      protected var _closestFixture:b2Fixture;
      
      protected var _unitInVision:Boolean;
      
      protected var _prepCount:int;
      
      protected var _prepared:int;
      
      protected var _continueOnSight:int;
      
      public function P_Laser(layerNo:int, data:DO_LaserData)
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
         this._prepared = 25;
         this._continueOnSight = 0;
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_kinematicBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var s:b2CircleShape = new b2CircleShape(this._data.RADIUS * this._data.scale / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(s,1);
         fix.SetUserData(MAIN);
         this._laserSprite = new Sprite();
         GameCamera.ins.addChildTo(this._laserSprite,_layerNo);
         _costume = new MC_Laser();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.body_rot * 180 / Math.PI;
         _costume.mc_head.rotation = this._data.head_rot * 180 / Math.PI;
      }
      
      override public function removeCostume() : void
      {
         super.removeCostume();
         CF.removeDisplayObject(this._laserSprite);
      }
      
      override public function update() : void
      {
         var p:Particle = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         var distance:Number = 1200;
         var angle:Number = this._data.body_rot + this._data.head_rot;
         var p1:b2Vec2 = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         var p2:b2Vec2 = new b2Vec2((this._data.x + distance * Math.cos(angle)) / Constants.SCALE,(this._data.y + distance * Math.sin(angle)) / Constants.SCALE);
         this._closestFraction = 1;
         this._closestPoint = new Point(p2.x * Constants.SCALE,p2.y * Constants.SCALE);
         PM.ins.world.RayCast(this.rayCastCallback,p1,p2);
         if(this._closestFixture)
         {
            p = this._closestFixture.GetBody().GetUserData() as Particle;
         }
         if(p && p is P_Unit)
         {
            if(!this._unitInVision)
            {
               this._unitInVision = true;
            }
            this._continueOnSight = 60;
         }
         else
         {
            this._unitInVision = false;
         }
         this._laserSprite.graphics.clear();
         this._laserSprite.graphics.lineStyle(1,16711680,1);
         this._laserSprite.graphics.moveTo(this._data.x,this._data.y);
         this._laserSprite.graphics.lineTo(this._closestPoint.x,this._closestPoint.y);
         this._laserSprite.graphics.beginFill(16711680,1);
         this._laserSprite.graphics.drawCircle(this._closestPoint.x,this._closestPoint.y,3);
         this._laserSprite.graphics.endFill();
         if(this._unitInVision || this._continueOnSight > 0)
         {
            if(!this._unitInVision)
            {
               --this._continueOnSight;
            }
            if(this._prepCount >= this._prepared)
            {
               this._laserSprite.graphics.clear();
               if(_step % 3 == 0)
               {
                  this.shoot();
               }
            }
            else
            {
               this._laserSprite.graphics.clear();
               ++this._prepCount;
            }
         }
         else
         {
            this._prepCount = 0;
            this._continueOnSight = 0;
         }
      }
      
      private function shoot() : void
      {
         var p:Particle = null;
         this._closestFixture = null;
         var distance:Number = 1200;
         var randomAngle:Number = Math.PI * Math.random() / 18 - Math.PI / 36;
         var offsetAngle:Number = this._data.head_rot + this._data.body_rot + randomAngle;
         var offsetX:Number = this._data.RADIUS * 1.1 * this._data.scale * Math.cos(offsetAngle);
         var offsetY:Number = this._data.RADIUS * 1.1 * this._data.scale * Math.sin(offsetAngle);
         var x:Number = (this._data.x + offsetX) / Constants.SCALE;
         var y:Number = (this._data.y + offsetY) / Constants.SCALE;
         var p1:b2Vec2 = new b2Vec2(x,y);
         var p2:b2Vec2 = new b2Vec2(x + distance * Math.cos(offsetAngle) / Constants.SCALE,y + distance * Math.sin(offsetAngle) / Constants.SCALE);
         PM.ins.world.RayCast(this.rayCastCallback,p1,p2);
         SM.ins.playSound(GameSound.LASER_SHOT);
         if(this._closestFixture)
         {
            p = this._closestFixture.GetBody().GetUserData() as Particle;
            if(p is P_Unit)
            {
               if(!GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
               {
                  LM.ins.cp.addLaserShot();
               }
               (p as P_Unit).laserShot(this._closestPoint.x,this._closestPoint.y,offsetAngle);
            }
            else if(p is P_Wheel || p is P_Obstacle || p is P_Chain)
            {
               p.applyForce(this._closestPoint.x,this._closestPoint.y,offsetAngle);
            }
            else if(p is P_Seeker)
            {
               (p as P_Seeker).explode();
            }
         }
         this._laserSprite.graphics.clear();
         this._laserSprite.graphics.lineStyle(this._data.scale * 2,13369344,0.8);
         this._laserSprite.graphics.moveTo(this._data.x,this._data.y);
         this._laserSprite.graphics.lineTo(this._closestPoint.x,this._closestPoint.y);
      }
      
      private function rayCastCallback(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number) : void
      {
         var p:Particle = fixture.GetBody().GetUserData();
         if(fixture.IsSensor())
         {
            return;
         }
         if(fraction < this._closestFraction)
         {
            this._closestFraction = fraction;
            this._closestPoint = new Point(point.x * Constants.SCALE,point.y * Constants.SCALE);
            this._closestFixture = fixture;
         }
      }
      
      public function get data() : DO_LaserData
      {
         return this._data;
      }
   }
}
