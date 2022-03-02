package design.data
{
   import flash.display.Graphics;
   
   public class DO_BouncerData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var power:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public var min_power:Number;
      
      public var max_power:Number;
      
      public const WIDTH:Number = 40;
      
      public const HEIGHT:Number = 35;
      
      public function DO_BouncerData()
      {
         super(TYPE_BOUNCER);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.power = 100;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         this.min_power = 50;
         this.max_power = 200;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_BouncerData = new DO_BouncerData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.power = this.power;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.power.toString();
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
         this.power = Number(data[4]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         var w:Number = this.WIDTH * this.scale * s;
         var h:Number = this.HEIGHT * this.scale * s;
         g.beginFill(5726533,1);
         g.drawRect(this.x * s - w / 2,this.y * s - h / 2,w,h);
      }
   }
}
