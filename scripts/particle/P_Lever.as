package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_LeverData;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   
   public class P_Lever extends Particle
   {
      
      public static const MAIN:String = "lever_main";
       
      
      protected var _data:DO_LeverData;
      
      protected var _isPulled:Boolean;
      
      public function P_Lever(layerNo:int, data:DO_LeverData)
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
         var s1:b2CircleShape = new b2CircleShape(this._data.SIZE * this._data.scale / Constants.SCALE / 2);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         fix1.SetSensor(true);
         _costume = new MC_Lever();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         if(this._data.pulled == 0)
         {
            _costume.gotoAndStop("unpulled");
         }
         else
         {
            _costume.gotoAndStop("pulled");
         }
      }
      
      public function pull() : void
      {
         if(this._isPulled)
         {
            return;
         }
         this._isPulled = true;
         _costume.gotoAndPlay("pull");
         SM.ins.playSound(GameSound.LEVER_PULLED);
      }
      
      public function unpull() : void
      {
         if(!this._isPulled)
         {
            return;
         }
         this._isPulled = false;
         _costume.gotoAndPlay("unpull");
         SM.ins.playSound(GameSound.LEVER_PULLED);
      }
      
      public function get data() : DO_LeverData
      {
         return this._data;
      }
      
      public function get isPulled() : Boolean
      {
         return this._isPulled;
      }
   }
}
