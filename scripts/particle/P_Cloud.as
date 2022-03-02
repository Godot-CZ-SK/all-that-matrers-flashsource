package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_CloudData;
   import flash.display.MovieClip;
   import flash.filters.ConvolutionFilter;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Cloud extends Particle
   {
      
      public static const MAIN:String = "cloud_main";
       
      
      protected var _data:DO_CloudData;
      
      public function P_Cloud(layerNo:int, data:DO_CloudData)
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
         bdef.position = new b2Vec2((this._data.x + this._data.width / 2) / Constants.SCALE,(this._data.y + this._data.height / 2) / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsBox(this._data.width / 2 / Constants.SCALE,this._data.height / 2 / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         _costume = new MovieClip();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.graphics.clear();
         _costume.graphics.lineStyle(2,2497557);
         _costume.graphics.beginFill(5521966,1);
         _costume.graphics.moveTo(this._data.x,this._data.y);
         _costume.graphics.lineTo(this._data.x + this._data.width,this._data.y);
         _costume.graphics.lineTo(this._data.x + this._data.width,this._data.y + this._data.height);
         _costume.graphics.lineTo(this._data.x,this._data.y + this._data.height);
         _costume.graphics.lineTo(this._data.x,this._data.y);
         _costume.graphics.endFill();
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-2,0,-2,1,2,0,2,0],1);
         _costume.filters = [cf];
      }
      
      public function get data() : DO_CloudData
      {
         return this._data;
      }
   }
}
