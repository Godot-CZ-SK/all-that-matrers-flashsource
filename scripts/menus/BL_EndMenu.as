package menus
{
   import Playtomic.Link;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import game.SafeScore;
   import managers.DM;
   import managers.KM;
   import managers.LM;
   import managers.SM;
   
   public class BL_EndMenu extends EventDispatcher
   {
      
      private static var _ins:BL_EndMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_BL_EndMenu;
      
      protected var _numHearts:int;
      
      protected var _shownHearts:int;
      
      protected var _name:String;
      
      protected var _step:int;
      
      protected var _score:SafeScore;
      
      protected var _buttons:Array;
      
      public function BL_EndMenu()
      {
         super();
      }
      
      public static function get ins() : BL_EndMenu
      {
         if(!_ins)
         {
            _ins = new BL_EndMenu();
         }
         return _ins;
      }
      
      public function create(name:String, score:SafeScore) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_BL_EndMenu();
         DM.ins.menu.addChild(this._costume);
         this._score = score;
         this._numHearts = this._score.value;
         this._buttons = [this._costume.btn_back,this._costume.btn_replay,this._costume.btn_submit,this._costume.btn_highscores,this._costume.btn_sponsor];
         this.addEvents();
         this._costume.txt_no.text = "0";
         this._shownHearts = 0;
         this._name = name;
         this._costume.txt_name.text = name;
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
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(HighscoresPanel.ins.isCreated)
         {
            return;
         }
         if(e.keyCode == KM.ESCAPE)
         {
            dispatchEvent(new Event("menu"));
            this.remove();
         }
         else if(e.keyCode == KM.KEY_R)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
      }
      
      public function addEvents() : void
      {
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         Main.s.addEventListener(Event.ENTER_FRAME,this.frameHandler,false,0,true);
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            (this._buttons[i] as MovieClip).buttonMode = true;
            (this._buttons[i] as MovieClip).mouseChildren = false;
         }
      }
      
      public function removeEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.CLICK,this.clickHandler);
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
         Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function disableButtons() : void
      {
         var i:int = 0;
         for(i = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).enabled = false;
            (this._buttons[i] as MovieClip).mouseEnabled = false;
            (this._buttons[i] as MovieClip).gotoAndStop("disabled");
         }
      }
      
      private function enableButtons() : void
      {
         var i:int = 0;
         for(i = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).enabled = true;
            (this._buttons[i] as MovieClip).mouseEnabled = true;
            if((this._buttons[i] as MovieClip).currentLabel == "disabled")
            {
               (this._buttons[i] as MovieClip).gotoAndStop("out");
            }
         }
      }
      
      private function frameHandler(e:Event) : void
      {
         var temp:int = 0;
         var showIn:int = 0;
         var cdFrom:int = 0;
         var n:int = 0;
         if(!this._isCreated)
         {
            return;
         }
         if(this._shownHearts == this._numHearts)
         {
            Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
         }
         ++this._step;
         if(this._step > 10)
         {
            temp = this._step - 10;
            showIn = 2 * (this._shownHearts + 1);
            cdFrom = 10;
            n = 0;
            if(this._shownHearts > this._numHearts - cdFrom)
            {
               n = 11 - (this._numHearts - this._shownHearts);
               showIn += n * (n + 1) / 2;
            }
            if(temp >= showIn)
            {
               ++this._shownHearts;
            }
            this._costume.txt_no.text = this._shownHearts.toString();
         }
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "disabled")
         {
            return;
         }
         (e.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "disabled")
         {
            return;
         }
         (e.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._costume.btn_back)
         {
            dispatchEvent(new Event("menu"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_submit)
         {
            HighscoresPanel.ins.create(this._name);
            HighscoresPanel.ins.sendScoreAndShow(LM.ins.cp.name,this._score.value);
         }
         else if(e.currentTarget == this._costume.btn_highscores)
         {
            HighscoresPanel.ins.create(this._name);
            HighscoresPanel.ins.showLeaderboard(HighscoresPanel.ALL_TIME,1);
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"endMenu","sponsor");
         }
      }
   }
}
