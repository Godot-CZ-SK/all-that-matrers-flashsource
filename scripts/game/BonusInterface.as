package game
{
   import Playtomic.Link;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import managers.SM;
   
   public class BonusInterface extends EventDispatcher
   {
       
      
      protected var _isCreated:Boolean;
      
      protected var _buttons:Array;
      
      protected var _costume:MC_BonusInterface;
      
      protected var _parent:DisplayObjectContainer;
      
      public function BonusInterface(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
      }
      
      public function create(name:String) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_BonusInterface();
         this._parent.addChild(this._costume);
         this._costume.txt_level.text = name;
         this._buttons = [this._costume.btn_mute,this._costume.btn_pause,this._costume.btn_replay];
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            this._buttons[i].buttonMode = true;
            this._buttons[i].mouseChildren = false;
         }
         this._costume.btn_sponsor.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._costume.btn_sponsor.addEventListener(MouseEvent.ROLL_OVER,this.sponsorOverHandler,false,0,true);
         this._costume.btn_sponsor.addEventListener(MouseEvent.ROLL_OUT,this.sponsorOutHandler,false,0,true);
         this._costume.btn_sponsor.buttonMode = true;
         this._costume.btn_sponsor.mouseChildren = false;
         this.updateMuteButton();
      }
      
      private function sponsorOutHandler(e:MouseEvent) : void
      {
         if(this._costume.btn_sponsor.currentLabel == "over")
         {
            this._costume.btn_sponsor.gotoAndPlay("out_play");
         }
         else
         {
            this._costume.btn_sponsor.gotoAndStop("out");
         }
      }
      
      private function sponsorOverHandler(e:MouseEvent) : void
      {
         this._costume.btn_sponsor.gotoAndPlay("over_play");
      }
      
      public function remove() : void
      {
         var i:int = 0;
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         for(i = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
         CF.removeDisplayObject(this._costume);
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "unmute_over" || mc.currentLabel == "unmute_out")
         {
            mc.gotoAndStop("unmute_out");
         }
         else
         {
            mc.gotoAndStop("out");
         }
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "unmute_out" || mc.currentLabel == "unmute_over")
         {
            mc.gotoAndStop("unmute_over");
         }
         else
         {
            mc.gotoAndStop("over");
         }
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc == this._costume.btn_pause)
         {
            dispatchEvent(new Event("pause"));
         }
         else if(mc == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
         }
         else if(mc == this._costume.btn_mute)
         {
            this.toggleMute();
         }
         else if(mc == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"inGame","sponsor");
         }
      }
      
      public function toggleMute() : void
      {
         SM.ins.toggleAll();
         this.updateMuteButton();
      }
      
      private function updateMuteButton() : void
      {
         if(SM.ins.isMusicMuted && SM.ins.isSoundMuted)
         {
            this._costume.btn_mute.gotoAndStop("unmute_out");
         }
         else
         {
            this._costume.btn_mute.gotoAndStop("out");
         }
      }
      
      public function updateInterface(num:int) : void
      {
         this._costume.txt_no.text = num.toString();
      }
   }
}
