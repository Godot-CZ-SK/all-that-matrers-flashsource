package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_CannonBallData;
   import design.data.DO_CannonData;
   import design.data.DO_RotationMap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Cannon extends Particle
   {
      
      public static const MAIN:String = "cannon_main";
       
      
      protected var _ballLayerNo:int;
      
      protected var _cooldown:int;
      
      protected var _counter:int;
      
      protected var _rotIndex:int;
      
      protected var _destAngle:Number;
      
      protected var _data:DO_CannonData;
      
      protected var _isReturning:Boolean;
      
      protected var _isActivated:Boolean;
      
      public function P_Cannon(layerNo:int, ballLayerNo:int, data:DO_CannonData)
      {
         this._ballLayerNo = ballLayerNo;
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
         this._isActivated = true;
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_kinematicBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         var ws1:Number = 60 * this._data.scale / Constants.SCALE / 2;
         var hs1:Number = 34 * this._data.scale / Constants.SCALE / 2;
         var xs1:Number = -6 * this._data.scale / Constants.SCALE + ws1;
         var ys1:Number = -18 * this._data.scale / Constants.SCALE + hs1;
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsOrientedBox(ws1,hs1,new b2Vec2(xs1,ys1));
         var rs2:Number = 40 * this._data.scale / Constants.SCALE / 2;
         var s2:b2CircleShape = new b2CircleShape(rs2);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         var fix2:b2Fixture = _body.CreateFixture2(s2,1);
         fix1.SetUserData(MAIN);
         fix2.SetUserData(MAIN);
         var fd:b2FilterData = new b2FilterData();
         fd.categoryBits = 8;
         fix1.SetFilterData(fd);
         fix2.SetFilterData(fd);
         _costume = new MC_Cannon();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         (_costume as MC_Cannon).mc_body.mc_fitil.stop();
         this._cooldown = this._data.speed / Constants.DT;
         this._counter = 0;
         this._rotIndex = -1;
         this.setRotation(_costume,this._data.rotation);
         _body.SetAngle(this._data.rotation);
      }
      
      override public function update() : void
      {
         var nextIndex:int = 0;
         var lastAngle:Number = NaN;
         var angle:Number = NaN;
         var percent:Number = NaN;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(!this._isActivated)
         {
            return;
         }
         ++this._counter;
         if(this._rotIndex == 0 && this._data.map.angles.length == 1)
         {
            nextIndex = 0;
         }
         else if(this._data.map.style == DO_RotationMap.CIRCULAR)
         {
            nextIndex = (this._rotIndex + 1) % this._data.map.angles.length;
         }
         else if(this._data.map.style == DO_RotationMap.LINE)
         {
            if(this._isReturning)
            {
               nextIndex = this._rotIndex - 1;
            }
            else
            {
               nextIndex = this._rotIndex + 1;
            }
         }
         this._destAngle = this._data.map.angles[nextIndex];
         if(this._rotIndex == -1)
         {
            lastAngle = this._data.rotation;
         }
         else
         {
            lastAngle = this._data.map.angles[this._rotIndex];
         }
         if(this._counter >= 0 && this._counter < this._cooldown / 4)
         {
            percent = this._counter / (this._cooldown / 4);
            angle = lastAngle + percent * (this._destAngle - lastAngle);
            this.setRotation(_costume,angle);
            _body.SetAngle(angle);
         }
         else if(this._counter > this._cooldown / 4 && this._counter < this._cooldown / 2)
         {
            percent = (this._counter - this._cooldown / 4) / (this._cooldown / 4);
            (_costume as MC_Cannon).mc_body.mc_fitil.gotoAndStop(int(50 * percent));
         }
         else if(this._counter >= this._cooldown / 2 && this._counter < this._cooldown)
         {
            percent = (this._counter - this._cooldown / 2) / (this._cooldown / 2);
            (_costume as MC_Cannon).mc_body.mc_fitil.gotoAndStop(int(50 + 50 * percent));
         }
         else if(this._counter == this._cooldown)
         {
            this.shoot();
         }
         else if(this._counter > this._cooldown)
         {
            this._counter = 0;
            if(this._data.map.style == DO_RotationMap.LINE)
            {
               if(this._isReturning && this._rotIndex == 1)
               {
                  this._isReturning = false;
               }
               else if(!this._isReturning && this._rotIndex == this._data.map.angles.length - 2)
               {
                  this._isReturning = true;
               }
            }
            this._rotIndex = nextIndex;
         }
      }
      
      public function activate() : void
      {
         if(this._isActivated)
         {
            return;
         }
         this._isActivated = true;
      }
      
      public function deactivate() : void
      {
         if(!this._isActivated)
         {
            return;
         }
         this._isActivated = false;
         this._counter = 0;
         (_costume as MC_Cannon).mc_body.mc_fitil.gotoAndStop(0);
      }
      
      private function shoot() : void
      {
         var scale:Number = NaN;
         var topx:Number = NaN;
         var topy:Number = NaN;
         var botx:Number = NaN;
         var boty:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var type:int = 0;
         var clName:String = null;
         var cl:Class = null;
         var mc:MovieClip = null;
         var cballdata:DO_CannonBallData = new DO_CannonBallData();
         cballdata.x = this._data.x + 22 * this._data.scale * Math.cos(this._destAngle);
         cballdata.y = this._data.y + 2.5 * this._data.scale + 22 * this._data.scale * Math.sin(this._destAngle);
         cballdata.scale = this._data.scale + 0.15;
         cballdata.angle = this._destAngle;
         cballdata.speed = 3.5;
         var cball:P_CannonBall = new P_CannonBall(GameCamera.CANNON_BALL,cballdata,this);
         cball.create();
         for(var i:int = 0; i < 7; i++)
         {
            scale = Math.random() * 0.6 + 0.8;
            topx = 55 * Math.cos(this._destAngle - Math.PI / 9);
            topy = 55 * Math.sin(this._destAngle - Math.PI / 9);
            botx = topx + 50 * Math.cos(Math.PI / 2 + this._destAngle);
            boty = topy + 50 * Math.sin(Math.PI / 2 + this._destAngle);
            x = topx + (botx - topx) * Math.random();
            y = topy + (boty - topy) * Math.random();
            type = Math.ceil(Math.random() * 4);
            clName = "MC_CannonCloud" + type.toString();
            cl = getDefinitionByName(clName) as Class;
            mc = new cl() as MovieClip;
            mc.x = _costume.scaleX * x;
            mc.y = y;
            mc.scaleX = scale;
            mc.scaleY = scale;
            mc.alpha = 0.8;
            mc.addEventListener("end",this.removeCloudHandler,false,0,true);
            _costume.addChild(mc);
         }
      }
      
      private function setRotation(clip:MovieClip, rotation:Number) : void
      {
         rotation = rotation * 180 / Math.PI;
         var left:Boolean = false;
         if(rotation < -90)
         {
            rotation = 180 - rotation;
            left = true;
         }
         if(left)
         {
            clip.scaleX = -this._data.scale;
         }
         else
         {
            clip.scaleX = this._data.scale;
         }
         clip.mc_body.rotation = rotation;
      }
      
      private function removeCloudHandler(e:Event) : void
      {
         CF.removeDisplayObject(e.currentTarget as MovieClip);
      }
      
      public function get data() : DO_CannonData
      {
         return this._data;
      }
   }
}
