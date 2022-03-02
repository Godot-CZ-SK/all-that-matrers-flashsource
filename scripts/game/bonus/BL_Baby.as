package game.bonus
{
   import design.data.DO_HeartData;
   import design.data.DO_PolyData;
   import design.data.DO_UnitData;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameCamera;
   import particle.P_BonusBomb;
   import particle.P_BonusHeart;
   import particle.P_PowerUp;
   import particle.P_Wall;
   import particle.Particle;
   import particle.units.P_BonusBaby;
   
   public class BL_Baby extends BonusLevel
   {
       
      
      protected var _baby:P_BonusBaby;
      
      protected var _floor:P_Wall;
      
      protected var _time:int;
      
      protected var _next:int;
      
      protected var _increment:int;
      
      protected var _lastHeartX:Number;
      
      public function BL_Baby()
      {
         super();
      }
      
      override public function create() : void
      {
         var babyData:DO_UnitData = null;
         if(_isCreated)
         {
            return;
         }
         _name = TOBYS_DREAM;
         _width = 640;
         _height = 480;
         this._time = 0;
         this._lastHeartX = 320;
         this._next = 60;
         this._increment = 40;
         super.create();
         _nextLevelNo = 6;
         var floorData:DO_PolyData = new DO_PolyData(DO_PolyData.WALL);
         floorData.vertices.push(new Point(-20,380),new Point(0,380),new Point(0,400),new Point(640,400),new Point(640,380),new Point(660,380),new Point(660,430),new Point(-20,430));
         this._floor = new P_Wall(GameCamera.WALL,floorData);
         this._floor.setPhysicParams(1,0.5,0.6);
         this._floor.create();
         babyData = new DO_UnitData(DO_UnitData.BABY);
         babyData.radius = 15;
         babyData.x = 320;
         babyData.y = 380;
         this._baby = new P_BonusBaby(GameCamera.UNIT,babyData);
         this._baby.create();
         this._baby.addEventListener(Event.REMOVED,unitRemoveListener,false,0,true);
         this._baby.setArea(_area);
         _particles.push(this._floor,this._baby);
         _tracked = this._baby;
         this._baby.startTracking();
         this.createNewHeart();
         commence();
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         this._baby = null;
         this._floor = null;
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         ++this._time;
         if(this._time == 600)
         {
            this._increment = 35;
         }
         if(this._time == 900)
         {
            this._increment = 30;
         }
         if(this._time == 1200)
         {
            this._increment = 25;
         }
         if(this._time == 1500)
         {
            this._increment = 20;
         }
         if(this._time == 2000)
         {
            this._increment = 15;
         }
         if(this._time == 2500)
         {
            this._increment = 10;
         }
         if(this._time == 3000)
         {
            this._increment = 5;
         }
         if(this._time == this._next)
         {
            this._next += this._increment;
            this.fallBomb();
         }
      }
      
      override public function speedUp(duration:int) : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         this._baby.setSpeedUp(duration);
         super.speedUp(duration);
      }
      
      override public function shield() : void
      {
         if(!_isCreated || _isEnded)
         {
            return;
         }
         super.shield();
         this._baby.setShield(210);
      }
      
      private function createNewHeart() : void
      {
         var hc:int = _heartsCollected.value;
         if(hc == 5 || hc == 15 || hc == 30 || hc == 45)
         {
            this.createPowerUp(P_PowerUp.SPEED_UP);
         }
         if(hc == 10 || hc == 25 || hc == 40)
         {
            this.createPowerUp(P_PowerUp.SHIELD);
         }
         var xpos:Number = 20 + Math.random() * 600;
         while(Math.abs(xpos - this._lastHeartX) < 150)
         {
            xpos = 20 + Math.random() * 600;
         }
         this._lastHeartX = xpos;
         var hd:DO_HeartData = new DO_HeartData();
         hd.x = xpos;
         hd.y = 385;
         hd.radius = 12;
         var heart:P_BonusHeart = new P_BonusHeart(GameCamera.HEART,hd);
         heart.create();
         heart.addEventListener(Event.REMOVED,this.heartCollectListener,false,0,true);
         _particles.push(heart);
      }
      
      private function createPowerUp(type:String) : void
      {
         var xpos:Number = 20 + Math.random() * 600;
         while(Math.abs(xpos - this._lastHeartX) < 150)
         {
            xpos = 20 + Math.random() * 600;
         }
         var power:P_PowerUp = new P_PowerUp(type,GameCamera.POWER_UP,xpos,385);
         power.create();
         power.addEventListener(Event.REMOVED,particleRemovedHandler,false,0,true);
         _particles.push(power);
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
         this.createNewHeart();
      }
      
      private function fallBomb() : void
      {
         var bomb:P_BonusBomb = new P_BonusBomb(GameCamera.UO,Math.random() * 640,-30);
         bomb.create();
         bomb.addEventListener(Event.REMOVED,particleRemovedHandler,false,0,true);
         _particles.push(bomb);
      }
   }
}
