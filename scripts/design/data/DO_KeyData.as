package design.data
{
   import flash.display.Graphics;
   
   public class DO_KeyData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public const SIZE_X:Number = 25;
      
      public const SIZE_Y:Number = 15;
      
      public function DO_KeyData()
      {
         super(TYPE_KEY);
         this.scale = 1;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         this.x = 0;
         this.y = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_KeyData = new DO_KeyData();
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
         var w:Number = this.SIZE_X * s * this.scale;
         var h:Number = this.SIZE_Y * s * this.scale;
         g.beginFill(7563072,1);
         g.drawRect(this.x * s - w / 2,this.y * s - h / 2,w,h);
      }
   }
}
