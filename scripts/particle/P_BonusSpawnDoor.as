package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import flash.filters.ConvolutionFilter;
   import game.GameCamera;
   import managers.PM;
   
   public class P_BonusSpawnDoor extends Particle
   {
      
      public static const MAIN:String = "spawn_door_main";
       
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      protected var _rotation:Number;
      
      public function P_BonusSpawnDoor(layerNo:int, x:Number, y:Number, rot:Number)
      {
         this._x = x;
         this._y = y;
         this._rotation = rot;
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
         bdef.position = new b2Vec2(this._x / Constants.SCALE,this._y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsOrientedBox(15 / Constants.SCALE,75 / Constants.SCALE,new b2Vec2(),this._rotation * Math.PI / 180);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         _costume = new MC_SpawnDoor();
         _costume.x = this._x;
         _costume.y = this._y;
         _costume.rotation = this._rotation;
         GameCamera.ins.addChildTo(_costume,_layerNo);
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.3,0,-0.3,1,0.3,0,0.3,0],1.2);
      }
   }
}
