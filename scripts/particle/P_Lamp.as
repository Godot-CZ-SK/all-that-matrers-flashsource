package particle
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_LampData;
   import flash.display.MovieClip;
   import game.GameCamera;
   import managers.PM;
   
   public class P_Lamp extends Particle
   {
      
      public static const MAIN:String = "lamp_main";
      
      public static const ROPE:String = "lamp_rope";
       
      
      protected var _links:Vector.<b2RevoluteJoint>;
      
      protected var _lampLink:b2RevoluteJoint;
      
      protected var _bodies:Vector.<b2Body>;
      
      protected var _bound:b2Body;
      
      protected var _data:DO_LampData;
      
      protected var _linkCostume:MovieClip;
      
      public function P_Lamp(layerNo:int, data:DO_LampData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var filterData:b2FilterData = null;
         var revJointDef:b2RevoluteJointDef = null;
         var ropeHeight:Number = NaN;
         var last:b2Body = null;
         var bdef:b2BodyDef = null;
         var body:b2Body = null;
         var shape:b2PolygonShape = null;
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
         var bbdef:b2BodyDef = new b2BodyDef();
         bbdef.position = new b2Vec2((this._data.x + Math.cos(this._data.rotation - Math.PI / 2) * (this._data.WIDTH / 2 * this._data.scale + this._data.height)) / Constants.SCALE,(this._data.y + Math.sin(this._data.rotation - Math.PI / 2) * (this._data.HEIGHT / 2 * this._data.scale + this._data.height)) / Constants.SCALE);
         bbdef.type = b2Body.b2_staticBody;
         this._bound = PM.ins.world.CreateBody(bbdef);
         this._bound.SetUserData(this);
         var bShape:b2CircleShape = new b2CircleShape(5 / Constants.SCALE);
         var bFix:b2Fixture = this._bound.CreateFixture2(bShape,5);
         bFix.SetSensor(true);
         bFix.SetFilterData(filterData);
         revJointDef = new b2RevoluteJointDef();
         var ropeWidth:Number = 4 * this._data.scale;
         ropeHeight = 20 * this._data.scale;
         last = this._bound;
         var numberOfLinks:int = Math.ceil(this._data.height / ropeHeight);
         for(var i:int = 0; i < numberOfLinks; i++)
         {
            bdef = new b2BodyDef();
            bdef.position = new b2Vec2((this._data.x + Math.cos(this._data.rotation - Math.PI / 2) * (this._data.WIDTH / 2 * this._data.scale + this._data.height - (i + 0.5) * ropeHeight)) / Constants.SCALE,(this._data.y + Math.sin(this._data.rotation - Math.PI / 2) * (this._data.HEIGHT / 2 * this._data.scale + this._data.height - (i + 0.5) * ropeHeight)) / Constants.SCALE);
            bdef.type = b2Body.b2_dynamicBody;
            body = PM.ins.world.CreateBody(bdef);
            body.SetUserData(this);
            body.SetAngle(this._data.rotation);
            this._bodies.push(body);
            shape = new b2PolygonShape();
            shape.SetAsBox(ropeWidth / 2 / Constants.SCALE,ropeHeight / 2 / Constants.SCALE);
            fix = body.CreateFixture2(shape,5);
            fix.SetSensor(true);
            fix.SetUserData(ROPE);
            fix.SetFilterData(filterData);
            anchor = body.GetWorldCenter();
            anchor.x += ropeHeight / 2 / Constants.SCALE * Math.cos(this._data.rotation - Math.PI / 2);
            anchor.y += ropeHeight / 2 / Constants.SCALE * Math.sin(this._data.rotation - Math.PI / 2);
            revJointDef.Initialize(last,body,anchor);
            revJointDef.collideConnected = false;
            link = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
            this._links.push(link);
            last = body;
         }
         var cbdef:b2BodyDef = new b2BodyDef();
         cbdef.type = b2Body.b2_dynamicBody;
         cbdef.position = new b2Vec2((this._data.x + Math.cos(this._data.rotation - Math.PI / 2) * (this._data.height - numberOfLinks * ropeHeight)) / Constants.SCALE,(this._data.y + Math.sin(this._data.rotation - Math.PI / 2) * (this._data.height - numberOfLinks * ropeHeight)) / Constants.SCALE);
         _body = PM.ins.world.CreateBody(cbdef);
         _body.SetUserData(this);
         _body.SetAngle(this._data.rotation);
         var cShape:b2PolygonShape = new b2PolygonShape();
         cShape.SetAsArray([new b2Vec2(0,-this._data.HEIGHT / 2 / Constants.SCALE),new b2Vec2(this._data.WIDTH / 2 / Constants.SCALE,this._data.HEIGHT / 2 / Constants.SCALE),new b2Vec2(-this._data.WIDTH / 2 / Constants.SCALE,this._data.HEIGHT / 2 / Constants.SCALE)],3);
         var cFix:b2Fixture = _body.CreateFixture2(cShape,5);
         cFix.SetFriction(0.7);
         cFix.SetFilterData(filterData);
         anchor = _body.GetWorldCenter();
         anchor.x += this._data.HEIGHT / 2 * this._data.scale / Constants.SCALE * Math.cos(this._data.rotation - Math.PI / 2);
         anchor.y += this._data.HEIGHT / 2 * this._data.scale / Constants.SCALE * Math.sin(this._data.rotation - Math.PI / 2);
         revJointDef.Initialize(last,_body,anchor);
         revJointDef.collideConnected = false;
         this._lampLink = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
         _costume = new MC_Lamp();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation * Math.PI / 2;
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
         this._linkCostume.graphics.lineStyle(this._data.scale * 2,0);
         for(var i:int = 0; i < this._links.length; i++)
         {
            this._linkCostume.graphics.moveTo(this._links[i].GetBodyA().GetPosition().x * Constants.SCALE,this._links[i].GetBodyA().GetPosition().y * Constants.SCALE);
            this._linkCostume.graphics.lineTo(this._links[i].GetBodyB().GetPosition().x * Constants.SCALE,this._links[i].GetBodyB().GetPosition().y * Constants.SCALE);
         }
         this._linkCostume.graphics.moveTo(this._lampLink.GetBodyA().GetPosition().x * Constants.SCALE,this._lampLink.GetBodyA().GetPosition().y * Constants.SCALE);
         this._linkCostume.graphics.lineTo(this._lampLink.GetAnchorA().x * Constants.SCALE,this._lampLink.GetAnchorA().y * Constants.SCALE);
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
      
      public function get data() : DO_LampData
      {
         return this._data;
      }
   }
}
