package managers
{
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   
   public class KM
   {
      
      private static var _ins:KM;
      
      public static var KEY_W:int = 87;
      
      public static var KEY_A:int = 65;
      
      public static var KEY_S:int = 83;
      
      public static var KEY_D:int = 68;
      
      public static var KEY_P:int = 80;
      
      public static var KEY_R:int = 82;
      
      public static var KEY_1:int = 49;
      
      public static var UP:int = 38;
      
      public static var LEFT:int = 37;
      
      public static var DOWN:int = 40;
      
      public static var RIGHT:int = 39;
      
      public static var ENTER:int = 13;
      
      public static var DELETE:int = 46;
      
      public static var CTRL:int = 17;
      
      public static var SHIFT:int = 16;
      
      public static var ESCAPE:int = 27;
      
      public static var SPACE:int = 32;
      
      public static var G_LINE:int = 219;
       
      
      private var _ed:EventDispatcher;
      
      private var _keys:Vector.<Boolean>;
      
      protected const DELAY:Number = 0.3;
      
      public function KM()
      {
         super();
      }
      
      public static function get ins() : KM
      {
         if(!_ins)
         {
            _ins = new KM();
         }
         return _ins;
      }
      
      public function init(ed:EventDispatcher) : void
      {
         this._ed = ed;
         this._ed.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,0,true);
         this._ed.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler,false,0,true);
         this._keys = new Vector.<Boolean>();
         for(var i:int = 0; i < 256; i++)
         {
            this._keys.push(false);
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < this._keys.length; i++)
         {
            this._keys[i] = false;
         }
      }
      
      private function keyDownHandler(e:KeyboardEvent) : void
      {
         this._keys[e.keyCode] = true;
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         this._keys[e.keyCode] = false;
      }
      
      public function isDown(keyCode:int) : Boolean
      {
         return this._keys[keyCode];
      }
   }
}
