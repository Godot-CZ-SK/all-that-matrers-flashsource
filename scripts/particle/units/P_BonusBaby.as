package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import com.greensock.TweenLite;
   import design.data.DO_UnitData;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameVoice;
   import managers.KM;
   import managers.PM;
   import managers.TM;
   import particle.P_BonusBomb;
   
   public class P_BonusBaby extends P_BonusUnit
   {
       
      
      protected var _shieldDuration:int;
      
      protected var _hasShield:Boolean;
      
      public function P_BonusBaby(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
         setPhysicParams(2,0.5,0.1);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _costume = new MC_Baby();
         _costume.x = _data.x;
         _costume.y = _data.y;
         _scale = _data.radius * 2 / _data.SIZE;
         _costume.scaleX = _scale;
         _costume.scaleY = _scale;
         _max_linear_velocity = 6 * _scale;
         _hitVoiceID = GameVoice.TOBY_HIT;
         _selectVoiceID = GameVoice.TOBY_SELECT;
         _deathVoiceID = GameVoice.TOBY_DIE;
         _victoryVoiceID = GameVoice.TOBY_VICTORY;
         super.create();
      }
      
      public function setShield(duration:Number) : void
      {
         if(!_isCreated || isDead)
         {
            return;
         }
         this._shieldDuration = duration;
         _puDuration = this._shieldDuration;
         _puMax = _puDuration;
         this._hasShield = true;
      }
      
      override public function update() : void
      {
         var effect:MC_DO_Baby = null;
         var i:int = 0;
         var b:P_BonusBomb = null;
         var poi1:Point = null;
         var poi2:Point = null;
         var dist:Number = NaN;
         var a:Number = NaN;
         var pow:Number = NaN;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._shieldDuration > 0)
         {
            --this._shieldDuration;
            if(this._shieldDuration == 0)
            {
               this._hasShield = false;
            }
         }
         if(_speedUp > 0)
         {
            --_speedUp;
            if(_step % 4 == 0)
            {
               if(Math.abs(_body.GetLinearVelocity().x) > 2)
               {
                  effect = new MC_DO_Baby();
                  effect.x = _costume.x;
                  effect.y = _costume.y;
                  effect.rotation = _costume.rotation;
                  effect.alpha = 0.5;
                  GameCamera.ins.addChildTo(effect,_layerNo - 1);
                  TweenLite.to(effect,1,{"alpha":0});
                  TM.ins.tf(function():void
                  {
                     CF.removeDisplayObject(effect);
                  },1);
               }
            }
         }
         if(this._hasShield)
         {
            for(i = 0; i < PM.ins.list.length; i++)
            {
               if(PM.ins.list[i] is P_BonusBomb)
               {
                  b = PM.ins.list[i] as P_BonusBomb;
                  if(!(b.isDead || b.isExploded || !b.isCreated))
                  {
                     poi1 = new Point(_body.GetPosition().x,_body.GetPosition().y);
                     poi2 = new Point(b.body.GetPosition().x,b.body.GetPosition().y);
                     dist = CF.dist(poi1,poi2) * Constants.SCALE;
                     if(dist < 200)
                     {
                        a = Math.atan2(poi2.y - poi1.y,poi2.x - poi1.x);
                        pow = 2000 / (dist + 25);
                        b.body.SetLinearVelocity(new b2Vec2(b.body.GetLinearVelocity().x * 0.95,b.body.GetLinearVelocity().y * 0.9));
                        b.body.ApplyForce(new b2Vec2(pow * Math.cos(a),pow * Math.sin(a)),b.body.GetWorldCenter());
                     }
                  }
               }
            }
         }
      }
      
      override protected function updateMovement() : void
      {
         var dir:int = 0;
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT))
         {
            dir += -1;
         }
         if(KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT))
         {
            dir += 1;
         }
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT) || KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT))
         {
            _isInteracting = 5;
         }
         var force:Number = dir * 20 * _scale * _body.GetMass();
         if(_speedUp > 0)
         {
            force *= 1.8;
         }
         if(_onAir)
         {
            force *= 0.6;
         }
         if(dir == 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.1,_body.GetLinearVelocity().y));
         }
         if(_body.GetLinearVelocity().x * dir < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.5,_body.GetLinearVelocity().y));
         }
         _body.ApplyForce(new b2Vec2(force,0),_body.GetWorldCenter());
         var linear_velocity_x:Number = _body.GetLinearVelocity().x;
         var linear_velocity_y:Number = _body.GetLinearVelocity().y;
         var temp_max:Number = _max_linear_velocity;
         if(_onAir)
         {
            temp_max /= 1.6;
         }
         if(_speedUp > 0)
         {
            temp_max *= 1.8;
         }
         if(linear_velocity_x > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_x < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(-temp_max,_body.GetLinearVelocity().y));
         }
         super.updateMovement();
      }
   }
}
