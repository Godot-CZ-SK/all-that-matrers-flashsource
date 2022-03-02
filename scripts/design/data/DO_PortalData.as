package design.data
{
   import flash.display.Graphics;
   
   public class DO_PortalData extends DO_CircleData
   {
       
      
      public const SIZE:Number = 30;
      
      public function DO_PortalData()
      {
         super(TYPE_PORTAL);
         radius = 25;
         min_radius = 10;
         max_radius = 40;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PortalData = new DO_PortalData();
         result.x = x;
         result.y = y;
         result.radius = radius;
         result.density = density;
         return result;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(4728970,1);
         g.drawCircle(this.x * s,this.y * s,this.radius * s);
      }
   }
}
