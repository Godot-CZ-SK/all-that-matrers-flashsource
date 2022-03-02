package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_ChainData;
   import flash.display.MovieClip;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Chain extends Particle
   {
      
      public static const MAIN:String = "chain_main";
      
      public static const HOLD:String = "chain_hold";
      
      public static const LINK:String = "chain_link";
       
      
      protected var _links:Vector.<b2RevoluteJoint>;
      
      protected var _chainLink:b2RevoluteJoint;
      
      protected var _bound:b2Body;
      
      protected var _bodies:Vector.<b2Body>;
      
      protected var _data:DO_ChainData;
      
      protected var _linkCostume:MovieClip;
      
      public function P_Chain(layerNo:int, data:DO_ChainData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(20,0.2,0.1);
      }
      
      override public function create() : void
      {
         var filterData:b2FilterData = null;
         var revJointDef:b2RevoluteJointDef = null;
         var bdef:b2BodyDef = null;
         var body:b2Body = null;
         var shape:b2CircleShape = null;
         var fix:b2Fixture = null;
         var anchor:b2Vec2 = null;
         var link:b2RevoluteJoint = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._links = new Vector.<b2RevoluteJoint>();
         this._bodies = new Vector.<b2Body>();
         filterData = new b2FilterData();
         filterData.categoryBits = 16;
         filterData.maskBits = ~16;
         var bbdef:b2BodyDef = new b2BodyDef();
         bbdef.position = new b2Vec2(this._data.x / Constants.SCALE,(this._data.y - this._data.RADIUS * this._data.scale) / Constants.SCALE);
         bbdef.type = b2Body.b2_staticBody;
         this._bound = PM.ins.world.CreateBody(bbdef);
         this._bound.SetUserData(this);
         var bShape:b2CircleShape = new b2CircleShape(this._data.RADIUS * this._data.scale / Constants.SCALE);
         var bFix:b2Fixture = this._bound.CreateFixture2(bShape,_density);
         bFix.SetSensor(true);
         bFix.SetFilterData(filterData);
         bFix.SetUserData(MAIN);
         bFix.SetFriction(_friction);
         bFix.SetRestitution(_restitution);
         revJointDef = new b2RevoluteJointDef();
         var last:b2Body = this._bound;
         var numberOfLinks:int = Math.ceil(this._data.height / this._data.RADIUS / 2);
         for(var i:int = 0; i < numberOfLinks; i++)
         {
            bdef = new b2BodyDef();
            bdef.position = new b2Vec2(this._data.x / Constants.SCALE,(this._data.y + (i + 0.5) * 2 * this._data.RADIUS * this._data.scale) / Constants.SCALE);
            bdef.type = b2Body.b2_dynamicBody;
            body = PM.ins.world.CreateBody(bdef);
            body.SetUserData(this);
            this._bodies.push(body);
            shape = new b2CircleShape(this._data.RADIUS * this._data.scale / Constants.SCALE);
            fix = body.CreateFixture2(shape,_density);
            fix.SetUserData(LINK);
            fix.SetFilterData(filterData);
            fix.SetFriction(_friction);
            fix.SetRestitution(_restitution);
            anchor = body.GetWorldCenter();
            anchor.y -= this._data.RADIUS * this._data.scale / Constants.SCALE;
            revJointDef.Initialize(last,body,anchor);
            revJointDef.collideConnected = false;
            link = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
            this._links.push(link);
            last = body;
         }
         var cbdef:b2BodyDef = new b2BodyDef();
         cbdef.type = b2Body.b2_dynamicBody;
         cbdef.position = new b2Vec2(this._data.x / Constants.SCALE,(this._data.y + (numberOfLinks + 0.5) * this._data.RADIUS * this._data.scale * 2) / Constants.SCALE);
         _body = PM.ins.world.CreateBody(cbdef);
         _body.SetUserData(this);
         var cShape:b2CircleShape = new b2CircleShape(this._data.RADIUS * 2.5 * this._data.scale / Constants.SCALE);
         var cFix:b2Fixture = _body.CreateFixture2(cShape,10);
         cFix.SetUserData(HOLD);
         cFix.SetSensor(true);
         cFix.SetFilterData(filterData);
         cFix.SetRestitution(_restitution);
         cFix.SetFriction(_friction);
         anchor = _body.GetWorldCenter();
         anchor.y -= this._data.RADIUS * this._data.scale / Constants.SCALE;
         revJointDef.Initialize(last,_body,anchor);
         revJointDef.collideConnected = false;
         this._chainLink = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
         _costume = new MC_ChainHold();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         _costume.scaleX = this._data.scale * 1.25;
         _costume.scaleY = this._data.scale * 1.25;
         this._linkCostume = new MovieClip();
         GameCamera.ins.addChildTo(this._linkCostume,_layerNo);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         _costume.x = _body.GetPosition().x * Constants.SCALE;
         _costume.y = _body.GetPosition().y * Constants.SCALE;
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         this._linkCostume.graphics.clear();
         this._linkCostume.graphics.lineStyle(this._data.scale,0);
         this._linkCostume.graphics.beginFill(11184810,1);
         for(var i:int = 0; i < this._bodies.length; i++)
         {
            this._linkCostume.graphics.drawCircle(this._bodies[i].GetPosition().x * Constants.SCALE,this._bodies[i].GetPosition().y * Constants.SCALE,this._data.RADIUS * this._data.scale);
            this._linkCostume.graphics.drawCircle(this._bodies[i].GetPosition().x * Constants.SCALE,this._bodies[i].GetPosition().y * Constants.SCALE,this._data.RADIUS * this._data.scale / 2);
         }
         _body.SetLinearVelocity(new b2Vec2(_body.GetLinearVelocity().x * 0.98,_body.GetLinearVelocity().y * 0.98));
         super.update();
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         for(var i:int = 0; i < this._links.length; i++)
         {
            PM.ins.world.DestroyJoint(this._links[i]);
         }
         for(i = 0; i < this._bodies.length; i++)
         {
            PM.ins.world.DestroyBody(this._bodies[i]);
         }
         PM.ins.world.DestroyBody(this._bound);
         CF.removeDisplayObject(_costume);
         CF.removeDisplayObject(this._linkCostume);
         super.remove();
      }
      
      public function get data() : DO_ChainData
      {
         return this._data;
      }
   }
}
