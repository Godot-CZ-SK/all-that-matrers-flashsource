package design.data
{
   import flash.display.Graphics;
   
   public class DO_PistonPlateData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public const WIDTH:Number = 40;
      
      public const HEIGHT:Number = 10;
      
      public function DO_PistonPlateData()
      {
         super(TYPE_PISTON_PLATE);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PistonPlateData = new DO_PistonPlateData();
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
         if(data.length != 4 && data.length != 5)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         if(data.length == 4)
         {
            this.rotation = 0;
         }
         else
         {
            this.rotation = Number(data[4]);
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(4928300,1);
         drawRotatedRectangle(s,g,this.x + this.WIDTH * this.scale / 2,this.y + this.HEIGHT * this.scale / 2,this.WIDTH * this.scale,this.HEIGHT * this.scale,this.rotation / 180 * Math.PI);
      }
   }
}
