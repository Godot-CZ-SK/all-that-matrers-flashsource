package design.data
{
   import flash.display.Graphics;
   
   public class DO_BlowerData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var power:Number;
      
      public var rotation:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public var min_power:Number;
      
      public var max_power:Number;
      
      public var max_distance:Number;
      
      public const RADIUS:Number = 13;
      
      public function DO_BlowerData()
      {
         super(TYPE_BLOWER);
         this.x = 0;
         this.y = 0;
         this.rotation = 0;
         this.scale = 1;
         this.power = 100;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         this.min_power = 50;
         this.max_power = 200;
         this.max_distance = 150;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_BlowerData = new DO_BlowerData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.power = this.power;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.power.toString() + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length == 5)
         {
            data.push(0);
         }
         if(data.length != 6)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.power = Number(data[4]);
         this.rotation = Number(data[5]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(6710886,1);
         g.drawCircle(this.x * s,this.y * s,this.RADIUS * this.scale * s);
      }
   }
}
