package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_HeartData;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.GameCamera;
   import game.GameSound;
   import managers.DM;
   import managers.GM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.units.P_Unit;
   
   public class P_Heart extends Particle
   {
      
      public static const MAIN:String = "coin_main";
       
      
      protected var _data:DO_HeartData;
      
      protected var _isCollected:Boolean;
      
      protected var _scale:Number;
      
      protected var _textField:TextField;
      
      protected var _textFormat:TextFormat;
      
      public function P_Heart(layerNo:int, data:DO_HeartData)
      {
         this._data = data;
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
         _costume.scaleX = this._scale;
         _costume.scaleY = this._scale;
         (_costume as MC_DO_Heart).mc_heartMask.visible = false;
         if(this._data.time > 0)
         {
            this.setTimer(this._data.time * Constants.FRAME_RATE);
            this._textField = new TextField();
            _costume.addChild(this._textField);
            this._textFormat = new TextFormat("calibri",12,16777215,true,null,null,null,null,TextFormatAlign.CENTER);
            this._textField.width = 40;
            this._textField.height = 20;
            this._textField.filters = [new GlowFilter(5570560,1,4,4,5,1)];
            this._textField.x = -20;
            this._textField.y = -10;
            this._textField.defaultTextFormat = this._textFormat;
            this._textField.embedFonts = true;
            this._textField.selectable = false;
            this._textField.wordWrap = true;
            this._textField.multiline = true;
         }
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         CF.removeDisplayObject(this._textField);
         this._textFormat = null;
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
         GM.ins.cl.collectHeart();
         if(!GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
         {
            LM.ins.cp.addHeartsCollected();
         }
         safeRemove();
         SM.ins.playSound(GameSound.HEART_COLLECT);
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
         var ss:int = _step % 30;
         if(ss < 13)
         {
            _costume.scaleX = this._scale * (1 + ss * ss / 800);
            _costume.scaleY = this._scale * (1 + ss * ss / 800);
         }
         else if(ss < 26)
         {
            _costume.scaleX = this._scale * (1 + (26 - ss) * 13 / 800);
            _costume.scaleY = this._scale * (1 + (26 - ss) * 13 / 800);
         }
         else
         {
            _costume.scaleX = this._scale;
            _costume.scaleY = this._scale;
         }
         if(_maxLifeTime > 0)
         {
            this._textField.text = int(_lifeTime / 30).toString();
            (_costume as MC_DO_Heart).mc_heartMask.y = 20 * (1 - _lifeTime / _maxLifeTime) - 20;
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
