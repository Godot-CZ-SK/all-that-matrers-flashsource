package design.data
{
   import flash.display.Graphics;
   
   public class DO_UOData extends DO_PathObjectData
   {
      
      public static const UFO:String = "Ufo";
      
      public static const UMO:String = "Umo";
      
      public static const EMPTY:String = "Empty";
       
      
      public var radius:Number;
      
      public var density:Number;
      
      public var min_radius:Number;
      
      public var max_radius:Number;
      
      public var uoType:String;
      
      public const SIZE:Number = 30;
      
      public function DO_UOData(uoType:String = "Empty")
      {
         this.uoType = uoType;
         this.min_radius = 5;
         this.max_radius = 25;
         this.radius = 15;
         super(TYPE_UO);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_UOData = new DO_UOData(this.uoType);
         result.x = x;
         result.y = y;
         result.radius = this.radius;
         result.density = this.density;
         result.speed = speed;
         result.path = path.clone();
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.uoType + ";" + x.toString() + ";" + y.toString() + ";" + this.radius.toString() + ";" + this.density.toString() + ";" + speed.toString() + ";" + path.convertToString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 8)
         {
            return false;
         }
         type = data[0];
         this.uoType = data[1];
         x = Number(data[2]);
         y = Number(data[3]);
         this.radius = Number(data[4]);
         this.density = Number(data[5]);
         speed = Number(data[6]);
         path.loadFromString(data[7]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(4473924,1);
         g.drawCircle(this.x * s,this.y * s,this.radius * s);
      }
   }
}
