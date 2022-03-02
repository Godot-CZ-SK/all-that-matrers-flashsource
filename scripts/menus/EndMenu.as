package menus
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import game.LevelInfos;
   import game.bonus.BonusLevel;
   import managers.DM;
   import managers.GM;
   import managers.KM;
   import managers.LM;
   import managers.SM;
   import managers.TM;
   
   public class EndMenu extends EventDispatcher
   {
      
      private static var _ins:EndMenu;
       
      
      protected var _levNo:int;
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_EndMenu;
      
      protected var _buttons:Vector.<MovieClip>;
      
      protected var _endSprite:Sprite;
      
      protected var _bonus:MovieClip;
      
      protected var _bonusShown:Boolean;
      
      protected var _specialUnlocked:Array;
      
      public function EndMenu()
      {
         super();
      }
      
      public static function get ins() : EndMenu
      {
         if(!_ins)
         {
            _ins = new EndMenu();
         }
         return _ins;
      }
      
      public function create(levNo:int, hc:int) : void
      {
         var mc:MovieClip = null;
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._levNo = levNo;
         this._bonusShown = false;
         this._costume = new MC_EndMenu();
         this._costume.txt_name.text = LevelInfos.ins.list[this._levNo].levelName;
         this._costume.alpha = 0;
         this._specialUnlocked = [];
         var total:int = LM.ins.cp.getTotalHearts();
         var before:int = total - hc;
         for(var i:int = 0; i < 3; i++)
         {
            if(i == 0)
            {
               mc = this._costume.btn_toby;
            }
            else if(i == 1)
            {
               mc = this._costume.btn_billy;
            }
            else if(i == 2)
            {
               mc = this._costume.btn_elder;
            }
            if(!LM.ins.cp.isBonusSeen(i) && total >= LM.ins.cp.getSpecialHeartsNeeded(i))
            {
               LM.ins.cp.setBonusSeen(i,true);
               this.showBonusUnlocked(i);
               mc.gotoAndStop("point");
               this._specialUnlocked.push(true);
            }
            else if(LM.ins.cp.isBonusSeen(i) && total >= LM.ins.cp.getSpecialHeartsNeeded(i))
            {
               mc.gotoAndStop("out");
               this._specialUnlocked.push(true);
            }
            else
            {
               mc.gotoAndStop("locked_out");
               this._specialUnlocked.push(false);
            }
         }
         TweenLite.to(this._costume,0.5,{"alpha":1});
         DM.ins.menu.addChild(this._costume);
         this._buttons = new Vector.<MovieClip>();
         if(hc > 0)
         {
            TM.ins.tf(function():void
            {
               _costume.mc_heart1.gotoAndPlay("unlock");
            },0.75);
         }
         if(hc > 1)
         {
            TM.ins.tf(function():void
            {
               _costume.mc_heart2.gotoAndPlay("unlock");
            },1);
         }
         if(hc > 2)
         {
            TM.ins.tf(function():void
            {
               _costume.mc_heart3.gotoAndPlay("unlock");
            },1.25);
         }
         this._buttons.push(this._costume.btn_back,this._costume.btn_continue,this._costume.btn_replay,this._costume.btn_billy,this._costume.btn_elder,this._costume.btn_toby,this._costume.btn_sponsor);
         this.addEvents();
      }
      
      public function setAvailable(val:Boolean) : void
      {
         if(val)
         {
            this._costume.txt_info.text = "press space to continue";
         }
         else
         {
            this._costume.txt_info.text = "you haven\'t collected enough hearts to proceed\n" + "press space to replay";
         }
      }
      
      private function showBonusUnlocked(id:int) : void
      {
         if(this._bonusShown)
         {
            return;
         }
         this._bonusShown = true;
         if(id == 0)
         {
            this._bonus = new MC_BonusLevel1Pop();
         }
         else if(id == 1)
         {
            this._bonus = new MC_BonusLevel2Pop();
         }
         else
         {
            if(id != 2)
            {
               return;
            }
            this._bonus = new MC_BonusLevel3Pop();
         }
         this._costume.addChild(this._bonus);
         this._bonus.x = 320;
         this._bonus.y = 240;
         this._bonus.scaleX = 0;
         this._bonus.scaleY = 0;
         TweenLite.to(this._bonus,0.5,{
            "scaleX":1,
            "scaleY":1
         });
         TM.ins.tf(function():void
         {
            TweenLite.to(_bonus,0.5,{
               "scaleX":0,
               "scaleY":0
            });
         },4);
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_bonus);
         },4.5);
      }
      
      private function addEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
            this._buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
            this._buttons[i].mouseChildren = false;
            this._buttons[i].buttonMode = true;
         }
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function removeEvents() : void
      {
         for(var i:int = 0; i < this._buttons.length; i++)
         {
            this._buttons[i].removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
            this._buttons[i].removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
            this._buttons[i].buttonMode = false;
         }
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.SPACE)
         {
            dispatchEvent(new Event("next"));
            this.remove();
         }
         else if(e.keyCode == KM.ESCAPE)
         {
            dispatchEvent(new Event("back"));
            this.remove();
         }
         else if(e.keyCode == KM.KEY_R)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
      }
      
      public function timedRemove() : void
      {
         this.removeEvents();
         this._endSprite = new Sprite();
         this._endSprite.graphics.clear();
         this._endSprite.graphics.beginFill(0,1);
         this._endSprite.graphics.drawRect(0,0,640,480);
         this._endSprite.graphics.endFill();
         this._endSprite.alpha = 0;
         this._costume.addChild(this._endSprite);
         TweenLite.to(this._endSprite,0.75,{"alpha":1});
         TM.ins.tf(function():void
         {
            remove();
         },0.75);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this.removeEvents();
         CF.removeDisplayObject(this._bonus);
         CF.removeDisplayObject(this._endSprite);
         CF.removeDisplayObject(this._costume);
         this._buttons = new Vector.<MovieClip>();
         this._bonusShown = false;
      }
      
      private function buttonOutHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "new_over")
         {
            mc.gotoAndStop("new_out");
         }
         else if(mc.currentLabel == "locked_over")
         {
            mc.gotoAndStop("locked_out");
         }
         else
         {
            mc.gotoAndStop("out");
         }
      }
      
      private function buttonOverHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_OVER);
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentLabel == "new_out")
         {
            mc.gotoAndStop("new_over");
         }
         else if(mc.currentLabel == "locked_out")
         {
            mc.gotoAndStop("locked_over");
         }
         else
         {
            mc.gotoAndStop("over");
         }
      }
      
      private function buttonClickHandler(e:MouseEvent) : void
      {
         SM.ins.playSound(GameSound.BUTTON_CLICK);
         if(e.currentTarget == this._costume.btn_back)
         {
            dispatchEvent(new Event("back"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_continue)
         {
            dispatchEvent(new Event("next"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_replay)
         {
            dispatchEvent(new Event("replay"));
            this.remove();
         }
         else if(e.currentTarget == this._costume.btn_toby && this._specialUnlocked[0])
         {
            dispatchEvent(new Event("remove"));
            this.remove();
            GM.ins.startBonusLevel(BonusLevel.TOBYS_DREAM);
         }
         else if(e.currentTarget == this._costume.btn_billy && this._specialUnlocked[1])
         {
            dispatchEvent(new Event("remove"));
            this.remove();
            GM.ins.startBonusLevel(BonusLevel.BILLYS_ADVENTURE);
         }
         else if(e.currentTarget == this._costume.btn_elder && this._specialUnlocked[2])
         {
            dispatchEvent(new Event("remove"));
            GM.ins.startBonusLevel(BonusLevel.ELDER_ROLLS);
         }
         else if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"endMenu","sponsor");
         }
      }
   }
}
