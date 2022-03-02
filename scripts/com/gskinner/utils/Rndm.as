package com.gskinner.utils
{
   import flash.display.BitmapData;
   
   public class Rndm
   {
      
      protected static var _instance:Rndm;
       
      
      protected var _seed:uint = 0;
      
      protected var _pointer:uint = 0;
      
      protected var bmpd:BitmapData;
      
      protected var seedInvalid:Boolean = true;
      
      public function Rndm(seed:uint = 0)
      {
         super();
         this._seed = seed;
         this.bmpd = new BitmapData(1000,200);
      }
      
      public static function get instance() : Rndm
      {
         if(_instance == null)
         {
            _instance = new Rndm();
         }
         return _instance;
      }
      
      public static function get seed() : uint
      {
         return instance.seed;
      }
      
      public static function set seed(value:uint) : void
      {
         instance.seed = value;
      }
      
      public static function get pointer() : uint
      {
         return instance.pointer;
      }
      
      public static function set pointer(value:uint) : void
      {
         instance.pointer = value;
      }
      
      public static function random() : Number
      {
         return instance.random();
      }
      
      public static function float(min:Number, max:Number = NaN) : Number
      {
         return instance.float(min,max);
      }
      
      public static function boolean(chance:Number = 0.5) : Boolean
      {
         return instance.boolean(chance);
      }
      
      public static function sign(chance:Number = 0.5) : int
      {
         return instance.sign(chance);
      }
      
      public static function bit(chance:Number = 0.5) : int
      {
         return instance.bit(chance);
      }
      
      public static function integer(min:Number, max:Number = NaN) : int
      {
         return instance.integer(min,max);
      }
      
      public static function reset() : void
      {
         instance.reset();
      }
      
      public function get seed() : uint
      {
         return this._seed;
      }
      
      public function set seed(value:uint) : void
      {
         if(value != this._seed)
         {
            this.seedInvalid = true;
            this._pointer = 0;
         }
         this._seed = value;
      }
      
      public function get pointer() : uint
      {
         return this._pointer;
      }
      
      public function set pointer(value:uint) : void
      {
         this._pointer = value;
      }
      
      public function random() : Number
      {
         if(this.seedInvalid)
         {
            this.bmpd.noise(this._seed,0,255,1 | 2 | 4 | 8);
            this.seedInvalid = false;
         }
         this._pointer = (this._pointer + 1) % 200000;
         return (this.bmpd.getPixel32(this._pointer % 1000,this._pointer / 1000 >> 0) * 0.999999999999998 + 1e-15) / 4294967295;
      }
      
      public function float(min:Number, max:Number = NaN) : Number
      {
         if(isNaN(max))
         {
            max = min;
            min = 0;
         }
         return this.random() * (max - min) + min;
      }
      
      public function boolean(chance:Number = 0.5) : Boolean
      {
         return this.random() < chance;
      }
      
      public function sign(chance:Number = 0.5) : int
      {
         return this.random() < chance ? int(1) : int(-1);
      }
      
      public function bit(chance:Number = 0.5) : int
      {
         return this.random() < chance ? int(1) : int(0);
      }
      
      public function integer(min:Number, max:Number = NaN) : int
      {
         if(isNaN(max))
         {
            max = min;
            min = 0;
         }
         return Math.floor(this.float(min,max));
      }
      
      public function reset() : void
      {
         this._pointer = 0;
      }
   }
}
