package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import game.GameCamera;
   import game.GameSound;
   import managers.DM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   
   public class P_PowerUp extends Particle
   {
      
      public static const SPEED_UP:String = "speed_up";
      
      public static const TIME_SLOW:String = "time_slow";
      
      public static const KILL_ALL:String = "kill_all";
      
      public static const HEAL:String = "heal";
      
      public static const ATTRACTOR:String = "attractor";
      
      public static const TRIPLE_JUMP:String = "triple_jump";
      
      public static const SHIELD:String = "shield";
      
      protected static const RADIUS:Number = 12.5;
      
      public static const MAIN:String = "power_up_main";
       
      
      protected var _type:String;
      
      protected var _xpos:Number;
      
      protected var _ypos:Number;
      
      protected var _isCollected:Boolean;
      
      public function P_PowerUp(type:String, layerNo:int, xpos:Number, ypos:Number)
      {
         this._type = type;
         this._xpos = xpos;
         this._ypos = ypos;
         super(layerNo);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_kinematicBody;
         bodyDef.position = new b2Vec2(this._xpos / Constants.SCALE,this._ypos / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var shape:b2CircleShape = new b2CircleShape(RADIUS / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         fix.SetSensor(true);
         if(this._type == SPEED_UP)
         {
            _costume = new MC_SpeedUp();
         }
         else if(this._type == TIME_SLOW)
         {
            _costume = new MC_TimeSlow();
         }
         else if(this._type == KILL_ALL)
         {
            _costume = new MC_KillAll();
         }
         else if(this._type == HEAL)
         {
            _costume = new MC_Heal();
         }
         else if(this._type == TRIPLE_JUMP)
         {
            _costume = new MC_TripleJump();
         }
         else if(this._type == ATTRACTOR)
         {
            _costume = new MC_Attractor();
         }
         else if(this._type == SHIELD)
         {
            _costume = new MC_Shield();
         }
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._xpos;
         _costume.y = this._ypos;
      }
      
      public function collect() : void
      {
         var effect:MovieClip = null;
         if(this._isCollected)
         {
            return;
         }
         this._isCollected = true;
         if(this.type == SPEED_UP)
         {
            effect = new MC_SpeedUp();
         }
         else if(this.type == TIME_SLOW)
         {
            effect = new MC_TimeSlow();
         }
         else if(this.type == KILL_ALL)
         {
            effect = new MC_KillAll();
         }
         else if(this.type == HEAL)
         {
            effect = new MC_Heal();
         }
         else if(this.type == ATTRACTOR)
         {
            effect = new MC_Attractor();
         }
         else if(this.type == TRIPLE_JUMP)
         {
            effect = new MC_TripleJump();
         }
         else if(this.type == SHIELD)
         {
            effect = new MC_Shield();
         }
         effect.x = _costume.x + GameCamera.ins.x;
         effect.y = _costume.y + GameCamera.ins.y;
         DM.ins.iface.addChild(effect);
         TweenLite.to(effect,0.7,{
            "alpha":0,
            "scaleX":4,
            "scaleY":4
         });
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(effect);
         },0.7);
         safeRemove();
         SM.ins.playSound(GameSound.POWERUP);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         PM.ins.world.DestroyBody(_body);
         super.remove();
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         var ss:int = _step % 35;
         if(ss < 15)
         {
            _costume.scaleX = 1 + ss * ss / 400;
            _costume.scaleY = 1 + ss * ss / 400;
         }
         else if(ss < 30)
         {
            _costume.scaleX = 1 + (30 - ss) * 15 / 400;
            _costume.scaleY = 1 + (30 - ss) * 15 / 400;
         }
         else
         {
            _costume.scaleX = 1;
            _costume.scaleY = 1;
         }
      }
      
      public function get isCollected() : Boolean
      {
         return this._isCollected;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
