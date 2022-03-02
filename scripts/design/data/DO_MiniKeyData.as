package design.data
{
   public class DO_MiniKeyData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var radius:Number;
      
      public var scale:Number;
      
      public function DO_MiniKeyData()
      {
         super(TYPE_MINI_KEY);
         this.x = 0;
         this.y = 0;
         this.radius = 3;
         this.scale = 1;
      }
   }
}
