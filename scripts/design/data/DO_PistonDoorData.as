package design.data
{
   import flash.display.Graphics;
   
   public class DO_PistonDoorData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public const TOTAL_WIDTH:Number = 30;
      
      public const TOTAL_HEIGHT:Number = 130;
      
      public const MAIN_WIDTH:Number = 30;
      
      public const MAIN_HEIGHT:Number = 80;
      
      public const SLIDER_WIDTH:Number = 15;
      
      public const SLIDER_HEIGHT:Number = 70;
      
      public function DO_PistonDoorData()
      {
         super(TYPE_PISTON_DOOR);
         this.scale = 1;
         this.x = 0;
         this.y = 0;
         this.rotation = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PistonDoorData = new DO_PistonDoorData();
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
         var w:Number = this.TOTAL_WIDTH * this.scale;
         var h:Number = this.TOTAL_HEIGHT * this.scale;
         var rot:Number = this.rotation / 180 * Math.PI;
         g.beginFill(5790538,1);
         drawRotatedRectangle(s,g,this.x,this.y,w,h,rot);
      }
   }
}
