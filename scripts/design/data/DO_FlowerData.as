package design.data
{
   public class DO_FlowerData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var flowerType:int;
      
      public var back:Boolean;
      
      public function DO_FlowerData()
      {
         super(TYPE_FLOWER);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
         this.flowerType = 1;
         this.back = false;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_FlowerData = new DO_FlowerData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.flowerType = this.flowerType;
         result.rotation = this.rotation;
         result.back = this.back;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.rotation.toString() + ";" + this.flowerType.toString() + ";" + this.back.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 6 && data.length != 7)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.rotation = Number(data[4]);
         this.flowerType = int(data[5]);
         if(data.length == 7)
         {
            if(data[6] == "false")
            {
               this.back = false;
            }
            else
            {
               this.back = true;
            }
         }
         else
         {
            this.back = false;
         }
         return true;
      }
   }
}
