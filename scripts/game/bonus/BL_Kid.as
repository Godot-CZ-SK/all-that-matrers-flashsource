package game.bonus
{
   import Box2D.Common.Math.b2Vec2;
   import design.data.DO_CannonBallData;
   import design.data.DO_HeartData;
   import design.data.DO_Path;
   import design.data.DO_PlatformData;
   import design.data.DO_PolyData;
   import design.data.DO_UnitData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameCamera;
   import managers.DM;
   import particle.P_BonusCannonBall;
   import particle.P_BonusHeart;
   import particle.P_BonusPlatform;
   import particle.P_PowerUp;
   import particle.P_Wall;
   import particle.Particle;
   import particle.units.P_BonusKid;
   
   public class BL_Kid extends BonusLevel
   {
       
      
      protected var _attractDuration:int;
      
      protected var _kid:P_BonusKid;
      
      protected var _arrows:MovieClip;
      
      protected var _time:int;
      
      protected var _lastHeartX:Number;
      
      protected var _lastHeartY:Number;
      
      protected var _lastPlatform:int;
      
      protected var _fh:Number;
      
      protected var _fw:Number;
      
      protected var _pw:Number;
      
      protected var _numPlatform:int;
      
      protected var _beforePlatform:int;
      
      protected var _nextHeart:int;
      
      protected var _numHearts:int;
      
      protected var _maxHearts:int;
      
      protected var _numPowerUps:int;
      
      protected var _maxPowerUps:int;
      
      protected var _nextPlatform:int;
      
      protected var _nextBall:int;
      
      protected var _nextPowerUp:int;
      
      public function BL_Kid()
      {
         super();
      }
      
      override public function create() : void
      {
         var fData:DO_PolyData = null;
         var floor:P_Wall = null;
         if(_isCreated)
         {
            return;
         }
         _name = BILLYS_ADVENTURE;
         this._nextHeart = 110;
         this._maxHearts = 6;
         this._nextPlatform = 30;
         this._nextBall = 20;
         this._nextPowerUp = 600;
         this._maxPowerUps = 3;
         this._numHearts = 0;
         this._numPowerUps = 0;
         this._lastPlatform = 0;
         this._beforePlatform = 0;
         this._numPlatform = 4;
         _width = 1280;
         _height = 640;
         this._time = 0;
         this._lastHeartX = _width / 2;
         this._lastHeartY = _height / 2;
         this._pw = 120;
         this._fw = (_width - this._pw * this._numPlatform) / (this._numPlatform + 1);
         this._fh = 30;
         super.create();
         _nextLevelNo = 11;
         var kidData:DO_UnitData = new DO_UnitData(DO_UnitData.KID);
         kidData.radius = 20;
         kidData.x = _width / 2;
         kidData.y = _height - this._fh - 10;
         this._kid = new P_BonusKid(GameCamera.UNIT,kidData);
         this._kid.create();
         this._kid.addEventListener(Event.REMOVED,unitRemoveListener,false,0,true);
         this._kid.setArea(_area);
         var i:int = 0;
         for(i = 0; i < this._numPlatform + 1; i++)
         {
            fData = new DO_PolyData(DO_PolyData.WALL);
            fData.vertices.push(new Point((this._fw + this._pw) * i,_height - this._fh),new Point(this._fw * (i + 1) + this._pw * i,_height - this._fh),new Point(this._fw * (i + 1) + this._pw * i,_height),new Point((this._fw + this._pw) * i,_height));
            floor = new P_Wall(GameCamera.WALL,fData);
            floor.create();
            _particles.push(floor);
         }
         this._arrows = new MovieClip();
         DM.ins.iface.addChild(this._arrows);
         _particles.push(this._kid);
         _tracked = this._kid;
         this._kid.startTracking();
         this.createNewHeart();
         this.createNewHeart();
         commence();
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(this._arrows);
         if(this._kid)
         {
            this._kid.removeEventListener(Event.REMOVED,unitRemoveListener);
         }
         super.remove();
      }
      
      override public function update() : void
      {
         var i:int = 0;
         var rot:Number = NaN;
         var num:int = 0;
         var center:Point = null;
         var ePoint:Point = null;
         var rect:Rectangle = null;
         var pPoint:Point = null;
         var bl:Point = null;
         var tl:Point = null;
         var tr:Point = null;
         var br:Point = null;
         var poi:Point = null;
         var color:uint = 0;
         var minDist:Number = NaN;
         var dist:Number = NaN;
         var kidPos:Point = null;
         var heartPos:Point = null;
         var speed:Number = NaN;
         if(!_isCreated || _isEnded)
         {
            return;
         }
         super.update();
         ++this._time;
         if(!_isEnded)
         {
            if(this._time == 900)
            {
               this._nextHeart = 90;
               ++this._maxHearts;
               this._nextPlatform = 45;
               this._nextBall = 17;
            }
            else if(this._time == 1800)
            {
               this._nextHeart = 70;
               ++this._maxHearts;
               this._nextPlatform = 60;
               this._nextBall = 14;
            }
            else if(this._time == 3600)
            {
               this._nextHeart = 50;
               ++this._maxHearts;
               this._nextPlatform = 75;
               this._nextBall = 10;
            }
            else if(this._time == 7200)
            {
               this._nextHeart = 30;
               ++this._maxHearts;
               this._nextPlatform = 90;
               this._nextBall = 5;
            }
         }
         if(this._time % this._nextHeart == 0)
         {
            this.createNewHeart();
         }
         if(this._time % this._nextPlatform == 0)
         {
            this.createNewPlatform();
         }
         if(this._time % this._nextBall == 0)
         {
            this.createNewBall();
         }
         if(this._time % this._nextPowerUp == 0)
         {
            this.createPowerUp(P_PowerUp.KILL_ALL);
         }
         this._arrows.graphics.clear();
         if(_tracked)
         {
            num = 0;
            center = new Point(-GameCamera.ins.costume.x + 320,-GameCamera.ins.costume.y + 240);
            ePoint = new Point(this._kid.body.GetPosition().x * Constants.SCALE,this._kid.body.GetPosition().y * Constants.SCALE);
            rect = new Rectangle(center.x - 320,center.y - 240,640,480);
            this._arrows.x = -rect.x;
            this._arrows.y = -rect.y;
            for(i = 0; i < _particles.length; i++)
            {
               if(_particles[i] is P_BonusHeart || _particles[i] is P_PowerUp)
               {
                  pPoint = new Point(_particles[i].body.GetPosition().x * Constants.SCALE,_particles[i].body.GetPosition().y * Constants.SCALE);
                  if(!rect.containsPoint(pPoint))
                  {
                     bl = new Point(rect.x,rect.y + rect.height);
                     tl = new Point(rect.x,rect.y);
                     tr = new Point(rect.x + rect.width,rect.y);
                     br = new Point(rect.x + rect.width,rect.y + rect.height);
                     poi = CF.lineIntersectLine(tl,bl,ePoint,pPoint);
                     if(!poi)
                     {
                        poi = CF.lineIntersectLine(tl,tr,ePoint,pPoint);
                     }
                     if(!poi)
                     {
                        poi = CF.lineIntersectLine(tr,br,ePoint,pPoint);
                     }
                     if(!poi)
                     {
                        poi = CF.lineIntersectLine(br,bl,ePoint,pPoint);
                     }
                     if(poi)
                     {
                        rot = Math.atan2(ePoint.y - pPoint.y,ePoint.x - pPoint.x);
                        color = 13369344;
                        if(_particles[i] is P_PowerUp)
                        {
                           color = 26316;
                        }
                        this.drawArrow(poi,rot,color);
                     }
                  }
               }
            }
            this._arrows.graphics.endFill();
         }
         if(_tracked && this._kid && this._attractDuration > 0)
         {
            --this._attractDuration;
            minDist = 400 / Constants.SCALE;
            kidPos = new Point(this._kid.body.GetPosition().x,this._kid.body.GetPosition().y);
            heartPos = new Point();
            speed = 0.2;
            for(i = 0; i < _particles.length; i++)
            {
               if(_particles[i] is P_BonusHeart)
               {
                  heartPos.x = _particles[i].body.GetPosition().x;
                  heartPos.y = _particles[i].body.GetPosition().y;
                  dist = CF.distance(kidPos,heartPos);
                  if(dist < minDist)
                  {
                     rot = Math.atan2(kidPos.y - heartPos.y,kidPos.x - heartPos.x);
                     _particles[i].body.SetPosition(new b2Vec2(heartPos.x + speed * Math.cos(rot),heartPos.y + speed * Math.sin(rot)));
                  }
               }
            }
         }
      }
      
      private function drawArrow(poi:Point, rot:Number, color:uint) : void
      {
         var l:Number = 15;
         this._arrows.graphics.lineStyle(2,color,1);
         this._arrows.graphics.beginFill(color,0.6);
         this._arrows.graphics.moveTo(poi.x,poi.y);
         this._arrows.graphics.lineTo(poi.x + l * Math.cos(rot + Math.PI / 6),poi.y + l * Math.sin(rot + Math.PI / 6));
         this._arrows.graphics.lineTo(poi.x + l * Math.cos(rot - Math.PI / 6),poi.y + l * Math.sin(rot - Math.PI / 6));
         this._arrows.graphics.lineTo(poi.x,poi.y);
         this._arrows.graphics.endFill();
      }
      
      private function createNewHeart() : void
      {
         if(this._numHearts >= this._maxHearts)
         {
            return;
         }
         ++this._numHearts;
         var xpos:Number = 60 + Math.random() * (_width - 120);
         var ypos:Number = 60 + Math.random() * (_height - 120);
         while(Math.abs(xpos - this._lastHeartX) < 60 && Math.abs(ypos - this._lastHeartY) < 60)
         {
            xpos = 60 + Math.random() * (_width - 120);
            ypos = 60 + Math.random() * (_height - 120);
         }
         this._lastHeartX = xpos;
         this._lastHeartY = ypos;
         var hd:DO_HeartData = new DO_HeartData();
         hd.x = xpos;
         hd.y = ypos;
         hd.radius = 12;
         var heart:P_BonusHeart = new P_BonusHeart(GameCamera.HEART,hd,true);
         heart.create();
         heart.addEventListener(Event.REMOVED,this.heartCollectListener,false,0,true);
         _particles.push(heart);
      }
      
      private function createNewPlatform() : void
      {
         var xpos:Number = NaN;
         var ypos:Number = _height;
         var pos:int = Math.floor(Math.random() * this._numPlatform) + 1;
         while(pos == this._lastPlatform || pos == this._beforePlatform)
         {
            pos = Math.floor(Math.random() * this._numPlatform) + 1;
         }
         this._beforePlatform = this._lastPlatform;
         this._lastPlatform = pos;
         xpos = this._fw * pos + this._pw * (pos - 1);
         var pData:DO_PlatformData = new DO_PlatformData();
         pData.x = xpos;
         pData.y = ypos;
         pData.count = int(this._pw / pData.WIDTH) - 2;
         pData.speed = 1.2;
         pData.path = new DO_Path(DO_Path.LINE);
         pData.path.waypoints.push(new Point(0,-_height - 200));
         var platform:P_BonusPlatform = new P_BonusPlatform(GameCamera.PLATFORM,pData);
         platform.create();
         platform.addEventListener(Event.REMOVED,this.particleRemovedHandler);
         _particles.push(platform);
      }
      
      private function createNewBall() : void
      {
         var cbData:DO_CannonBallData = new DO_CannonBallData();
         var ypos:Number = (_height - this._fh) * Math.random() / 25 * 25;
         var xpos:Number = -20;
         cbData.angle = 0;
         if(Math.random() < 0.5)
         {
            xpos = _width + 20;
            cbData.angle = Math.PI;
         }
         cbData.x = xpos;
         cbData.y = ypos;
         cbData.scale = 1.3;
         cbData.speed = 5.5;
         var cb:P_BonusCannonBall = new P_BonusCannonBall(GameCamera.CANNON_BALL,cbData);
         cb.create();
         cb.addEventListener(Event.REMOVED,this.particleRemovedHandler);
         _particles.push(cb);
      }
      
      override public function shield() : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         super.shield();
         this._kid.setShield();
      }
      
      override public function tripleJump(duration:int) : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         super.tripleJump(duration);
         this._kid.setTripleJump(duration);
      }
      
      override public function attract(duration:int) : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         super.attract(duration);
         this._attractDuration = duration;
      }
      
      private function createPowerUp(param1:String) : void
      {
         if(this._numPowerUps >= this._maxPowerUps)
         {
            return;
         }
         ++this._numPowerUps;
         var _loc2_:Number = (_width - 150) * Math.random() + 75;
         var _loc3_:Number = (_height - 150) * Math.random() + 75;
         var _loc4_:Number = Math.random();
         param1 = P_PowerUp.SHIELD;
         if(_loc4_ < 0.33)
         {
            param1 = P_PowerUp.ATTRACTOR;
         }
         else if(_loc4_ < 0.66)
         {
            param1 = P_PowerUp.TRIPLE_JUMP;
         }
         var _loc5_:P_PowerUp = new P_PowerUp(param1,GameCamera.POWER_UP,_loc2_,_loc3_);
         _loc5_.create();
         _loc5_.addEventListener(Event.REMOVED,this.particleRemovedHandler,false,0,true);
         _particles.push(_loc5_);
      }
      
      override protected function particleRemovedHandler(e:Event) : void
      {
         if(e.currentTarget is P_PowerUp)
         {
            --this._numPowerUps;
         }
         super.particleRemovedHandler(e);
      }
      
      private function heartCollectListener(e:Event) : void
      {
         if(!_isCreated)
         {
            return;
         }
         var i:int = _particles.indexOf(e.currentTarget as Particle);
         if(i >= 0)
         {
            _particles.splice(i,1);
         }
         _heartsCollected.addValue(1);
         _interface.updateInterface(_heartsCollected.value);
         --this._numHearts;
      }
   }
}
