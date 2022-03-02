package design.data
{
   import flash.display.Graphics;
   
   public class DO_SeekerData extends DO_PathObjectData
   {
       
      
      public var scale:Number;
      
      public var density:Number;
      
      public const SIZE:Number = 20;
      
      public function DO_SeekerData()
      {
         this.scale = 1;
         super(TYPE_SEEKER);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_SeekerData = null;
         result = new DO_SeekerData();
         result.x = x;
         result.y = y;
         result.scale = this.scale;
         result.density = this.density;
         result.speed = speed;
         result.path = path.clone();
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + x.toString() + ";" + y.toString() + ";" + this.scale.toString() + ";" + this.density.toString() + ";" + speed.toString() + ";" + path.convertToString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 7)
         {
            return false;
         }
         type = data[0];
         x = Number(data[1]);
         y = Number(data[2]);
         this.scale = Number(data[3]);
         this.density = Number(data[4]);
         speed = Number(data[5]);
         path.loadFromString(data[6]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(8750957,1);
         g.drawCircle(this.x * s,this.y * s,this.scale * this.SIZE * s);
      }
   }
}
