package design.data
{
   public class DO_LampData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var height:Number;
      
      public var rotation:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public var min_height:Number;
      
      public var max_height:Number;
      
      public const WIDTH:Number = 30;
      
      public const HEIGHT:Number = 30;
      
      public function DO_LampData()
      {
         super(TYPE_LAMP);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         this.min_height = 50;
         this.max_height = 250;
         this.height = 150;
         this.rotation = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_LampData = new DO_LampData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.height = this.height;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.height.toString() + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 5 && data.length != 6)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.height = Number(data[4]);
         if(data.length == 6)
         {
            this.rotation = Number(data[5]);
         }
         else
         {
            this.rotation = 0;
         }
         return true;
      }
   }
}
