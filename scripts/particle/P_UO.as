package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_Path;
   import design.data.DO_UOData;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   
   public class P_UO extends Particle
   {
      
      public static const MAIN:String = "main";
       
      
      protected var _data:DO_UOData;
      
      protected var _isReturning:Boolean;
      
      protected var _isExploded:Boolean;
      
      protected var _pathNum:int;
      
      public function P_UO(layerNo:int, data:DO_UOData)
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
         var shape:b2CircleShape = new b2CircleShape(this._data.radius / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,this._data.density);
         fix.SetUserData(MAIN);
         if(this._data.uoType == DO_UOData.UFO)
         {
            _costume = new MC_UFO();
         }
         else if(this._data.uoType == DO_UOData.UMO)
         {
            _costume = new MC_UMO();
         }
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _costume.scaleY = this._data.radius * 2 / this._data.SIZE;
         this._pathNum = -1;
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         PM.ins.world.DestroyBody(_body);
         super.remove();
      }
      
      override public function update() : void
      {
         var destId:int = 0;
         var oldPosition:Point = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         if(this._data.path.style == DO_Path.CIRCULAR)
         {
            destId = (this._pathNum + 1) % this._data.path.waypoints.length;
         }
         else if(this._data.path.style == DO_Path.LINE)
         {
            if(this._data.path.waypoints.length == 1)
            {
               destId = 0;
            }
            else if(this._isReturning)
            {
               destId = this._pathNum - 1;
            }
            else
            {
               destId = this._pathNum + 1;
            }
         }
         if(this._pathNum == 0 && destId == 0)
         {
            return;
         }
         if(this._pathNum == -1)
         {
            oldPosition = new Point(0,0);
         }
         else
         {
            oldPosition = this._data.path.waypoints[this._pathNum].clone();
         }
         oldPosition.x += this._data.x;
         oldPosition.y += this._data.y;
         var destination:Point = this._data.path.waypoints[destId].clone();
         destination.x += this._data.x;
         destination.y += this._data.y;
         var current:Point = new Point(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
         var dir:Point = new Point(destination.x - oldPosition.x,destination.y - oldPosition.y);
         dir.normalize(this._data.speed);
         if(current.x + dir.x > destination.x && dir.x > 0 && current.y + dir.y > destination.y && dir.y > 0 || current.x + dir.x < destination.x && dir.x < 0 && current.y + dir.y > destination.y && dir.y > 0 || current.x + dir.x > destination.x && dir.x > 0 && current.y + dir.y < destination.y && dir.y < 0 || current.x + dir.x < destination.x && dir.x < 0 && current.y + dir.y < destination.y && dir.y < 0 || dir.x == 0 && current.y + dir.y > destination.y && dir.y > 0 || dir.x == 0 && current.y + dir.y < destination.y && dir.y < 0 || dir.y == 0 && current.x + dir.y > destination.x && dir.x > 0 || dir.y == 0 && current.x + dir.y < destination.x && dir.x < 0 || oldPosition.x == destination.x && oldPosition.y == destination.y)
         {
            _body.SetPosition(new b2Vec2(destination.x / Constants.SCALE,destination.y / Constants.SCALE));
            this._pathNum = destId;
            if(this._data.path.style == DO_Path.LINE)
            {
               if(destId == 0)
               {
                  this._isReturning = false;
               }
               if(destId == this._data.path.waypoints.length - 1)
               {
                  this._isReturning = true;
               }
            }
         }
         else
         {
            _body.SetPosition(new b2Vec2((current.x + dir.x) / Constants.SCALE,(current.y + dir.y) / Constants.SCALE));
         }
      }
      
      public function explode() : void
      {
         if(this._isExploded)
         {
            return;
         }
         if(!GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
         {
            LM.ins.cp.addUBODeath();
         }
         SM.ins.playSound(GameSound.BOMB_EXPLODE);
      }
      
      public function get isExploded() : Boolean
      {
         return this._isExploded;
      }
   }
}
