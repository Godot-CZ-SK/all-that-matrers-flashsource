package menus
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.KM;
   import managers.LM;
   import managers.SM;
   
   public class SkipMenu extends EventDispatcher
   {
      
      private static var _ins:SkipMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _buttons:Vector.<MovieClip>;
      
      protected var _costume:MC_SkipMenu;
      
      public function SkipMenu()
      {
         super();
      }
      
      public static function get ins() : SkipMenu
      {
         if(!_ins)
         {
            _ins = new SkipMenu();
         }
         return _ins;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_SkipMenu();
         DM.ins.menu.addChild(this._costume);
         this._buttons = new Vector.<MovieClip>();
         this._buttons.push(this._costume.btn_back,this._costume.btn_continue,this._costume.btn_skip,this._costume.btn_show,this._costume.btn_sponsor);
         TweenLite.to(this._costume,0.25,{"alpha":1});
         this._costume.alpha = 0;
         this.addEvents();
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
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "checked_out")
         {
            mc.gotoAndStop("checked_over");
         }
         else
         {
            mc.gotoAndStop("over");
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "checked_over")
         {
            mc.gotoAndStop("checked_out");
         }
         else
         {
            mc.gotoAndStop("out");
         }
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
         else if(e.currentTarget == this._costume.btn_skip)
         {
            dispatchEvent(new Event("skip"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_show)
         {
            LM.ins.cp.setSkip(!LM.ins.cp.hideSkip);
            if(LM.ins.cp.hideSkip)
            {
               this._costume.btn_show.gotoAndStop("checked_over");
            }
            else
            {
               this._costume.btn_show.gotoAndStop("over");
            }
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"skipMenu","sponsor");
         }
      }
   }
}
