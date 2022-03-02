package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import design.data.DO_UnitData;
   import game.GameVoice;
   import managers.GM;
   import managers.KM;
   import managers.SM;
   
   public class P_Mom extends P_Unit
   {
       
      
      public function P_Mom(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _costume = new MC_Mom();
         _costume.x = _data.x;
         _costume.y = _data.y;
         _scale = _data.radius * 2 / _data.SIZE;
         _costume.scaleX = _scale;
         _costume.scaleY = _scale;
         _costume.rotation = _data.rotation;
         _max_linear_velocity = 3.8 * _scale;
         super.create();
         _hpMax = 16;
         _hitPoint = 16;
         _deathVoiceID = GameVoice.SYDNEY_DIE;
         _hitVoiceID = GameVoice.SYDNEY_HIT;
         _jumpVoiceID = GameVoice.SYDNEY_JUMP;
         _selectVoiceID = GameVoice.SYDNEY_SELECT;
         _victoryVoiceID = GameVoice.SYDNEY_VICTORY;
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(GM.ins.cl.isTracking && GM.ins.cl.tracked is P_Dad)
         {
            this.falseMovement();
         }
      }
      
      protected function falseMovement() : void
      {
         var ladderForce:Number = NaN;
         var dir:int = 0;
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT))
         {
            dir += 1;
         }
         if(KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT))
         {
            dir += -1;
         }
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT) || KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT) || KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
         {
            _isInteracting = 5;
         }
         var force:Number = dir * 15 * _scale * _body.GetMass();
         if(_onAir)
         {
            force *= 0.6;
         }
         if(dir == 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.05,_body.GetLinearVelocity().y));
         }
         if(_body.GetLinearVelocity().x * dir < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.3,_body.GetLinearVelocity().y));
         }
         _body.ApplyForce(new b2Vec2(force,0),_body.GetWorldCenter());
         var linear_velocity_x:Number = _body.GetLinearVelocity().x;
         var linear_velocity_y:Number = _body.GetLinearVelocity().y;
         var temp_max:Number = _max_linear_velocity;
         if(_onAir)
         {
            temp_max /= 1.35;
         }
         if(linear_velocity_x > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_x < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(-temp_max,_body.GetLinearVelocity().y));
         }
         if(!_onLadder && !_isPulling)
         {
            if(KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
            {
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 2,_body.GetLinearVelocity().y));
            }
            if(_isJumping == 0 && !_onAir && (KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN)))
            {
               this.jump();
            }
            if(_isJumping > 0)
            {
               --_isJumping;
               if(_canBoost)
               {
                  if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
                  {
                     this.boostJump();
                  }
                  else
                  {
                     _canBoost = false;
                  }
               }
            }
         }
         if(_onLadder)
         {
            ladderForce = 20 * _scale * _body.GetMass() * 1.5;
            if(KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
            {
               _body.ApplyForce(new b2Vec2(0,ladderForce),_body.GetWorldCenter());
            }
            if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
            {
               _body.ApplyForce(new b2Vec2(0,-ladderForce),_body.GetWorldCenter());
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
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT) || KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT) || KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
         {
            _isInteracting = 5;
         }
         var force:Number = dir * 15 * _scale * _body.GetMass();
         if(_onAir)
         {
            force *= 0.6;
         }
         if(_onAir && _isPulling)
         {
            force *= 0.5;
         }
         if(dir == 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.05,_body.GetLinearVelocity().y));
         }
         if(_body.GetLinearVelocity().x * dir < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.3,_body.GetLinearVelocity().y));
         }
         _body.ApplyForce(new b2Vec2(force,0),_body.GetWorldCenter());
         var linear_velocity_x:Number = _body.GetLinearVelocity().x;
         var linear_velocity_y:Number = _body.GetLinearVelocity().y;
         var temp_max:Number = _max_linear_velocity;
         if(_onAir)
         {
            temp_max /= 1.35;
         }
         if(linear_velocity_x > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_x < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(-temp_max,_body.GetLinearVelocity().y));
         }
         if(!_onLadder && !_isPulling)
         {
            if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
            {
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 2,_body.GetLinearVelocity().y));
            }
            if(_isJumping == 0 && !_onAir && (KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP)))
            {
               this.jump();
            }
            if(_isJumping > 0)
            {
               --_isJumping;
               if(_canBoost)
               {
                  if(KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
                  {
                     this.boostJump();
                  }
                  else
                  {
                     _canBoost = false;
                  }
               }
            }
         }
         super.updateMovement();
      }
      
      protected function boostJump() : void
      {
         var pc:Number = _isJumping / 10;
         var impulse:Number = _body.GetMass() * _scale * 0.42;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
      }
      
      private function jump() : void
      {
         var impulse:Number = _body.GetMass() * _scale * 3.2;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         if(_hasKey)
         {
            impulse *= 1.2;
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,0));
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
         _isJumping = 8;
         _canJump = 20;
         _canBoost = true;
         SM.ins.playVoice(_jumpVoiceID);
      }
   }
}
