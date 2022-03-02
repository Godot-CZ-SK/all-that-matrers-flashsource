package be.boulevart.as3.security
{
   public class Goauld
   {
      
      public static var shiftValue:Number = 6;
       
      
      public function Goauld()
      {
         super();
      }
      
      public static function calculate(src:String) : String
      {
         var charCode:Number = NaN;
         var result:String = new String("");
         for(var i:Number = 0; i < src.length; i++)
         {
            charCode = src.substr(i,1).charCodeAt(0);
            result += String.fromCharCode(charCode ^ shiftValue);
         }
         return result;
      }
   }
}
