package menus
{
   import Playtomic.Leaderboards;
   import Playtomic.Link;
   import Playtomic.PlayerScore;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.GameSound;
   import managers.DM;
   import managers.SM;
   
   public class HighscoresPanel
   {
      
      public static const ALL_TIME:String = "alltime";
      
      public static const TODAY:String = "today";
      
      public static const LAST_7:String = "last7days";
      
      public static const LAST_30:String = "last30days";
      
      private static var _ins:HighscoresPanel;
       
      
      protected var _costume:MC_HighscoresPanel;
      
      protected var _name:String;
      
      protected var _isCreated:Boolean;
      
      protected var _buttons:Array;
      
      protected var _currentPage:int;
      
      protected var _currentMode:String;
      
      protected var _numScores:int;
      
      protected var PER_PAGE:int = 10;
      
      public function HighscoresPanel()
      {
         super();
      }
      
      public static function get ins() : HighscoresPanel
      {
         if(!_ins)
         {
            _ins = new HighscoresPanel();
         }
         return _ins;
      }
      
      public function create(name:String) : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._name = name;
         this._costume = new MC_HighscoresPanel();
         DM.ins.menu.addChild(this._costume);
         this._costume.txt_name.text = "Highscores - " + this._name;
         this._buttons = [this._costume.btn_all,this._costume.btn_close,this._costume.btn_daily,this._costume.btn_first,this._costume.btn_next,this._costume.btn_previous,this._costume.btn_weekly,this._costume.btn_sponsor];
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
            (this._buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            (this._buttons[i] as MovieClip).buttonMode = true;
            (this._buttons[i] as MovieClip).mouseChildren = false;
         }
         this._currentPage = 1;
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
      
      public function showLeaderboard(mode:String, page:int) : void
      {
         var i:int = 0;
         this._currentMode = mode;
         this.disableButtons();
         TweenLite.killTweensOf(this._costume.txt_info);
         this._costume.txt_info.alpha = 1;
         this._costume.txt_info.text = "Getting the list... Please Wait";
         if(mode == ALL_TIME)
         {
            this._costume.btn_all.gotoAndStop("selected");
         }
         else if(mode == TODAY)
         {
            this._costume.btn_daily.gotoAndStop("selected");
         }
         else if(mode == LAST_7)
         {
            this._costume.btn_weekly.gotoAndStop("selected");
         }
         for(i = 1; i <= 10; i++)
         {
            (this._costume["txt_num" + i.toString()] as TextField).text = "";
            (this._costume["txt_name" + i.toString()] as TextField).text = "";
            (this._costume["txt_points_" + i.toString()] as TextField).text = "";
         }
         var table:String = this._name;
         var callback:Function = this.listReturnHandler;
         var options:Object = new Object();
         options.mode = mode;
         options.page = page;
         options.perpage = 10;
         Leaderboards.List(table,callback,options);
      }
      
      private function listReturnHandler(scores:Array, numscores:int, response:Object) : void
      {
         var i:int = 0;
         var score:PlayerScore = null;
         this._numScores = numscores;
         this.enableButtons();
         if(scores.length > 0)
         {
            this._currentPage = Math.floor(scores[0].Rank / this.PER_PAGE) + 1;
         }
         else
         {
            this._currentPage = 1;
         }
         if(response.Success)
         {
            this._costume.txt_info.text = "Done!";
            TweenLite.to(this._costume.txt_info,1,{
               "alpha":0,
               "delay":1
            });
            for(i = 0; i < scores.length; i++)
            {
               score = scores[i];
               (this._costume["txt_num" + (i + 1).toString()] as TextField).text = score.Rank.toString();
               (this._costume["txt_name" + (i + 1).toString()] as TextField).text = score.Name;
               (this._costume["txt_points_" + (i + 1).toString()] as TextField).text = score.Points.toString();
            }
         }
         else
         {
            this._costume.txt_info.text = "Connection Problem: Please try again!";
            TweenLite.to(this._costume.txt_info,1,{
               "alpha":0,
               "delay":3
            });
            trace("Error: " + response.ErrorCode);
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "selected")
         {
            return;
         }
         (e.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "selected")
         {
            return;
         }
         (e.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._costume.btn_close)
         {
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_daily)
         {
            this.showLeaderboard(TODAY,1);
         }
         else if(e.currentTarget == this._costume.btn_weekly)
         {
            this.showLeaderboard(LAST_7,1);
         }
         else if(e.currentTarget == this._costume.btn_all)
         {
            this.showLeaderboard(ALL_TIME,1);
         }
         else if(e.currentTarget == this._costume.btn_next)
         {
            this.showLeaderboard(this._currentMode,Math.min(Math.floor(this._numScores / this.PER_PAGE) + 1,this._currentPage + 1));
         }
         else if(e.currentTarget == this._costume.btn_previous)
         {
            this.showLeaderboard(this._currentMode,Math.max(1,this._currentPage - 1));
         }
         else if(e.currentTarget == this._costume.btn_first)
         {
            this.showLeaderboard(this._currentMode,1);
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"highscores","sponsor");
         }
      }
      
      public function sendScoreAndShow(pName:String, s:int) : void
      {
         var i:int = 0;
         for(i = 1; i <= 10; i++)
         {
            (this._costume["txt_num" + i.toString()] as TextField).text = "";
            (this._costume["txt_name" + i.toString()] as TextField).text = "";
            (this._costume["txt_points_" + i.toString()] as TextField).text = "";
         }
         this.disableButtons();
         var score:PlayerScore = new PlayerScore(pName,s);
         var table:String = this._name;
         var callback:Function = this.listReturnHandler;
         var options:Object = new Object();
         options.perpage = 10;
         TweenLite.killTweensOf(this._costume.txt_info);
         this._costume.txt_info.alpha = 1;
         this._costume.txt_info.text = "Sending Score... Please Wait";
         options.mode = TODAY;
         this._currentMode = TODAY;
         Leaderboards.SaveAndList(score,table,callback,options);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._costume);
      }
      
      public function get isCreated() : Boolean
      {
         return this._isCreated;
      }
   }
}
