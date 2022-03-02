package design.data
{
   public class DO_CannonBallData extends DO_CircleData
   {
       
      
      public const SIZE:Number = 20;
      
      public var angle:Number;
      
      public var speed:Number;
      
      public var scale:Number;
      
      public function DO_CannonBallData()
      {
         super(TYPE_CANNON_BALL);
         radius = this.SIZE / 2;
         density = 5;
         this.scale = 1;
         this.speed = 3.5;
      }
   }
}
