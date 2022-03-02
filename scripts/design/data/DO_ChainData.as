package design.data
{
   public class DO_ChainData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var height:Number;
      
      public const RADIUS:Number = 4;
      
      public function DO_ChainData()
      {
         super(TYPE_CHAIN);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.height = 100;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_ChainData = new DO_ChainData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.height = this.height;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.height.toString();
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
         this.scale = Number(data[3]);
         this.height = Number(data[4]);
         return true;
      }
   }
}
