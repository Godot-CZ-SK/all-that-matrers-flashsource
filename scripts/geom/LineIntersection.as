package geom
{
   public class LineIntersection
   {
       
      
      public function LineIntersection()
      {
         super();
      }
      
      public static function doesIntersect(l1:Line, l2:Line) : Boolean
      {
         var h1:Number = NaN;
         var h2:Number = NaN;
         var c1:Number = NaN;
         var c2:Number = NaN;
         var denum:Number = (l2.y2 - l2.y1) * (l1.x2 - l1.x1) - (l2.x2 - l2.x1) * (l1.y2 - l1.y1);
         var uanum:Number = (l2.x2 - l2.x1) * (l1.y1 - l2.y1) - (l2.y2 - l2.y1) * (l1.x1 - l2.x1);
         var ubnum:Number = (l1.x2 - l1.x1) * (l1.y1 - l2.y1) - (l1.y2 - l1.y1) * (l1.x1 - l2.x1);
         if(denum == 0 && uanum == 0 && ubnum == 0)
         {
            if(l1.x1 == l1.x2)
            {
               h1 = Math.abs(l1.y1 - l1.y2);
               h2 = Math.abs(l2.y1 - l2.y2);
               c1 = (l1.y1 + l1.y2) / 2;
               c2 = (l2.y1 + l2.y2) / 2;
               if(Math.abs(c1 - c2) < (h1 + h2) / 2)
               {
                  return true;
               }
               return false;
            }
            h1 = Math.abs(l1.x1 - l1.x2);
            h2 = Math.abs(l2.x1 - l2.x2);
            c1 = (l1.x1 + l1.x2) / 2;
            c2 = (l2.x1 + l2.x2) / 2;
            if(Math.abs(c1 - c2) < (h1 + h2) / 2)
            {
               return true;
            }
            return false;
         }
         if(denum == 0)
         {
            return false;
         }
         var ua:Number = uanum / denum;
         var ub:Number = ubnum / denum;
         if(ua > 0 && ua < 1 && ub > 0 && ub < 1)
         {
            return true;
         }
         return false;
      }
   }
}
