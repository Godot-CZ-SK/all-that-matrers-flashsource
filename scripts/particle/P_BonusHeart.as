package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_HeartData;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.DM;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.units.P_Unit;
   
   public class P_BonusHeart extends Particle
   {
      
      public static const MAIN:String = "coin_main";
       
      
      protected var _data:DO_HeartData;
      
      protected var _isCollected:Boolean;
      
      protected var _isMagnet:Boolean;
      
      protected var _scale:Number;
      
      public function P_BonusHeart(layerNo:int, data:DO_HeartData, isMagnet:Boolean = false)
      {
         this._data = data;
         this._isMagnet = isMagnet;
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
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var shape:b2CircleShape = new b2CircleShape(this._data.radius / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,this._data.density);
         fix.SetUserData(MAIN);
         fix.SetSensor(true);
         _costume = new MC_DO_Heart();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         this._scale = this._data.radius * 2 / this._data.SIZE;
         (_costume as MC_DO_Heart).mc_heartMask.visible = false;
         _costume.scaleX = 0;
         _costume.scaleY = 0;
         TweenLite.to(_costume,1,{
            "scaleX":this._scale,
            "scaleY":this._scale
         });
         if(this._data.time > 0)
         {
            this.setTimer(this._data.time * Constants.FRAME_RATE);
         }
      }
      
      public function setTimer(time:int) : void
      {
         setLifeTime(time);
         (_costume as MC_DO_Heart).mc_heartMask.visible = true;
         (_costume as MC_DO_Heart).mc_heartMask.y = -20;
      }
      
      public function collect() : void
      {
         var effect:MC_DO_Heart = null;
         var val:int = 0;
         var collected:int = 0;
         if(_isDead || this._isCollected)
         {
            return;
         }
         this._isCollected = true;
         effect = new MC_DO_Heart();
         effect.x = _costume.x + GameCamera.ins.x;
         effect.y = _costume.y + GameCamera.ins.y;
         effect.scaleX = this._scale;
         effect.scaleY = this._scale;
         DM.ins.iface.addChild(effect);
         TweenLite.to(effect,1.5,{
            "x":620,
            "y":20,
            "alpha":0,
            "scaleX":this._scale * 5,
            "scaleY":this._scale * 5
         });
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(effect);
         },1.5);
         SM.ins.playSound(GameSound.HEART_COLLECT);
         safeRemove();
      }
      
      override public function update() : void
      {
         var units:Vector.<P_Unit> = null;
         var i:int = 0;
         var distance:Number = NaN;
         var pow:Number = NaN;
         var rot:Number = NaN;
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
            _costume.scaleX = this._scale * (1 + ss * ss / 400);
            _costume.scaleY = this._scale * (1 + ss * ss / 400);
         }
         else if(ss < 30)
         {
            _costume.scaleX = this._scale * (1 + (30 - ss) * 15 / 400);
            _costume.scaleY = this._scale * (1 + (30 - ss) * 15 / 400);
         }
         else
         {
            _costume.scaleX = this._scale;
            _costume.scaleY = this._scale;
         }
         if(_maxLifeTime > 0)
         {
            (_costume as MC_DO_Heart).mc_heartMask.y = 20 * (1 - _lifeTime / _maxLifeTime) - 20;
         }
         if(this._isMagnet)
         {
            units = GM.ins.bl.units;
            for(i = 0; i < units.length; i++)
            {
               distance = CF.distance(new Point(_body.GetPosition().x,_body.GetPosition().y),new Point(units[i].body.GetPosition().x,units[i].body.GetPosition().y)) * Constants.SCALE;
               if(distance < 80)
               {
                  pow = 0.08;
                  rot = Math.atan2(-_body.GetPosition().y + units[i].body.GetPosition().y,-_body.GetPosition().x + units[i].body.GetPosition().x);
                  _body.SetPosition(new b2Vec2(_body.GetPosition().x + pow * Math.cos(rot),_body.GetPosition().y + pow * Math.sin(rot)));
               }
            }
         }
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Unit)
         {
            this.collect();
         }
      }
      
      public function get isCollected() : Boolean
      {
         return this._isCollected;
      }
   }
}
