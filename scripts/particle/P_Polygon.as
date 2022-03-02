package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import design.data.DO_PolyData;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import geom.Polygon;
   import managers.PM;
   
   public class P_Polygon extends Particle
   {
      
      public static const MAIN:String = "polygon_main";
       
      
      protected var _data:DO_PolyData;
      
      protected var _mask:Sprite;
      
      protected var _bitmapCostume:Bitmap;
      
      protected var _filterData:b2FilterData;
      
      public function P_Polygon(layerNo:int, data:DO_PolyData)
      {
         this._data = data;
         super(layerNo);
         setPhysicParams(1.2,0.4,0.1);
      }
      
      override public function create() : void
      {
         var i:int = 0;
         var j:int = 0;
         var midY:Number = NaN;
         var poly:b2PolygonShape = null;
         var vec:Vector.<b2Vec2> = null;
         var fix:b2Fixture = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         var midX:Number = 0;
         midY = 0;
         var polygons:Vector.<Polygon> = this._data.getPolygons();
         var count:int = 0;
         for(i = 0; i < polygons.length; i++)
         {
            count += polygons[i].x.length;
            for(j = 0; j < polygons[i].x.length; j++)
            {
               midX += polygons[i].x[j];
               midY += polygons[i].y[j];
            }
         }
         midX /= count;
         midY /= count;
         var bodyDef:b2BodyDef = new b2BodyDef();
         bodyDef.position = new b2Vec2(midX / Constants.SCALE,midY / Constants.SCALE);
         if(this._data.polyType == DO_PolyData.OBSTACLE)
         {
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.fixedRotation = false;
         }
         else if(this._data.polyType == DO_PolyData.WALL)
         {
            bodyDef.type = b2Body.b2_staticBody;
         }
         _body = PM.ins.world.CreateBody(bodyDef);
         _body.SetUserData(this);
         for(i = 0; i < polygons.length; i++)
         {
            poly = new b2PolygonShape();
            vec = this.convertPointsToVec2(polygons[i].x,polygons[i].y,midX,midY);
            poly.SetAsVector(vec,vec.length);
            fix = _body.CreateFixture2(poly,2.5);
            fix.SetUserData(MAIN);
            fix.SetRestitution(_restitution);
            fix.SetFriction(_friction);
            if(this._filterData)
            {
               fix.SetFilterData(this._filterData);
            }
         }
         this.drawCostume();
      }
      
      public function drawCostume() : void
      {
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(this._bitmapCostume);
         CF.removeDisplayObject(this._mask);
         super.remove();
      }
      
      private function convertPointsToVec2(xArr:Array, yArr:Array, xOffset:Number = 0, yOffset:Number = 0) : Vector.<b2Vec2>
      {
         var vec:b2Vec2 = null;
         var result:Vector.<b2Vec2> = new Vector.<b2Vec2>();
         for(var i:int = 0; i < xArr.length; i++)
         {
            vec = new b2Vec2((xArr[i] - xOffset) / Constants.SCALE,(yArr[i] - yOffset) / Constants.SCALE);
            result.push(vec);
         }
         return result;
      }
   }
}
