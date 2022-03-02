package menus
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import design.data.DO_Data;
   import design.data.DO_UnitData;
   import design.data.LevelData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.Background;
   import game.GameSound;
   import game.LevelInfos;
   import game.bonus.BonusLevel;
   import managers.DM;
   import managers.GM;
   import managers.LM;
   import managers.SM;
   import managers.TM;
   
   public class LevelSelectionMenu
   {
      
      private static var _ins:LevelSelectionMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MovieClip;
      
      protected var _levelButtons:Array;
      
      protected var _specialButtons:Array;
      
      protected var _levelMap:MovieClip;
      
      protected var _levelBg:Sprite;
      
      protected var _vc:VC_Panel;
      
      protected var _sponsor:MC_LS_Sponsor;
      
      protected var _bottomBar:MC_LS_Interface;
      
      public function LevelSelectionMenu()
      {
         super();
      }
      
      public static function get ins() : LevelSelectionMenu
      {
         if(!_ins)
         {
            _ins = new LevelSelectionMenu();
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
         TitleScreen.ins.create();
         this._costume = new MovieClip();
         DM.ins.menu.addChild(this._costume);
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(0);
         mask.graphics.drawRect(0,0,640,480);
         DM.ins.menu.addChild(mask);
         this._costume.mask = mask;
         this.createInterface();
         TM.ins.tf(function():void
         {
            createButtons();
         },0.5);
         TM.ins.tf(function():void
         {
            addEvents();
         },1);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         var i:int = 0;
         for(i = 0; i < this._levelButtons.length; i++)
         {
            CF.removeDisplayObject(this._levelButtons[i]);
         }
         for(i = 0; i < this._specialButtons.length; i++)
         {
            CF.removeDisplayObject(this._specialButtons[i]);
         }
         this._levelButtons = [];
         this._specialButtons = [];
         this._vc.remove();
         CF.removeDisplayObject(this._sponsor);
         CF.removeDisplayObject(this._levelMap);
         CF.removeDisplayObject(this._bottomBar);
         CF.removeDisplayObject(this._costume);
         this._bottomBar = null;
         this._vc = null;
      }
      
      public function timedRemove() : void
      {
         CF.removeDisplayObject(this._levelMap);
         this.removeEvents();
         this.removeInterface();
         TM.ins.tf(function():void
         {
            removeButtons();
         },0.5);
         TM.ins.tf(function():void
         {
            remove();
         },2.7);
      }
      
      private function createButtons() : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var levButton:MC_LS_LevelIcon = null;
         var lockedLev:MC_LS_LevelIconLocked = null;
         var speButton:MC_LS_SpecialIcon = null;
         var portrait:MovieClip = null;
         var lockedSpe:MC_LS_LevelIconLocked = null;
         if(this._levelButtons && this._levelButtons.length > 0)
         {
            return;
         }
         var i:int = 0;
         this._levelButtons = [];
         this._specialButtons = [];
         this._vc = new VC_Panel(this._costume,570,20);
         this._vc.create();
         this._sponsor = new MC_LS_Sponsor();
         this._costume.addChild(this._sponsor);
         this._sponsor.x = 380;
         this._sponsor.y = 305;
         this._sponsor.alpha = 0;
         TweenLite.to(this._sponsor,1,{"alpha":1});
         this._sponsor.buttonMode = true;
         this._sponsor.mouseChildren = false;
         for(i = 0; i < 25; i++)
         {
            xpos = 40 + 50 * (i % 5);
            ypos = 150 + 50 * int(i / 5);
            if(LM.ins.cp.isLevelUnlocked(i))
            {
               levButton = new MC_LS_LevelIcon();
               levButton.txt_no.text = (i + 1).toString();
               levButton.mc_heart3.gotoAndStop("unlocked");
               levButton.mc_heart2.gotoAndStop("unlocked");
               levButton.mc_heart1.gotoAndStop("unlocked");
               if(LM.ins.cp.getLevelHearts(i) < 3)
               {
                  levButton.mc_heart3.gotoAndStop("locked");
                  levButton.mc_heart3.filters = [];
               }
               if(LM.ins.cp.getLevelHearts(i) < 2)
               {
                  levButton.mc_heart2.gotoAndStop("locked");
                  levButton.mc_heart2.filters = [];
               }
               if(LM.ins.cp.getLevelHearts(i) < 1)
               {
                  levButton.mc_heart1.gotoAndStop("locked");
                  levButton.mc_heart1.filters = [];
               }
               levButton.x = xpos;
               levButton.y = ypos;
               levButton.alpha = 0;
               TweenLite.to(levButton,0.3,{
                  "alpha":1,
                  "delay":i * 0.025
               });
               this._costume.addChild(levButton);
               this._levelButtons.push(levButton);
            }
            else
            {
               lockedLev = new MC_LS_LevelIconLocked();
               lockedLev.x = xpos;
               lockedLev.y = ypos;
               lockedLev.alpha = 0;
               TweenLite.to(lockedLev,0.3,{
                  "alpha":1,
                  "delay":i * 0.025
               });
               this._costume.addChild(lockedLev);
               this._levelButtons.push(lockedLev);
            }
         }
         for(i = 0; i < 3; i++)
         {
            xpos = 305;
            ypos = 200 + 50 * i;
            if(LM.ins.cp.isSpecialUnlocked(i))
            {
               speButton = new MC_LS_SpecialIcon();
               if(i == 0)
               {
                  portrait = new MC_DO_Baby();
               }
               else if(i == 1)
               {
                  portrait = new MC_DO_Kid();
               }
               else if(i == 2)
               {
                  portrait = new MC_DO_Elder();
               }
               speButton.x = xpos;
               speButton.y = ypos;
               speButton.alpha = 0;
               TweenLite.to(speButton,0.3,{
                  "alpha":1,
                  "delay":i * 0.1
               });
               speButton.addChild(portrait);
               this._costume.addChild(speButton);
               this._specialButtons.push(speButton);
            }
            else
            {
               lockedSpe = new MC_LS_LevelIconLocked();
               lockedSpe.x = xpos;
               lockedSpe.y = ypos;
               lockedSpe.alpha = 0;
               TweenLite.to(lockedSpe,0.3,{
                  "alpha":1,
                  "delay":i * 0.1
               });
               this._costume.addChild(lockedSpe);
               this._specialButtons.push(lockedSpe);
            }
         }
      }
      
      private function specialOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         CF.removeDisplayObject(this._levelMap);
         var speNo:int = this._specialButtons.indexOf(e.currentTarget);
         if(speNo == 0)
         {
            this._levelMap = new MC_BonusLevel1();
         }
         else if(speNo == 1)
         {
            this._levelMap = new MC_BonusLevel2();
         }
         else if(speNo == 2)
         {
            this._levelMap = new MC_BonusLevel3();
         }
         this._levelMap.txt_hs.text = "Highscore: " + LM.ins.cp.getSpecialHearts(speNo).toString();
         this._costume.addChild(this._levelMap);
         this._levelMap.x = 380;
         this._levelMap.y = 110;
      }
      
      private function lockedOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         CF.removeDisplayObject(this._levelMap);
         var levNo:int = this._levelButtons.indexOf(e.currentTarget);
         this._levelMap = new MC_LockedLevel();
         this._levelMap.x = 380;
         this._levelMap.y = 110;
         this._levelMap.txt_info.text = "Get " + LM.ins.cp.getLevelHeartsNeeded(levNo).toString() + " hearts to unlock this level.";
         this._costume.addChild(this._levelMap);
      }
      
      private function lockedSpecialOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         CF.removeDisplayObject(this._levelMap);
         var speNo:int = this._specialButtons.indexOf(e.currentTarget);
         this._levelMap = new MC_LockedLevel();
         this._levelMap.x = 380;
         this._levelMap.y = 110;
         this._levelMap.txt_info.text = "Get " + LM.ins.cp.getSpecialHeartsNeeded(speNo).toString() + " hearts to unlock this level.";
         this._costume.addChild(this._levelMap);
      }
      
      private function removeButtons() : void
      {
         this._vc.remove();
         TweenLite.to(this._sponsor,0.5,{"alpha":0});
         for(var i:int = 0; i < this._levelButtons.length; i++)
         {
            TweenLite.to(this._levelButtons[i],0.2,{
               "alpha":0,
               "delay":0.01 * i
            });
         }
         for(i = 0; i < this._specialButtons.length; i++)
         {
            TweenLite.to(this._specialButtons[i],0.2,{
               "alpha":0,
               "delay":0.05 * i
            });
         }
      }
      
      private function createInterface() : void
      {
         if(!this._bottomBar)
         {
            this._bottomBar = new MC_LS_Interface();
            this._bottomBar.btn_unlock.visible = false;
            this._costume.addChild(this._bottomBar);
            this._bottomBar.x = 10;
            this._bottomBar.y = 490;
            TweenLite.to(this._bottomBar,0.25,{"y":420});
            this._bottomBar.txt_hearts.text = LM.ins.cp.getTotalHearts().toString() + " / 75";
            this._levelBg = new Sprite();
            this._levelBg.graphics.beginFill(0,0.9);
            this._levelBg.graphics.drawRoundRect(555,10,75,75,10,10);
            this._levelBg.graphics.drawRoundRect(10,110,355,290,10,10);
            this._levelBg.graphics.drawRoundRect(380,110,250,180,10,10);
            this._levelBg.graphics.drawRoundRect(380,300,250,80,10,10);
            this._costume.addChild(this._levelBg);
            this._levelBg.alpha = 0;
            TweenLite.to(this._levelBg,0.25,{
               "alpha":1,
               "delay":0.15
            });
            if(!LM.ins.cp.isLevelUnlocked(25))
            {
               this._bottomBar.btn_outro.visible = false;
            }
         }
      }
      
      private function removeInterface() : void
      {
         if(this._bottomBar)
         {
            TweenLite.to(this._bottomBar,0.5,{"y":490});
            TweenLite.to(this._levelBg,0.5,{
               "alpha":0,
               "delay":1
            });
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_bottomBar);
               CF.removeDisplayObject(_levelBg);
            },1.5);
         }
      }
      
      private function levelOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         CF.removeDisplayObject(this._levelMap);
         var levNo:int = this._levelButtons.indexOf(e.currentTarget);
         var ld:LevelData = LevelInfos.ins.getLevel(levNo);
         this._levelMap = this.convertLevelToMinimap(ld);
         this._costume.addChild(this._levelMap);
         this._levelMap.x = 380;
         this._levelMap.y = 110;
      }
      
      private function levelOutHandler(e:MouseEvent) : void
      {
         CF.removeDisplayObject(this._levelMap);
      }
      
      private function buttonClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._bottomBar.btn_back)
         {
            this.timedRemove();
            TM.ins.tf(function():void
            {
               MainMenu.ins.create();
            },2.5);
         }
         else if(e.currentTarget == this._bottomBar.btn_message)
         {
            SM.ins.fadeMusic(1.2);
            this.timedRemove();
            TM.ins.tf(function():void
            {
               TitleScreen.ins.fadeOutAndRemove(0.5);
            },2.4);
            TM.ins.tf(function():void
            {
               IntroMenu.ins.create(IntroMenu.WALTER_INTRO);
            },2.9);
         }
         else if(e.currentTarget == this._bottomBar.btn_outro)
         {
            SM.ins.fadeMusic(1.2);
            this.timedRemove();
            TM.ins.tf(function():void
            {
               TitleScreen.ins.fadeOutAndRemove(0.5);
            },2.4);
            TM.ins.tf(function():void
            {
               IntroMenu.ins.create(IntroMenu.WALTER_OUTRO);
            },2.9);
         }
         else if(e.currentTarget == this._bottomBar.btn_unlock)
         {
            LM.ins.cp.unlockLevels();
            this.remove();
            this.create();
         }
         else if(e.currentTarget == this._sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"levelSelection","sponsor");
         }
      }
      
      private function buttonOutHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("out");
      }
      
      private function buttonOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("over");
      }
      
      protected function convertLevelToMinimap(ld:LevelData) : MovieClip
      {
         var bg:MovieClip = null;
         var dad:Boolean = false;
         var mom:Boolean = false;
         var kid:Boolean = false;
         var baby:Boolean = false;
         var elder:Boolean = false;
         var dp:MC_DO_Dad = null;
         var mp:MC_DO_Mom = null;
         var kp:MC_DO_Kid = null;
         var bp:MC_DO_Baby = null;
         var ep:MC_DO_Elder = null;
         var mc:MovieClip = new MovieClip();
         mc.graphics.lineStyle(1,16777215);
         mc.graphics.moveTo(145,12.5);
         mc.graphics.lineTo(145,102.5);
         Font.registerFont(apple);
         Font.enumerateFonts();
         var tf:TextField = new TextField();
         var format:TextFormat = new TextFormat("appleberry",18,16777215,null,null,null,null,null,TextFormatAlign.CENTER);
         tf.embedFonts = true;
         tf.defaultTextFormat = format;
         tf.text = ld.levelName;
         tf.width = 250;
         tf.y = 110;
         mc.addChild(tf);
         if(ld.background == Background.FAERIE)
         {
            bg = new MC_FaerieMapSmall();
         }
         else if(ld.background == Background.MOUNTAIN)
         {
            bg = new MC_MountainMapSmall();
         }
         else if(ld.background == Background.CITY)
         {
            bg = new MC_CityMapSmall();
         }
         else
         {
            bg = new MovieClip();
         }
         bg.x = 15;
         bg.y = 12.5;
         mc.addChild(bg);
         var objects:MovieClip = new MovieClip();
         mc.addChild(objects);
         objects.x = 15;
         objects.y = 12.5;
         for(var i:int = 0; i < ld.list.length; i++)
         {
            ld.list[i].debugDraw(0.08,objects.graphics);
            if(ld.list[i].type == DO_Data.TYPE_UNIT)
            {
               if((ld.list[i] as DO_UnitData).unitType == DO_UnitData.DAD)
               {
                  dad = true;
               }
               if((ld.list[i] as DO_UnitData).unitType == DO_UnitData.MOM)
               {
                  mom = true;
               }
               if((ld.list[i] as DO_UnitData).unitType == DO_UnitData.KID)
               {
                  kid = true;
               }
               if((ld.list[i] as DO_UnitData).unitType == DO_UnitData.BABY)
               {
                  baby = true;
               }
               if((ld.list[i] as DO_UnitData).unitType == DO_UnitData.ELDER)
               {
                  elder = true;
               }
            }
         }
         var xoffset:Number = 170;
         var yoffset:Number = 40;
         if(dad)
         {
            dp = new MC_DO_Dad();
            dp.x = xoffset;
            dp.y = yoffset;
            dp.scaleX = 0.8;
            dp.scaleY = 0.8;
            mc.addChild(dp);
            xoffset += 30;
            if(xoffset > 250)
            {
               xoffset = 170;
               yoffset += 30;
            }
         }
         if(mom)
         {
            mp = new MC_DO_Mom();
            mp.x = xoffset;
            mp.y = yoffset;
            mp.scaleX = 0.8;
            mp.scaleY = 0.8;
            mc.addChild(mp);
            xoffset += 30;
            if(xoffset > 250)
            {
               xoffset = 170;
               yoffset += 30;
            }
         }
         if(kid)
         {
            kp = new MC_DO_Kid();
            kp.x = xoffset;
            kp.y = yoffset;
            kp.scaleX = 0.8;
            kp.scaleY = 0.8;
            mc.addChild(kp);
            xoffset += 30;
            if(xoffset > 250)
            {
               xoffset = 170;
               yoffset += 30;
            }
         }
         if(baby)
         {
            bp = new MC_DO_Baby();
            bp.x = xoffset;
            bp.y = yoffset;
            bp.scaleX = 0.8;
            bp.scaleY = 0.8;
            mc.addChild(bp);
            xoffset += 30;
            if(xoffset > 250)
            {
               xoffset = 170;
               yoffset += 30;
            }
         }
         if(elder)
         {
            ep = new MC_DO_Elder();
            ep.x = xoffset;
            ep.y = yoffset;
            ep.scaleX = 0.8;
            ep.scaleY = 0.8;
            mc.addChild(ep);
            xoffset += 30;
            if(xoffset > 250)
            {
               xoffset = 170;
               yoffset += 30;
            }
         }
         return mc;
      }
      
      private function specialClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         var speNo:int = this._specialButtons.indexOf(e.currentTarget);
         if(speNo == 0)
         {
            GM.ins.startBonusLevel(BonusLevel.TOBYS_DREAM);
         }
         else if(speNo == 1)
         {
            GM.ins.startBonusLevel(BonusLevel.BILLYS_ADVENTURE);
         }
         else if(speNo == 2)
         {
            GM.ins.startBonusLevel(BonusLevel.ELDER_ROLLS);
         }
         this.remove();
      }
      
      private function levelClickHandler(e:MouseEvent) : void
      {
         var levNo:int = 0;
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         this.fadeOut(1.5);
         levNo = this._levelButtons.indexOf(e.currentTarget);
         TM.ins.tf(function():void
         {
            GM.ins.startLevelNo(levNo);
         },1.5);
      }
      
      private function fadeOut(time:Number) : void
      {
         var spr:Sprite = null;
         this.removeEvents();
         spr = new Sprite();
         spr.graphics.clear();
         spr.graphics.beginFill(0,1);
         spr.graphics.drawRect(0,0,640,480);
         spr.graphics.endFill();
         DM.ins.menu.addChild(spr);
         spr.alpha = 0;
         TweenLite.to(spr,time * 0.8,{"alpha":1});
         TM.ins.tf(function():void
         {
            remove();
            CF.removeDisplayObject(spr);
         },time);
      }
      
      private function addEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < this._levelButtons.length; i++)
         {
            if(LM.ins.cp.isLevelUnlocked(i))
            {
               this._levelButtons[i].buttonMode = true;
               this._levelButtons[i].mouseChildren = false;
               this._levelButtons[i].addEventListener(MouseEvent.CLICK,this.levelClickHandler,false,0,true);
               this._levelButtons[i].addEventListener(MouseEvent.ROLL_OVER,this.levelOverHandler,false,0,true);
               this._levelButtons[i].addEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler,false,0,true);
            }
            else
            {
               this._levelButtons[i].addEventListener(MouseEvent.ROLL_OVER,this.lockedOverHandler,false,0,true);
               this._levelButtons[i].addEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler,false,0,true);
            }
         }
         for(i = 0; i < this._specialButtons.length; i++)
         {
            if(LM.ins.cp.isSpecialUnlocked(i))
            {
               this._specialButtons[i].buttonMode = true;
               this._specialButtons[i].mouseChildren = false;
               this._specialButtons[i].addEventListener(MouseEvent.CLICK,this.specialClickHandler,false,0,true);
               this._specialButtons[i].addEventListener(MouseEvent.ROLL_OVER,this.specialOverHandler,false,0,true);
               this._specialButtons[i].addEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler,false,0,true);
            }
            else
            {
               this._specialButtons[i].addEventListener(MouseEvent.ROLL_OVER,this.lockedSpecialOverHandler,false,0,true);
               this._specialButtons[i].addEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler,false,0,true);
            }
         }
         this._bottomBar.btn_back.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._bottomBar.btn_back.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._bottomBar.btn_back.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._bottomBar.btn_back.buttonMode = true;
         this._bottomBar.btn_back.mouseChildren = false;
         this._bottomBar.btn_unlock.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._bottomBar.btn_unlock.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._bottomBar.btn_unlock.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._bottomBar.btn_unlock.buttonMode = true;
         this._bottomBar.btn_unlock.mouseChildren = false;
         this._bottomBar.btn_message.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._bottomBar.btn_message.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._bottomBar.btn_message.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._bottomBar.btn_message.buttonMode = true;
         this._bottomBar.btn_message.mouseChildren = false;
         this._bottomBar.btn_outro.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._bottomBar.btn_outro.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._bottomBar.btn_outro.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._bottomBar.btn_outro.buttonMode = true;
         this._bottomBar.btn_outro.mouseChildren = false;
         this._sponsor.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._sponsor.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._sponsor.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
      }
      
      private function removeEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < this._levelButtons.length; i++)
         {
            if(LM.ins.cp.isLevelUnlocked(i))
            {
               this._levelButtons[i].buttonMode = false;
               this._levelButtons[i].removeEventListener(MouseEvent.CLICK,this.levelClickHandler);
               this._levelButtons[i].removeEventListener(MouseEvent.ROLL_OVER,this.levelOverHandler);
               this._levelButtons[i].removeEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler);
            }
            else
            {
               this._levelButtons[i].removeEventListener(MouseEvent.ROLL_OVER,this.lockedOverHandler);
               this._levelButtons[i].removeEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler);
            }
         }
         for(i = 0; i < this._specialButtons.length; i++)
         {
            if(LM.ins.cp.isSpecialUnlocked(i))
            {
               this._specialButtons[i].buttonMode = false;
               this._specialButtons[i].removeEventListener(MouseEvent.CLICK,this.specialClickHandler);
               this._specialButtons[i].removeEventListener(MouseEvent.ROLL_OVER,this.specialOverHandler);
               this._specialButtons[i].removeEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler);
            }
            else
            {
               this._specialButtons[i].removeEventListener(MouseEvent.ROLL_OVER,this.lockedSpecialOverHandler);
               this._specialButtons[i].removeEventListener(MouseEvent.ROLL_OUT,this.levelOutHandler);
            }
         }
         this._bottomBar.btn_unlock.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._bottomBar.btn_unlock.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
         this._bottomBar.btn_unlock.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
         this._bottomBar.btn_back.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._bottomBar.btn_back.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
         this._bottomBar.btn_back.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
         this._bottomBar.btn_message.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._bottomBar.btn_message.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
         this._bottomBar.btn_message.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
         this._bottomBar.btn_outro.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._bottomBar.btn_outro.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
         this._bottomBar.btn_outro.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
         this._sponsor.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
      }
   }
}
