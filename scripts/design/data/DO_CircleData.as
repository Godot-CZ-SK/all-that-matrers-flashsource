package design.data
{
   import flash.display.Graphics;
   
   public class DO_CircleData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var radius:Number;
      
      public var density:Number;
      
      public var min_radius:Number;
      
      public var max_radius:Number;
      
      public function DO_CircleData(type:String = "circle")
      {
         this.x = 0;
         this.y = 0;
         this.radius = 1;
         this.density = 5;
         super(type);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_CircleData = new DO_CircleData(type);
         result.x = this.x;
         result.y = this.y;
         result.radius = this.radius;
         result.density = this.density;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.radius.toString() + ";" + this.density.toString();
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
         this.radius = Number(data[3]);
         this.density = Number(data[4]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(5609813,0.5);
         g.lineStyle(1,5609813,1);
         g.drawCircle(this.x * s,this.y * s,this.radius * s);
      }
   }
}
