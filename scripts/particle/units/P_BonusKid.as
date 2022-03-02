package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import design.data.DO_UnitData;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import game.GameVoice;
   import managers.KM;
   
   public class P_BonusKid extends P_BonusUnit
   {
       
      
      protected var _doubleJump:Boolean;
      
      protected var _tripleJump:Boolean;
      
      protected var _hasShield:Boolean;
      
      protected var _tripleJumpDuration:int;
      
      protected var _shieldSprite:Sprite;
      
      public function P_BonusKid(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _costume = new MC_Kid();
         _costume.x = _data.x;
         _costume.y = _data.y;
         _scale = _data.radius * 2 / _data.SIZE;
         _costume.scaleX = _scale;
         _costume.scaleY = _scale;
         _max_linear_velocity = 3.5 * _scale;
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.downHandler,false,0,true);
         super.create();
         _hpMax = 14;
         _hitPoint = 14;
         _hitVoiceID = GameVoice.BILLY_HIT;
         _selectVoiceID = GameVoice.BILLY_SELECT;
         _deathVoiceID = GameVoice.BILLY_DIE;
         _victoryVoiceID = GameVoice.BILLY_VICTORY;
      }
      
      public function setTripleJump(duration:int) : void
      {
         if(!_isCreated || isDead)
         {
            return;
         }
         this._tripleJumpDuration = duration;
         _puDuration = this._tripleJumpDuration;
         _puMax = _puDuration;
      }
      
      public function setShield() : void
      {
         if(!_isCreated || isDead || this._hasShield)
         {
            return;
         }
         this._hasShield = true;
         this._shieldSprite = new Sprite();
         this._shieldSprite.graphics.clear();
         this._shieldSprite.graphics.beginFill(16777062,0.25);
         this._shieldSprite.graphics.drawCircle(0,0,_data.radius * 1.1);
         _costume.addChild(this._shieldSprite);
      }
      
      public function destroyShield() : void
      {
         if(!_isCreated || _isDead || !this._hasShield)
         {
            return;
         }
         this._hasShield = false;
         CF.removeDisplayObject(this._shieldSprite);
      }
      
      private function downHandler(e:KeyboardEvent) : void
      {
         if(!_isCreated || !_isTracked)
         {
            return;
         }
         if(e.keyCode == KM.KEY_W || e.keyCode == KM.UP)
         {
            Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.downHandler);
            Main.s.addEventListener(KeyboardEvent.KEY_UP,this.upHandler,false,0,true);
            if(_onAir && this._doubleJump)
            {
               this.doubleJump();
            }
            else if(_onAir && this._tripleJump)
            {
               this.tripleJump();
            }
         }
      }
      
      private function upHandler(e:KeyboardEvent) : void
      {
         if(!_isCreated || !_isTracked)
         {
            return;
         }
         if(e.keyCode == KM.KEY_W || e.keyCode == KM.UP)
         {
            Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.downHandler,false,0,true);
            Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.upHandler,false);
         }
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.downHandler);
         CF.removeDisplayObject(this._shieldSprite);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._tripleJumpDuration > 0)
         {
            --this._tripleJumpDuration;
         }
         if(!_onAir)
         {
            this._doubleJump = true;
            if(this._tripleJumpDuration > 0)
            {
               this._tripleJump = true;
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
            temp_max /= 1.45;
         }
         if(linear_velocity_x > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_x < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(-temp_max,_body.GetLinearVelocity().y));
         }
         if(!_onLadder)
         {
            if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
            {
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 2,_body.GetLinearVelocity().y));
            }
            if(_isJumping == 0 && !_onAir && (KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP)))
            {
               this.jump();
            }
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
         super.updateMovement();
      }
      
      override public function damage(val:Number) : void
      {
         if(this._hasShield)
         {
            this.destroyShield();
            return;
         }
         super.damage(val);
      }
      
      protected function boostJump() : void
      {
         var pc:Number = _isJumping / 10;
         var impulse:Number = _body.GetMass() * _scale * 0.5;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
      }
      
      private function jump() : void
      {
         var impulse:Number = _body.GetMass() * _scale * 3.6;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         if(_hasKey)
         {
            impulse *= 1.2;
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,0));
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
         _isJumping = 7;
         _canBoost = true;
      }
      
      private function doubleJump() : void
      {
         this._doubleJump = false;
         var impulse:Number = _body.GetMass() * _scale * 3.5;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         if(_hasKey)
         {
            impulse *= 1.2;
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,0));
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
         _isJumping = 5;
         _canBoost = true;
      }
      
      private function tripleJump() : void
      {
         this._tripleJump = false;
         var impulse:Number = _body.GetMass() * _scale * 3.5;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI;
         if(_hasKey)
         {
            impulse *= 1.2;
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,0));
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),_body.GetWorldCenter());
         _isJumping = 5;
         _canBoost = true;
      }
   }
}
