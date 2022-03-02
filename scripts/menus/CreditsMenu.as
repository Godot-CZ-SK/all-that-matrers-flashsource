package menus
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.LM;
   import managers.SM;
   import managers.TM;
   
   public class CreditsMenu
   {
      
      private static var _ins:CreditsMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_Credits;
      
      protected var _buttons:Array;
      
      public function CreditsMenu()
      {
         super();
      }
      
      public static function get ins() : CreditsMenu
      {
         if(!_ins)
         {
            _ins = new CreditsMenu();
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
         LM.ins.cp.setCurious();
         this._costume = new MC_Credits();
         this._costume.alpha = 0;
         TweenLite.to(this._costume,1,{"alpha":1});
         DM.ins.menu.addChild(this._costume);
         TM.ins.tf(function():void
         {
            addEvents();
         },1);
         this._buttons = [this._costume.btn_back,this._costume.btn_blog,this._costume.btn_mail,this._costume.btn_sponsor,this._costume.btn_twitter,this._costume.btn_jig];
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this.removeEvents();
         CF.removeDisplayObject(this._costume);
      }
      
      public function timedRemove() : void
      {
         this.removeEvents();
         TweenLite.to(this._costume,2,{"alpha":0});
         TM.ins.tf(function():void
         {
            remove();
         },2);
      }
      
      public function addEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            this._buttons[i].buttonMode = true;
            this._buttons[i].mouseChildren = false;
         }
      }
      
      public function removeEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            this._buttons[i].buttonMode = false;
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("out");
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("over");
         SM.ins.playSound(GameSound.BUTTON_OVER);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc == this._costume.btn_back)
         {
            this.timedRemove();
            TM.ins.tf(function():void
            {
               MainMenu.ins.create();
            },1);
         }
         else if(mc == this._costume.btn_blog)
         {
            Link.Open(Constants.DEV_LINK,"credits","batiali");
         }
         else if(mc == this._costume.btn_mail)
         {
            Link.Open(Constants.DEV_MAIL_LINK,"credits","e-mail");
         }
         else if(mc == this._costume.btn_twitter)
         {
            Link.Open(Constants.DEV_TWITTER_LINK,"credits","twitter");
         }
         else if(mc == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"credits","sponsor");
         }
         else if(mc == this._costume.btn_jig)
         {
            Link.Open(Constants.JAY_IS_GAMES_LINK,"credits","jig");
         }
      }
   }
}
