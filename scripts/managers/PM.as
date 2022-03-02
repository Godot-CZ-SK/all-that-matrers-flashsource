package managers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2DebugDraw;
   import Box2D.Dynamics.b2World;
   import flash.display.Sprite;
   import game.ContactListener;
   import particle.Particle;
   import particle.units.P_Unit;
   
   public class PM
   {
      
      private static var _ins:PM;
       
      
      protected var _world:b2World;
      
      protected var _list:Vector.<Particle>;
      
      protected var _trash:Vector.<Particle>;
      
      protected var _create:Vector.<Particle>;
      
      protected var _dsParent:Sprite;
      
      protected var _ds:Sprite;
      
      public function PM()
      {
         super();
      }
      
      public static function get ins() : PM
      {
         if(!_ins)
         {
            _ins = new PM();
         }
         return _ins;
      }
      
      public function init(dsParent:Sprite) : void
      {
         var dd:b2DebugDraw = null;
         this._dsParent = dsParent;
         this._world = new b2World(new b2Vec2(0,0),false);
         this._world.SetContactListener(new ContactListener());
         if(this._dsParent != null)
         {
            this._ds = new Sprite();
            this._dsParent.addChild(this._ds);
            this._ds.alpha = 0.5;
            dd = new b2DebugDraw();
            dd.SetSprite(this._ds);
            dd.AppendFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            dd.SetDrawScale(Constants.SCALE);
            this._world.SetDebugDraw(dd);
         }
         this._list = new Vector.<Particle>();
         this._trash = new Vector.<Particle>();
         this._create = new Vector.<Particle>();
      }
      
      public function update() : void
      {
         this.step();
         this._world.ClearForces();
         this._world.DrawDebugData();
         for(var i:int = 0; i < this._list.length; i++)
         {
            this._list[i].update();
         }
         for(i = 0; i < this._trash.length; i++)
         {
            this.removeP(this._trash[i]);
         }
         this._trash = new Vector.<Particle>();
         for(i = 0; i < this._create.length; i++)
         {
            this._create[i].create();
         }
         this._create = new Vector.<Particle>();
      }
      
      private function step() : void
      {
         var p:Particle = null;
         var timeStep:Number = Constants.physicsTimeStep;
         var velIterations:int = 10;
         var posIterations:int = 10;
         for(var b:b2Body = this._world.GetBodyList(); b != null; b = b.GetNext())
         {
            p = b.GetUserData();
            if(p != null)
            {
               if(!(p is P_Unit && (p as P_Unit).onLadder))
               {
                  b.ApplyForce(new b2Vec2(p.gravity.x * b.GetMass(),p.gravity.y * b.GetMass()),b.GetWorldCenter());
               }
            }
         }
         this._world.Step(timeStep,velIterations,posIterations);
         this._world.Step(timeStep,velIterations,posIterations);
      }
      
      public function removeP(p:Particle) : void
      {
         if(this._list.indexOf(p) < 0)
         {
            return;
         }
         this._list.splice(this._list.indexOf(p),1);
         p.remove();
      }
      
      public function addP(p:Particle) : void
      {
         if(this._list.indexOf(p) >= 0)
         {
            return;
         }
         this._list.push(p);
      }
      
      public function safeRemoveP(p:Particle) : void
      {
         if(this._trash.indexOf(p) >= 0)
         {
            return;
         }
         this._trash.push(p);
      }
      
      public function safeCreateP(p:Particle) : void
      {
         if(this._create.indexOf(p) >= 0)
         {
            return;
         }
         this._create.push(p);
      }
      
      public function reset() : void
      {
         var dd:b2DebugDraw = null;
         for(var i:int = 0; i < this._list.length; i++)
         {
            this._list[i].remove();
         }
         this._list = new Vector.<Particle>();
         this._trash = new Vector.<Particle>();
         this._create = new Vector.<Particle>();
         while(this._world.GetJointList())
         {
            this._world.DestroyJoint(this._world.GetJointList());
         }
         while(this._world.GetBodyList())
         {
            this._world.DestroyBody(this._world.GetBodyList());
         }
         CF.removeDisplayObject(this._ds);
         this._world = null;
         this._world = new b2World(new b2Vec2(0,0),false);
         this._world.SetContactListener(new ContactListener());
         if(this._dsParent != null)
         {
            this._ds = new Sprite();
            this._dsParent.addChild(this._ds);
            this._ds.alpha = 0.5;
            dd = new b2DebugDraw();
            dd.SetSprite(this._ds);
            dd.AppendFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            dd.SetDrawScale(Constants.SCALE);
            this._world.SetDebugDraw(dd);
         }
      }
      
      public function get world() : b2World
      {
         return this._world;
      }
      
      public function get list() : Vector.<Particle>
      {
         return this._list;
      }
   }
}
