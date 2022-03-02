package Playtomic
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   final class Encode
   {
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      private static const decodeChars:Array = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1];
      
      private static var crcTable:Array;
      
      private static var crcTableComputed:Boolean = false;
      
      private static var hex_chr:String = "0123456789abcdef";
       
      
      function Encode()
      {
         super();
      }
      
      static function Base64(data:ByteArray) : String
      {
         var dataBuffer:Array = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         var output:String = "";
         var outputBuffer:Array = new Array(4);
         data.position = 0;
         while(data.bytesAvailable > 0)
         {
            dataBuffer = new Array();
            i = 0;
            while(i < 3 && data.bytesAvailable > 0)
            {
               dataBuffer[i] = data.readUnsignedByte();
               i++;
            }
            outputBuffer[0] = (dataBuffer[0] & 252) >> 2;
            outputBuffer[1] = (dataBuffer[0] & 3) << 4 | dataBuffer[1] >> 4;
            outputBuffer[2] = (dataBuffer[1] & 15) << 2 | dataBuffer[2] >> 6;
            outputBuffer[3] = dataBuffer[2] & 63;
            for(j = dataBuffer.length; j < 3; j++)
            {
               outputBuffer[j + 1] = 64;
            }
            for(k = 0; k < outputBuffer.length; k++)
            {
               output += BASE64_CHARS.charAt(outputBuffer[k]);
            }
         }
         return output;
      }
      
      static function Base64Decode(str:String) : ByteArray
      {
         var c1:int = 0;
         var c2:int = 0;
         var c3:int = 0;
         var c4:int = 0;
         var i:int = 0;
         var len:int = 0;
         var out:ByteArray = null;
         len = str.length;
         i = 0;
         out = new ByteArray();
         loop0:
         while(i < len)
         {
            do
            {
               c1 = decodeChars[str.charCodeAt(i++) & 255];
            }
            while(i < len && c1 == -1);
            
            if(c1 == -1)
            {
               break;
            }
            do
            {
               c2 = decodeChars[str.charCodeAt(i++) & 255];
            }
            while(i < len && c2 == -1);
            
            if(c2 == -1)
            {
               break;
            }
            out.writeByte(c1 << 2 | (c2 & 48) >> 4);
            while(true)
            {
               c3 = str.charCodeAt(i++) & 255;
               if(c3 == 61)
               {
                  break;
               }
               c3 = decodeChars[c3];
               if(!(i < len && c3 == -1))
               {
                  if(c3 == -1)
                  {
                     break loop0;
                  }
                  out.writeByte((c2 & 15) << 4 | (c3 & 60) >> 2);
                  while(true)
                  {
                     c4 = str.charCodeAt(i++) & 255;
                     if(c4 == 61)
                     {
                        break;
                     }
                     c4 = decodeChars[c4];
                     if(!(i < len && c4 == -1))
                     {
                        if(c4 == -1)
                        {
                           break loop0;
                        }
                        out.writeByte((c3 & 3) << 6 | c4);
                        continue loop0;
                     }
                  }
                  return out;
               }
            }
            return out;
         }
         return out;
      }
      
      static function PNG(img:BitmapData) : ByteArray
      {
         var p:uint = 0;
         var j:int = 0;
         var png:ByteArray = new ByteArray();
         png.writeUnsignedInt(2303741511);
         png.writeUnsignedInt(218765834);
         var IHDR:ByteArray = new ByteArray();
         IHDR.writeInt(img.width);
         IHDR.writeInt(img.height);
         IHDR.writeUnsignedInt(134610944);
         IHDR.writeByte(0);
         writeChunk(png,1229472850,IHDR);
         var IDAT:ByteArray = new ByteArray();
         for(var i:int = 0; i < img.height; i++)
         {
            IDAT.writeByte(0);
            if(!img.transparent)
            {
               for(j = 0; j < img.width; j++)
               {
                  p = img.getPixel(j,i);
                  IDAT.writeUnsignedInt(uint((p & 16777215) << 8 | 255));
               }
            }
            else
            {
               for(j = 0; j < img.width; j++)
               {
                  p = img.getPixel32(j,i);
                  IDAT.writeUnsignedInt(uint((p & 16777215) << 8 | p >>> 24));
               }
            }
         }
         IDAT.compress();
         writeChunk(png,1229209940,IDAT);
         writeChunk(png,1229278788,null);
         return png;
      }
      
      private static function writeChunk(png:ByteArray, type:uint, data:ByteArray) : void
      {
         var c:uint = 0;
         var n:uint = 0;
         var k:uint = 0;
         if(!crcTableComputed)
         {
            crcTableComputed = true;
            crcTable = [];
            for(n = 0; n < 256; n++)
            {
               c = n;
               for(k = 0; k < 8; k++)
               {
                  if(c & 1)
                  {
                     c = uint(uint(3988292384) ^ uint(c >>> 1));
                  }
                  else
                  {
                     c = uint(c >>> 1);
                  }
               }
               crcTable[n] = c;
            }
         }
         var len:uint = 0;
         if(data != null)
         {
            len = data.length;
         }
         png.writeUnsignedInt(len);
         var p:uint = png.position;
         png.writeUnsignedInt(type);
         if(data != null)
         {
            png.writeBytes(data);
         }
         var e:uint = png.position;
         png.position = p;
         c = 4294967295;
         for(var i:int = 0; i < e - p; i++)
         {
            c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(255)] ^ uint(c >>> 8));
         }
         c = uint(c ^ uint(4294967295));
         png.position = e;
         png.writeUnsignedInt(c);
      }
      
      private static function bitOR(a:Number, b:Number) : Number
      {
         var lsb:Number = a & 1 | b & 1;
         var msb31:Number = a >>> 1 | b >>> 1;
         return msb31 << 1 | lsb;
      }
      
      private static function bitXOR(a:Number, b:Number) : Number
      {
         var lsb:Number = a & 1 ^ b & 1;
         var msb31:Number = a >>> 1 ^ b >>> 1;
         return msb31 << 1 | lsb;
      }
      
      private static function bitAND(a:Number, b:Number) : Number
      {
         var lsb:Number = a & 1 & (b & 1);
         var msb31:Number = a >>> 1 & b >>> 1;
         return msb31 << 1 | lsb;
      }
      
      private static function addme(x:Number, y:Number) : Number
      {
         var lsw:Number = (x & 65535) + (y & 65535);
         var msw:Number = (x >> 16) + (y >> 16) + (lsw >> 16);
         return msw << 16 | lsw & 65535;
      }
      
      private static function rhex(num:Number) : String
      {
         var j:int = 0;
         var str:String = "";
         for(j = 0; j <= 3; j++)
         {
            str += hex_chr.charAt(num >> j * 8 + 4 & 15) + hex_chr.charAt(num >> j * 8 & 15);
         }
         return str;
      }
      
      private static function str2blks_MD5(str:String) : Array
      {
         var i:int = 0;
         var nblk:Number = (str.length + 8 >> 6) + 1;
         var blks:Array = new Array(nblk * 16);
         for(i = 0; i < nblk * 16; i++)
         {
            blks[i] = 0;
         }
         for(i = 0; i < str.length; i++)
         {
            blks[i >> 2] |= str.charCodeAt(i) << (str.length * 8 + i) % 4 * 8;
         }
         blks[i >> 2] |= 128 << (str.length * 8 + i) % 4 * 8;
         var l:int = str.length * 8;
         blks[nblk * 16 - 2] = l & 255;
         blks[nblk * 16 - 2] |= (l >>> 8 & 255) << 8;
         blks[nblk * 16 - 2] |= (l >>> 16 & 255) << 16;
         blks[nblk * 16 - 2] |= (l >>> 24 & 255) << 24;
         return blks;
      }
      
      private static function rol(num:Number, cnt:Number) : Number
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      private static function cmn(q:Number, a:Number, b:Number, x:Number, s:Number, t:Number) : Number
      {
         return addme(rol(addme(addme(a,q),addme(x,t)),s),b);
      }
      
      private static function ff(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number) : Number
      {
         return cmn(bitOR(bitAND(b,c),bitAND(~b,d)),a,b,x,s,t);
      }
      
      private static function gg(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number) : Number
      {
         return cmn(bitOR(bitAND(b,d),bitAND(c,~d)),a,b,x,s,t);
      }
      
      private static function hh(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number) : Number
      {
         return cmn(bitXOR(bitXOR(b,c),d),a,b,x,s,t);
      }
      
      private static function ii(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number) : Number
      {
         return cmn(bitXOR(c,bitOR(b,~d)),a,b,x,s,t);
      }
      
      static function MD5(str:String) : String
      {
         var i:int = 0;
         var olda:Number = NaN;
         var oldb:Number = NaN;
         var oldc:Number = NaN;
         var oldd:Number = NaN;
         var x:Array = str2blks_MD5(str);
         var a:Number = 1732584193;
         var b:Number = -271733879;
         var c:Number = -1732584194;
         var d:Number = 271733878;
         for(i = 0; i < x.length; i += 16)
         {
            olda = a;
            oldb = b;
            oldc = c;
            oldd = d;
            a = ff(a,b,c,d,x[i + 0],7,-680876936);
            d = ff(d,a,b,c,x[i + 1],12,-389564586);
            c = ff(c,d,a,b,x[i + 2],17,606105819);
            b = ff(b,c,d,a,x[i + 3],22,-1044525330);
            a = ff(a,b,c,d,x[i + 4],7,-176418897);
            d = ff(d,a,b,c,x[i + 5],12,1200080426);
            c = ff(c,d,a,b,x[i + 6],17,-1473231341);
            b = ff(b,c,d,a,x[i + 7],22,-45705983);
            a = ff(a,b,c,d,x[i + 8],7,1770035416);
            d = ff(d,a,b,c,x[i + 9],12,-1958414417);
            c = ff(c,d,a,b,x[i + 10],17,-42063);
            b = ff(b,c,d,a,x[i + 11],22,-1990404162);
            a = ff(a,b,c,d,x[i + 12],7,1804603682);
            d = ff(d,a,b,c,x[i + 13],12,-40341101);
            c = ff(c,d,a,b,x[i + 14],17,-1502002290);
            b = ff(b,c,d,a,x[i + 15],22,1236535329);
            a = gg(a,b,c,d,x[i + 1],5,-165796510);
            d = gg(d,a,b,c,x[i + 6],9,-1069501632);
            c = gg(c,d,a,b,x[i + 11],14,643717713);
            b = gg(b,c,d,a,x[i + 0],20,-373897302);
            a = gg(a,b,c,d,x[i + 5],5,-701558691);
            d = gg(d,a,b,c,x[i + 10],9,38016083);
            c = gg(c,d,a,b,x[i + 15],14,-660478335);
            b = gg(b,c,d,a,x[i + 4],20,-405537848);
            a = gg(a,b,c,d,x[i + 9],5,568446438);
            d = gg(d,a,b,c,x[i + 14],9,-1019803690);
            c = gg(c,d,a,b,x[i + 3],14,-187363961);
            b = gg(b,c,d,a,x[i + 8],20,1163531501);
            a = gg(a,b,c,d,x[i + 13],5,-1444681467);
            d = gg(d,a,b,c,x[i + 2],9,-51403784);
            c = gg(c,d,a,b,x[i + 7],14,1735328473);
            b = gg(b,c,d,a,x[i + 12],20,-1926607734);
            a = hh(a,b,c,d,x[i + 5],4,-378558);
            d = hh(d,a,b,c,x[i + 8],11,-2022574463);
            c = hh(c,d,a,b,x[i + 11],16,1839030562);
            b = hh(b,c,d,a,x[i + 14],23,-35309556);
            a = hh(a,b,c,d,x[i + 1],4,-1530992060);
            d = hh(d,a,b,c,x[i + 4],11,1272893353);
            c = hh(c,d,a,b,x[i + 7],16,-155497632);
            b = hh(b,c,d,a,x[i + 10],23,-1094730640);
            a = hh(a,b,c,d,x[i + 13],4,681279174);
            d = hh(d,a,b,c,x[i + 0],11,-358537222);
            c = hh(c,d,a,b,x[i + 3],16,-722521979);
            b = hh(b,c,d,a,x[i + 6],23,76029189);
            a = hh(a,b,c,d,x[i + 9],4,-640364487);
            d = hh(d,a,b,c,x[i + 12],11,-421815835);
            c = hh(c,d,a,b,x[i + 15],16,530742520);
            b = hh(b,c,d,a,x[i + 2],23,-995338651);
            a = ii(a,b,c,d,x[i + 0],6,-198630844);
            d = ii(d,a,b,c,x[i + 7],10,1126891415);
            c = ii(c,d,a,b,x[i + 14],15,-1416354905);
            b = ii(b,c,d,a,x[i + 5],21,-57434055);
            a = ii(a,b,c,d,x[i + 12],6,1700485571);
            d = ii(d,a,b,c,x[i + 3],10,-1894986606);
            c = ii(c,d,a,b,x[i + 10],15,-1051523);
            b = ii(b,c,d,a,x[i + 1],21,-2054922799);
            a = ii(a,b,c,d,x[i + 8],6,1873313359);
            d = ii(d,a,b,c,x[i + 15],10,-30611744);
            c = ii(c,d,a,b,x[i + 6],15,-1560198380);
            b = ii(b,c,d,a,x[i + 13],21,1309151649);
            a = ii(a,b,c,d,x[i + 4],6,-145523070);
            d = ii(d,a,b,c,x[i + 11],10,-1120210379);
            c = ii(c,d,a,b,x[i + 2],15,718787259);
            b = ii(b,c,d,a,x[i + 9],21,-343485551);
            a = addme(a,olda);
            b = addme(b,oldb);
            c = addme(c,oldc);
            d = addme(d,oldd);
         }
         return rhex(a) + rhex(b) + rhex(c) + rhex(d);
      }
   }
}
