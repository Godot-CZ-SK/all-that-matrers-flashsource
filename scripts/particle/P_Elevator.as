package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_ElevatorData;
   import design.data.DO_PolyData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import geom.Polygon;
   import managers.PM;
   import managers.SM;
   
   public class P_Elevator extends Particle
   {
      
      public static const MAIN:String = "elevator_main";
      
      public static const SENSOR:String = "elevator_sensor";
       
      
      protected var _lineSprite:Sprite;
      
      protected var _data:DO_ElevatorData;
      
      protected var _currentPos:Number;
      
      protected var _destination:int;
      
      protected var _dir:int;
      
      protected var _isActivated:Boolean;
      
      public function P_Elevator(layerNo:int, data:DO_ElevatorData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(1,0.25,0.1);
      }
      
      override public function create() : void
      {
         var i:int = 0;
         var poly:b2PolygonShape = null;
         var vec:Vector.<b2Vec2> = null;
         var fix:b2Fixture = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._dir = 0;
         this._isActivated = false;
         this._destination = 2;
         this._currentPos = this._data.pos1;
         var bDef:b2BodyDef = new b2BodyDef();
         bDef.position = new b2Vec2(this._data.x / Constants.SCALE,(this._data.y + this._data.pos1) / Constants.SCALE);
         bDef.type = b2Body.b2_kinematicBody;
         _body = PM.ins.world.CreateBody(bDef);
         _body.SetUserData(this);
         var pData:DO_PolyData = new DO_PolyData();
         pData.vertices.push(new Point(-50,-60),new Point(50,-60),new Point(50,60),new Point(-50,60),new Point(-50,55),new Point(45,55),new Point(45,-55),new Point(-45,-55),new Point(-45,-40),new Point(-50,-40));
         var polygons:Vector.<Polygon> = pData.getPolygons();
         for(i = 0; i < polygons.length; i++)
         {
            poly = new b2PolygonShape();
            vec = this.convertPointsToVec2(polygons[i].x,polygons[i].y,0,0,this._data.scale);
            poly.SetAsVector(vec,vec.length);
            fix = _body.CreateFixture2(poly,2.5);
            fix.SetUserData(MAIN);
            fix.SetRestitution(_restitution);
            fix.SetFriction(_friction);
         }
         var sShape:b2PolygonShape = new b2PolygonShape();
         sShape.SetAsOrientedBox(5 / Constants.SCALE,20 / Constants.SCALE,new b2Vec2(33 / Constants.SCALE,30 / Constants.SCALE));
         var sFix:b2Fixture = _body.CreateFixture2(sShape,1);
         sFix.SetSensor(true);
         sFix.SetUserData(SENSOR);
         this._lineSprite = new Sprite();
         this._lineSprite.graphics.clear();
         _costume = new MC_Elevator();
         GameCamera.ins.addChildTo(this._lineSprite,_layerNo);
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         (_costume as MC_Elevator).mc_elevator.y = this._data.pos1;
      }
      
      public function activate() : void
      {
         if(this._isActivated)
         {
            if(this._destination == 2)
            {
               this._destination = 1;
            }
            else
            {
               this._destination = 2;
            }
         }
         SM.ins.playSound(GameSound.ELEVATOR_START);
         this._isActivated = true;
         if(this._destination == 2)
         {
            if(this._data.pos2 - this._data.pos1 > 0)
            {
               this._dir = 1;
            }
            else
            {
               this._dir = -1;
            }
         }
         else if(this._destination == 1)
         {
            if(this._data.pos1 - this._data.pos2 > 0)
            {
               this._dir = 1;
            }
            else
            {
               this._dir = -1;
            }
         }
         (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_down.gotoAndStop("disabled");
         (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_up.gotoAndStop("disabled");
         if(this._dir < 0)
         {
            (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_up.gotoAndStop("moving");
         }
         if(this._dir > 0)
         {
            (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_down.gotoAndStop("moving");
         }
      }
      
      public function reached() : void
      {
         if(!this._isActivated)
         {
            return;
         }
         this._isActivated = false;
         (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_down.gotoAndStop("disabled");
         (_costume as MC_Elevator).mc_elevator.mc_buttons.btn_up.gotoAndStop("disabled");
         _body.SetLinearVelocity(new b2Vec2(0,0));
         if(this._destination == 1)
         {
            _body.SetPosition(new b2Vec2(this._data.x / Constants.SCALE,(this._data.y + this._data.pos1) / Constants.SCALE));
            this._currentPos = this._data.pos1;
            this._destination = 2;
         }
         else
         {
            _body.SetPosition(new b2Vec2(this._data.x / Constants.SCALE,(this._data.y + this._data.pos2) / Constants.SCALE));
            this._currentPos = this._data.pos2;
            this._destination = 1;
         }
         SM.ins.playSound(GameSound.ELEVATOR_STOP);
      }
      
      override public function update() : void
      {
         var speed:Number = NaN;
         var destPos:Number = NaN;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(this._isActivated)
         {
            speed = this._dir * this._data.speed;
            destPos = this._data.pos2;
            if(this._destination == 1)
            {
               destPos = this._data.pos1;
            }
            if(this._dir > 0 && this._currentPos >= destPos)
            {
               this.reached();
            }
            else if(this._dir < 0 && this._currentPos <= destPos)
            {
               this.reached();
            }
            else
            {
               _body.SetLinearVelocity(new b2Vec2(0,speed));
            }
         }
         this._currentPos = _body.GetPosition().y * Constants.SCALE - this._data.y;
         (_costume as MC_Elevator).mc_elevator.y = this._currentPos;
         var total:Number = 75 + Math.max(this._data.pos1,this._data.pos2);
         var l1:Number = 15 + this._currentPos;
         var l2:Number = (total - l1) / 2;
         var start:Number = this._data.y - 85;
         this._lineSprite.graphics.clear();
         this._lineSprite.graphics.lineStyle(4,666666,1);
         this._lineSprite.graphics.moveTo(this._data.x,start);
         this._lineSprite.graphics.lineTo(this._data.x,start + l1);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start);
         this._lineSprite.graphics.lineTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x + 25,start);
         this._lineSprite.graphics.lineTo(this._data.x + 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.curveTo(this._data.x - 25,start + l2 + 15,this._data.x,start + l2 + 15);
         this._lineSprite.graphics.moveTo(this._data.x,start + l2 + 15);
         this._lineSprite.graphics.curveTo(this._data.x + 25,start + l2 + 15,this._data.x + 25,start + l2);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
      }
      
      private function convertPointsToVec2(xArr:Array, yArr:Array, xOff:Number, yOff:Number, scale:Number) : Vector.<b2Vec2>
      {
         var vec:b2Vec2 = null;
         var result:Vector.<b2Vec2> = new Vector.<b2Vec2>();
         for(var i:int = 0; i < xArr.length; i++)
         {
            vec = new b2Vec2((xArr[i] + xOff) * scale / Constants.SCALE,(yArr[i] + yOff) * scale / Constants.SCALE);
            result.push(vec);
         }
         return result;
      }
   }
}
