package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_DoorData;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Door extends Particle
   {
      
      public static const MAIN:String = "door_main";
       
      
      protected var _isOpened:Boolean;
      
      protected var _data:DO_DoorData;
      
      public function P_Door(layerNo:int, data:DO_DoorData)
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
         var bdef:b2BodyDef = new b2BodyDef();
         bdef.type = b2Body.b2_staticBody;
         bdef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsBox(this._data.SIZE_X * this._data.scale / 2 / Constants.SCALE,this._data.SIZE_Y * this._data.scale / 2 / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         _costume = new MC_Door();
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         GameCamera.ins.addChildTo(_costume,_layerNo);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
      }
      
      public function open() : void
      {
         if(this._isOpened)
         {
            return;
         }
         this._isOpened = true;
         _costume.gotoAndPlay("open");
         _body.GetFixtureList().SetSensor(true);
      }
      
      public function get data() : DO_DoorData
      {
         return this._data;
      }
      
      public function get isOpened() : Boolean
      {
         return this._isOpened;
      }
   }
}
