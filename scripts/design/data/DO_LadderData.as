package design.data
{
   import flash.display.Graphics;
   
   public class DO_LadderData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var count:int;
      
      public const WIDTH:Number = 40;
      
      public const HEIGHT:Number = 20;
      
      public const COUNT_MIN:int = 1;
      
      public function DO_LadderData()
      {
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.count = 1;
         super(TYPE_LADDER);
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_LadderData = new DO_LadderData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.count = this.count;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.count.toString();
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
         this.scale = Number(data[3]);
         this.count = int(data[4]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         var w:Number = this.WIDTH * s * this.scale;
         var h:Number = this.HEIGHT * s * this.scale * (this.count + 2);
         g.beginFill(5726533,1);
         g.drawRect(this.x * s,this.y * s,w,h);
      }
   }
}
