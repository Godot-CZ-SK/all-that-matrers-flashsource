package design.data
{
   public class DO_ThingData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var thingType:int;
      
      public function DO_ThingData()
      {
         super(TYPE_THING);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
         this.thingType = 1;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_ThingData = new DO_ThingData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.thingType = this.thingType;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.rotation.toString() + ";" + this.thingType.toString();
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
         this.thingType = int(data[5]);
         return true;
      }
   }
}
