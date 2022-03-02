package geom
{
   import flash.geom.Point;
   
   public class Triangulator
   {
       
      
      public function Triangulator()
      {
         super();
      }
      
      public static function triangulatePolygon(v:Vector.<Point>) : Vector.<Triangle>
      {
         var earIndex:int = 0;
         var vNew:Vector.<Point> = null;
         var currDest:int = 0;
         var under:int = 0;
         var over:int = 0;
         var toAdd:Triangle = null;
         if(v.length < 3)
         {
            trace("Please make sure you have at least 3 vertices!");
            return null;
         }
         var i:int = 0;
         var vNum:int = v.length;
         var buffer:Vector.<Triangle> = new Vector.<Triangle>();
         var vTemp:Vector.<Point> = new Vector.<Point>();
         for(i = 0; i < v.length; i++)
         {
            vTemp.push(v[i].clone());
         }
         while(true)
         {
            if(vNum <= 3)
            {
               buffer.push(new Triangle(vTemp[1].x,vTemp[1].y,vTemp[2].x,vTemp[2].y,vTemp[0].x,vTemp[0].y));
               return buffer;
            }
            earIndex = -1;
            for(i = 0; i < vNum; i++)
            {
               if(isEar(i,vTemp))
               {
                  earIndex = i;
                  break;
               }
            }
            if(earIndex == -1)
            {
               break;
            }
            vNum--;
            vNew = new Vector.<Point>();
            currDest = 0;
            for(i = 0; i < vNum; i++)
            {
               if(currDest == earIndex)
               {
                  currDest++;
               }
               vNew.push(new Point(vTemp[currDest].x,vTemp[currDest].y));
               currDest++;
            }
            under = earIndex == 0 ? int(vTemp.length - 1) : int(earIndex - 1);
            over = earIndex == vTemp.length - 1 ? int(0) : int(earIndex + 1);
            toAdd = new Triangle(vTemp[earIndex].x,vTemp[earIndex].y,vTemp[over].x,vTemp[over].y,vTemp[under].x,vTemp[under].y);
            buffer.push(toAdd);
            vTemp = vNew;
         }
         return null;
      }
      
      public static function polygonizeTriangles(triangles:Vector.<Triangle>) : Vector.<Polygon>
      {
         var poly:Polygon = null;
         var newPoly:Polygon = null;
         if(!triangles || triangles.length == 0)
         {
            return null;
         }
         var polygons:Vector.<Polygon> = new Vector.<Polygon>();
         var i:int = 0;
         var j:int = 0;
         var covered:Array = new Array();
         for(i = 0; i < triangles.length; i++)
         {
            covered[i] = false;
         }
         var notDone:Boolean = true;
         for(i = 0; i < triangles.length; i++)
         {
            if(!covered[i])
            {
               poly = new Polygon(triangles[i].x,triangles[i].y);
               covered[i] = true;
               for(j = i + 1; j < triangles.length; j++)
               {
                  newPoly = poly.add(triangles[j]);
                  if(newPoly != null)
                  {
                     if(newPoly.isConvex())
                     {
                        poly = newPoly;
                        covered[j] = true;
                     }
                  }
               }
               polygons.push(poly);
            }
         }
         return polygons;
      }
      
      public static function isEar(i:int, v:Vector.<Point>) : Boolean
      {
         var dx0:Number = NaN;
         var dy0:Number = NaN;
         var dx1:Number = NaN;
         var dy1:Number = NaN;
         var upper:int = 0;
         var lower:int = 0;
         dx0 = dy0 = dx1 = dy1 = 0;
         if(i >= v.length || i < 0 || v.length < 3)
         {
            return false;
         }
         if(i + 1 == v.length)
         {
            upper = 0;
         }
         else
         {
            upper = i + 1;
         }
         if(i - 1 < 0)
         {
            lower = v.length - 1;
         }
         else
         {
            lower = i - 1;
         }
         dx0 = v[i].x - v[lower].x;
         dy0 = v[i].y - v[lower].y;
         dx1 = v[upper].x - v[i].x;
         dy1 = v[upper].y - v[i].y;
         var cross:Number = dx0 * dy1 - dx1 * dy0;
         if(cross > 0)
         {
            return false;
         }
         var myTri:Triangle = new Triangle(v[i].x,v[i].y,v[upper].x,v[upper].y,v[lower].x,v[lower].y);
         for(var j:int = 0; j < v.length; j++)
         {
            if(!(j == i || j == lower || j == upper))
            {
               if(myTri.isInside(v[j].x,v[j].y))
               {
                  return false;
               }
            }
         }
         return true;
      }
   }
}
