package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_SlideDoorData;
   import game.GameCamera;
   import managers.PM;
   
   public class P_SlideDoor extends Particle
   {
      
      public static const MAIN:String = "slide_door_main";
       
      
      protected var _isOpened:Boolean;
      
      protected var _data:DO_SlideDoorData;
      
      protected var _speed:Number;
      
      public function P_SlideDoor(layerNo:int, data:DO_SlideDoorData)
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
         this._speed = 0.5;
         var bdef:b2BodyDef = new b2BodyDef();
         bdef.type = b2Body.b2_staticBody;
         bdef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsBox(this._data.WIDTH * this._data.scale / 2 / Constants.SCALE,this._data.HEIGHT * this._data.scale / 2 / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         _costume = new MC_SlideDoor();
         _costume.x = Math.round(this._data.x);
         _costume.y = Math.round(this._data.y);
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         GameCamera.ins.addChildTo(_costume,_layerNo);
      }
      
      override public function update() : void
      {
         var ypos:Number = NaN;
         if(!_isCreated)
         {
            return;
         }
         if(this._isOpened)
         {
            ypos = _body.GetPosition().y * Constants.SCALE;
            if(ypos > this._data.y - 80)
            {
               ypos = Math.max(this._data.y - 80,ypos - this._speed);
               _body.SetPosition(new b2Vec2(_body.GetPosition().x,ypos / Constants.SCALE));
               (_costume as MC_SlideDoor).mc_door.y = -this._data.y + ypos;
               (_costume as MC_SlideDoor).mc_wheel.y = -this._data.y + ypos;
               (_costume as MC_SlideDoor).mc_wheel.rotation -= this._speed * 5;
            }
         }
      }
      
      public function open() : void
      {
         if(this._isOpened)
         {
            return;
         }
         this._isOpened = true;
      }
      
      public function get data() : DO_SlideDoorData
      {
         return this._data;
      }
      
      public function get isOpened() : Boolean
      {
         return this._isOpened;
      }
   }
}
