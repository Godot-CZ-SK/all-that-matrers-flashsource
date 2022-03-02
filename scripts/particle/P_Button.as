package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_ButtonData;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_Button extends Particle
   {
      
      public static const MAIN:String = "button_main";
       
      
      protected var _data:DO_ButtonData;
      
      protected var _isPushed:Boolean;
      
      public function P_Button(layerNo:int, data:DO_ButtonData)
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
         var s1:b2CircleShape = new b2CircleShape(this._data.RADIUS * this._data.scale / Constants.SCALE);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         fix1.SetSensor(true);
         _costume = new MC_Button();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation * 180 / Math.PI;
      }
      
      public function push() : void
      {
         if(this._isPushed)
         {
            return;
         }
         this._isPushed = true;
         _costume.gotoAndStop("pushed");
         SM.ins.playSound(GameSound.BUTTON_PRESSED);
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Unit)
         {
            GM.ins.cl.pushButton();
         }
      }
      
      public function get data() : DO_ButtonData
      {
         return this._data;
      }
      
      public function get isPushed() : Boolean
      {
         return this._isPushed;
      }
   }
}
