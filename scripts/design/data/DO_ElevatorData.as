package design.data
{
   public class DO_ElevatorData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var speed:Number;
      
      public var elevatorType:int;
      
      public var pos1:Number;
      
      public var pos2:Number;
      
      public var scale:Number;
      
      public function DO_ElevatorData()
      {
         super(TYPE_ELEVATOR);
         this.speed = 2.5;
         this.scale = 1;
         this.elevatorType = 1;
         this.pos1 = 0;
         this.pos2 = 100;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_ElevatorData = new DO_ElevatorData();
         result.x = this.x;
         result.y = this.y;
         result.speed = this.speed;
         result.scale = this.scale;
         result.elevatorType = this.elevatorType;
         result.pos1 = this.pos1;
         result.pos2 = this.pos2;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.speed.toString() + ";" + this.scale.toString() + ";" + this.elevatorType.toString() + ";" + this.pos1.toString() + ";" + this.pos2.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 8)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.speed = Number(data[3]);
         this.scale = Number(data[4]);
         this.elevatorType = int(data[5]);
         this.pos1 = Number(data[6]);
         this.pos2 = Number(data[7]);
         return true;
      }
   }
}
