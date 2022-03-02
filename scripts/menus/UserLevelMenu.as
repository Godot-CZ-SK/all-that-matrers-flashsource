package menus
{
   import Playtomic.Link;
   import Playtomic.PlayerLevel;
   import Playtomic.PlayerLevels;
   import com.greensock.TweenLite;
   import design.data.LevelData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.GM;
   import managers.SM;
   import managers.TM;
   
   public class UserLevelMenu
   {
      
      public static const NEWEST:String = "newest";
      
      public static const POPULAR:String = "popular";
      
      private static var _ins:UserLevelMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_UserLevelMenu;
      
      protected var _buttons:Array;
      
      protected var _maps:Vector.<UL_Map>;
      
      protected var _playerLevels:Array;
      
      protected var _cm:String;
      
      protected var _cp:int;
      
      public function UserLevelMenu()
      {
         super();
      }
      
      public static function get ins() : UserLevelMenu
      {
         if(!_ins)
         {
            _ins = new UserLevelMenu();
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
         this._costume = new MC_UserLevelMenu();
         DM.ins.menu.addChild(this._costume);
         this._buttons = [this._costume.btn_firstPage,this._costume.btn_popular,this._costume.btn_newest,this._costume.btn_next,this._costume.btn_prev,this._costume.mc_interface.btn_back,this._costume.mc_interface.btn_sponsor];
         this._maps = new Vector.<UL_Map>();
         this._costume.alpha = 0;
         TweenLite.to(this._costume,1,{"alpha":1});
         TM.ins.tf(function():void
         {
            addEvents();
         },0.5);
         this.list(NEWEST,1);
      }
      
      private function list(mode:String, page:int) : void
      {
         this._costume.mc_load.visible = true;
         this._costume.mc_load.txt_load.text = "Loading User Levels\n" + "Please Stand By...";
         this._costume.mc_load.mc_load.visible = true;
         var options:Object = {
            "mode":mode,
            "page":page,
            "data":true,
            "perpage":12
         };
         PlayerLevels.List(this.listingCompleted,options);
         this.clearLevels();
         this.disableButtons();
         this._cm = mode;
         this._cp = page;
      }
      
      private function clearLevels() : void
      {
         var i:int = 0;
         for(i = 0; i < this._maps.length; i++)
         {
            this._maps[i].remove();
         }
         this._maps = new Vector.<UL_Map>();
      }
      
      private function listingCompleted(levels:Array, numlevels:int, response:Object) : void
      {
         var i:int = 0;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var ulMap:UL_Map = null;
         var pl:PlayerLevel = null;
         this.enableButtons();
         if(response.Success)
         {
            trace("Numlevels: " + numlevels.toString());
            this._costume.mc_load.visible = false;
            if(this._cm == NEWEST)
            {
               this._costume.btn_newest.gotoAndStop("selected");
            }
            else if(this._cm == POPULAR)
            {
               this._costume.btn_popular.gotoAndStop("selected");
            }
            for(i = 0; i < levels.length; i++)
            {
               pl = levels[i];
               trace(pl.Data,pl.Name);
               xpos = 30 + 150 * (i % 4);
               ypos = 75 + 110 * int(i / 4);
               ulMap = new UL_Map(this._costume,pl.LevelId,pl.Name,pl.Rating,xpos,ypos);
               ulMap.create();
               ulMap.addEventListener(MouseEvent.CLICK,this.levelClickHandler);
               this._maps.push(ulMap);
               if(pl.Data == "" || pl.Data == null)
               {
                  PlayerLevels.Load(pl.LevelId,this.levelLoadCompleted);
               }
               else
               {
                  ulMap.setData(pl.Data);
               }
            }
         }
         else
         {
            trace("Error: " + response.ErrorCode);
            this._costume.mc_load.mc_load.visible = false;
            this._costume.mc_load.txt_load.text = "There was an error listing levels.\n" + "Please try again later.";
         }
         this.enableButtons();
      }
      
      private function levelLoadCompleted(level:PlayerLevel, response:Object) : void
      {
         var i:int = 0;
         if(response.Success)
         {
            for(i = 0; i < this._maps.length; i++)
            {
               if(level.LevelId == this._maps[i].id)
               {
                  this._maps[i].setData(level.Data);
                  break;
               }
            }
         }
         else
         {
            trace("Error: " + response.ErrorCode);
         }
      }
      
      private function levelClickHandler(e:MouseEvent) : void
      {
         var levelData:LevelData = null;
         var levelId:String = null;
         var ulMap:UL_Map = e.currentTarget as UL_Map;
         this.timedRemove();
         levelData = ulMap.data.clone();
         levelId = ulMap.id;
         TM.ins.tf(function():void
         {
            GM.ins.startUserLevel(levelId,levelData);
         },1);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "disabled")
         {
            return;
         }
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(mc == this._costume.mc_interface.btn_back)
         {
            this.timedRemove();
            TM.ins.tf(function():void
            {
               MainMenu.ins.create();
            },1);
         }
         else if(mc == this._costume.btn_newest)
         {
            this.list(NEWEST,1);
         }
         else if(mc == this._costume.btn_popular)
         {
            this.list(POPULAR,1);
         }
         else if(mc == this._costume.mc_interface.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"userLevels","sponsor");
         }
         else if(mc == this._costume.btn_next)
         {
            this.list(this._cm,this._cp + 1);
         }
         else if(mc == this._costume.btn_prev)
         {
            this.list(this._cm,Math.max(1,this._cp - 1));
         }
         else if(mc == this._costume.btn_firstPage)
         {
            this.list(this._cm,1);
         }
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel != "disabled" && mc.currentLabel != "selected")
         {
            mc.gotoAndStop("over");
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel != "disabled" && mc.currentLabel != "selected")
         {
            mc.gotoAndStop("out");
         }
      }
      
      private function disableButtons() : void
      {
         this._costume.btn_firstPage.gotoAndStop("disabled");
         this._costume.btn_newest.gotoAndStop("disabled");
         this._costume.btn_next.gotoAndStop("disabled");
         this._costume.btn_popular.gotoAndStop("disabled");
         this._costume.btn_prev.gotoAndStop("disabled");
      }
      
      private function enableButtons() : void
      {
         this._costume.btn_firstPage.gotoAndStop("out");
         this._costume.btn_newest.gotoAndStop("out");
         this._costume.btn_next.gotoAndStop("out");
         this._costume.btn_popular.gotoAndStop("out");
         this._costume.btn_prev.gotoAndStop("out");
      }
      
      public function addEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
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
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            this._buttons[i].buttonMode = false;
         }
      }
      
      private function timedRemove() : void
      {
         this.removeEvents();
         this.clearLevels();
         TweenLite.to(this._costume,1,{"alpha":0});
         TM.ins.tf(function():void
         {
            remove();
         },1);
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
   }
}
