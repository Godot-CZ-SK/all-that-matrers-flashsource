package design.data
{
   import flash.display.Graphics;
   
   public class DO_TrapData extends DO_Data
   {
      
      public static const FIRE:String = "Fire";
      
      public static const SPIKE:String = "Spike";
      
      public static const EMPTY:String = "Empty";
       
      
      public var trapType:String;
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var count:int;
      
      public var density:Number;
      
      public var rotation:Number;
      
      public const WIDTH:Number = 15;
      
      public const HEIGHT:Number = 20;
      
      public function DO_TrapData(trapType:String = "Empty")
      {
         this.trapType = trapType;
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.count = 1;
         this.density = 1;
         this.rotation = 0;
         super(TYPE_TRAP);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_TrapData = new DO_TrapData(this.trapType);
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.count = this.count;
         result.density = this.density;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.trapType + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.count.toString() + ";" + this.density.toString() + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 7 && data.length != 8)
         {
            return false;
         }
         type = data[0];
         this.trapType = data[1];
         this.x = Number(data[2]);
         this.y = Number(data[3]);
         this.scale = Number(data[4]);
         this.count = int(data[5]);
         this.density = Number(data[6]);
         if(data.length == 7)
         {
            this.rotation = 0;
         }
         else
         {
            this.rotation = Number(data[7]);
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(10040115,1);
         var w:Number = 15 * this.count;
         var h:Number = 15;
         var rot:Number = this.rotation * Math.PI / 180;
         drawRotatedRectangle(s,g,this.x + w / 2 * Math.cos(rot) - h / 2 * Math.sin(rot),this.y + w / 2 * Math.sin(rot) + h / 2 * Math.cos(rot),w,h,this.rotation * Math.PI / 180);
      }
   }
}
