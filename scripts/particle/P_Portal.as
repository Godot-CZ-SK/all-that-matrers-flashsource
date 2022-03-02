package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_BubbleData;
   import design.data.DO_PortalData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Portal extends Particle
   {
      
      public static const MAIN:String = "portal_main";
      
      public static const CORE:String = "portal_core";
       
      
      protected var _data:DO_PortalData;
      
      protected var _isOpened:Boolean;
      
      protected var _bubbles:Array;
      
      protected var _effectSprite:Sprite;
      
      public function P_Portal(layerNo:int, data:DO_PortalData)
      {
         this._bubbles = [];
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
         var main_shape:b2CircleShape = new b2CircleShape(this._data.radius * 1.5 / Constants.SCALE);
         var main_fix:b2Fixture = _body.CreateFixture2(main_shape,this._data.density);
         main_fix.SetUserData(MAIN);
         main_fix.SetSensor(true);
         var core_shape:b2CircleShape = new b2CircleShape(this._data.radius / 8 / Constants.SCALE);
         var core_fix:b2Fixture = _body.CreateFixture2(core_shape,this._data.density);
         core_fix.SetUserData(CORE);
         core_fix.SetSensor(true);
         _costume = new MC_Portal();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         var scale:Number = this._data.radius * 2 / this._data.SIZE;
         _costume.scaleX = scale;
         _costume.scaleY = scale;
         this.openPortal();
         this._effectSprite = new Sprite();
         GameCamera.ins.addChildTo(this._effectSprite,GameCamera.PORTAL_EFFECT);
      }
      
      public function openPortal() : void
      {
         if(!_isCreated || this._isOpened)
         {
            return;
         }
         this._isOpened = true;
         _costume.gotoAndPlay("open");
      }
      
      public function closePortal() : void
      {
         if(!_isCreated || !this._isOpened)
         {
            return;
         }
         this._isOpened = false;
         _costume.gotoAndPlay("close");
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(_costume);
         PM.ins.world.DestroyBody(_body);
         this._bubbles = [];
         super.remove();
      }
      
      override public function update() : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var radius:Number = NaN;
         var alpha:Number = NaN;
         var speed:Point = null;
         var bd:DO_BubbleData = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         if(this._isOpened && _step % 3 == 0)
         {
            this.addEffect();
         }
         this._effectSprite.graphics.clear();
         for(var i:int = this._bubbles.length - 1; i > 0; i--)
         {
            speed = new Point();
            bd = this._bubbles[i];
            ++bd.current;
            if(bd.current >= bd.time)
            {
               this._bubbles.splice(i,1)[0] = null;
            }
            else
            {
               speed.x = bd.speed * Math.cos(bd.angle);
               speed.y = bd.speed * Math.sin(bd.angle);
               x = bd.startX + speed.x * bd.current;
               y = bd.startY + speed.y * bd.current;
               radius = bd.radius * (1 - bd.current / bd.time);
               alpha = 0.7 - 0.7 * bd.current / bd.time;
               this._effectSprite.graphics.beginFill(16777215,alpha);
               this._effectSprite.graphics.drawCircle(x,y,radius);
               this._effectSprite.graphics.endFill();
            }
         }
      }
      
      private function addEffect() : void
      {
         var bubbleData:DO_BubbleData = new DO_BubbleData();
         var angle:Number = Math.random() * Math.PI * 2;
         var distance:Number = (Math.random() * 1 + 0.7) * this._data.radius;
         bubbleData.startX = _costume.x - distance * Math.cos(angle);
         bubbleData.startY = _costume.y - distance * Math.sin(angle);
         bubbleData.angle = angle;
         bubbleData.time = 20 + Math.random() * 20;
         bubbleData.speed = distance / bubbleData.time;
         bubbleData.current = 0;
         bubbleData.radius = (2 + 2.5 * Math.random()) * this._data.radius / this._data.SIZE;
         this._bubbles.push(bubbleData);
      }
      
      public function get isOpened() : Boolean
      {
         return this._isOpened;
      }
   }
}
