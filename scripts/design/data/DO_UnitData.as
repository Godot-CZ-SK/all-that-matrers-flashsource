package design.data
{
   import flash.display.Graphics;
   
   public class DO_UnitData extends DO_CircleData
   {
      
      public static const DAD:String = "Dad";
      
      public static const MOM:String = "Mom";
      
      public static const ELDER:String = "Elder";
      
      public static const KID:String = "Kid";
      
      public static const BABY:String = "Baby";
      
      public static const EMPTY:String = "Empty";
       
      
      public const SIZE:Number = 30;
      
      public var unitType:String;
      
      public var rotation:Number;
      
      public function DO_UnitData(unitType:String = "Empty")
      {
         this.unitType = unitType;
         super(TYPE_UNIT);
         min_radius = 10;
         max_radius = 30;
         radius = 20;
         this.rotation = 0;
         if(unitType == DAD || unitType == MOM || unitType == ELDER)
         {
            radius = 20;
         }
         else if(unitType == BABY)
         {
            radius = 15;
         }
         else if(unitType == KID)
         {
            radius = 18;
         }
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_UnitData = null;
         result = new DO_UnitData(this.unitType);
         result.x = x;
         result.y = y;
         result.radius = radius;
         result.density = density;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.unitType + ";" + x.toString() + ";" + y.toString() + ";" + radius.toString() + ";" + density.toString() + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 6 && data.length != 7)
         {
            return false;
         }
         type = data[0];
         this.unitType = data[1];
         x = Number(data[2]);
         y = Number(data[3]);
         radius = Number(data[4]);
         density = Number(data[5]);
         if(data.length == 6)
         {
            this.rotation = 0;
         }
         else
         {
            this.rotation = data[6];
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(16304263,1);
         g.drawCircle(this.x * s,this.y * s,this.radius * s);
      }
   }
}
