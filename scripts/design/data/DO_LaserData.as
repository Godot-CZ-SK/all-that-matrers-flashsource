package design.data
{
   import flash.display.Graphics;
   
   public class DO_LaserData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var head_rot:Number;
      
      public var body_rot:Number;
      
      public var min_head_rot:Number;
      
      public var max_head_rot:Number;
      
      public var min_body_rot:Number;
      
      public var max_body_rot:Number;
      
      public var min_scale:Number;
      
      public var max_scale:Number;
      
      public const RADIUS:Number = 10;
      
      public function DO_LaserData()
      {
         super(TYPE_LASER);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.head_rot = 0;
         this.body_rot = 0;
         this.min_scale = 0.5;
         this.max_scale = 1.5;
         this.min_body_rot = -Math.PI;
         this.max_body_rot = Math.PI;
         this.min_head_rot = -Math.PI;
         this.max_head_rot = 0;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_LaserData = new DO_LaserData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.head_rot = this.head_rot;
         result.body_rot = this.body_rot;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.head_rot.toString() + ";" + this.body_rot;
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 6)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.head_rot = Number(data[4]);
         this.body_rot = Number(data[5]);
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         g.beginFill(12237462,1);
         g.drawCircle(this.x * s,this.y * s,this.RADIUS * this.scale * s);
      }
   }
}
