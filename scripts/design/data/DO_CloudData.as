package design.data
{
   public class DO_CloudData extends DO_Data
   {
       
      
      public var width:Number;
      
      public var height:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var min_size:Number;
      
      public function DO_CloudData()
      {
         super(TYPE_CLOUD);
         this.x = 0;
         this.y = 0;
         this.min_size = 5;
         this.width = this.min_size * 8;
         this.height = this.min_size * 2;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_CloudData = new DO_CloudData();
         result.x = this.x;
         result.y = this.y;
         result.width = this.width;
         result.height = this.height;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.width.toString() + ";" + this.height.toString();
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
         this.width = Number(data[3]);
         this.height = Number(data[4]);
         return true;
      }
   }
}
