package design.data
{
   import flash.geom.Point;
   
   public class DO_Path
   {
      
      public static const CIRCULAR:String = "circular";
      
      public static const LINE:String = "line";
       
      
      public var style:String;
      
      public var waypoints:Vector.<Point>;
      
      public function DO_Path(style:String = "line")
      {
         super();
         this.style = style;
         this.waypoints = new Vector.<Point>();
      }
      
      public function clear() : void
      {
         this.waypoints = new Vector.<Point>();
      }
      
      public function clone() : DO_Path
      {
         var result:DO_Path = new DO_Path(this.style);
         for(var i:int = 0; i < this.waypoints.length; i++)
         {
            result.waypoints.push(this.waypoints[i].clone());
         }
         return result;
      }
      
      public function convertToString() : String
      {
         var result:String = this.style;
         for(var i:int = 0; i < this.waypoints.length; i++)
         {
            result += "|" + this.waypoints[i].x + "," + this.waypoints[i].y;
         }
         return result;
      }
      
      public function loadFromString(data:String) : Boolean
      {
         var poiString:String = null;
         var poiArr:Array = null;
         var poi:Point = null;
         var arr:Array = data.split("|");
         this.style = arr[0];
         this.waypoints = new Vector.<Point>();
         for(var i:int = 1; i < arr.length; i++)
         {
            poiString = arr[i];
            poiArr = poiString.split(",");
            poi = new Point(Number(poiArr[0]),Number(poiArr[1]));
            this.waypoints.push(poi);
         }
         return true;
      }
   }
}
