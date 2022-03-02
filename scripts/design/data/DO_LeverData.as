package design.data
{
   public class DO_LeverData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var color:int;
      
      public var pulled:int;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public const SIZE:Number = 30;
      
      public function DO_LeverData()
      {
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.color = DO_Color.RED;
         this.pulled = 0;
         super(TYPE_LEVER);
         this.min_scale = 0.5;
         this.max_scale = 1.5;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_LeverData = new DO_LeverData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.color = this.color;
         result.pulled = this.pulled;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.color.toString() + ";" + this.pulled.toString();
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
         this.color = int(data[4]);
         this.pulled = int(data[5]);
         return true;
      }
   }
}
