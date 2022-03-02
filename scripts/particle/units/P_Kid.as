package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import design.data.DO_UnitData;
   import flash.events.KeyboardEvent;
   import game.GameVoice;
   import managers.KM;
   import managers.SM;
   import particle.P_Bouncer;
   import particle.P_Chain;
   import particle.Particle;
   
   public class P_Kid extends P_Unit
   {
       
      
      protected var _doubleJump:Boolean;
      
      public function P_Kid(layerNo:int, data:DO_UnitData)
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
         _costume.rotation = _data.rotation;
         _max_linear_velocity = 3.5 * _scale;
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.downHandler,false,0,true);
         super.create();
         _hpMax = 15;
         _hitPoint = 15;
         _deathVoiceID = GameVoice.BILLY_DIE;
         _hitVoiceID = GameVoice.BILLY_HIT;
         _jumpVoiceID = GameVoice.BILLY_JUMP;
         _selectVoiceID = GameVoice.BILLY_SELECT;
         _victoryVoiceID = GameVoice.BILLY_VICTORY;
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
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(!_onAir)
         {
            this._doubleJump = true;
         }
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Bouncer)
         {
            this._doubleJump = true;
         }
         super.preHit(p,b,angle,selfData,targetData);
      }
      
      override public function postHit(p:Particle, b:b2Body, angle:Number, power:Number, selfData:String, targetData:String) : void
      {
         super.postHit(p,b,angle,power,selfData,targetData);
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
               if(!(_pulledObject is P_Chain && !_canRelease))
               {
                  this.jump();
               }
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
         SM.ins.playVoice(_jumpVoiceID);
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
         SM.ins.playVoice(GameVoice.BILLY_DOUBLE_JUMP);
      }
   }
}
