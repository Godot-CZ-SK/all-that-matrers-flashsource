package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import design.data.DO_UnitData;
   import flash.display.Sprite;
   import game.GameCamera;
   import managers.GM;
   import particle.P_BonusBomb;
   import particle.P_BonusCannonBall;
   import particle.P_BonusSeeker;
   import particle.P_PowerUp;
   import particle.Particle;
   
   public class P_BonusUnit extends P_Unit
   {
       
      
      protected var _puBar:Sprite;
      
      protected var _speedUp:int;
      
      protected var _puDuration:int;
      
      protected var _puMax:int;
      
      public function P_BonusUnit(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._speedUp = 0;
         this._puDuration = 0;
         this._puBar = new Sprite();
         GameCamera.ins.addChildTo(this._puBar,_layerNo);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         CF.removeDisplayObject(this._puBar);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         this.powerUpUpdate();
      }
      
      public function setSpeedUp(val:int) : void
      {
         this._speedUp = val;
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         var p2:Number = NaN;
         var i2:b2Vec2 = null;
         if(_isDead)
         {
            return;
         }
         if(p is P_BonusBomb)
         {
            damage(3);
         }
         else if(p is P_PowerUp)
         {
            (p as P_PowerUp).collect();
            if((p as P_PowerUp).type == P_PowerUp.SPEED_UP)
            {
               GM.ins.bl.speedUp(150);
            }
            else if((p as P_PowerUp).type == P_PowerUp.KILL_ALL)
            {
               GM.ins.bl.killAll();
            }
            else if((p as P_PowerUp).type == P_PowerUp.HEAL)
            {
               GM.ins.bl.heal();
            }
            else if((p as P_PowerUp).type == P_PowerUp.ATTRACTOR)
            {
               GM.ins.bl.attract(300);
            }
            else if((p as P_PowerUp).type == P_PowerUp.TRIPLE_JUMP)
            {
               GM.ins.bl.tripleJump(400);
            }
            else if((p as P_PowerUp).type == P_PowerUp.SHIELD)
            {
               GM.ins.bl.shield();
            }
         }
         else if(p is P_BonusSeeker && selfData == MAIN)
         {
            if((p as P_BonusSeeker).isExploded)
            {
               return;
            }
            (p as P_BonusSeeker).explode();
            createExplosion(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE,15,10);
            damage(6);
            p2 = 8 * _scale * _scale;
            i2 = new b2Vec2(p2 * Math.cos(angle),p2 * Math.sin(angle));
            _body.ApplyImpulse(i2,_body.GetWorldCenter());
         }
         else if(p is P_BonusCannonBall && selfData == MAIN)
         {
            createExplosion(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE,25,15);
            damage(6);
            (p as P_BonusCannonBall).die();
            _body.ApplyImpulse(new b2Vec2(8 * _scale * _scale * Math.cos(angle),8 * _scale * _scale * Math.sin(angle)),_body.GetWorldCenter());
         }
         super.preHit(p,b,angle,selfData,targetData);
      }
      
      protected function powerUpUpdate() : void
      {
         this._puBar.graphics.clear();
         if(this._puDuration <= 0)
         {
            return;
         }
         --this._puDuration;
         var barX:Number = -_data.SIZE * 0.5 * _scale + _costume.x;
         var barY:Number = -_data.SIZE * 0.75 * _scale + _costume.y;
         var barWidth:Number = _data.SIZE * _scale;
         var barHeight:Number = _data.SIZE * 0.1 * _scale;
         var puWidth:Number = _data.SIZE * _scale * (this._puDuration / this._puMax);
         this._puBar.graphics.beginFill(16777215,1);
         this._puBar.graphics.drawRect(barX,barY,barWidth,barHeight);
         this._puBar.graphics.endFill();
         this._puBar.graphics.beginFill(22015,1);
         this._puBar.graphics.drawRect(barX,barY,puWidth,barHeight);
      }
   }
}
