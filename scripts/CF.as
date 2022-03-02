package
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class CF
   {
       
      
      public function CF()
      {
         super();
      }
      
      public static function removeDisplayObject(obj:DisplayObject) : void
      {
         var i:int = 0;
         if(obj is DisplayObjectContainer && !(obj is Loader))
         {
            i = (obj as DisplayObjectContainer).numChildren;
            while(i--)
            {
               removeDisplayObject((obj as DisplayObjectContainer).getChildAt(0));
            }
         }
         if(obj is Bitmap && (obj as Bitmap).bitmapData)
         {
            (obj as Bitmap).bitmapData.dispose();
         }
         if(obj is MovieClip)
         {
            (obj as MovieClip).stop();
         }
         if(obj && obj.parent)
         {
            obj.parent.removeChild(obj);
         }
         obj = null;
      }
      
      public static function openLink(address:String) : void
      {
         var urlRequest:URLRequest = new URLRequest(address);
         navigateToURL(urlRequest,"_blank");
      }
      
      public static function getRandomColor() : uint
      {
         return uint(Math.floor(256 * Math.random()) * 256 * 256 + Math.floor(256 * Math.random()) * 256 + Math.floor(256 * Math.random()));
      }
      
      public static function distance(poi1:Point, poi2:Point) : Number
      {
         return Math.sqrt((poi1.x - poi2.x) * (poi1.x - poi2.x) + (poi1.y - poi2.y) * (poi1.y - poi2.y));
      }
      
      public static function rotateAroundCenter(ob:*, angleDegrees:Number, ptRotationPoint:Point) : void
      {
         var m:Matrix = ob.transform.matrix;
         m.tx -= ptRotationPoint.x;
         m.ty -= ptRotationPoint.y;
         m.rotate(angleDegrees * (Math.PI / 180));
         m.tx += ptRotationPoint.x;
         m.ty += ptRotationPoint.y;
         ob.transform.matrix = m;
      }
      
      public static function dist(p1:Point, p2:Point) : Number
      {
         return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
      }
      
      public static function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Boolean = true) : Point
      {
         var ip:Point = null;
         var a1:Number = NaN;
         var a2:Number = NaN;
         var b1:Number = NaN;
         var b2:Number = NaN;
         var c1:Number = NaN;
         var c2:Number = NaN;
         a1 = B.y - A.y;
         b1 = A.x - B.x;
         c1 = B.x * A.y - A.x * B.y;
         a2 = F.y - E.y;
         b2 = E.x - F.x;
         c2 = F.x * E.y - E.x * F.y;
         var denom:Number = a1 * b2 - a2 * b1;
         if(denom == 0)
         {
            return null;
         }
         ip = new Point();
         ip.x = (b1 * c2 - b2 * c1) / denom;
         ip.y = (a2 * c1 - a1 * c2) / denom;
         if(as_seg)
         {
            if(Math.pow(ip.x - B.x,2) + Math.pow(ip.y - B.y,2) > Math.pow(A.x - B.x,2) + Math.pow(A.y - B.y,2))
            {
               return null;
            }
            if(Math.pow(ip.x - A.x,2) + Math.pow(ip.y - A.y,2) > Math.pow(A.x - B.x,2) + Math.pow(A.y - B.y,2))
            {
               return null;
            }
            if(Math.pow(ip.x - F.x,2) + Math.pow(ip.y - F.y,2) > Math.pow(E.x - F.x,2) + Math.pow(E.y - F.y,2))
            {
               return null;
            }
            if(Math.pow(ip.x - E.x,2) + Math.pow(ip.y - E.y,2) > Math.pow(E.x - F.x,2) + Math.pow(E.y - F.y,2))
            {
               return null;
            }
         }
         return ip;
      }
   }
}
