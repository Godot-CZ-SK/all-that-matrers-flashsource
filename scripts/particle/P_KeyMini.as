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
   import design.data.DO_MiniKeyData;
   import flash.display.MovieClip;
   import game.GameCamera;
   import managers.PM;
   import particle.units.P_Unit;
   
   public class P_KeyMini extends Particle
   {
      
      public static const MAIN:String = "mini_key_main";
       
      
      protected var _links:Vector.<b2RevoluteJoint>;
      
      protected var _bodies:Vector.<b2Body>;
      
      protected var _bounded:P_Unit;
      
      protected var _data:DO_MiniKeyData;
      
      protected var _linkCostume:MovieClip;
      
      public function P_KeyMini(layerNo:int, data:DO_MiniKeyData, bounded:P_Unit)
      {
         super(layerNo);
         this._data = data;
         this._bounded = bounded;
      }
      
      override public function create() : void
      {
         var revJointDef:b2RevoluteJointDef = null;
         var filterData:b2FilterData = null;
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
         this._data.x += this._bounded.body.GetPosition().x * Constants.SCALE;
         this._data.y += this._bounded.body.GetPosition().y * Constants.SCALE;
         revJointDef = new b2RevoluteJointDef();
         var ropeWidth:Number = 4 * this._data.scale;
         var ropeHeight:Number = 1 * this._data.scale;
         var last:b2Body = this._bounded.body;
         filterData = new b2FilterData();
         filterData.categoryBits = 2;
         filterData.maskBits = ~2;
         for(var i:int = 0; i < 6; i++)
         {
            bdef = new b2BodyDef();
            bdef.position = new b2Vec2(this._data.x / Constants.SCALE + ropeWidth / Constants.SCALE * (i + 0.5),this._data.y / Constants.SCALE);
            bdef.type = b2Body.b2_dynamicBody;
            body = PM.ins.world.CreateBody(bdef);
            body.SetUserData(this);
            this._bodies.push(body);
            shape = new b2PolygonShape();
            shape.SetAsBox(ropeWidth / 2 / Constants.SCALE,ropeHeight / 2 / Constants.SCALE);
            fix = body.CreateFixture2(shape,5);
            fix.SetSensor(true);
            fix.SetFilterData(filterData);
            anchor = body.GetWorldCenter();
            anchor.x -= ropeWidth / 2 / Constants.SCALE;
            revJointDef.Initialize(last,body,anchor);
            revJointDef.collideConnected = false;
            link = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
            this._links.push(link);
            last = body;
         }
         var cbdef:b2BodyDef = new b2BodyDef();
         cbdef.type = b2Body.b2_dynamicBody;
         cbdef.position = new b2Vec2(this._data.x / Constants.SCALE + 5.5 * ropeWidth / Constants.SCALE + this._data.radius / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(cbdef);
         _body.SetUserData(this);
         var cShape:b2CircleShape = new b2CircleShape(this._data.radius * this._data.scale / Constants.SCALE);
         var cFix:b2Fixture = _body.CreateFixture2(cShape,3);
         cFix.SetFriction(0.7);
         cFix.SetFilterData(filterData);
         var cAnchor:b2Vec2 = _body.GetWorldCenter();
         cAnchor.x -= this._data.radius * this._data.scale / Constants.SCALE;
         revJointDef.Initialize(last,_body,_body.GetWorldCenter());
         revJointDef.collideConnected = false;
         var clink:b2RevoluteJoint = PM.ins.world.CreateJoint(revJointDef) as b2RevoluteJoint;
         this._links.push(clink);
         _costume = new MC_KeyMini();
         GameCamera.ins.addChildTo(_costume,GameCamera.MINI_KEY);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         this._linkCostume = new MovieClip();
         GameCamera.ins.addChildTo(this._linkCostume,GameCamera.MINI_KEY);
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
         this._linkCostume.graphics.lineStyle(1,5592405);
         for(var i:int = 0; i < this._links.length; i++)
         {
            this._linkCostume.graphics.moveTo(this._links[i].GetBodyA().GetPosition().x * Constants.SCALE,this._links[i].GetBodyA().GetPosition().y * Constants.SCALE);
            this._linkCostume.graphics.lineTo(this._links[i].GetBodyB().GetPosition().x * Constants.SCALE,this._links[i].GetBodyB().GetPosition().y * Constants.SCALE);
         }
         _body.SetAngularVelocity(_body.GetAngularVelocity() * 0.6);
         super.update();
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Door)
         {
            if((p as P_Door).isOpened)
            {
               return;
            }
            (p as P_Door).open();
            safeRemove();
            this._bounded.removeKey();
         }
         super.preHit(p,b,angle,selfData,targetData);
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
         CF.removeDisplayObject(_costume);
         CF.removeDisplayObject(this._linkCostume);
         super.remove();
      }
      
      public function get data() : DO_MiniKeyData
      {
         return this._data;
      }
   }
}
