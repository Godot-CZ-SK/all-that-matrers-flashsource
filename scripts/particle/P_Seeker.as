package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_Path;
   import design.data.DO_SeekerData;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.units.P_Unit;
   
   public class P_Seeker extends Particle
   {
      
      public static const MAIN:String = "seeker_main";
       
      
      protected var _data:DO_SeekerData;
      
      protected var _isReturning:Boolean;
      
      protected var _isExploded:Boolean;
      
      protected var _onRoute:Boolean;
      
      protected var _pathNum:int;
      
      protected var _search:int;
      
      protected var _closestPoint:Point;
      
      protected var _closestFraction:Number;
      
      protected var _closestFixture:b2Fixture;
      
      protected var _follow:Particle;
      
      protected var _lastSeen:Point;
      
      protected var _speed:Number;
      
      protected var _maxSpeed:Number;
      
      protected var _accelaration:Number;
      
      public function P_Seeker(layerNo:int, data:DO_SeekerData)
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
         var shape:b2CircleShape = new b2CircleShape(this._data.SIZE * this._data.scale / 2 / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,this._data.density);
         fix.SetUserData(MAIN);
         _costume = new MC_Seeker();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         this._pathNum = -1;
         this._onRoute = true;
         this._search = 0;
         this._lastSeen = new Point();
         this._speed = 0;
         this._maxSpeed = 12;
         this._accelaration = 0.1;
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         PM.ins.world.DestroyBody(_body);
         super.remove();
      }
      
      override public function update() : void
      {
         var rot:Number = NaN;
         var destId:int = 0;
         var oldPosition:Point = null;
         var destination:Point = null;
         var current:Point = null;
         var dir:Point = null;
         var curPos:Point = null;
         var velocity:Point = null;
         if(!_isCreated || _isDead)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         if(_costume.currentLabel != "attack" && _costume.currentLabel != "prepare" && _costume.currentLabel != "die")
         {
            if(this._onRoute)
            {
               this.playAnimation("walk");
            }
            else
            {
               this.playAnimation("stay");
            }
         }
         if(this._onRoute)
         {
            if(this._data.path.style == DO_Path.CIRCULAR)
            {
               destId = (this._pathNum + 1) % this._data.path.waypoints.length;
            }
            else if(this._data.path.style == DO_Path.LINE)
            {
               if(this._data.path.waypoints.length == 1)
               {
                  destId = 0;
               }
               else if(this._isReturning)
               {
                  destId = this._pathNum - 1;
               }
               else
               {
                  destId = this._pathNum + 1;
               }
            }
            if(this._pathNum == 0 && destId == 0)
            {
               return;
            }
            if(this._pathNum == -1)
            {
               oldPosition = new Point(0,0);
            }
            else
            {
               oldPosition = this._data.path.waypoints[this._pathNum].clone();
            }
            oldPosition.x += this._data.x;
            oldPosition.y += this._data.y;
            destination = this._data.path.waypoints[destId].clone();
            destination.x += this._data.x;
            destination.y += this._data.y;
            current = new Point(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
            dir = new Point(destination.x - oldPosition.x,destination.y - oldPosition.y);
            dir.normalize(this._data.speed);
            rot = Math.atan2(dir.y,dir.x) * 180 / Math.PI;
            if(rot - _costume.rotation < -180)
            {
               rot += 360;
            }
            else if(rot - _costume.rotation > 180)
            {
               rot -= 360;
            }
            TweenLite.to(_costume,0.3,{"rotation":rot});
            if(current.x + dir.x > destination.x && dir.x > 0 && current.y + dir.y > destination.y && dir.y > 0 || current.x + dir.x < destination.x && dir.x < 0 && current.y + dir.y > destination.y && dir.y > 0 || current.x + dir.x > destination.x && dir.x > 0 && current.y + dir.y < destination.y && dir.y < 0 || current.x + dir.x < destination.x && dir.x < 0 && current.y + dir.y < destination.y && dir.y < 0 || dir.x == 0 && current.y + dir.y > destination.y && dir.y > 0 || dir.x == 0 && current.y + dir.y < destination.y && dir.y < 0 || dir.y == 0 && current.x + dir.y > destination.x && dir.x > 0 || dir.y == 0 && current.x + dir.y < destination.x && dir.x < 0 || oldPosition.x == destination.x && oldPosition.y == destination.y)
            {
               _body.SetPosition(new b2Vec2(destination.x / Constants.SCALE,destination.y / Constants.SCALE));
               this._pathNum = destId;
               if(this._data.path.style == DO_Path.LINE)
               {
                  if(destId == 0)
                  {
                     this._isReturning = false;
                  }
                  if(destId == this._data.path.waypoints.length - 1)
                  {
                     this._isReturning = true;
                  }
               }
            }
            else
            {
               _body.SetPosition(new b2Vec2((current.x + dir.x) / Constants.SCALE,(current.y + dir.y) / Constants.SCALE));
            }
         }
         if(this._follow && (this._follow.isDead || !this._follow.isCreated))
         {
            this._follow = null;
         }
         if(!this._follow)
         {
            this.searchForUnit();
         }
         if(this._follow)
         {
            if(_costume.currentLabel != "prepare" && _costume.currentLabel != "die")
            {
               this.playAnimation("attack");
            }
            this.trackUnit();
         }
         if(!this._follow && !this._onRoute)
         {
            this._speed += this._accelaration;
            curPos = new Point(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
            if(this._speed > this._maxSpeed)
            {
               this._speed = this._maxSpeed;
            }
            rot = _costume.rotation * Math.PI / 180;
            velocity = new Point(this._speed * Math.cos(rot),this._speed * Math.sin(rot));
            _body.SetPosition(new b2Vec2((curPos.x + velocity.x) / Constants.SCALE,(curPos.y + velocity.y) / Constants.SCALE));
         }
         var transform:b2Transform = new b2Transform(_body.GetPosition(),new b2Mat22());
         PM.ins.world.QueryShape(this.queryCallback,_body.GetFixtureList().GetShape(),transform);
      }
      
      private function queryCallback(fix:b2Fixture) : Boolean
      {
         var p:Particle = fix.GetBody().GetUserData();
         if(p is P_Seeker || p is P_Unit || fix.IsSensor())
         {
            return true;
         }
         this.explode();
         return true;
      }
      
      private function trackUnit() : void
      {
         ++this._search;
         if(this._search >= 5)
         {
            this._search = 0;
            this.updateLastPosition();
         }
         this._speed += this._accelaration;
         if(this._speed > this._maxSpeed)
         {
            this._speed = this._maxSpeed;
         }
         var curAngle:Number = _costume.rotation;
         var curPos:Point = new Point(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
         var desiredAngle:Number = Math.atan2(this._lastSeen.y - curPos.y,this._lastSeen.x - curPos.x) * 180 / Math.PI;
         var distance:Number = CF.distance(curPos,this._lastSeen);
         if(desiredAngle - curAngle < -180)
         {
            desiredAngle += 360;
         }
         else if(desiredAngle - curAngle > 180)
         {
            desiredAngle -= 360;
         }
         TweenLite.to(_costume,0.8,{"rotation":desiredAngle});
         var rot:Number = _costume.rotation * Math.PI / 180;
         var velocity:Point = new Point(this._speed * Math.cos(rot),this._speed * Math.sin(rot));
         _body.SetPosition(new b2Vec2((curPos.x + velocity.x) / Constants.SCALE,(curPos.y + velocity.y) / Constants.SCALE));
      }
      
      private function updateLastPosition() : void
      {
         var p:Particle = null;
         var p1:b2Vec2 = _body.GetPosition().Copy();
         var p2:b2Vec2 = this._follow.body.GetPosition().Copy();
         this._closestFraction = 1;
         this._closestPoint = new Point(p2.x * Constants.SCALE,p2.y * Constants.SCALE);
         PM.ins.world.RayCast(this.rayCastCallback,p1,p2);
         if(this._closestFixture)
         {
            p = this._closestFixture.GetBody().GetUserData() as Particle;
            if(p == this._follow)
            {
               this._lastSeen.x = Math.floor(this._closestPoint.x);
               this._lastSeen.y = Math.floor(this._closestPoint.y);
            }
            return;
         }
      }
      
      private function searchForUnit() : void
      {
         var unitsInDistance:Vector.<P_Unit> = null;
         var distances:Array = null;
         var i:int = 0;
         var j:int = 0;
         var unit:P_Unit = null;
         var distance:Number = NaN;
         var tempNum:Number = NaN;
         var p1:b2Vec2 = null;
         var p2:b2Vec2 = null;
         var p:Particle = null;
         ++this._search;
         if(this._search >= 30)
         {
            this._search = 0;
            unitsInDistance = new Vector.<P_Unit>();
            distances = [];
            for(i = 0; i < GM.ins.cl.units.length; i++)
            {
               unit = GM.ins.cl.units[i];
               if(!(unit.isDead || !unit.isCreated))
               {
                  distance = CF.distance(new Point(unit.body.GetPosition().x,unit.body.GetPosition().y),new Point(_body.GetPosition().x,_body.GetPosition().y)) * Constants.SCALE;
                  if(distance <= 300)
                  {
                     unitsInDistance.push(unit);
                     distances.push(distance);
                  }
               }
            }
            if(distances.length > 0)
            {
               for(i = 0; i < distances.length - 1; i++)
               {
                  for(j = i + 1; j < distances.length; j++)
                  {
                     if(distances[j] < distances[i])
                     {
                        tempNum = distances[j];
                        distances[j] = distances[i];
                        distances[i] = tempNum;
                        unit = unitsInDistance[j];
                        unitsInDistance[j] = unitsInDistance[i];
                        unitsInDistance[i] = unit;
                     }
                  }
               }
            }
            for(i = 0; i < unitsInDistance.length; i++)
            {
               unit = unitsInDistance[i];
               p1 = _body.GetPosition().Copy();
               p2 = unit.body.GetPosition().Copy();
               this._closestFraction = 1;
               this._closestPoint = new Point(p2.x * Constants.SCALE,p2.y * Constants.SCALE);
               PM.ins.world.RayCast(this.rayCastCallback,p1,p2);
               if(this._closestFixture)
               {
                  p = this._closestFixture.GetBody().GetUserData() as Particle;
                  if(p is P_Unit)
                  {
                     this._follow = p;
                     this._onRoute = false;
                     this._lastSeen.x = this._closestPoint.x;
                     this._lastSeen.y = this._closestPoint.y;
                     if(_costume.currentLabel != "attack" && _costume.currentLabel != "die")
                     {
                        this.playAnimation("prepare");
                     }
                     break;
                  }
               }
            }
         }
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
      
      private function playAnimation(label:String) : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         if(_costume && _costume.currentLabel != label)
         {
            _costume.gotoAndPlay(label);
         }
      }
      
      public function explode() : void
      {
         if(this._isExploded)
         {
            return;
         }
         this._isExploded = true;
         _isFading = true;
         if(!GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
         {
            LM.ins.cp.addSeekerDeath();
         }
         SM.ins.playSound(GameSound.SEEKER_EXPLODE);
         this.playAnimation("die");
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_costume);
         },1.5);
         GM.ins.cl.shakeCamera(15,100);
         safeRemove();
      }
      
      public function get isExploded() : Boolean
      {
         return this._isExploded;
      }
   }
}
