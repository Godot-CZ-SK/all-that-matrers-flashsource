package game.bonus
{
   import design.data.DO_HeartData;
   import design.data.DO_Path;
   import design.data.DO_PolyData;
   import design.data.DO_SeekerData;
   import design.data.DO_UnitData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameCamera;
   import managers.DM;
   import particle.P_BonusHeart;
   import particle.P_BonusSeeker;
   import particle.P_BonusSpawnDoor;
   import particle.P_PowerUp;
   import particle.P_Wall;
   import particle.Particle;
   import particle.units.P_BonusElder;
   
   public class BL_Elder extends BonusLevel
   {
       
      
      protected var _elder:P_BonusElder;
      
      protected var _time:int;
      
      protected var _nextHeart:int;
      
      protected var _numHearts:int;
      
      protected var _maxHearts:int;
      
      protected var _nextSeeker:int;
      
      protected var _numSeekers:int;
      
      protected var _maxSeekers:int;
      
      protected var _nextPowerUp:int;
      
      protected var _increment:int;
      
      protected var _lastHeartArea:int;
      
      protected var _lastSeekerArea:int;
      
      protected var _arrows:MovieClip;
      
      protected var _lastPowerUpLocation:int;
      
      protected var _fw:Number;
      
      protected var _fh:Number;
      
      protected var _mws:Number;
      
      protected var _doorWidth:Number;
      
      public function BL_Elder()
      {
         super();
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _name = ELDER_ROLLS;
         _width = 960;
         _height = 960;
         this._time = 0;
         this._nextHeart = 120;
         this._numHearts = 0;
         this._lastPowerUpLocation = 0;
         this._maxHearts = 5;
         this._nextSeeker = 120;
         this._numSeekers = 0;
         this._maxSeekers = 10;
         this._nextPowerUp = 600;
         this._increment = 40;
         this._lastHeartArea = 0;
         this._lastSeekerArea = 0;
         super.create();
         _nextLevelNo = 6;
         this._doorWidth = 150;
         this._fw = (_width - this._doorWidth) / 2;
         this._fh = 30;
         var tlData:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         var trData:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         var blData:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         var brData:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         var m1Data:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         var m2Data:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         this._mws = 60;
         tlData.vertices.push(new Point(0,0),new Point(this._fw,0),new Point(this._fw,this._fh),new Point(this._fh,this._fh),new Point(this._fh,this._fw),new Point(0,this._fw));
         trData.vertices.push(new Point(_width,0),new Point(_width,this._fw),new Point(_width - this._fh,this._fw),new Point(_width - this._fh,this._fh),new Point(_width - this._fw,this._fh),new Point(_width - this._fw,0));
         brData.vertices.push(new Point(_width,_height),new Point(_width - this._fw,_height),new Point(_width - this._fw,_height - this._fh),new Point(_width - this._fh,_height - this._fh),new Point(_width - this._fh,_height - this._fw),new Point(_width,_height - this._fw));
         blData.vertices.push(new Point(0,_height),new Point(0,_height - this._fw),new Point(this._fh,_height - this._fw),new Point(this._fh,_height - this._fh),new Point(this._fw,_height - this._fh),new Point(this._fw,_height));
         m1Data.vertices.push(new Point(_width * 0.5 + this._mws * 0.5,_height * 0.5 + this._mws * 1.5),new Point(_width * 0.5 + this._mws * 0.5,_height * 0.5 + this._mws * 0.5),new Point(_width * 0.5 + this._mws * 1.5,_height * 0.5 + this._mws * 0.5),new Point(_width * 0.5 + this._mws * 1.5,_height * 0.5 - this._mws * 0.5),new Point(_width * 0.5 + this._mws * 0.5,_height * 0.5 - this._mws * 0.5),new Point(_width * 0.5 - this._mws * 0.5,_height * 0.5 + this._mws * 0.5),new Point(_width * 0.5 - this._mws * 0.5,_height * 0.5 + this._mws * 1.5));
         m2Data.vertices.push(new Point(_width * 0.5 - this._mws * 0.5,_height * 0.5 - this._mws * 0.5),new Point(_width * 0.5 - this._mws * 0.5,_height * 0.5 - this._mws * 1.5),new Point(_width * 0.5 + this._mws * 0.5,_height * 0.5 - this._mws * 1.5),new Point(_width * 0.5 + this._mws * 0.5,_height * 0.5 - this._mws * 0.5),new Point(_width * 0.5 - this._mws * 0.5,_height * 0.5 + this._mws * 0.5),new Point(_width * 0.5 - this._mws * 1.5,_height * 0.5 + this._mws * 0.5),new Point(_width * 0.5 - this._mws * 1.5,_height * 0.5 - this._mws * 0.5));
         var tl:P_Wall = new P_Wall(GameCamera.WALL,tlData);
         var tr:P_Wall = new P_Wall(GameCamera.WALL,trData);
         var bl:P_Wall = new P_Wall(GameCamera.WALL,blData);
         var br:P_Wall = new P_Wall(GameCamera.WALL,brData);
         var m1:P_Wall = new P_Wall(GameCamera.WALL,m1Data);
         var m2:P_Wall = new P_Wall(GameCamera.WALL,m2Data);
         tl.create();
         tr.create();
         bl.create();
         br.create();
         m1.create();
         m2.create();
         var lDoor:P_BonusSpawnDoor = new P_BonusSpawnDoor(GameCamera.DOOR,this._fh / 2,_height / 2,0);
         var tDoor:P_BonusSpawnDoor = new P_BonusSpawnDoor(GameCamera.DOOR,_width / 2,this._fh / 2,90);
         var rDoor:P_BonusSpawnDoor = new P_BonusSpawnDoor(GameCamera.DOOR,_width - this._fh / 2,_height / 2,180);
         var bDoor:P_BonusSpawnDoor = new P_BonusSpawnDoor(GameCamera.DOOR,_width / 2,_height - this._fh / 2,270);
         lDoor.create();
         tDoor.create();
         rDoor.create();
         bDoor.create();
         var elderData:DO_UnitData = new DO_UnitData(DO_UnitData.ELDER);
         elderData.x = _width / 2;
         elderData.y = _height / 2 - this._mws * 2;
         this._elder = new P_BonusElder(GameCamera.UNIT,elderData);
         this._elder.create();
         this._elder.addEventListener(Event.REMOVED,unitRemoveListener,false,0,true);
         this._elder.setArea(_area);
         _units.push(this._elder);
         _particles.push(tl,tr,bl,br,this._elder);
         this._arrows = new MovieClip();
         DM.ins.iface.addChild(this._arrows);
         _tracked = this._elder;
         this._elder.startTracking();
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
         super.remove();
         this._elder = null;
      }
      
      override public function update() : void
      {
         var num:int = 0;
         var center:Point = null;
         var ePoint:Point = null;
         var rect:Rectangle = null;
         var i:int = 0;
         var pPoint:Point = null;
         var bl:Point = null;
         var tl:Point = null;
         var tr:Point = null;
         var br:Point = null;
         var poi:Point = null;
         var rot:Number = NaN;
         var color:uint = 0;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         ++this._time;
         if(this._time % this._nextSeeker == 0)
         {
            this.createNewSeeker();
         }
         if(this._time % this._nextHeart == 0)
         {
            this.createNewHeart();
         }
         if(this._time % this._nextPowerUp == 0)
         {
            this.createPowerUp();
         }
         if(this._time == 600)
         {
            this._nextHeart = 100;
            ++this._maxHearts;
            this._nextSeeker = 100;
            this._maxSeekers += 2;
         }
         else if(this._time == 1200)
         {
            this._nextHeart = 80;
            ++this._maxHearts;
            this._nextSeeker = 80;
            this._maxSeekers += 2;
         }
         else if(this._time == 1800)
         {
            this._nextHeart = 60;
            ++this._maxHearts;
            this._nextSeeker = 60;
            this._maxSeekers += 2;
         }
         else if(this._time == 2400)
         {
            this._nextHeart = 40;
            ++this._maxHearts;
            this._nextSeeker = 40;
            this._maxSeekers += 2;
         }
         this._arrows.graphics.clear();
         if(_tracked)
         {
            num = 0;
            center = new Point(-GameCamera.ins.costume.x + 320,-GameCamera.ins.costume.y + 240);
            ePoint = new Point(this._elder.body.GetPosition().x * Constants.SCALE,this._elder.body.GetPosition().y * Constants.SCALE);
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
      
      override public function killAll() : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         for(var i:int = 0; i < _particles.length; i++)
         {
            if(_particles[i] is P_BonusSeeker)
            {
               (_particles[i] as P_BonusSeeker).explode();
            }
         }
         super.killAll();
      }
      
      override public function speedUp(duration:int) : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         this._elder.setSpeedUp(200);
         super.speedUp(duration);
      }
      
      override public function heal() : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         this._elder.heal(100);
         super.heal();
      }
      
      private function createNewHeart() : void
      {
         if(this._numHearts >= this._maxHearts)
         {
            return;
         }
         ++this._numHearts;
         var rot:Number = Math.random() * Math.PI * 2;
         var xpos:Number = (_width / 4 - 40) * Math.cos(rot) + _width / 4;
         var ypos:Number = (_height / 4 - 40) * Math.sin(rot) + _height / 4;
         for(var area:int = Math.floor(Math.random() * 5) + 1; area == this._lastHeartArea; )
         {
            area = Math.floor(Math.random() * 5) + 1;
         }
         this._lastHeartArea = area;
         if(area == 2)
         {
            xpos += _width / 2;
         }
         else if(area == 3)
         {
            ypos += _height / 2;
         }
         else if(area == 4)
         {
            xpos += _width / 2;
            ypos += _height / 2;
         }
         else if(area == 5)
         {
            xpos += _width / 4;
            ypos += _height / 4;
         }
         var hd:DO_HeartData = new DO_HeartData();
         hd.x = xpos;
         hd.y = ypos;
         hd.radius = 12;
         var heart:P_BonusHeart = new P_BonusHeart(GameCamera.HEART,hd,true);
         heart.create();
         heart.addEventListener(Event.REMOVED,this.heartCollectListener,false,0,true);
         _particles.push(heart);
      }
      
      private function createNewSeeker() : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         if(this._numSeekers >= this._maxSeekers)
         {
            return;
         }
         ++this._numSeekers;
         for(var area:int = Math.floor(Math.random() * 4) + 1; area == this._lastSeekerArea; )
         {
            area = Math.floor(Math.random() * 4) + 1;
         }
         this._lastSeekerArea = area;
         var sd:DO_SeekerData = new DO_SeekerData();
         sd.path = new DO_Path(DO_Path.CIRCULAR);
         var dist:Number = this._fh * 1.5 + int(300 * Math.random() / 20) * 20;
         if(area == 1)
         {
            xpos = _width / 2;
            ypos = 0;
            sd.path.waypoints.push(new Point(0,dist),new Point(_width / 2 - dist,dist),new Point(_width / 2 - dist,_height - dist),new Point(-_width / 2 + dist,_height - dist),new Point(-_width / 2 + dist,dist));
         }
         else if(area == 2)
         {
            xpos = _width;
            ypos = _height / 2;
            sd.path.waypoints.push(new Point(-dist,0),new Point(-dist,_height / 2 - dist),new Point(-_width + dist,_height / 2 - dist),new Point(-_width + dist,-_height / 2 + dist),new Point(-dist,-_height / 2 + dist));
         }
         else if(area == 3)
         {
            xpos = _width / 2;
            ypos = _height;
            sd.path.waypoints.push(new Point(0,-dist),new Point(-_width / 2 + dist,-dist),new Point(-_width / 2 + dist,-_height + dist),new Point(_width / 2 - dist,-_height + dist),new Point(_width / 2 - dist,-dist));
         }
         else if(area == 4)
         {
            xpos = 0;
            ypos = _height / 2;
            sd.path.waypoints.push(new Point(dist,0),new Point(dist,-_height / 2 + dist),new Point(_width - dist,-_height / 2 + dist),new Point(_width - dist,_height / 2 - dist),new Point(dist,_height / 2 - dist));
         }
         sd.x = xpos;
         sd.y = ypos;
         var seeker:P_BonusSeeker = new P_BonusSeeker(GameCamera.UO,sd);
         seeker.create();
         seeker.addEventListener(Event.REMOVED,this.seekerDeathListener,false,0,true);
         _particles.push(seeker);
      }
      
      private function createPowerUp() : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         for(var area:int = Math.floor(Math.random() * 4) + 1; area == this._lastPowerUpLocation; )
         {
            area = Math.floor(Math.random() * 4) + 1;
         }
         this._lastPowerUpLocation = area;
         if(area == 1)
         {
            xpos = _width * 0.5 - this._mws;
            ypos = _height * 0.5 - this._mws;
         }
         else if(area == 2)
         {
            xpos = _width * 0.5 + this._mws;
            ypos = _height * 0.5 - this._mws;
         }
         else if(area == 3)
         {
            xpos = _width * 0.5 + this._mws;
            ypos = _height * 0.5 + this._mws;
         }
         else if(area == 4)
         {
            xpos = _width * 0.5 - this._mws;
            ypos = _height * 0.5 + this._mws;
         }
         var rand:Number = Math.random();
         var type:String = P_PowerUp.SPEED_UP;
         if(rand < 0.33)
         {
            type = P_PowerUp.KILL_ALL;
         }
         else if(rand < 0.66)
         {
            type = P_PowerUp.HEAL;
         }
         var pu:P_PowerUp = new P_PowerUp(type,GameCamera.POWER_UP,xpos,ypos);
         pu.create();
         pu.addEventListener(Event.REMOVED,particleRemovedHandler,false,0,true);
         _particles.push(pu);
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
         --this._numHearts;
         _heartsCollected.addValue(1);
         _interface.updateInterface(_heartsCollected.value);
      }
      
      private function seekerDeathListener(e:Event) : void
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
         --this._numSeekers;
      }
   }
}
