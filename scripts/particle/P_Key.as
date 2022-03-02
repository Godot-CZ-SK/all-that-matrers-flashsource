package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_KeyData;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Key extends Particle
   {
      
      public static const MAIN:String = "key_main";
       
      
      protected var _data:DO_KeyData;
      
      public function P_Key(layerNo:int, data:DO_KeyData)
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
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsBox(this._data.scale * this._data.SIZE_X / 2 / Constants.SCALE,this._data.scale * this._data.SIZE_Y / 2 / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         fix.SetSensor(true);
         _costume = new MC_DO_Key();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.rotation += 5;
      }
   }
}
