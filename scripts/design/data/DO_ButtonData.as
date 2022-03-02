package design.data
{
   import flash.display.Graphics;
   
   public class DO_ButtonData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public const RADIUS:Number = 15;
      
      public function DO_ButtonData()
      {
         super(TYPE_BUTTON);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_ButtonData = new DO_ButtonData();
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
         if(data.length != 5)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.rotation = Number(data[4]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(9932422,1);
         g.drawCircle(this.x * s,this.y * s,this.RADIUS * this.scale * s);
      }
   }
}
