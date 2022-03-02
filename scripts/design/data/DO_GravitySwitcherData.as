package design.data
{
   import flash.display.Graphics;
   
   public class DO_GravitySwitcherData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var hasFoot:Boolean;
      
      public var isSensor:Boolean;
      
      public const WIDTH:Number = 25;
      
      public const HEIGHT:Number = 25;
      
      public function DO_GravitySwitcherData()
      {
         super(TYPE_GRAVITY_SWITCHER);
         this.x = 0;
         this.y = 0;
         this.scale = 1;
         this.rotation = 0;
         this.hasFoot = false;
         this.isSensor = false;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_GravitySwitcherData = new DO_GravitySwitcherData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.rotation = this.rotation;
         result.hasFoot = this.hasFoot;
         result.isSensor = this.isSensor;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.rotation.toString() + ";" + this.hasFoot.toString() + ";" + this.isSensor.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 7)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.rotation = Number(data[4]);
         if(data[5] == "false")
         {
            this.hasFoot = false;
         }
         else
         {
            this.hasFoot = true;
         }
         if(data[6] == "false")
         {
            this.isSensor = false;
         }
         else
         {
            this.isSensor = true;
         }
         return true;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         var w:Number = this.WIDTH * s * this.scale;
         var h:Number = this.HEIGHT * s * this.scale;
         g.beginFill(5152843,1);
         g.drawRect(this.x * s - w / 2,this.y * s - h / 2,w,h);
      }
   }
}
