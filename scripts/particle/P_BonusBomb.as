package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.units.P_Unit;
   
   public class P_BonusBomb extends Particle
   {
      
      public static const MAIN:String = "bonus_bomb_main";
       
      
      protected var _xpos:Number;
      
      protected var _ypos:Number;
      
      protected var _isExploded:Boolean;
      
      protected var _delayedExploded:Boolean;
      
      protected const RADIUS:Number = 10;
      
      public function P_BonusBomb(layerNo:int, x:Number, y:Number)
      {
         this._xpos = x;
         this._ypos = y;
         super(layerNo);
         setPhysicParams(10,0.5,0.4);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bDef:b2BodyDef = new b2BodyDef();
         bDef.position = new b2Vec2(this._xpos / Constants.SCALE,this._ypos / Constants.SCALE);
         bDef.type = b2Body.b2_dynamicBody;
         _body = PM.ins.world.CreateBody(bDef);
         _body.SetUserData(this);
         _body.SetActive(true);
         var shape:b2CircleShape = new b2CircleShape(this.RADIUS / Constants.SCALE);
         var fix:b2Fixture = _body.CreateFixture2(shape,_density);
         fix.SetUserData(MAIN);
         fix.SetRestitution(_restitution);
         fix.SetFriction(_friction);
         _costume = new MC_UMO();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._xpos;
         _costume.y = this._ypos;
         _costume.scaleX = this.RADIUS / 15;
         _costume.scaleY = this.RADIUS / 15;
         _gravity = new Point(0,Constants.GRAVITY * 0.8);
         _body.SetAngularVelocity(Math.random() * 10 - 5);
         _body.SetLinearVelocity(new b2Vec2(Math.random() * 1.2 - 0.6,0));
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
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Wall)
         {
            this.delayedExplode();
         }
         else if(p is P_Unit)
         {
            this.explode();
         }
         super.preHit(p,b,angle,selfData,targetData);
      }
      
      private function delayedExplode() : void
      {
         if(this._delayedExploded || this._isExploded)
         {
            return;
         }
         this._delayedExploded = true;
         TM.ins.tf(function():void
         {
            explode();
         },1.2);
      }
      
      public function explode() : void
      {
         if(this._isExploded)
         {
            return;
         }
         this._isExploded = true;
         _isFading = true;
         _costume.gotoAndPlay("die");
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_costume);
         },0.6);
         if(GM.ins.bl)
         {
            GM.ins.bl.shakeCamera(5,10);
         }
         SM.ins.playSound(GameSound.CANNON_SHOOT);
         TM.ins.tf(function():void
         {
            safeRemove();
         },0.1);
      }
      
      public function get isExploded() : Boolean
      {
         return this._isExploded;
      }
   }
}
