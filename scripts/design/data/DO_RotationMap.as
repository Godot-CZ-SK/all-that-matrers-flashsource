package design.data
{
   public class DO_RotationMap
   {
      
      public static const CIRCULAR:String = "circular";
      
      public static const LINE:String = "line";
       
      
      public var angles:Vector.<Number>;
      
      public var style:String;
      
      public function DO_RotationMap(style:String = "line")
      {
         super();
         this.style = style;
         this.angles = new Vector.<Number>();
      }
      
      public function clear() : void
      {
         this.angles = new Vector.<Number>();
      }
      
      public function clone() : DO_RotationMap
      {
         var result:DO_RotationMap = new DO_RotationMap(this.style);
         for(var i:int = 0; i < this.angles.length; i++)
         {
            result.angles.push(this.angles[i]);
         }
         return result;
      }
      
      public function convertToString() : String
      {
         var result:String = this.style;
         for(var i:int = 0; i < this.angles.length; i++)
         {
            result += "|" + this.angles[i];
         }
         return result;
      }
      
      public function loadFromString(data:String) : Boolean
      {
         var angle:Number = NaN;
         var arr:Array = data.split("|");
         this.style = arr[0];
         this.angles = new Vector.<Number>();
         for(var i:int = 1; i < arr.length; i++)
         {
            angle = Number(arr[i]);
            this.angles.push(angle);
         }
         return true;
      }
   }
}
