package design.data
{
   public class DO_PathObjectData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var path:DO_Path;
      
      public var speed:Number;
      
      public function DO_PathObjectData(type:String = "path_object")
      {
         this.path = new DO_Path();
         this.x = 0;
         this.y = 0;
         this.speed = 2.5;
         super(type);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PathObjectData = new DO_PathObjectData(type);
         result.x = this.x;
         result.y = this.y;
         result.path = this.path.clone();
         result.speed = this.speed;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.speed.toString() + ";" + this.path.convertToString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 5)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.speed = Number(data[3]);
         this.path.loadFromString(data[4]);
         return true;
      }
   }
}
