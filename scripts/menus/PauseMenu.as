package menus
{
   import Playtomic.Link;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.KM;
   import managers.SM;
   
   public class PauseMenu extends EventDispatcher
   {
      
      private static var _ins:PauseMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _buttons:Vector.<MovieClip>;
      
      protected var _costume:MC_PauseMenu;
      
      protected var _vc:VC_Panel;
      
      public function PauseMenu()
      {
         super();
      }
      
      public static function get ins() : PauseMenu
      {
         if(!_ins)
         {
            _ins = new PauseMenu();
         }
         return _ins;
      }
      
      public function create(levName:String) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_PauseMenu();
         this._costume.txt_levelName.text = levName;
         DM.ins.menu.addChild(this._costume);
         this._vc = new VC_Panel(this._costume,580,10);
         this._vc.create();
         this._buttons = new Vector.<MovieClip>();
         this._buttons.push(this._costume.btn_back,this._costume.btn_continue,this._costume.btn_skip,this._costume.btn_replay,this._costume.btn_sponsor);
         this.addEvents();
      }
      
      public function hideSkipButton() : void
      {
         this._costume.btn_skip.visible = false;
      }
      
      private function addEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            this._buttons[i].buttonMode = true;
            this._buttons[i].mouseChildren = false;
         }
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function removeEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            this._buttons[i].buttonMode = false;
         }
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.SPACE || e.keyCode == KM.ESCAPE)
         {
            dispatchEvent(new Event("resume"));
            this.remove();
         }
         else if(e.keyCode == KM.KEY_R)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         (e.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this.removeEvents();
         this._buttons = new Vector.<MovieClip>();
         this._vc.remove();
         CF.removeDisplayObject(this._costume);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._costume.btn_back)
         {
            dispatchEvent(new Event("menu"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_continue)
         {
            dispatchEvent(new Event("resume"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_skip)
         {
            dispatchEvent(new Event("skip"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"pauseMenu","sponsor");
         }
      }
   }
}
