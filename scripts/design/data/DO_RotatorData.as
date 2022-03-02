package design.data
{
   public class DO_RotatorData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var map:DO_RotationMap;
      
      public var speed:Number;
      
      public var rotation:Number;
      
      public var min_speed:Number;
      
      public var max_speed:Number;
      
      public var min_angle:Number;
      
      public var max_angle:Number;
      
      public function DO_RotatorData(type:String = "rotator")
      {
         this.map = new DO_RotationMap();
         this.x = 0;
         this.y = 0;
         this.rotation = 0;
         this.min_speed = 1;
         this.max_speed = 10;
         this.speed = 5;
         super(type);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_RotatorData = new DO_RotatorData(type);
         result.x = this.x;
         result.y = this.y;
         result.map = this.map.clone();
         result.speed = this.speed;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.speed.toString() + ";" + this.rotation.toString() + ";" + this.map.convertToString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 6)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.speed = Number(data[3]);
         this.rotation = Number(data[4]);
         this.map.loadFromString(data[5]);
         return true;
      }
   }
}
