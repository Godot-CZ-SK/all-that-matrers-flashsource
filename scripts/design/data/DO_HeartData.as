package design.data
{
   import flash.display.Graphics;
   
   public class DO_HeartData extends DO_CircleData
   {
       
      
      public const SIZE:Number = 20;
      
      public var time:int;
      
      public function DO_HeartData()
      {
         super(TYPE_HEART);
         radius = 10;
         min_radius = 5;
         max_radius = 15;
         this.time = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_HeartData = new DO_HeartData();
         result.x = x;
         result.y = y;
         result.radius = radius;
         result.density = density;
         result.time = this.time;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + x.toString() + ";" + y.toString() + ";" + radius.toString() + ";" + density.toString() + ";" + this.time.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(!(data.length == 5 || data.length == 6))
         {
            return false;
         }
         type = data[0];
         x = Number(data[1]);
         y = Number(data[2]);
         radius = Number(data[3]);
         density = Number(data[4]);
         if(data.length == 6)
         {
            this.time = int(data[5]);
         }
         else
         {
            this.time = 0;
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(14483456,1);
         g.drawCircle(this.x * s,this.y * s,this.radius * s);
      }
   }
}
