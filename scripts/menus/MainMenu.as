package menus
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import game.Player;
   import managers.DM;
   import managers.KM;
   import managers.LM;
   import managers.SM;
   import managers.TM;
   
   public class MainMenu
   {
      
      private static var _ins:MainMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _firstTime:Boolean;
      
      protected var _costume:MovieClip;
      
      protected var _buttons:MC_MM_Buttons;
      
      protected var _account:MC_MM_Account;
      
      protected var _register:MC_MM_Reg;
      
      protected var _sponsor:MC_MM_Sponsor;
      
      protected var _new:MC_MM_New;
      
      protected var _sure:MC_SureBox;
      
      protected var _deleteSelection:int;
      
      public function MainMenu()
      {
         super();
      }
      
      public static function get ins() : MainMenu
      {
         if(!_ins)
         {
            _ins = new MainMenu();
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
         if(this._firstTime)
         {
            TitleScreen.ins.fadeIn(2);
         }
         else
         {
            TitleScreen.ins.create();
         }
         this._costume = new MovieClip();
         DM.ins.menu.addChild(this._costume);
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(0);
         mask.graphics.drawRect(0,0,640,480);
         mask.graphics.endFill();
         DM.ins.menu.addChild(mask);
         this._costume.mask = mask;
         if(this._firstTime)
         {
            if(LM.ins.cp)
            {
               TM.ins.tf(function():void
               {
                  openAccount();
               },1.5);
            }
            else
            {
               TM.ins.tf(function():void
               {
                  openRegisterMenu();
               },1.5);
            }
         }
         else if(LM.ins.cp)
         {
            this.openAccount();
         }
         else
         {
            this.openRegisterMenu();
         }
      }
      
      public function browseUserLevels() : void
      {
         if(Main.isKong)
         {
            Main.k.sharedContent.browse("UserLevel","BY_RATING");
         }
         else
         {
            this.closeButtons();
            this.closeAccount();
            TM.ins.tf(function():void
            {
               remove();
               UserLevelMenu.ins.create();
            },0.8);
         }
      }
      
      public function firstTime() : void
      {
         this._firstTime = true;
      }
      
      private function openAccount() : void
      {
         this._account = new MC_MM_Account();
         this._costume.addChild(this._account);
         this._account.txt_playerName.text = LM.ins.cp.name;
         this._account.txt_playerHearts.text = LM.ins.cp.getTotalHearts().toString() + " / 75";
         this._account.x = 360;
         this._account.y = -40;
         TweenLite.to(this._account,0.2,{"y":0});
         TM.ins.tf(function():void
         {
            openButtons();
         },0.4);
         this._account.addEventListener(MouseEvent.CLICK,this.accountClickHandler,false,0,true);
         this._account.mouseChildren = false;
         this._account.buttonMode = true;
      }
      
      private function closeAccount() : void
      {
         if(this._account)
         {
            this._account.removeEventListener(MouseEvent.CLICK,this.accountClickHandler);
            TweenLite.to(this._account,0.2,{"y":-40});
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_account);
            },0.2);
         }
      }
      
      private function accountClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._account)
         {
            this.closeAccount();
            this.closeButtons();
            TM.ins.tf(function():void
            {
               openRegisterMenu();
            },0.4);
         }
      }
      
      private function openButtons() : void
      {
         this._buttons = new MC_MM_Buttons();
         this._costume.addChild(this._buttons);
         this._buttons.x = 360;
         this._buttons.y = 480;
         TweenLite.to(this._buttons,0.4,{"y":250});
         var buttons:Array = [this._buttons.btn_play,this._buttons.btn_memories,this._buttons.btn_credits,this._buttons.btn_editor,this._buttons.btn_moregames,this._buttons.btn_userLevels];
         for(var i:int = 0; i < buttons.length; i++)
         {
            (buttons[i] as MovieClip).addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
            (buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
            (buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
            (buttons[i] as MovieClip).buttonMode = true;
            (buttons[i] as MovieClip).mouseChildren = false;
         }
         this._sponsor = new MC_MM_Sponsor();
         this._costume.addChild(this._sponsor);
         this._sponsor.x = 240;
         this._sponsor.y = 500;
         TweenLite.to(this._sponsor,0.4,{
            "y":360,
            "delay":0.3
         });
         this._sponsor.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._sponsor.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._sponsor.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._sponsor.mouseChildren = false;
         this._sponsor.buttonMode = true;
      }
      
      private function closeButtons() : void
      {
         var buttons:Array = null;
         var i:int = 0;
         if(this._buttons)
         {
            buttons = [this._buttons.btn_credits,this._buttons.btn_editor,this._buttons.btn_moregames,this._buttons.btn_play,this._buttons.btn_userLevels];
            for(i = 0; i < buttons.length; i++)
            {
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
            }
            TweenLite.to(this._buttons,0.4,{
               "y":480,
               "delay":0.2
            });
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_buttons);
            },0.6);
         }
         TweenLite.to(this._sponsor,0.4,{"y":500});
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_sponsor);
         },0.4);
      }
      
      private function buttonClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._buttons.btn_play)
         {
            this.closeButtons();
            this.closeAccount();
            if(LM.ins.cp.isIntroPlayed)
            {
               TM.ins.tf(function():void
               {
                  remove();
                  LevelSelectionMenu.ins.create();
               },0.8);
            }
            else
            {
               SM.ins.fadeMusic(1.2);
               TM.ins.tf(function():void
               {
                  TitleScreen.ins.fadeOutAndRemove(1);
               },0.8);
               TM.ins.tf(function():void
               {
                  remove();
                  IntroMenu.ins.create(IntroMenu.WALTER_INTRO);
               },1.8);
            }
         }
         else if(e.currentTarget == this._buttons.btn_memories)
         {
            this.closeButtons();
            this.closeAccount();
            TM.ins.tf(function():void
            {
               remove();
               MemoriesMenu.ins.create();
            },0.8);
         }
         else if(e.currentTarget == this._buttons.btn_userLevels)
         {
            this.browseUserLevels();
         }
         else if(e.currentTarget == this._buttons.btn_editor)
         {
            this.closeButtons();
            this.closeAccount();
            TM.ins.tf(function():void
            {
               TitleScreen.ins.fadeOutAndRemove(1);
            },0.8);
            TM.ins.tf(function():void
            {
               remove();
               DesignMenu.ins.create();
               DesignMenu.ins.loadLastSave();
            },1.8);
         }
         else if(e.currentTarget == this._buttons.btn_credits)
         {
            this.closeButtons();
            this.closeAccount();
            TM.ins.tf(function():void
            {
               remove();
               CreditsMenu.ins.create();
            },0.8);
         }
         else if(e.currentTarget == this._buttons.btn_moregames || e.currentTarget == this._sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"mainMenu","sponsor");
         }
      }
      
      public function selectPlayer(no:int) : void
      {
         LM.ins.choosePlayer(LM.ins.players[no]);
         this.closeRegister();
         TM.ins.tf(function():void
         {
            openAccount();
         },0.4);
      }
      
      public function openRegisterMenu() : void
      {
         this._register = new MC_MM_Reg();
         this._costume.addChild(this._register);
         this._register.x = 360;
         this._register.y = -200;
         TweenLite.to(this._register,0.5,{"y":0});
         this.updateRegisterMenu();
         var buttons:Array = [this._register.mc_profile1.btn_profile,this._register.mc_profile2.btn_profile,this._register.mc_profile3.btn_profile,this._register.mc_profile1.btn_delete,this._register.mc_profile2.btn_delete,this._register.mc_profile3.btn_delete];
         for(var i:int = 0; i < buttons.length; i++)
         {
            (buttons[i] as MovieClip).addEventListener(MouseEvent.CLICK,this.registerClickHandler,false,0,true);
            (buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
            (buttons[i] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
            (buttons[i] as MovieClip).buttonMode = true;
            (buttons[i] as MovieClip).mouseChildren = false;
         }
      }
      
      private function closeRegister() : void
      {
         var buttons:Array = null;
         var i:int = 0;
         if(this._register)
         {
            buttons = [this._register.mc_profile1.btn_profile,this._register.mc_profile2.btn_profile,this._register.mc_profile3.btn_profile,this._register.mc_profile1.btn_delete,this._register.mc_profile2.btn_delete,this._register.mc_profile3.btn_delete];
            for(i = 0; i < buttons.length; i++)
            {
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.CLICK,this.registerClickHandler);
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
               (buttons[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
            }
            TweenLite.to(this._register,0.4,{"y":-200});
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_register);
            },0.4);
         }
      }
      
      public function updateRegisterMenu() : void
      {
         if(this._register == null)
         {
            return;
         }
         if(LM.ins.players.length > 0)
         {
            this._register.mc_profile1.txt_player.textColor = 16777215;
            this._register.mc_profile1.txt_player.text = LM.ins.players[0].name;
            this._register.mc_profile1.btn_delete.visible = true;
         }
         else
         {
            this._register.mc_profile1.txt_player.textColor = 16763904;
            this._register.mc_profile1.txt_player.text = "New Game";
            this._register.mc_profile1.btn_delete.visible = false;
         }
         if(LM.ins.players.length > 1)
         {
            this._register.mc_profile2.txt_player.textColor = 16777215;
            this._register.mc_profile2.txt_player.text = LM.ins.players[1].name;
            this._register.mc_profile2.btn_delete.visible = true;
         }
         else
         {
            this._register.mc_profile2.txt_player.textColor = 16763904;
            this._register.mc_profile2.txt_player.text = "New Game";
            this._register.mc_profile2.btn_delete.visible = false;
         }
         if(LM.ins.players.length > 2)
         {
            this._register.mc_profile3.txt_player.textColor = 16777215;
            this._register.mc_profile3.txt_player.text = LM.ins.players[2].name;
            this._register.mc_profile3.btn_delete.visible = true;
         }
         else
         {
            this._register.mc_profile3.txt_player.textColor = 16763904;
            this._register.mc_profile3.txt_player.text = "New Game";
            this._register.mc_profile3.btn_delete.visible = false;
         }
      }
      
      private function registerClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._register.mc_profile1.btn_profile)
         {
            if(LM.ins.players.length > 0)
            {
               this.selectPlayer(0);
            }
            else
            {
               this.createNew();
            }
         }
         else if(e.currentTarget == this._register.mc_profile2.btn_profile)
         {
            if(LM.ins.players.length > 1)
            {
               this.selectPlayer(1);
            }
            else
            {
               this.createNew();
            }
         }
         else if(e.currentTarget == this._register.mc_profile3.btn_profile)
         {
            if(LM.ins.players.length > 2)
            {
               this.selectPlayer(2);
            }
            else
            {
               this.createNew();
            }
         }
         else if(e.currentTarget == this._register.mc_profile1.btn_delete)
         {
            this.removeSureBox();
            this.createSureBox(this._register.mc_profile1.x,this._register.mc_profile1.y);
            this._deleteSelection = 0;
         }
         else if(e.currentTarget == this._register.mc_profile2.btn_delete)
         {
            this.removeSureBox();
            this.createSureBox(this._register.mc_profile2.x,this._register.mc_profile2.y);
            this._deleteSelection = 1;
         }
         else if(e.currentTarget == this._register.mc_profile3.btn_delete)
         {
            this.removeSureBox();
            this.createSureBox(this._register.mc_profile3.x,this._register.mc_profile3.y);
            this._deleteSelection = 2;
         }
      }
      
      private function createSureBox(x:Number, y:Number) : void
      {
         this._sure = new MC_SureBox();
         this._sure.x = x;
         this._sure.y = y;
         this._register.addChild(this._sure);
         this._sure.btn_cancel.addEventListener(MouseEvent.CLICK,this.sureClickHandler,false,0,true);
         this._sure.btn_cancel.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._sure.btn_cancel.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._sure.btn_cancel.mouseChildren = false;
         this._sure.btn_cancel.buttonMode = true;
         this._sure.btn_confirm.addEventListener(MouseEvent.CLICK,this.sureClickHandler,false,0,true);
         this._sure.btn_confirm.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._sure.btn_confirm.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._sure.btn_confirm.mouseChildren = false;
         this._sure.btn_confirm.buttonMode = true;
      }
      
      private function sureClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._sure.btn_cancel)
         {
            this.removeSureBox();
         }
         else if(e.currentTarget == this._sure.btn_confirm)
         {
            LM.ins.removePlayerById(this._deleteSelection);
            this.updateRegisterMenu();
            this.removeSureBox();
         }
      }
      
      private function removeSureBox() : void
      {
         if(this._sure)
         {
            CF.removeDisplayObject(this._sure);
         }
      }
      
      private function createNew() : void
      {
         this._new = new MC_MM_New();
         this._new.x = 640;
         this._new.y = 45;
         TweenLite.to(this._new,0.4,{"x":360});
         this._costume.addChild(this._new);
         this._new.btn_back.addEventListener(MouseEvent.CLICK,this.newClickHandler,false,0,true);
         this._new.btn_back.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._new.btn_back.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._new.btn_ok.addEventListener(MouseEvent.CLICK,this.newClickHandler,false,0,true);
         this._new.btn_ok.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._new.btn_ok.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._new.btn_back.buttonMode = true;
         this._new.btn_back.mouseChildren = false;
         this._new.btn_ok.buttonMode = true;
         this._new.btn_ok.mouseChildren = false;
         this._new.txt_input.maxChars = 16;
         this._new.txt_input.restrict = "a-z A-Z 0-9";
         Main.s.focus = this._new.txt_input;
         this._new.txt_input.setSelection(0,this._new.txt_input.text.length);
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.newKeyHandler,false,0,true);
      }
      
      private function newKeyHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.ENTER)
         {
            this._new.btn_ok.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         else if(e.keyCode == KM.ESCAPE)
         {
            this._new.btn_back.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function closeNew() : void
      {
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.newKeyHandler);
         if(this._new)
         {
            this._new.btn_back.removeEventListener(MouseEvent.CLICK,this.newClickHandler);
            this._new.btn_back.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
            this._new.btn_back.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
            this._new.btn_ok.removeEventListener(MouseEvent.CLICK,this.newClickHandler);
            this._new.btn_ok.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
            this._new.btn_ok.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
            TweenLite.to(this._new,0.4,{"x":640});
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_new);
            },0.4);
         }
      }
      
      private function newClickHandler(e:MouseEvent) : void
      {
         var p:Player = null;
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._new.btn_back)
         {
            this.closeNew();
         }
         else if(e.currentTarget == this._new.btn_ok)
         {
            if(this._new.txt_input.text == "Type Your Name")
            {
               return;
            }
            this.closeNew();
            this.closeRegister();
            TM.ins.tf(function():void
            {
               openAccount();
            },0.4);
            p = new Player(this._new.txt_input.text);
            LM.ins.addPlayer(p);
            LM.ins.choosePlayer(p);
            this.updateRegisterMenu();
         }
      }
      
      private function buttonOutHandler(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      private function buttonOverHandler(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).gotoAndStop("over");
         SM.ins.playSound(GameSound.BUTTON_OVER);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this._firstTime = false;
         CF.removeDisplayObject(this._costume);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.newKeyHandler);
      }
   }
}
