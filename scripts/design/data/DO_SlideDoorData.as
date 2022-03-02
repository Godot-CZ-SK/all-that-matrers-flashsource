package design.data
{
   import flash.display.Graphics;
   
   public class DO_SlideDoorData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public const WIDTH:Number = 20;
      
      public const HEIGHT:Number = 80;
      
      public function DO_SlideDoorData()
      {
         super(TYPE_SLIDE_DOOR);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_SlideDoorData = new DO_SlideDoorData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 4)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         var w:Number = this.WIDTH * s * this.scale;
         var h:Number = this.HEIGHT * s * this.scale;
         g.beginFill(7563072,1);
         g.drawRect(this.x * s - w / 2,this.y * s - h / 2,w,h);
      }
   }
}
