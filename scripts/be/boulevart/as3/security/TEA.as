package be.boulevart.as3.security
{
   public class TEA
   {
       
      
      public function TEA()
      {
         super();
      }
      
      public static function encrypt(src:String, key:String) : String
      {
         var p:Number = NaN;
         var mx:Number = NaN;
         var e:Number = NaN;
         var v:Array = charsToLongs(strToChars(src));
         var k:Array = charsToLongs(strToChars(key));
         var n:Number = v.length;
         if(n == 0)
         {
            return "";
         }
         if(n == 1)
         {
            var _loc14_:* = n++;
            v[_loc14_] = 0;
         }
         var z:Number = v[n - 1];
         var y:Number = v[0];
         var delta:Number = 2654435769;
         var q:Number = Math.floor(6 + 52 / n);
         var sum:Number = 0;
         while(q-- > 0)
         {
            sum += delta;
            e = sum >>> 2 & 3;
            for(p = 0; p < n - 1; p++)
            {
               y = v[p + 1];
               mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
               z = v[p] = v[p] + mx;
            }
            y = v[0];
            mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
            z = v[n - 1] = v[n - 1] + mx;
         }
         return charsToHex(longsToChars(v));
      }
      
      public static function decrypt(src:String, key:String) : String
      {
         var p:Number = NaN;
         var mx:Number = NaN;
         var e:Number = NaN;
         var v:Array = charsToLongs(hexToChars(src));
         var k:Array = charsToLongs(strToChars(key));
         var n:Number = v.length;
         if(n == 0)
         {
            return "";
         }
         var z:Number = v[n - 1];
         var y:Number = v[0];
         var delta:Number = 2654435769;
         var q:Number = Math.floor(6 + 52 / n);
         var sum:Number = q * delta;
         while(sum != 0)
         {
            e = sum >>> 2 & 3;
            for(p = n - 1; p > 0; p--)
            {
               z = v[p - 1];
               mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
               y = v[p] = v[p] - mx;
            }
            z = v[n - 1];
            mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
            y = v[0] = v[0] - mx;
            sum -= delta;
         }
         return charsToStr(longsToChars(v));
      }
      
      protected static function charsToLongs(chars:Array) : Array
      {
         var temp:Array = new Array(Math.ceil(chars.length / 4));
         for(var i:Number = 0; i < temp.length; i++)
         {
            temp[i] = chars[i * 4] + (chars[i * 4 + 1] << 8) + (chars[i * 4 + 2] << 16) + (chars[i * 4 + 3] << 24);
         }
         return temp;
      }
      
      protected static function longsToChars(longs:Array) : Array
      {
         var codes:Array = new Array();
         for(var i:Number = 0; i < longs.length; i++)
         {
            codes.push(longs[i] & 255,longs[i] >>> 8 & 255,longs[i] >>> 16 & 255,longs[i] >>> 24 & 255);
         }
         return codes;
      }
      
      protected static function charsToHex(chars:Array) : String
      {
         var result:String = new String("");
         var hexes:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
         for(var i:Number = 0; i < chars.length; i++)
         {
            result += hexes[chars[i] >> 4] + hexes[chars[i] & 15];
         }
         return result;
      }
      
      protected static function hexToChars(hex:String) : Array
      {
         var codes:Array = new Array();
         for(var i:Number = hex.substr(0,2) == "0x" ? Number(2) : Number(0); i < hex.length; i += 2)
         {
            codes.push(parseInt(hex.substr(i,2),16));
         }
         return codes;
      }
      
      protected static function charsToStr(chars:Array) : String
      {
         var result:String = new String("");
         for(var i:Number = 0; i < chars.length; i++)
         {
            result += String.fromCharCode(chars[i]);
         }
         return result;
      }
      
      protected static function strToChars(str:String) : Array
      {
         var codes:Array = new Array();
         for(var i:Number = 0; i < str.length; i++)
         {
            codes.push(str.charCodeAt(i));
         }
         return codes;
      }
   }
}
