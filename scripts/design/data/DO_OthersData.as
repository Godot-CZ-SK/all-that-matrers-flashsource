package design.data
{
   public class DO_OthersData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var othersType:int;
      
      public function DO_OthersData()
      {
         super(TYPE_OTHERS);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
         this.othersType = 1;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_OthersData = new DO_OthersData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.othersType = this.othersType;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.rotation.toString() + ";" + this.othersType.toString();
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
         this.scale = Number(data[3]);
         this.rotation = Number(data[4]);
         this.othersType = int(data[5]);
         return true;
      }
   }
}
