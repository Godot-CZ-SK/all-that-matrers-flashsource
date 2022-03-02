package be.boulevart.as3.security
{
   public class Base64
   {
      
      protected static var base64chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
       
      
      public function Base64()
      {
         super();
      }
      
      public static function encode(src:String) : String
      {
         var chr1:Number = NaN;
         var chr2:Number = NaN;
         var chr3:Number = NaN;
         var enc1:Number = NaN;
         var enc2:Number = NaN;
         var enc3:Number = NaN;
         var enc4:Number = NaN;
         var i:Number = 0;
         var output:String = new String("");
         while(i < src.length)
         {
            chr1 = src.charCodeAt(i++);
            chr2 = src.charCodeAt(i++);
            chr3 = src.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = (chr1 & 3) << 4 | chr2 >> 4;
            enc3 = (chr2 & 15) << 2 | chr3 >> 6;
            enc4 = chr3 & 63;
            if(isNaN(chr2))
            {
               enc3 = enc4 = 64;
            }
            else if(isNaN(chr3))
            {
               enc4 = 64;
            }
            output += base64chars.charAt(enc1) + base64chars.charAt(enc2);
            output += base64chars.charAt(enc3) + base64chars.charAt(enc4);
         }
         return output;
      }
      
      public static function decode(src:String) : String
      {
         var chr1:Number = NaN;
         var chr2:Number = NaN;
         var chr3:Number = NaN;
         var enc1:Number = NaN;
         var enc2:Number = NaN;
         var enc3:Number = NaN;
         var enc4:Number = NaN;
         var i:Number = 0;
         var output:String = new String("");
         while(i < src.length)
         {
            enc1 = base64chars.indexOf(src.charAt(i++));
            enc2 = base64chars.indexOf(src.charAt(i++));
            enc3 = base64chars.indexOf(src.charAt(i++));
            enc4 = base64chars.indexOf(src.charAt(i++));
            chr1 = enc1 << 2 | enc2 >> 4;
            chr2 = (enc2 & 15) << 4 | enc3 >> 2;
            chr3 = (enc3 & 3) << 6 | enc4;
            output += String.fromCharCode(chr1);
            if(enc3 != 64)
            {
               output += String.fromCharCode(chr2);
            }
            if(enc4 != 64)
            {
               output += String.fromCharCode(chr3);
            }
         }
         return output;
      }
   }
}
