package design.data
{
   import flash.display.Graphics;
   
   public class DO_PlatformData extends DO_PathObjectData
   {
      
      public static const CIRCULAR:String = "circular";
      
      public static const LINE:String = "line";
      
      public static const EMPTY:String = "empty";
       
      
      public var count:int;
      
      public var scale:Number;
      
      public var timeToWait:Number;
      
      public var density:Number;
      
      public var min_count:Number;
      
      public var max_count:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public const WIDTH:Number = 30;
      
      public const HEIGHT:Number = 30;
      
      public function DO_PlatformData(type:String = "platform")
      {
         super(type);
         this.density = 100;
         this.count = 0;
         this.min_count = 0;
         this.timeToWait = 0;
         this.max_count = 8;
         speed = 1;
         this.scale = 1;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PlatformData = null;
         result = new DO_PlatformData();
         result.x = x;
         result.y = y;
         result.count = this.count;
         result.scale = this.scale;
         result.density = this.density;
         result.speed = speed;
         result.path = path.clone();
         result.timeToWait = this.timeToWait;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + x.toString() + ";" + y.toString() + ";" + this.count.toString() + ";" + this.scale.toString() + ";" + this.density.toString() + ";" + speed.toString() + ";" + path.convertToString() + ";" + this.timeToWait.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 8 && data.length != 9)
         {
            return false;
         }
         type = data[0];
         x = Number(data[1]);
         y = Number(data[2]);
         this.count = Number(data[3]);
         this.scale = Number(data[4]);
         this.density = Number(data[5]);
         speed = Number(data[6]);
         path.loadFromString(data[7]);
         if(data.length == 9)
         {
            this.timeToWait = Number(data[8]);
         }
         else
         {
            this.timeToWait = 0;
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         var w:Number = this.WIDTH * s * this.scale * (this.count + 2);
         var h:Number = this.HEIGHT * s * this.scale;
         g.beginFill(5654322,1);
         g.drawRect(x * s - w / 2,y * s - h / 2,w,h);
      }
   }
}
