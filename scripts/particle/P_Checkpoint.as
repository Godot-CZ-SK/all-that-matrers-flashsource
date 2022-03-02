package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_CheckpointData;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import game.GameCamera;
   import game.GameSound;
   import managers.GM;
   import managers.PM;
   import managers.SM;
   import particle.units.P_Unit;
   
   public class P_Checkpoint extends Particle
   {
      
      public static const MAIN:String = "checkpoint_main";
       
      
      protected var _data:DO_CheckpointData;
      
      protected var _isActivated:Boolean;
      
      protected var _activeUnit:P_Unit;
      
      protected var _effect:MovieClip;
      
      public function P_Checkpoint(layerNo:int, data:DO_CheckpointData)
      {
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
         var s1:b2PolygonShape = new b2PolygonShape();
         s1.SetAsBox(20 / Constants.SCALE * this._data.scale,5 / Constants.SCALE * this._data.scale);
         var fix1:b2Fixture = _body.CreateFixture2(s1,1);
         fix1.SetUserData(MAIN);
         fix1.SetSensor(true);
         _costume = new MC_Checkpoint();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation;
      }
      
      public function activate(unit:P_Unit) : void
      {
         if(this._isActivated)
         {
            if(this._activeUnit == unit)
            {
               return;
            }
            CF.removeDisplayObject(this._effect);
            this._activeUnit = null;
         }
         GM.ins.cl.activateCheckpoint(this,unit);
         this._isActivated = true;
         this._activeUnit = unit;
         _costume.gotoAndStop("activated");
         var clName:String = getQualifiedClassName(unit.costume);
         var cl:Class = getDefinitionByName(clName) as Class;
         this._effect = new cl() as MovieClip;
         _costume.addChildAt(this._effect,0);
         this._effect.y = -25;
         this._effect.stop();
         this._effect.alpha = 0.15;
         SM.ins.playSound(GameSound.CHECKPOINT);
      }
      
      public function deactivate() : void
      {
         if(!this._isActivated)
         {
            return;
         }
         this._activeUnit = null;
         _costume.gotoAndStop("deactivated");
         CF.removeDisplayObject(this._effect);
      }
      
      override public function preHit(p:Particle, b:b2Body, angle:Number, selfData:String, targetData:String) : void
      {
         if(p is P_Unit)
         {
            this.activate(p as P_Unit);
         }
      }
      
      public function get data() : DO_CheckpointData
      {
         return this._data;
      }
      
      public function get isActivated() : Boolean
      {
         return this._isActivated;
      }
      
      public function get activeUnit() : P_Unit
      {
         return this._activeUnit;
      }
   }
}
