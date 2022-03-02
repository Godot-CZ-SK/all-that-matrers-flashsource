package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_PistonDoorData;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   
   public class P_PistonDoor extends Particle
   {
      
      public static const MAIN:String = "piston_door_main";
      
      public static const SLIDER:String = "piston_door_slider";
       
      
      protected var _isOpened:Boolean;
      
      protected var _data:DO_PistonDoorData;
      
      protected var _sliderBody:b2Body;
      
      protected var _speed:Number;
      
      public function P_PistonDoor(layerNo:int, data:DO_PistonDoorData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var sdef:b2BodyDef = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bdef:b2BodyDef = new b2BodyDef();
         bdef.type = b2Body.b2_staticBody;
         bdef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         sdef = new b2BodyDef();
         sdef.type = b2Body.b2_kinematicBody;
         sdef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         _body.SetAngle(this._data.rotation / 180 * Math.PI);
         this._sliderBody = PM.ins.world.CreateBody(sdef);
         this._sliderBody.SetUserData(this);
         this._sliderBody.SetAngle(this._data.rotation / 180 * Math.PI);
         var mainShape:b2PolygonShape = new b2PolygonShape();
         mainShape.SetAsOrientedBox(this._data.MAIN_WIDTH * this._data.scale / Constants.SCALE / 2,this._data.MAIN_HEIGHT * this._data.scale / Constants.SCALE / 2,new b2Vec2(0,-25 * this._data.scale / Constants.SCALE));
         var mainFix:b2Fixture = _body.CreateFixture2(mainShape,1);
         mainFix.SetUserData(MAIN);
         var sliderShape:b2PolygonShape = new b2PolygonShape();
         sliderShape.SetAsOrientedBox(this._data.SLIDER_WIDTH * this._data.scale / 2 / Constants.SCALE,this._data.SLIDER_HEIGHT * this._data.scale / 2 / Constants.SCALE,new b2Vec2(0,30 * this._data.scale / Constants.SCALE));
         var sliderFix:b2Fixture = this._sliderBody.CreateFixture2(sliderShape,1);
         sliderFix.SetUserData(SLIDER);
         _costume = new MC_PistonDoor();
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation;
         GameCamera.ins.addChildTo(_costume,_layerNo);
         this._speed = 0.8 / Constants.SCALE;
      }
      
      override public function update() : void
      {
         var rot:Number = NaN;
         var dist:Number = NaN;
         var dest:b2Vec2 = null;
         var pos:b2Vec2 = null;
         var sub:b2Vec2 = null;
         var vel:b2Vec2 = null;
         var newPos:b2Vec2 = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._isOpened)
         {
            rot = this._data.rotation / 180 * Math.PI - Math.PI / 2;
            dist = 55 * this._data.scale / Constants.SCALE;
            dest = new b2Vec2(_body.GetPosition().x + Math.cos(rot) * dist,_body.GetPosition().y + Math.sin(rot) * dist);
            pos = this._sliderBody.GetPosition();
            sub = dest.Copy();
            sub.Subtract(pos);
            vel = dest.Copy();
            vel.Subtract(pos);
            vel.Normalize();
            vel.Multiply(this._speed);
            newPos = pos.Copy();
            newPos.Add(vel);
         }
         else
         {
            rot = this._data.rotation / 180 * Math.PI + Math.PI / 2;
            dest = _body.GetPosition();
            pos = this._sliderBody.GetPosition();
            sub = dest.Copy();
            sub.Subtract(pos);
            vel = dest.Copy();
            vel.Subtract(pos);
            vel.Normalize();
            vel.Multiply(this._speed);
            newPos = pos.Copy();
            newPos.Add(vel);
         }
         if(sub.LengthSquared() > vel.LengthSquared() * 2)
         {
            this._sliderBody.SetPosition(newPos);
         }
         else
         {
            this._sliderBody.SetPosition(dest);
         }
         var dif:b2Vec2 = pos.Copy();
         dif.Subtract(_body.GetPosition());
         (_costume as MC_PistonDoor).mc_slide.y = -dif.Length() / this._data.scale * Constants.SCALE + 30;
      }
      
      public function open() : void
      {
         if(this._isOpened)
         {
            return;
         }
         this._isOpened = true;
      }
      
      public function close() : void
      {
         if(!this._isOpened)
         {
            return;
         }
         this._isOpened = false;
         SM.ins.playSound(GameSound.PISTON_CLOSE);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         PM.ins.world.DestroyBody(this._sliderBody);
         this._sliderBody = null;
      }
      
      public function get data() : DO_PistonDoorData
      {
         return this._data;
      }
      
      public function get isOpened() : Boolean
      {
         return this._isOpened;
      }
   }
}
