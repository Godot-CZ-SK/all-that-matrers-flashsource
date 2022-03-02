package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_LadderData;
   import flash.display.MovieClip;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Ladder extends Particle
   {
      
      public static const MAIN:String = "main_ladder";
       
      
      protected var _data:DO_LadderData;
      
      public function P_Ladder(layerNo:int, data:DO_LadderData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var part:MovieClip = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_staticBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var w:Number = this._data.WIDTH * this._data.scale;
         var h:Number = this._data.HEIGHT * (this._data.count + 2) * this._data.scale - this._data.HEIGHT * 0.5 * this._data.scale;
         var offsetY:Number = (h + this._data.HEIGHT * 0.25 * this._data.scale) * 0.5 / Constants.SCALE;
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsOrientedBox(w / 6 / Constants.SCALE,h / 2 / Constants.SCALE,new b2Vec2(w / 2 / Constants.SCALE,offsetY));
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         fix.SetFriction(0);
         fix.SetSensor(true);
         _costume = new MovieClip();
         for(var i:int = 0; i < this._data.count + 2; i++)
         {
            if(i == 0)
            {
               part = new MC_LadderTop();
            }
            else if(i < this._data.count + 1)
            {
               part = new MC_LadderMid();
            }
            else
            {
               part = new MC_LadderBot();
            }
            part.y = i * this._data.HEIGHT;
            part.scaleY = 1.05;
            part.scaleX = 1.05;
            _costume.addChild(part);
         }
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
      }
   }
}
