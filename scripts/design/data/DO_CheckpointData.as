package design.data
{
   public class DO_CheckpointData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public function DO_CheckpointData()
      {
         super(TYPE_CHECKPOINT);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_CheckpointData = new DO_CheckpointData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.rotation = Number(data[4]);
         return true;
      }
   }
}
