package be.boulevart.as3.security
{
   public class Base8
   {
       
      
      public function Base8()
      {
         super();
      }
      
      public static function encode(src:String) : String
      {
         var result:String = new String("");
         for(var i:Number = 0; i < src.length; i++)
         {
            result += src.charCodeAt(i).toString(16);
         }
         return result;
      }
      
      public static function decode(src:String) : String
      {
         var result:String = new String("");
         for(var i:Number = 0; i < src.length; i += 2)
         {
            result += String.fromCharCode(parseInt(src.substr(i,2),16));
         }
         return result;
      }
   }
}
