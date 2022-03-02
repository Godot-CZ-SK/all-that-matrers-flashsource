package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_TrapData;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Trap extends Particle
   {
      
      public static const MAIN:String = "trap_main";
       
      
      protected var _data:DO_TrapData;
      
      public function P_Trap(layerNo:int, data:DO_TrapData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var part:MovieClip = null;
         var cur:int = 0;
         var cName:String = null;
         var cl:Class = null;
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
         var hw:Number = this._data.WIDTH * this._data.count * this._data.scale / 2 / Constants.SCALE;
         var hh:Number = this._data.HEIGHT * this._data.scale / 4 / Constants.SCALE;
         shape.SetAsOrientedBox(hw,hh,new b2Vec2(hw,0));
         var fix:b2Fixture = _body.CreateFixture2(shape,this._data.density);
         fix.SetUserData(MAIN);
         fix.SetSensor(true);
         _body.SetAngle(this._data.rotation * Math.PI / 180);
         _costume = new MovieClip();
         for(var i:int = 0; i < this._data.count; i++)
         {
            if(this._data.trapType == DO_TrapData.FIRE)
            {
               part = new MC_FireTrap();
            }
            else if(this._data.trapType == DO_TrapData.SPIKE)
            {
               cur = i % 4 + 1;
               cName = "MC_SpikeTrap" + cur.toString();
               cl = getDefinitionByName(cName) as Class;
               part = new cl() as MovieClip;
            }
            part.scaleX = this._data.scale;
            part.scaleY = this._data.scale * 1.05;
            part.x = this._data.WIDTH / 2 + i * this._data.WIDTH * this._data.scale;
            part.y = 1 * this._data.scale;
            _costume.addChild(part);
         }
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.rotation = this._data.rotation;
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(_costume);
         PM.ins.world.DestroyBody(_body);
         super.remove();
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
      }
      
      public function get data() : DO_TrapData
      {
         return this._data;
      }
   }
}
