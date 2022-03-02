package particle
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import managers.PM;
   import managers.TM;
   
   public class Particle extends EventDispatcher
   {
      
      protected static const STOP:int = 0;
      
      protected static const PLAY:int = 1;
       
      
      protected var _isCreated:Boolean;
      
      protected var _isDead:Boolean;
      
      protected var _isFading:Boolean;
      
      protected var _isReviving:Boolean;
      
      protected var _layerNo:int;
      
      protected var _costume:MovieClip;
      
      protected var _lifeTime:int;
      
      protected var _maxLifeTime:int;
      
      protected var _hitPoint:Number;
      
      protected var _hpMax:Number;
      
      protected var _density:Number;
      
      protected var _restitution:Number;
      
      protected var _friction:Number;
      
      protected var _resistance:Number;
      
      protected var _step:int;
      
      protected var _gravity:Point;
      
      protected var _currentAnimation:int;
      
      protected var _area:Rectangle;
      
      protected var _body:b2Body;
      
      public function Particle(layerNo:int)
      {
         super();
         this._layerNo = layerNo;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._gravity = new Point(0,Constants.GRAVITY);
         this._isCreated = true;
         this._hitPoint = 0;
         this._step = 0;
         PM.ins.addP(this);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         if(!this._isFading || this._isReviving)
         {
            this.removeCostume();
         }
         dispatchEvent(new Event(Event.REMOVED));
         PM.ins.world.DestroyBody(this._body);
         this._body = null;
         this._area = null;
         this._gravity = null;
      }
      
      public function removeCostume() : void
      {
         CF.removeDisplayObject(this._costume);
      }
      
      public function applyForce(x:Number, y:Number, angle:Number, impulse:Number = 1) : void
      {
         if(!this._isCreated || this._isDead)
         {
            return;
         }
         this._body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),new b2Vec2(x / Constants.SCALE,y / Constants.SCALE));
      }
      
      public function safeRemove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         PM.ins.safeRemoveP(this);
      }
      
      public function safeCreate() : void
      {
         if(this._isCreated)
         {
            return;
         }
         PM.ins.safeCreateP(this);
      }
      
      public function setCostume(c:MovieClip) : void
      {
         this._costume = c;
      }
      
      public function setBody(b:b2Body) : void
      {
         this._body = b;
      }
      
      public function setArea(area:Rectangle) : void
      {
         this._area = area;
      }
      
      public function update() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         if(this._lifeTime > 1)
         {
            --this._lifeTime;
         }
         if(this._lifeTime == 1)
         {
            PM.ins.safeRemoveP(this);
            this.fadeOutCostume();
         }
         ++this._step;
      }
      
      public function damage(val:Number) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._hitPoint = Math.max(0,this._hitPoint - val);
         if(this._hitPoint == 0)
         {
            this.die();
         }
      }
      
      public function heal(val:Number) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._hitPoint = Math.min(this._hpMax,this._hitPoint + val);
      }
      
      public function die() : void
      {
         if(!this._isCreated || this._isDead)
         {
            return;
         }
         this._isDead = true;
      }
      
      public function fadeOutCostume(time:Number = 0.5, delay:Number = 0) : void
      {
         if(this._isFading)
         {
            return;
         }
         this._isFading = true;
         TM.ins.tf(function():void
         {
            TweenLite.to(_costume,time,{"alpha":0});
         },delay);
         TM.ins.tf(function():void
         {
            removeCostume();
         },time + delay);
      }
      
      public function setPhysicParams(density:Number, friction:Number, restitution:Number) : void
      {
         this._density = density;
         this._friction = friction;
         this._restitution = restitution;
      }
      
      public function delayedSafeRemove(delay:Number) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         TM.ins.tf(function():void
         {
            if(!_isCreated)
            {
               return;
            }
            safeRemove();
         },delay);
      }
      
      public function setLifeTime(lifeTime:int) : void
      {
         this._maxLifeTime = lifeTime;
         this._lifeTime = lifeTime;
      }
      
      public function postHit(p:Particle, b:b2Body, angle:Number, power:Number, selfData:String, targetData:String) : void
      {
      }
      
      public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
      }
      
      public function get isCreated() : Boolean
      {
         return this._isCreated;
      }
      
      public function get resistance() : Number
      {
         return this._resistance;
      }
      
      public function get isDead() : Boolean
      {
         return this._isDead;
      }
      
      public function get body() : b2Body
      {
         return this._body;
      }
      
      public function get costume() : MovieClip
      {
         return this._costume;
      }
      
      public function get gravity() : Point
      {
         return this._gravity;
      }
      
      public function setGravity(val:Point) : void
      {
         this._gravity = val;
      }
   }
}
