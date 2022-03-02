package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_Path;
   import design.data.DO_PlatformData;
   import flash.display.MovieClip;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.PM;
   
   public class P_BonusPlatform extends Particle
   {
      
      public static const MAIN:String = "main";
      
      public static const STICKY:String = "sticky";
       
      
      protected var _data:DO_PlatformData;
      
      protected var _isReturning:Boolean;
      
      protected var _pathNum:int;
      
      public function P_BonusPlatform(layerNo:int, data:DO_PlatformData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var mid:MC_PlatformMid = null;
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
         var w:Number = this._data.WIDTH * (this._data.count + 2) * this._data.scale;
         var h:Number = this._data.HEIGHT * this._data.scale;
         var sw:Number = this._data.WIDTH * (this._data.count + 1.5) * this._data.scale;
         var sh:Number = this._data.HEIGHT * this._data.scale / 8;
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsOrientedBox(w / 2 / Constants.SCALE,h / 2 / Constants.SCALE,new b2Vec2(w / 2 / Constants.SCALE,h / 2 / Constants.SCALE));
         var fix:b2Fixture = _body.CreateFixture2(shape,this._data.density);
         fix.SetUserData(MAIN);
         fix.SetFriction(0);
         var shape2:b2PolygonShape = new b2PolygonShape();
         shape2.SetAsOrientedBox(sw / 2 / Constants.SCALE,sh / 2 / Constants.SCALE,new b2Vec2(w / 2 / Constants.SCALE,-sh / 2 / Constants.SCALE));
         var fix2:b2Fixture = _body.CreateFixture2(shape2);
         fix2.SetUserData(STICKY);
         fix2.SetFriction(100);
         fix2.SetSensor(true);
         _costume = new MovieClip();
         var first:MC_PlatformStart = new MC_PlatformStart();
         first.x = this._data.WIDTH / 2;
         first.y = this._data.HEIGHT / 2;
         _costume.addChild(first);
         for(var i:int = 0; i < this._data.count; i++)
         {
            mid = new MC_PlatformMid();
            _costume.addChild(mid);
            mid.x = this._data.WIDTH * (i + 1.5);
            mid.y = this._data.HEIGHT / 2;
         }
         var last:MC_PlatformStart = new MC_PlatformStart();
         _costume.addChild(last);
         last.x = this._data.WIDTH * (this._data.count + 1.5);
         last.y = this._data.HEIGHT / 2;
         last.scaleX = -1;
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.5,0,-0.5,1,0.5,0,0.5,0],1);
         _costume.filters = [cf];
         this._pathNum = -1;
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
            _body.SetLinearVelocity(new b2Vec2(0,0));
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
            _body.SetLinearVelocity(new b2Vec2(dir.x,dir.y));
         }
         if(current.y < -50)
         {
            safeRemove();
         }
      }
   }
}
