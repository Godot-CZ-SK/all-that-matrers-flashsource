package design.data
{
   import flash.display.Graphics;
   
   public class DO_Data
   {
      
      public static const TYPE_CIRCLE:String = "circle";
      
      public static const TYPE_POLY:String = "polygon";
      
      public static const TYPE_UNIT:String = "unit";
      
      public static const TYPE_HEART:String = "heart";
      
      public static const TYPE_TRAP:String = "trap";
      
      public static const TYPE_PLATFORM:String = "platform";
      
      public static const TYPE_PORTAL:String = "portal";
      
      public static const TYPE_UO:String = "uo";
      
      public static const TYPE_PATH_OBJECT:String = "path_object";
      
      public static const TYPE_ROTATOR:String = "rotator";
      
      public static const TYPE_CANNON:String = "cannon";
      
      public static const TYPE_CANNON_BALL:String = "cannon_ball";
      
      public static const TYPE_LEVER:String = "lever";
      
      public static const TYPE_CLOUD:String = "cloud";
      
      public static const TYPE_DOOR:String = "door";
      
      public static const TYPE_KEY:String = "key";
      
      public static const TYPE_MINI_KEY:String = "mini_key";
      
      public static const TYPE_LAMP:String = "lamp";
      
      public static const TYPE_BOUNCER:String = "bouncer";
      
      public static const TYPE_BLOWER:String = "blower";
      
      public static const TYPE_LASER:String = "laser";
      
      public static const TYPE_LASER_BALL:String = "laser_ball";
      
      public static const TYPE_LADDER:String = "ladder";
      
      public static const TYPE_BUTTON:String = "button";
      
      public static const TYPE_SLIDE_DOOR:String = "slide_door";
      
      public static const TYPE_GRAVITY_SWITCHER:String = "gravity_switcher";
      
      public static const TYPE_WHEEL:String = "wheel";
      
      public static const TYPE_SEEKER:String = "seeker";
      
      public static const TYPE_PISTON_PLATE:String = "piston_plate";
      
      public static const TYPE_PISTON_DOOR:String = "piston_door";
      
      public static const TYPE_CHAIN:String = "chain";
      
      public static const TYPE_TEXT:String = "text";
      
      public static const TYPE_SIGN:String = "sign";
      
      public static const TYPE_STONE:String = "stone";
      
      public static const TYPE_FLOWER:String = "flower";
      
      public static const TYPE_THING:String = "thing";
      
      public static const TYPE_OTHERS:String = "others";
      
      public static const TYPE_ELEVATOR:String = "elevator";
      
      public static const TYPE_CHECKPOINT:String = "checkpoint";
       
      
      public var type:String;
      
      public function DO_Data(type:String)
      {
         super();
         this.type = type;
      }
      
      public static function drawRotatedRectangle(s:Number, g:Graphics, x:Number, y:Number, w:Number, h:Number, rot:Number) : void
      {
         var hw:Number = w / 2;
         var hh:Number = h / 2;
         var cos:Number = Math.cos(rot);
         var sin:Number = Math.sin(rot);
         var ltx:Number = x - hw * cos + hh * sin;
         var lty:Number = y - hw * sin - hh * cos;
         var rtx:Number = x + hw * cos + hh * sin;
         var rty:Number = y + hw * sin - hh * cos;
         var lbx:Number = x - hw * cos - hh * sin;
         var lby:Number = y - hw * sin + hh * cos;
         var rbx:Number = x + hw * cos - hh * sin;
         var rby:Number = y + hw * sin + hh * cos;
         g.moveTo(ltx * s,lty * s);
         g.lineTo(rtx * s,rty * s);
         g.lineTo(rbx * s,rby * s);
         g.lineTo(lbx * s,lby * s);
         g.lineTo(ltx * s,lty * s);
      }
      
      public function clear() : void
      {
      }
      
      public function convertToString() : String
      {
         return "";
      }
      
      public function loadFromArray(data:Array) : Boolean
      {
         return false;
      }
      
      public function clone() : DO_Data
      {
         return null;
      }
      
      public function debugDraw(scale:Number, g:Graphics) : void
      {
      }
   }
}
