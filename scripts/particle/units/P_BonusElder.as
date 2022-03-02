package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import com.greensock.TweenLite;
   import design.data.DO_UnitData;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameVoice;
   import managers.KM;
   import managers.TM;
   
   public class P_BonusElder extends P_BonusUnit
   {
       
      
      public function P_BonusElder(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _costume = new MC_Elder();
         _costume.x = _data.x;
         _costume.y = _data.y;
         _scale = _data.radius * 2 / _data.SIZE;
         _costume.scaleX = _scale;
         _costume.scaleY = _scale;
         _max_linear_velocity = 6 * _scale;
         _force = 12.5;
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler,false,0,true);
         super.create();
         _hpMax = 15;
         _hitPoint = _hpMax;
         _hitVoiceID = GameVoice.MRGREER_HIT;
         _selectVoiceID = GameVoice.MRGREER_SELECT;
         _deathVoiceID = GameVoice.MRGREER_DIE;
         _victoryVoiceID = GameVoice.MRGREER_VICTORY;
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(!_isCreated || !_isTracked)
         {
            return;
         }
         if(e.keyCode == KM.KEY_W || e.keyCode == KM.UP)
         {
            _gravity = new Point(0,-Constants.GRAVITY);
         }
         else if(e.keyCode == KM.KEY_S || e.keyCode == KM.DOWN)
         {
            _gravity = new Point(0,Constants.GRAVITY);
         }
         else if(e.keyCode == KM.KEY_A || e.keyCode == KM.LEFT)
         {
            _gravity = new Point(-Constants.GRAVITY,0);
         }
         else if(e.keyCode == KM.KEY_D || e.keyCode == KM.RIGHT)
         {
            _gravity = new Point(Constants.GRAVITY,0);
         }
      }
      
      override protected function updateMovement() : void
      {
         if(_speedUp <= 0)
         {
            return;
         }
         var dirX:int = 0;
         var dirY:int = 0;
         if(KM.ins.isDown(KM.KEY_A) || KM.ins.isDown(KM.LEFT))
         {
            dirX += -1;
         }
         if(KM.ins.isDown(KM.KEY_D) || KM.ins.isDown(KM.RIGHT))
         {
            dirX += 1;
         }
         if(KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
         {
            dirY += -1;
         }
         if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
         {
            dirY += 1;
         }
         var forceX:Number = dirX * 30 * _scale * _body.GetMass();
         var forceY:Number = dirY * 30 * _scale * _body.GetMass();
         if(dirX == 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.1,_body.GetLinearVelocity().y));
         }
         if(dirY == 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,_body.GetLinearVelocity().y / 1.1));
         }
         if(_body.GetLinearVelocity().x * dirX < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 1.2,_body.GetLinearVelocity().y));
         }
         if(_body.GetLinearVelocity().y * dirY < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,_body.GetLinearVelocity().y / 1.2));
         }
         _body.ApplyForce(new b2Vec2(forceX,forceY),_body.GetWorldCenter());
         var linear_velocity_x:Number = _body.GetLinearVelocity().x;
         var linear_velocity_y:Number = _body.GetLinearVelocity().y;
         var temp_max:Number = _max_linear_velocity * 1.5;
         if(linear_velocity_x > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_x < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(-temp_max,_body.GetLinearVelocity().y));
         }
         if(linear_velocity_y > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,temp_max));
         }
         if(linear_velocity_y < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,-temp_max));
         }
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      override public function stopTracking() : void
      {
         if(!_isTracked)
         {
            return;
         }
         super.stopTracking();
      }
      
      override public function update() : void
      {
         var effect:MC_DO_Elder = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(_gravity.x <= 0 && _body.GetLinearVelocity().x > 0 || _gravity.x >= 0 && _body.GetLinearVelocity().x < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.85,_body.GetLinearVelocity().y));
         }
         if(_gravity.y <= 0 && _body.GetLinearVelocity().y > 0 || _gravity.y >= 0 && _body.GetLinearVelocity().y < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,_body.GetLinearVelocity().y * 0.85));
         }
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
         if(linear_velocity_y > temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,temp_max));
         }
         if(linear_velocity_y < -temp_max)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,-temp_max));
         }
         if(_speedUp > 0)
         {
            --_speedUp;
            _gravity = new Point();
            if(_step % 4 == 0)
            {
               if(Math.abs(_body.GetLinearVelocity().x) > 2 || Math.abs(_body.GetLinearVelocity().y) > 2)
               {
                  effect = new MC_DO_Elder();
                  effect.x = _costume.x;
                  effect.y = _costume.y;
                  effect.scaleX = _costume.scaleX;
                  effect.scaleY = _costume.scaleY;
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
      }
      
      override protected function mouseUpHandler(e:MouseEvent) : void
      {
      }
      
      override protected function frameHandler(e:Event) : void
      {
      }
   }
}
