package game
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import design.data.DO_UnitData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import managers.KM;
   import managers.SM;
   
   public class Interface extends EventDispatcher
   {
       
      
      protected var _costume:MC_Interface;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _isCreated:Boolean;
      
      protected var _unitList:Array;
      
      protected var _buttons:Array;
      
      protected var _dad:Boolean;
      
      protected var _mom:Boolean;
      
      protected var _kid:Boolean;
      
      protected var _baby:Boolean;
      
      protected var _elder:Boolean;
      
      protected var _dad_id:int;
      
      protected var _mom_id:int;
      
      protected var _kid_id:int;
      
      protected var _baby_id:int;
      
      protected var _elder_id:int;
      
      protected var _selected_id:int;
      
      protected var _heartsCollected:int;
      
      protected var _portraits:Vector.<MC_Portrait>;
      
      public function Interface(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
         this._portraits = new Vector.<MC_Portrait>();
         this._selected_id = -1;
         this._unitList = [];
         this._buttons = [];
         this._heartsCollected = 0;
      }
      
      public function create(levelName:String) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_Interface();
         this._parent.addChild(this._costume);
         this._costume.alpha = 0;
         this._costume.txt_level.text = levelName;
         TweenLite.to(this._costume,1,{"alpha":1});
         this.createCharacters();
         this._buttons = [this._costume.btn_hint,this._costume.btn_pause,this._costume.btn_replay,this._costume.btn_mute];
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
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler,false,0,true);
      }
      
      public function focusWalkthrough() : void
      {
         this._costume.btn_hint.gotoAndPlay("focus");
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
      
      public function collectHeart(hc:int) : void
      {
         while(this._heartsCollected < hc)
         {
            ++this._heartsCollected;
            if(this._heartsCollected == 1)
            {
               this._costume.mc_heart1.gotoAndPlay("unlock");
            }
            else if(this._heartsCollected == 2)
            {
               this._costume.mc_heart2.gotoAndPlay("unlock");
            }
            else if(this._heartsCollected == 3)
            {
               this._costume.mc_heart3.gotoAndPlay("unlock");
            }
         }
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
         for(i = 0; i < this._portraits.length; i++)
         {
            CF.removeDisplayObject(this._portraits[i]);
         }
         CF.removeDisplayObject(this._costume);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
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
         else if(mc == this._costume.btn_hint)
         {
            dispatchEvent(new Event("hint"));
         }
         else if(mc == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
         }
         else if(mc == this._costume.btn_mute)
         {
            SM.ins.toggleAll();
            this.updateMuteButton();
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
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         var id:int = -1;
         if(e.keyCode == KM.KEY_1)
         {
            id = 0;
         }
         else if(e.keyCode == KM.KEY_1 + 1)
         {
            id = 1;
         }
         else if(e.keyCode == KM.KEY_1 + 2)
         {
            id = 2;
         }
         else if(e.keyCode == KM.KEY_1 + 3)
         {
            id = 3;
         }
         else if(e.keyCode == KM.KEY_1 + 4)
         {
            id = 4;
         }
         if(id >= 0)
         {
            this.selectPortraitWithId(id);
         }
      }
      
      public function setCharacters(dad:Boolean = false, mom:Boolean = false, kid:Boolean = false, baby:Boolean = false, elder:Boolean = false) : void
      {
         this._unitList = [];
         if(dad)
         {
            this._unitList.push(DO_UnitData.DAD);
         }
         if(mom)
         {
            this._unitList.push(DO_UnitData.MOM);
         }
         if(elder)
         {
            this._unitList.push(DO_UnitData.ELDER);
         }
         if(kid)
         {
            this._unitList.push(DO_UnitData.KID);
         }
         if(baby)
         {
            this._unitList.push(DO_UnitData.BABY);
         }
      }
      
      public function createCharacters() : void
      {
         for(var i:int = 0; i < this._unitList.length; i++)
         {
            this.createPortrait(this._unitList[i]);
         }
         this._selected_id = 0;
         this.updatePortraits();
      }
      
      public function updateCharacters(dad:Boolean = false, mom:Boolean = false, kid:Boolean = false, baby:Boolean = false, elder:Boolean = false) : void
      {
         if(!dad && this._unitList.indexOf(DO_UnitData.DAD) >= 0)
         {
            this.disablePortrait(DO_UnitData.DAD);
         }
         if(!mom && this._unitList.indexOf(DO_UnitData.MOM) >= 0)
         {
            this.disablePortrait(DO_UnitData.MOM);
         }
         if(!kid && this._unitList.indexOf(DO_UnitData.KID) >= 0)
         {
            this.disablePortrait(DO_UnitData.KID);
         }
         if(!baby && this._unitList.indexOf(DO_UnitData.BABY) >= 0)
         {
            this.disablePortrait(DO_UnitData.BABY);
         }
         if(!elder && this._unitList.indexOf(DO_UnitData.ELDER) >= 0)
         {
            this.disablePortrait(DO_UnitData.ELDER);
         }
      }
      
      public function selectPortraitWithName(member:String) : void
      {
         var id:int = this._unitList.indexOf(member);
         if(id >= 0)
         {
            this.selectPortraitWithId(id);
         }
         else
         {
            this.clearSelection();
         }
      }
      
      private function selectPortraitWithId(id:int) : void
      {
         if(id < 0 || id > this._portraits.length - 1)
         {
            return;
         }
         if(id == this._selected_id)
         {
            return;
         }
         if(this._portraits[id].alpha < 1)
         {
            return;
         }
         this._selected_id = id;
         this.updatePortraits();
         dispatchEvent(new Event(this._unitList[this._selected_id]));
      }
      
      private function disablePortrait(member:String) : void
      {
         var id:int = this._unitList.indexOf(member);
         if(id < 0 || id >= this._portraits.length)
         {
            return;
         }
         this._portraits[id].alpha = 0.7;
      }
      
      private function createPortrait(member:String) : void
      {
         var mc:MovieClip = null;
         if(member == DO_UnitData.DAD)
         {
            mc = new MC_DO_Dad();
            this._dad_id = this._portraits.length;
         }
         else if(member == DO_UnitData.MOM)
         {
            mc = new MC_DO_Mom();
            this._mom_id = this._portraits.length;
         }
         else if(member == DO_UnitData.KID)
         {
            mc = new MC_DO_Kid();
            this._kid_id = this._portraits.length;
         }
         else if(member == DO_UnitData.BABY)
         {
            mc = new MC_DO_Baby();
            this._baby_id = this._portraits.length;
         }
         else if(member == DO_UnitData.ELDER)
         {
            mc = new MC_DO_Elder();
            this._elder_id = this._portraits.length;
         }
         var portrait:MC_Portrait = new MC_Portrait();
         portrait.addChildAt(mc,0);
         portrait.txt_no.text = (this._portraits.length + 1).toString();
         portrait.addEventListener(MouseEvent.CLICK,this.portraitClickHandler,false,0,true);
         portrait.buttonMode = true;
         portrait.mouseChildren = false;
         this._costume.addChild(portrait);
         this._portraits.push(portrait);
      }
      
      private function portraitClickHandler(e:MouseEvent) : void
      {
         var portrait:MC_Portrait = e.currentTarget as MC_Portrait;
         var id:int = this._portraits.indexOf(portrait);
         this.selectPortraitWithId(id);
      }
      
      private function clearSelection() : void
      {
         this._selected_id = -1;
         this.updatePortraits();
      }
      
      private function updatePortraits() : void
      {
         var scale:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         var positions:Array = [];
         var widths:Array = [];
         var width:Number = 45;
         for(var i:int = 0; i < this._portraits.length; i++)
         {
            scale = 1.1;
            y = 40;
            if(this._selected_id == i)
            {
               scale = 1.5;
            }
            if(i == 0)
            {
               x = width * scale / 2 + 10;
            }
            else
            {
               x = positions[i - 1] + widths[i - 1] / 2 + width * scale / 2 + 10;
            }
            positions.push(x);
            widths.push(scale * width);
            TweenLite.to(this._portraits[i],0.2,{
               "x":x,
               "y":y,
               "scaleX":scale,
               "scaleY":scale
            });
         }
      }
   }
}
