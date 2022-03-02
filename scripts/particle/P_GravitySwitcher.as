package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_GravitySwitcherData;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_GravitySwitcher extends Particle
   {
      
      public static const MAIN:String = "button_main";
       
      
      protected var _data:DO_GravitySwitcherData;
      
      protected var _isActivated:Boolean;
      
      public function P_GravitySwitcher(layerNo:int, data:DO_GravitySwitcherData)
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
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsBox(this._data.WIDTH * this._data.scale / 2 / Constants.SCALE,this._data.HEIGHT * this._data.scale / 2 / Constants.SCALE);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         fix1.SetSensor(true);
         _costume = new MC_GravitySwitcher();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation * 180 / Math.PI;
         if(this._data.isSensor)
         {
            _costume.gotoAndStop("s_closed");
         }
         if(!this._data.hasFoot)
         {
            (_costume as MC_GravitySwitcher).mc_bottom.visible = false;
         }
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Unit)
         {
            if(this.isSensor && !this.isActivated)
            {
               GM.ins.cl.changeGravity(this._data.rotation + Math.PI);
               SM.ins.playSound(GameSound.GRAVITY_SWITCHED);
            }
         }
      }
      
      public function get data() : DO_GravitySwitcherData
      {
         return this._data;
      }
      
      public function activate() : void
      {
         if(this._isActivated)
         {
            return;
         }
         this._isActivated = true;
         if(this._data.isSensor)
         {
            _costume.gotoAndStop("s_opened");
         }
         else
         {
            _costume.gotoAndStop("opened");
         }
      }
      
      public function deactivate() : void
      {
         if(!this._isActivated)
         {
            return;
         }
         this._isActivated = false;
         if(this._data.isSensor)
         {
            _costume.gotoAndStop("s_closed");
         }
         else
         {
            _costume.gotoAndStop("closed");
         }
      }
      
      public function get isSensor() : Boolean
      {
         return this._data.isSensor;
      }
      
      public function get rotation() : Number
      {
         return this._data.rotation;
      }
      
      public function get isActivated() : Boolean
      {
         return this._isActivated;
      }
   }
}
