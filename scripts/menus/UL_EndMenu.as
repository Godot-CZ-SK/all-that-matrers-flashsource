package menus
{
   import Playtomic.Link;
   import Playtomic.PlayerLevels;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.KM;
   import managers.SM;
   
   public class UL_EndMenu extends EventDispatcher
   {
      
      private static var _ins:UL_EndMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_UL_EndMenu;
      
      protected var _levelName:String;
      
      protected var _score:int;
      
      protected var _buttons:Array;
      
      protected var _rated:Boolean;
      
      protected var _levelId:String;
      
      public function UL_EndMenu()
      {
         super();
      }
      
      public static function get ins() : UL_EndMenu
      {
         if(!_ins)
         {
            _ins = new UL_EndMenu();
         }
         return _ins;
      }
      
      public function create(levelName:String, levelId:String, score:int) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._levelName = levelName;
         this._score = score;
         this._levelId = levelId;
         this._costume = new MC_UL_EndMenu();
         DM.ins.menu.addChild(this._costume);
         this._buttons = [this._costume.btn_back,this._costume.btn_editor,this._costume.btn_replay,this._costume.btn_sponsor,this._costume.mc_stars];
         this.addEvents();
         if(Main.isKong)
         {
            this._costume.mc_stars.visible = false;
         }
         this._costume.txt_levelName.text = this._levelName;
         this._costume.txt_no.text = this._score.toString();
         this._costume.txt_submit.text = "";
      }
      
      private function starMoveHandler(e:MouseEvent) : void
      {
         var x:Number = NaN;
         var w:Number = NaN;
         var rate:int = 0;
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(!this._rated)
         {
            x = this._costume.mc_stars.mouseX;
            w = 75;
            rate = Math.min(11,Math.max(1,x / w * 10 + 2));
            this._costume.mc_stars.gotoAndStop(rate);
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
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            (this._buttons[i] as MovieClip).buttonMode = true;
            (this._buttons[i] as MovieClip).mouseChildren = false;
         }
         this._costume.mc_stars.addEventListener(MouseEvent.MOUSE_MOVE,this.starMoveHandler,false,0,true);
      }
      
      public function removeEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.CLICK,this.clickHandler);
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            (this._buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
         this._costume.mc_stars.removeEventListener(MouseEvent.MOUSE_MOVE,this.starMoveHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc != this._costume.mc_stars)
         {
            if(mc.currentLabel == "disabled")
            {
               return;
            }
            (e.currentTarget as MovieClip).gotoAndStop("over");
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc == this._costume.mc_stars)
         {
            if(!this._rated)
            {
               mc.gotoAndStop(1);
            }
         }
         else
         {
            if(mc.currentLabel == "disabled")
            {
               return;
            }
            (e.currentTarget as MovieClip).gotoAndStop("out");
         }
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var x:Number = NaN;
         var w:Number = NaN;
         var rate:int = 0;
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._costume.btn_back)
         {
            dispatchEvent(new Event("menu"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_editor)
         {
            dispatchEvent(new Event("editor"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"endMenu","sponsor");
         }
         else if(e.currentTarget == this._costume.mc_stars)
         {
            if(!this._rated)
            {
               x = this._costume.mc_stars.mouseX;
               w = 75;
               rate = Math.min(11,Math.max(1,x / w * 10 + 2));
               this._costume.mc_stars.gotoAndStop(rate);
               this._rated = true;
               PlayerLevels.Rate(this._levelId,rate,this.ratingCompleted);
               this._costume.txt_submit.text = "Submitting...";
            }
         }
      }
      
      private function ratingCompleted(response:Object) : void
      {
         if(response.Success)
         {
            this._costume.txt_submit.text = "Done!";
         }
         else
         {
            this._costume.txt_submit.text = "A problem occured, please try again later.";
            this._rated = false;
            this._costume.mc_stars.gotoAndStop(1);
         }
      }
   }
}
