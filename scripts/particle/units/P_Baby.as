package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import com.greensock.TweenLite;
   import design.data.DO_UnitData;
   import game.GameCamera;
   import game.GameVoice;
   import managers.GM;
   import managers.KM;
   import managers.TM;
   
   public class P_Baby extends P_Unit
   {
       
      
      public function P_Baby(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
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
         _costume.rotation = _data.rotation;
         _max_linear_velocity = 4.5 * _scale;
         super.create();
         _deathVoiceID = GameVoice.TOBY_DIE;
         _hitVoiceID = GameVoice.TOBY_HIT;
         _selectVoiceID = GameVoice.TOBY_SELECT;
         _victoryVoiceID = GameVoice.TOBY_VICTORY;
      }
      
      override public function update() : void
      {
         var effect:MC_DO_Baby = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(KM.ins.isDown(KM.UP) || KM.ins.isDown(KM.KEY_W))
         {
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
            _max_linear_velocity = 6.5 * _scale;
         }
         else
         {
            _max_linear_velocity = 4.5 * _scale;
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
         var str:Number = 20 * _scale * _body.GetMass();
         var force:Number = dir * str;
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
         if(!_onAir && dir != 0)
         {
            _body.ApplyForce(new b2Vec2(0,-str * 0.8 * Math.sin(GM.ins.cl.gravityAngle)),_body.GetWorldCenter());
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
         if(!_onLadder)
         {
            if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
            {
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x / 2,_body.GetLinearVelocity().y));
            }
         }
         super.updateMovement();
      }
   }
}
