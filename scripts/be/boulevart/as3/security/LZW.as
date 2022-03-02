package be.boulevart.as3.security
{
   public class LZW
   {
       
      
      public function LZW()
      {
         super();
      }
      
      public static function compress(src:String) : String
      {
         var xstr:String = null;
         var current:String = null;
         var chars:Number = 256;
         var original:String = src;
         var dict:Array = new Array();
         var i:Number = 0;
         for(i = 0; i < chars; dict[String(i)] = i,i++)
         {
         }
         var result:String = new String("");
         var splitted:Array = original.split("");
         var buffer:Array = new Array();
         for(i = 0; i <= splitted.length; i++)
         {
            current = splitted[i];
            if(buffer.length == 0)
            {
               xstr = String(current.charCodeAt(0));
            }
            else
            {
               xstr = buffer.join("-") + "-" + String(current.charCodeAt(0));
            }
            if(dict[xstr] !== undefined)
            {
               buffer.push(current.charCodeAt(0));
            }
            else
            {
               result += String.fromCharCode(dict[buffer.join("-")]);
               dict[xstr] = chars;
               chars++;
               buffer = new Array();
               buffer.push(current.charCodeAt(0));
            }
         }
         return result;
      }
      
      public static function decompress(src:String) : String
      {
         var i:Number = NaN;
         var c:String = null;
         var code:Number = NaN;
         var current:String = null;
         var chars:Number = 256;
         var dict:Array = new Array();
         for(i = 0; i < chars; i++)
         {
            c = String.fromCharCode(i);
            dict[i] = c;
         }
         var original:String = src;
         var splitted:Array = original.split("");
         var buffer:String = new String("");
         var chain:String = new String("");
         var result:String = new String("");
         for(i = 0; i < splitted.length; i++)
         {
            code = original.charCodeAt(i);
            current = dict[code];
            if(buffer == "")
            {
               buffer = current;
               result += current;
            }
            else if(code <= 255)
            {
               result += current;
               chain = buffer + current;
               dict[chars] = chain;
               chars++;
               buffer = current;
            }
            else
            {
               chain = dict[code];
               if(chain == "")
               {
                  chain = buffer + buffer.slice(0,1);
               }
               result += chain;
               dict[chars] = buffer + chain.slice(0,1);
               chars++;
               buffer = chain;
            }
         }
         return result;
      }
   }
}
