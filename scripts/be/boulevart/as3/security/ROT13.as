package be.boulevart.as3.security
{
   public class ROT13
   {
      
      protected static var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMabcdefghijklmnopqrstuvwxyzabcdefghijklm";
       
      
      public function ROT13()
      {
         super();
      }
      
      public static function calculate(src:String) : String
      {
         var character:String = null;
         var pos:Number = NaN;
         var calculated:String = new String("");
         for(var i:Number = 0; i < src.length; i++)
         {
            character = src.charAt(i);
            pos = chars.indexOf(character);
            if(pos > -1)
            {
               character = chars.charAt(pos + 13);
            }
            calculated += character;
         }
         return calculated;
      }
   }
}
