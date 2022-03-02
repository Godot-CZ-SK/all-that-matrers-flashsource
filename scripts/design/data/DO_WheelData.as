package design.data
{
   public class DO_WheelData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public const RADIUS:Number = 10;
      
      public function DO_WheelData()
      {
         super(TYPE_WHEEL);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_WheelData = new DO_WheelData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 4)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         return true;
      }
   }
}
