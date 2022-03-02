package particle.units
{
   import Box2D.Common.Math.b2Vec2;
   import design.data.DO_UnitData;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameVoice;
   import managers.KM;
   import managers.SM;
   
   public class P_Elder extends P_Unit
   {
       
      
      protected var _voiceCounter:int;
      
      public function P_Elder(layerNo:int, data:DO_UnitData)
      {
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         this._voiceCounter = 0;
         _costume = new MC_Elder();
         _costume.x = _data.x;
         _costume.y = _data.y;
         _scale = _data.radius * 2 / _data.SIZE;
         _costume.scaleX = _scale;
         _costume.scaleY = _scale;
         _costume.rotation = _data.rotation;
         _max_linear_velocity = 4.2 * _scale;
         _force = 12.5;
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.movementHandler,false,0,true);
         super.create();
         _deathVoiceID = GameVoice.MRGREER_DIE;
         _hitVoiceID = GameVoice.MRGREER_HIT;
         _jumpVoiceID = GameVoice.MRGREER_JUMP;
         _selectVoiceID = GameVoice.MRGREER_SELECT;
         _victoryVoiceID = GameVoice.MRGREER_VICTORY;
      }
      
      private function movementHandler(e:KeyboardEvent) : void
      {
         if(!_isCreated || !_isTracked)
         {
            return;
         }
         var oldGravity:Point = _gravity.clone();
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
         if(!(oldGravity.x == _gravity.x && oldGravity.y == _gravity.y))
         {
            _changeBody = true;
            if(this._voiceCounter == 0)
            {
               this._voiceCounter = 50;
               SM.ins.playVoice(_jumpVoiceID);
            }
         }
      }
      
      override protected function updateMovement() : void
      {
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.movementHandler);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._voiceCounter > 0)
         {
            --this._voiceCounter;
         }
         if(_gravity.x <= 0 && _body.GetLinearVelocity().x > 0 || _gravity.x >= 0 && _body.GetLinearVelocity().x < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.8,_body.GetLinearVelocity().y));
         }
         if(_gravity.y <= 0 && _body.GetLinearVelocity().y > 0 || _gravity.y >= 0 && _body.GetLinearVelocity().y < 0)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,_body.GetLinearVelocity().y * 0.8));
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
      }
      
      override protected function mouseUpHandler(e:MouseEvent) : void
      {
      }
      
      override protected function frameHandler(e:Event) : void
      {
      }
   }
}
