package be.boulevart.as3.security
{
   public class EncryptionTypes
   {
      
      protected static var _Base8:Object = Base8;
      
      protected static var _Base64:Object = Base64;
      
      protected static var _SHA1:Object = SHA1;
      
      protected static var _MD5:Object = MD5;
      
      protected static var _RC4:Object = RC4;
      
      protected static var _Rijndael:Object = Rijndael;
      
      protected static var _TEA:Object = TEA;
      
      protected static var _LZW:Object = LZW;
      
      protected static var _ROT13:Object = ROT13;
      
      protected static var _Goauld:Object = Goauld;
       
      
      public function EncryptionTypes()
      {
         super();
         _Base8 = Base8();
         _Base64 = Base64();
         _SHA1 = SHA1();
         _MD5 = MD5();
         _RC4 = RC4();
         _Rijndael = Rijndael();
         _TEA = TEA();
         _LZW = LZW();
         _ROT13 = ROT13();
         _Goauld = Goauld();
      }
      
      public static function Base8() : Object
      {
         return _Base8;
      }
      
      public static function Base64() : Object
      {
         return _Base64;
      }
      
      public static function SHA1() : Object
      {
         return _SHA1;
      }
      
      public static function MD5() : Object
      {
         return _MD5;
      }
      
      public static function RC4() : Object
      {
         return _RC4;
      }
      
      public static function Rijndael() : Object
      {
         return _Rijndael;
      }
      
      public static function TEA() : Object
      {
         return _TEA;
      }
      
      public static function Goauld() : Object
      {
         return _Goauld;
      }
      
      public static function LZW() : Object
      {
         return _LZW;
      }
      
      public static function ROT13() : Object
      {
         return _ROT13;
      }
   }
}
