package particle.units
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.b2WorldManifold;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_MiniKeyData;
   import design.data.DO_TrapData;
   import design.data.DO_UnitData;
   import effects.BloodEffect;
   import effects.ExplosionEffect;
   import effects.FireEffect;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.DM;
   import managers.GM;
   import managers.KM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.P_Blower;
   import particle.P_BonusHeart;
   import particle.P_BonusPlatform;
   import particle.P_Bouncer;
   import particle.P_Button;
   import particle.P_CannonBall;
   import particle.P_Chain;
   import particle.P_Checkpoint;
   import particle.P_Door;
   import particle.P_Elevator;
   import particle.P_GravitySwitcher;
   import particle.P_Heart;
   import particle.P_Key;
   import particle.P_KeyMini;
   import particle.P_Ladder;
   import particle.P_Lamp;
   import particle.P_Lever;
   import particle.P_Obstacle;
   import particle.P_Platform;
   import particle.P_Portal;
   import particle.P_Seeker;
   import particle.P_Sign;
   import particle.P_SlideDoor;
   import particle.P_Trap;
   import particle.P_UO;
   import particle.P_Wheel;
   import particle.Particle;
   
   public class P_Unit extends Particle
   {
      
      public static const MAIN:String = "unit_main";
      
      public static const REACH:String = "unit_reach";
      
      public static const FOOT:String = "unit_foot";
       
      
      protected var _isSticked:Boolean;
      
      protected var _data:DO_UnitData;
      
      protected var _scale:Number;
      
      protected var _scaleSQ:Number;
      
      protected var _force:Number;
      
      protected var _max_linear_velocity:Number;
      
      protected var _rotation:Number;
      
      protected var _angular_velocity:Number;
      
      protected var _swingCounter:int;
      
      protected var _hurtCounter:int;
      
      protected var _notTouchingCounter:int;
      
      protected var _reviveNow:Boolean;
      
      protected var _trackCounter:int;
      
      protected var _glow:MovieClip;
      
      protected var _selectArrow:MC_UnitArrow;
      
      protected var _dj:b2DistanceJoint;
      
      protected var _firstTracked:Boolean;
      
      protected var _isTracked:Boolean;
      
      protected var _isBounced:int;
      
      protected var _isInteracting:int;
      
      protected var _isJumping:int;
      
      protected var _canJump:int;
      
      protected var _canSwing:int;
      
      protected var _canInteract:Boolean;
      
      protected var _canRelease:Boolean;
      
      protected var _isTouching:Boolean;
      
      protected var _onLadder:Boolean;
      
      protected var _canBoost:Boolean;
      
      protected var _onAir:Boolean;
      
      protected var _hasKey:Boolean;
      
      protected var _key:P_KeyMini;
      
      protected var _hpBar:Sprite;
      
      protected var _hpBarCounter:int;
      
      protected var _firstGravity:Point;
      
      protected var _foot:b2Fixture;
      
      protected var _changeBody:Boolean;
      
      protected var _isCollected:Boolean;
      
      protected var _reviveCP:P_Checkpoint;
      
      protected var _isPulling:Boolean;
      
      protected var _pulledObject:Particle;
      
      protected var _bound:b2Joint;
      
      protected var _anchor:b2Vec2;
      
      protected var _deathVoiceID:int;
      
      protected var _victoryVoiceID:int;
      
      protected var _jumpVoiceID:int;
      
      protected var _hitVoiceID:int;
      
      protected var _selectVoiceID:int;
      
      public function P_Unit(layerNo:int, data:DO_UnitData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(5,0.2,0.1);
         this._deathVoiceID = 0;
         this._hitVoiceID = 0;
         this._jumpVoiceID = 0;
         this._selectVoiceID = 0;
         this._victoryVoiceID = 0;
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         this.createBody();
         this._firstGravity = new Point(0,Constants.GRAVITY);
         GameCamera.ins.addChildTo(_costume,_layerNo);
         this._isInteracting = 0;
         this._isBounced = 0;
         this._rotation = this._data.rotation;
         this._canJump = 0;
         this._scale = this._data.radius * 2 / this._data.SIZE;
         _hitPoint = 10;
         _hpMax = 10;
         this._hpBarCounter = 0;
         this._notTouchingCounter = 0;
         this._swingCounter = 0;
         this._trackCounter = 0;
         this._canInteract = true;
         this._canRelease = true;
         this._hpBar = new Sprite();
         GameCamera.ins.addChildTo(this._hpBar,_layerNo);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         this.removeBound();
         this.stopTracking();
         CF.removeDisplayObject(this._glow);
         CF.removeDisplayObject(this._selectArrow);
         CF.removeDisplayObject(this._hpBar);
         if(GM.ins.cl && !GM.ins.cl.isTest && !GM.ins.cl.isEnded && !this._isCollected)
         {
         }
         super.remove();
      }
      
      override public function removeCostume() : void
      {
         if(_isReviving || !_isDead)
         {
            return;
         }
         CF.removeDisplayObject(_costume);
      }
      
      override public function safeRemove() : void
      {
         var cp:P_Checkpoint = null;
         if(!_isCreated)
         {
            return;
         }
         if(GM.ins.cl)
         {
            cp = GM.ins.cl.getUnitCheckpoint(this);
         }
         if(cp != null && !this._isCollected)
         {
            _isReviving = true;
            TM.ins.tf(function():void
            {
               _reviveNow = true;
            },0.9);
            this._reviveCP = cp;
            return;
         }
         super.safeRemove();
         if(this._hasKey)
         {
            this._key.safeRemove();
         }
      }
      
      protected function createBody() : void
      {
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.type = b2Body.b2_dynamicBody;
         bodyDef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         _body.SetFixedRotation(true);
         var main_shape:b2CircleShape = new b2CircleShape(this._data.radius / Constants.SCALE);
         var main_fix:b2Fixture = _body.CreateFixture2(main_shape,_density);
         main_fix.SetUserData(MAIN);
         main_fix.SetFriction(_friction);
         main_fix.SetRestitution(_restitution);
         var foot_shape:b2PolygonShape = new b2PolygonShape();
         foot_shape.SetAsOrientedBox(this._data.radius / 1.2 / Constants.SCALE,this._data.radius / 4 / Constants.SCALE,new b2Vec2(0,this._data.radius / Constants.SCALE));
         this._foot = _body.CreateFixture2(foot_shape);
         this._foot.SetSensor(true);
         this._foot.SetUserData(FOOT);
         var reach_shape:b2CircleShape = new b2CircleShape(this._data.radius * 1.2 / Constants.SCALE);
         var reach_fix:b2Fixture = _body.CreateFixture2(reach_shape);
         reach_fix.SetUserData(REACH);
         reach_fix.SetSensor(true);
         var filterData:b2FilterData = new b2FilterData();
         filterData.categoryBits = 4;
         filterData.maskBits = ~2;
         main_fix.SetFilterData(filterData);
      }
      
      override public function update() : void
      {
         var time:Number = NaN;
         var old:Number = NaN;
         var f1:b2Fixture = null;
         var f2:b2Fixture = null;
         var b1:b2Body = null;
         var b2:b2Body = null;
         var p1:Particle = null;
         var p2:Particle = null;
         var d1:String = null;
         var d2:String = null;
         var manifold:b2WorldManifold = null;
         var ddef:b2DistanceJointDef = null;
         var rdef:b2RevoluteJointDef = null;
         if(!_isCreated)
         {
            return;
         }
         if(_isReviving)
         {
            if(this._reviveNow)
            {
               this.revive();
               return;
            }
         }
         if(_isFading && _isDead)
         {
            this.updatePosition();
            return;
         }
         if(_isFading)
         {
            return;
         }
         if(this._canJump > 0)
         {
            --this._canJump;
         }
         if(this._canSwing > 0)
         {
            --this._canSwing;
         }
         if(this._isBounced > 0)
         {
            --this._isBounced;
         }
         if(this._isInteracting > 0)
         {
            --this._isInteracting;
         }
         if(this._hurtCounter > 0)
         {
            --this._hurtCounter;
         }
         if(this._isTracked)
         {
            if(this._trackCounter > 0)
            {
               --this._trackCounter;
            }
            if(this._trackCounter == 0)
            {
               TweenLite.to(this._selectArrow,0.5,{"alpha":0});
            }
            this.updateMovement();
         }
         if(this._changeBody)
         {
            this.changeBody();
         }
         var wasOnLadder:Boolean = this._onLadder;
         this._onLadder = false;
         this._isSticked = false;
         this._isTouching = false;
         this.checkAir();
         for(var ce:b2ContactEdge = _body.GetContactList(); ce != null; ce = ce.next)
         {
            if(ce.contact.IsTouching())
            {
               f1 = ce.contact.GetFixtureA();
               f2 = ce.contact.GetFixtureB();
               b1 = f1.GetBody();
               b2 = f2.GetBody();
               p1 = b1.GetUserData() as Particle;
               p2 = b2.GetUserData() as Particle;
               d1 = f1.GetUserData() as String;
               d2 = f2.GetUserData() as String;
               if(this._isInteracting == 0 && (p2 is P_Platform || p2 is P_BonusPlatform) && d2 == P_Platform.STICKY)
               {
                  this.stickToParticle(p2);
               }
               else if(this._isInteracting == 0 && (p1 is P_Platform || p1 is P_BonusPlatform) && d1 == P_Platform.STICKY)
               {
                  this.stickToParticle(p1);
               }
               else if(p1 is P_Portal && d1 == P_Portal.MAIN)
               {
                  this.moveToParticle(p1);
               }
               else if(p2 is P_Portal && d2 == P_Portal.MAIN)
               {
                  this.moveToParticle(p2);
               }
               if(p1 is P_Ladder || p2 is P_Ladder)
               {
                  this._onLadder = true;
               }
               if((d1 == MAIN || d2 == MAIN) && (d1 == P_Chain.HOLD || d2 == P_Chain.HOLD) && this._canSwing == 0)
               {
                  if(!this._isPulling)
                  {
                     if(d1 == P_Chain.HOLD)
                     {
                        this._pulledObject = p1;
                     }
                     else
                     {
                        this._pulledObject = p2;
                     }
                     this._isPulling = true;
                  }
               }
               if(this._isTracked)
               {
                  if((d1 == REACH || d2 == REACH) && (p1 is P_Obstacle || p2 is P_Obstacle || p1 is P_Wheel || p2 is P_Wheel))
                  {
                     if(KM.ins.isDown(KM.SPACE))
                     {
                        if(!this._isPulling)
                        {
                           if(p1 is P_Obstacle || p1 is P_Wheel)
                           {
                              this._pulledObject = p1;
                           }
                           else
                           {
                              this._pulledObject = p2;
                           }
                           this._anchor = _body.GetWorldCenter();
                           this._isPulling = true;
                           this.checkAir();
                        }
                     }
                  }
               }
            }
         }
         if(!this._onAir)
         {
            this._onLadder = false;
         }
         if(this._isPulling)
         {
            if(this._onAir && (this._pulledObject is P_Wheel || this._pulledObject is P_Obstacle))
            {
               this.removeBound();
            }
            else if(!this._bound)
            {
               this._pulledObject.costume.filters = [new GlowFilter(16777215,0.6,5,5,10)];
               if(this._pulledObject is P_Chain)
               {
                  this._swingCounter = 0;
                  ddef = new b2DistanceJointDef();
                  ddef.Initialize(_body,this._pulledObject.body,_body.GetWorldCenter(),this._pulledObject.body.GetWorldCenter());
                  ddef.collideConnected = false;
                  this._bound = PM.ins.world.CreateJoint(ddef);
                  SM.ins.playSound(GameSound.CHAIN_SWING);
               }
               else
               {
                  rdef = new b2RevoluteJointDef();
                  rdef.Initialize(_body,this._pulledObject.body,this._anchor);
                  rdef.collideConnected = true;
                  this._bound = PM.ins.world.CreateJoint(rdef);
               }
            }
            else if(this._pulledObject is P_Chain)
            {
               ++this._swingCounter;
            }
            if(this._pulledObject is P_Chain)
            {
               this._onAir = false;
            }
         }
         if(!(this is P_Elder))
         {
            if(this._onLadder)
            {
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.9,_body.GetLinearVelocity().y * 0.7));
            }
         }
         if(wasOnLadder && !this._onLadder)
         {
            _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x,_body.GetLinearVelocity().y / 2));
         }
         if(this._isPulling)
         {
            this.playAnimation("onLadder");
         }
         else if(this._onLadder)
         {
            this.playAnimation("onLadder");
         }
         else if(this._onAir && _body.GetLinearVelocity().y * _gravity.y > 10)
         {
            this.playAnimation("air");
         }
         else
         {
            this.playAnimation("idle");
         }
         if(!this._onAir)
         {
            if(GM.ins.cl && !GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
            {
               if(this._notTouchingCounter > 0)
               {
                  time = this._notTouchingCounter / Constants.FRAME_RATE;
                  LM.ins.cp.setNotTouchingTime(Math.round(time));
                  trace("not touching = " + time);
               }
            }
            this._notTouchingCounter = 0;
         }
         else
         {
            ++this._notTouchingCounter;
         }
         if(_area)
         {
            if(!_area.containsPoint(new Point(_costume.x,_costume.y)))
            {
               this.die();
               if(GM.ins.cl && !GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
               {
                  LM.ins.cp.addOutOfBounds();
               }
            }
         }
         this.heal(0.02);
         this.hpBarUpdate();
         this.updatePosition();
      }
      
      private function revive() : void
      {
         this._reviveNow = false;
         _isReviving = false;
         _isDead = false;
         _isFading = false;
         _costume.gotoAndPlay("idle");
         _hitPoint = _hpMax;
         _costume.alpha = 0;
         TweenLite.to(_costume,0.6,{"alpha":1});
         var imp:Number = 5.5 * _body.GetMass() * this._scale;
         var angle:Number = this._reviveCP.data.rotation * Math.PI / 180 - Math.PI / 2;
         _body.SetPosition(new b2Vec2(this._reviveCP.data.x / Constants.SCALE + 0.5 * Math.cos(angle),this._reviveCP.data.y / Constants.SCALE + 0.5 * Math.sin(angle)));
         _body.ApplyImpulse(new b2Vec2(imp * Math.cos(angle),imp * Math.sin(angle)),_body.GetWorldCenter());
      }
      
      private function checkAir() : void
      {
         var b1:b2Body = null;
         var b2:b2Body = null;
         var f1:b2Fixture = null;
         var f2:b2Fixture = null;
         var p1:Particle = null;
         var p2:Particle = null;
         var d1:String = null;
         var d2:String = null;
         this._onAir = true;
         this._isTouching = false;
         for(var ce:b2ContactEdge = _body.GetContactList(); ce != null; ce = ce.next)
         {
            if(ce.contact.IsTouching())
            {
               b1 = ce.contact.GetFixtureA().GetBody();
               b2 = ce.contact.GetFixtureB().GetBody();
               f1 = ce.contact.GetFixtureA();
               f2 = ce.contact.GetFixtureB();
               p1 = b1.GetUserData() as Particle;
               p2 = b2.GetUserData() as Particle;
               d1 = f1.GetUserData() as String;
               d2 = f2.GetUserData() as String;
               if(p1 == this && d1 == FOOT && !(p2 == this._pulledObject || d2 == P_Lamp.ROPE || p2 is P_Trap || p2 is P_CannonBall || p2 is P_KeyMini || p2 is P_Ladder || p2 is P_Heart || p2 is P_Key || p2 is P_Portal || p2 is P_Lever || p2 is P_Bouncer || p2 is P_Blower || p2 is P_Button || p2 is P_BonusHeart || p2 is P_Chain || p2 is P_GravitySwitcher || p2 is P_Sign || p2 is P_SlideDoor && (p2 as P_SlideDoor).isOpened || p2 is P_Door && (p2 as P_Door).isOpened))
               {
                  this._onAir = false;
               }
               if(p2 == this && d2 == FOOT && !(p1 == this._pulledObject || d1 == P_Lamp.ROPE || p1 is P_Trap || p1 is P_CannonBall || p1 is P_KeyMini || p1 is P_Ladder || p1 is P_Heart || p1 is P_Key || p1 is P_Portal || p1 is P_Lever || p1 is P_Bouncer || p1 is P_Blower || p1 is P_Button || p1 is P_BonusHeart || p1 is P_Chain || p1 is P_GravitySwitcher || p1 is P_Sign || p1 is P_SlideDoor && (p1 as P_SlideDoor).isOpened || p1 is P_Door && (p1 as P_Door).isOpened))
               {
                  this._onAir = false;
               }
            }
         }
      }
      
      private function removeBound() : void
      {
         if(this._bound)
         {
            PM.ins.world.DestroyJoint(this._bound);
         }
         if(this._pulledObject && this._pulledObject.costume)
         {
            this._pulledObject.costume.filters = [];
         }
         this._bound = null;
         this._pulledObject = null;
         this._isPulling = false;
      }
      
      private function changeBody() : void
      {
         this._changeBody = false;
         var angle:Number = Math.atan2(_gravity.y,_gravity.x);
         var ox:Number = this._data.radius * 1.1 / Constants.SCALE * Math.cos(angle);
         var oy:Number = this._data.radius * 1.1 / Constants.SCALE * Math.sin(angle);
         _body.DestroyFixture(this._foot);
         this._foot = null;
         var foot_shape:b2PolygonShape = new b2PolygonShape();
         foot_shape.SetAsOrientedBox(this._data.radius / 1.2 / Constants.SCALE,this._data.radius / 4 / Constants.SCALE,new b2Vec2(ox,oy),angle + Math.PI / 2);
         this._foot = _body.CreateFixture2(foot_shape);
         this._foot.SetSensor(true);
         this._foot.SetUserData(FOOT);
      }
      
      override public function postHit(p:Particle, b:b2Body, angle:Number, power:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Bouncer || p is P_Unit)
         {
            return;
         }
         var soundTreshold:Number = 8 * this._scale * this._scale;
         if(power > soundTreshold)
         {
            if(this._hurtCounter == 0 && this._hitVoiceID > 0)
            {
               this._hurtCounter = 10;
               SM.ins.playVoice(this._hitVoiceID);
               if(_costume.currentLabel != "ouch" && _costume.currentLabel != "death")
               {
                  _costume.gotoAndPlay("ouch");
               }
            }
         }
         var threshold:Number = 20 * this._scale * this._scale;
         if(power > threshold)
         {
            this.damage((power - threshold) / this._scale / this._scale / 2);
         }
         super.postHit(p,b,angle,power,selfData,targetData);
      }
      
      protected function hpBarUpdate() : void
      {
         this._hpBar.graphics.clear();
         if(this._hpBarCounter <= 0)
         {
            return;
         }
         --this._hpBarCounter;
         var barX:Number = -this._data.SIZE * this._scale * 0.5 + _costume.x;
         var barY:Number = -this._data.SIZE * this._scale * 0.65 + _costume.y;
         var barWidth:Number = this._data.SIZE * this._scale;
         var barHeight:Number = this._data.SIZE * this._scale * 0.1;
         var hpWidth:Number = this._data.SIZE * this._scale * (_hitPoint / _hpMax);
         this._hpBar.graphics.beginFill(16777215,1);
         this._hpBar.graphics.drawRect(barX,barY,barWidth,barHeight);
         this._hpBar.graphics.endFill();
         this._hpBar.graphics.beginFill(16711680,1);
         this._hpBar.graphics.drawRect(barX,barY,hpWidth,barHeight);
         if(this._hpBarCounter < 30)
         {
            this._hpBar.alpha = this._hpBarCounter / 30;
         }
         else
         {
            this._hpBar.alpha = 1;
         }
      }
      
      protected function updatePosition() : void
      {
         this._rotation = (this._rotation + 360) % 360;
         if(this._isPulling)
         {
            this._angular_velocity = _body.GetLinearVelocity().x * 2;
         }
         else if(this._onAir)
         {
            this._angular_velocity = _body.GetLinearVelocity().x * 2;
         }
         else
         {
            this._angular_velocity = _body.GetLinearVelocity().x * 4;
         }
         if(!this._isSticked)
         {
            this._rotation += this._angular_velocity;
         }
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = this._rotation;
         if(this._glow)
         {
            this._glow.x = _costume.x;
            this._glow.y = _costume.y;
         }
         if(this._selectArrow)
         {
            this._selectArrow.x = _costume.x;
            this._selectArrow.y = _costume.y;
         }
      }
      
      override public function damage(val:Number) : void
      {
         super.damage(val);
         this._hpBarCounter = 60;
      }
      
      override public function heal(val:Number) : void
      {
         if(val > 10)
         {
            this._hpBarCounter = 100;
         }
         super.heal(val);
      }
      
      public function playAnimation(animType:String) : void
      {
         if(!_isCreated)
         {
            return;
         }
         if(_costume.currentLabel != "ouch" && _costume.currentLabel != animType && _costume.currentLabel != "death")
         {
            _costume.gotoAndPlay(animType);
         }
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         var keyData:DO_MiniKeyData = null;
         var power:Number = NaN;
         var impulse:b2Vec2 = null;
         var p2:Number = NaN;
         var i2:b2Vec2 = null;
         if(_isDead)
         {
            return;
         }
         if(p is P_Portal && (p as P_Portal).isOpened)
         {
            if(targetData == P_Portal.CORE)
            {
               this.goInsidePortal(p);
            }
         }
         else if(p is P_Key)
         {
            if(this._hasKey)
            {
               return;
            }
            this._hasKey = true;
            p.safeRemove();
            keyData = new DO_MiniKeyData();
            keyData.x = 0;
            keyData.y = this._data.radius * 0.8;
            keyData.scale = this._scale;
            this._key = new P_KeyMini(GameCamera.KEY,keyData,this);
            this._key.safeCreate();
            SM.ins.playSound(GameSound.KEY_TAKEN);
         }
         else if(p is P_Door)
         {
            if(!this._hasKey || (p as P_Door).isOpened)
            {
               return;
            }
            this._key.safeRemove();
            this.removeKey();
            (p as P_Door).open();
            SM.ins.playSound(GameSound.KEY_UNLOCK);
         }
         else if(p is P_UO && selfData == MAIN)
         {
            if((p as P_UO).isExploded)
            {
               return;
            }
            (p as P_UO).explode();
            this.createExplosion(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
            this.die();
            power = 10 * this._scale * this._scale;
            impulse = new b2Vec2(power * Math.cos(angle),power * Math.sin(angle));
            _body.ApplyImpulse(impulse,_body.GetWorldCenter());
         }
         else if(p is P_Seeker && selfData == MAIN)
         {
            if((p as P_Seeker).isExploded)
            {
               return;
            }
            (p as P_Seeker).explode();
            this.createExplosion(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
            this.die();
            p2 = 8 * this._scale * this._scale;
            i2 = new b2Vec2(p2 * Math.cos(angle),p2 * Math.sin(angle));
            _body.ApplyImpulse(i2,_body.GetWorldCenter());
         }
         else if(p is P_Trap && selfData == MAIN)
         {
            if((p as P_Trap).data.trapType == DO_TrapData.FIRE)
            {
               this.createFire(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE);
               SM.ins.playSound(GameSound.FIRE_HIT);
            }
            else if((p as P_Trap).data.trapType == DO_TrapData.SPIKE)
            {
               this.spillBlood(_body.GetPosition().x * Constants.SCALE,_body.GetPosition().y * Constants.SCALE + 10 * this._scale);
               SM.ins.playSound(GameSound.SPIKE_HIT);
            }
            this.die();
         }
         else if(p is P_CannonBall && selfData == MAIN)
         {
            this.damage(100);
         }
         super.preHit(p,b,angle,selfData,targetData);
      }
      
      protected function spillBlood(posX:Number, posY:Number) : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         var be:BloodEffect = new BloodEffect(posX,posY,10,24);
         be.create();
      }
      
      protected function createFire(posX:Number, posY:Number) : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         var fe:FireEffect = new FireEffect(posX,posY,25,20);
         fe.create();
      }
      
      protected function createExplosion(posX:Number, posY:Number, effect:Number = 25, duration:int = 20) : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         var ee:ExplosionEffect = new ExplosionEffect(posX,posY,effect,duration);
         ee.create();
      }
      
      public function laserShot(x:Number, y:Number, angle:Number) : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         var be:BloodEffect = new BloodEffect(_body.GetPosition().x * Constants.SCALE + this._data.SIZE * this._scale * Math.random() - this._data.SIZE / 2 * this._scale,_body.GetPosition().y * Constants.SCALE + this._data.SIZE * this._scale * Math.random() - this._data.SIZE / 2 * this._scale,3,5);
         be.create();
         this.damage(1);
         var impulse:Number = 1.15;
         _body.ApplyImpulse(new b2Vec2(impulse * Math.cos(angle),impulse * Math.sin(angle)),new b2Vec2(x / Constants.SCALE,y / Constants.SCALE));
      }
      
      override public function die() : void
      {
         if(!_isCreated || _isDead)
         {
            return;
         }
         super.die();
         CF.removeDisplayObject(this._hpBar);
         if(this._deathVoiceID > 0)
         {
            SM.ins.playVoice(this._deathVoiceID);
         }
         _isFading = true;
         _costume.gotoAndPlay("death");
         TM.ins.tf(function():void
         {
            removeCostume();
         },0.75);
         this.safeRemove();
      }
      
      protected function goInsidePortal(p:Particle) : void
      {
         if(!_isCreated || _isDead || this._isCollected)
         {
            return;
         }
         this._isCollected = true;
         if(!GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
         {
            LM.ins.cp.addUnitSaved();
         }
         if(this._victoryVoiceID > 0)
         {
            SM.ins.playVoice(this._victoryVoiceID);
         }
         TM.ins.tf(function():void
         {
            dispatchEvent(new Event("collected"));
         },1);
         _isFading = true;
         _costume.x = p.body.GetPosition().x * Constants.SCALE;
         _costume.y = p.body.GetPosition().y * Constants.SCALE;
         TweenLite.to(_costume,1.5,{
            "rotation":960,
            "scaleX":0,
            "scaleY":0,
            "alpha":0
         });
         TM.ins.tf(function():void
         {
            removeCostume();
         },1.5);
         this.safeRemove();
      }
      
      private function moveToParticle(p:Particle) : void
      {
         var move_angle:Number = Math.atan2(p.body.GetPosition().y - _body.GetPosition().y,p.body.GetPosition().x - _body.GetPosition().x);
         var power:Number = 25 * this._scale * this._scale;
         var force:b2Vec2 = new b2Vec2(power * Math.cos(move_angle),power * Math.sin(move_angle));
         _body.ApplyForce(force,_body.GetWorldCenter());
      }
      
      private function stickToParticle(p:Particle) : void
      {
         this._isSticked = true;
         var lin_vel:b2Vec2 = _body.GetLinearVelocity();
         var p_vel:b2Vec2 = p.body.GetLinearVelocity();
         var vel:b2Vec2 = new b2Vec2((2 * lin_vel.x + 3 * p_vel.x) / 5,(2 * lin_vel.y + 3 * p_vel.y) / 5);
         this._angular_velocity = 0;
         _body.SetLinearVelocity(vel);
      }
      
      protected function updateMovement() : void
      {
         var ladderForce:Number = 30 * this._scale * _body.GetMass() * 1;
         if(this._onLadder)
         {
            if(KM.ins.isDown(KM.KEY_S) || KM.ins.isDown(KM.DOWN))
            {
               _body.ApplyForce(new b2Vec2(0,ladderForce),_body.GetWorldCenter());
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.7,_body.GetLinearVelocity().y));
            }
            if(KM.ins.isDown(KM.KEY_W) || KM.ins.isDown(KM.UP))
            {
               _body.ApplyForce(new b2Vec2(0,-ladderForce),_body.GetWorldCenter());
               _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.7,_body.GetLinearVelocity().y));
            }
         }
      }
      
      public function startTracking() : void
      {
         if(this._isTracked)
         {
            return;
         }
         this._isTracked = true;
         if(GM.ins.cl && !GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
         {
            LM.ins.cp.trackMember(this._data.unitType);
         }
         Main.s.addEventListener(Event.ENTER_FRAME,this.frameHandler,false,0,true);
         DM.ins.game_mc.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,0,true);
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler,false,0,true);
         this._glow = new MovieClip();
         this._glow.graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215],[0,0.5],[0,255]);
         this._glow.graphics.drawCircle(0,0,this._data.radius * 1.25);
         this._glow.graphics.endFill();
         GameCamera.ins.addChildTo(this._glow,GameCamera.UNIT_GLOW);
         this._selectArrow = new MC_UnitArrow();
         if(!this._firstTracked)
         {
            this._firstTracked = true;
            if(this is P_Dad)
            {
               this._selectArrow.txt_name.text = "Walter";
            }
            else if(this is P_Mom)
            {
               this._selectArrow.txt_name.text = "Sydney";
            }
            else if(this is P_Baby || this is P_BonusBaby)
            {
               this._selectArrow.txt_name.text = "Toby";
            }
            else if(this is P_Kid || this is P_BonusKid)
            {
               this._selectArrow.txt_name.text = "Billy";
            }
            else if(this is P_Elder || this is P_BonusElder)
            {
               this._selectArrow.txt_name.text = "Mr. Greer";
            }
            this._trackCounter = 75;
         }
         else
         {
            this._selectArrow.txt_name.visible = false;
            this._trackCounter = 60;
         }
         var angle:Number = Math.atan2(_gravity.y,_gravity.x) - Math.PI / 2;
         this._selectArrow.rotation = angle * 180 / Math.PI;
         GameCamera.ins.addChildTo(this._selectArrow,GameCamera.UNIT);
         if(this._selectVoiceID > 0)
         {
            SM.ins.playVoice(this._selectVoiceID);
         }
      }
      
      public function stopTracking() : void
      {
         if(!this._isTracked)
         {
            return;
         }
         this._isTracked = false;
         Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
         DM.ins.game_mc.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         CF.removeDisplayObject(this._glow);
         CF.removeDisplayObject(this._selectArrow);
         if(this._bound && (this._pulledObject is P_Wheel || this._pulledObject is P_Obstacle))
         {
            this.removeBound();
         }
         this._canInteract = true;
         this._canRelease = true;
      }
      
      private function keyDownHandler(e:KeyboardEvent) : void
      {
         var time:Number = NaN;
         if(this._isTracked && e.keyCode == KM.SPACE)
         {
            if(this._canInteract)
            {
               this.interact();
               this._canInteract = false;
            }
         }
         else if(this._isTracked && (e.keyCode == KM.UP || e.keyCode == KM.KEY_W))
         {
            if(this._canRelease)
            {
               if(this._bound && this._pulledObject is P_Chain)
               {
                  if(GM.ins.cl && !GM.ins.cl.isTest && !GM.ins.cl.isUserLevel)
                  {
                     time = this._swingCounter / Constants.FRAME_RATE;
                     LM.ins.cp.setSwingTime(Math.round(time));
                  }
                  this._canSwing = 15;
                  this.removeBound();
                  trace("released!");
               }
               this._canRelease = false;
            }
         }
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.SPACE)
         {
            this._canInteract = true;
            if(this._bound && (this._pulledObject is P_Wheel || this._pulledObject is P_Obstacle))
            {
               this.removeBound();
            }
         }
         else if(e.keyCode == KM.UP || e.keyCode == KM.KEY_W)
         {
            this._canRelease = true;
         }
      }
      
      private function interact() : void
      {
         var fA:b2Fixture = null;
         var fB:b2Fixture = null;
         var bA:b2Body = null;
         var bB:b2Body = null;
         var pA:Particle = null;
         var pB:Particle = null;
         var dA:String = null;
         var dB:String = null;
         var lever:P_Lever = null;
         var grs:P_GravitySwitcher = null;
         var ele:P_Elevator = null;
         for(var ce:b2ContactEdge = _body.GetContactList(); ce != null; ce = ce.next)
         {
            if(ce.contact.IsTouching())
            {
               fA = ce.contact.GetFixtureA();
               fB = ce.contact.GetFixtureB();
               bA = fA.GetBody();
               bB = fB.GetBody();
               pA = bA.GetUserData();
               pB = bB.GetUserData();
               dA = fA.GetUserData();
               dB = fB.GetUserData();
               if(pA is P_Lever || pB is P_Lever)
               {
                  if(pA is P_Lever)
                  {
                     lever = pA as P_Lever;
                  }
                  else if(pB is P_Lever)
                  {
                     lever = pB as P_Lever;
                  }
                  if(lever.isPulled)
                  {
                     GM.ins.cl.enableObjects();
                  }
                  else
                  {
                     GM.ins.cl.disableObjects();
                  }
                  return;
               }
               if(pA is P_GravitySwitcher || pB is P_GravitySwitcher)
               {
                  if(pA is P_GravitySwitcher)
                  {
                     grs = pA as P_GravitySwitcher;
                  }
                  else if(pB is P_GravitySwitcher)
                  {
                     grs = pB as P_GravitySwitcher;
                  }
                  SM.ins.playSound(GameSound.GRAVITY_SWITCHED);
                  if(!grs.isActivated && !grs.isSensor)
                  {
                     GM.ins.cl.changeGravity(grs.rotation + Math.PI);
                  }
                  return;
               }
               if(dA == P_Elevator.SENSOR || dB == P_Elevator.SENSOR)
               {
                  if(pA is P_Elevator)
                  {
                     ele = pA as P_Elevator;
                  }
                  else
                  {
                     ele = pB as P_Elevator;
                  }
                  ele.activate();
                  return;
               }
            }
         }
      }
      
      public function removeKey() : void
      {
         this._hasKey = false;
         this._key = null;
      }
      
      protected function mouseUpHandler(e:MouseEvent) : void
      {
      }
      
      protected function frameHandler(e:Event) : void
      {
      }
      
      override public function setGravity(val:Point) : void
      {
         this._changeBody = true;
         super.setGravity(val);
      }
      
      public function get data() : DO_UnitData
      {
         return this._data;
      }
      
      public function get hasKey() : Boolean
      {
         return this._hasKey;
      }
      
      public function get isTracked() : Boolean
      {
         return this._isTracked;
      }
      
      public function get onLadder() : Boolean
      {
         return this._onLadder;
      }
      
      public function get isCollected() : Boolean
      {
         return this._isCollected;
      }
      
      public function get isBounced() : int
      {
         return this._isBounced;
      }
      
      public function set isBounced(value:int) : void
      {
         this._isBounced = value;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
   }
}
