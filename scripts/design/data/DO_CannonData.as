package design.data
{
   import flash.display.Graphics;
   
   public class DO_CannonData extends DO_RotatorData
   {
       
      
      public var scale:Number;
      
      public var color:int;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public const SIZE:Number = 30;
      
      public function DO_CannonData()
      {
         super(TYPE_CANNON);
         this.color = DO_Color.RED;
         this.scale = 1;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         min_angle = -Math.PI;
         max_angle = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_CannonData = new DO_CannonData();
         result.x = x;
         result.y = y;
         result.map = map.clone();
         result.speed = speed;
         result.rotation = rotation;
         result.scale = this.scale;
         result.color = this.color;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + x.toString() + ";" + y.toString() + ";" + speed.toString() + ";" + rotation.toString() + ";" + this.scale.toString() + ";" + this.color.toString() + ";" + map.convertToString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 8)
         {
            return false;
         }
         type = data[0];
         x = Number(data[1]);
         y = Number(data[2]);
         speed = Number(data[3]);
         rotation = Number(data[4]);
         this.scale = Number(data[5]);
         this.color = int(data[6]);
         map.loadFromString(data[7]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(7563072,1);
         g.drawCircle(x * s,y * s,this.SIZE * this.scale * s);
      }
   }
}
