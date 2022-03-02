package managers
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   
   public class UM
   {
      
      private static var _ins:UM;
       
      
      protected var _ed:EventDispatcher;
      
      protected var _isPaused:Boolean;
      
      public function UM()
      {
         super();
      }
      
      public static function get ins() : UM
      {
         if(!_ins)
         {
            _ins = new UM();
         }
         return _ins;
      }
      
      public function init(ed:EventDispatcher) : void
      {
         this._ed = ed;
         this._ed.addEventListener(Event.ENTER_FRAME,this.frameListener,false,0,true);
         this._ed.addEventListener(KeyboardEvent.KEY_UP,this.upListener,false,0,true);
      }
      
      public function reset() : void
      {
         this._isPaused = false;
      }
      
      private function upListener(e:KeyboardEvent) : void
      {
         if(e.keyCode == 80)
         {
         }
      }
      
      public function pause() : void
      {
         this._isPaused = true;
      }
      
      public function resume() : void
      {
         this._isPaused = false;
      }
      
      private function frameListener(e:Event) : void
      {
         this.update();
      }
      
      public function update() : void
      {
         TM.ins.update();
         LM.ins.update();
         if(this._isPaused)
         {
            return;
         }
         PM.ins.update();
         GM.ins.update();
         EM.ins.update();
         DM.ins.update();
      }
   }
}
