package menus
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import game.Memory;
   import managers.DM;
   import managers.LM;
   import managers.TM;
   
   public class MemoriesMenu
   {
      
      private static var _ins:MemoriesMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MovieClip;
      
      protected var _titleText:TextField;
      
      protected var _explanationText:TextField;
      
      protected var _memoryButtons:Array;
      
      protected var _memoryHolder:MovieClip;
      
      protected var _bottomBar:MC_MEM_Interface;
      
      protected var _infoBar:MC_MEM_InfoBar;
      
      public function MemoriesMenu()
      {
         super();
      }
      
      public static function get ins() : MemoriesMenu
      {
         if(!_ins)
         {
            _ins = new MemoriesMenu();
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
         this._costume = new MovieClip();
         DM.ins.menu.addChild(this._costume);
         this.createInterface();
         TM.ins.tf(function():void
         {
            createButtons();
         },1);
         TM.ins.tf(function():void
         {
            addEvents();
         },2);
      }
      
      public function remove() : void
      {
         var i:int = 0;
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         for(i = 0; i < this._memoryButtons.length; i++)
         {
            CF.removeDisplayObject(this._memoryButtons[i]);
         }
         this._memoryButtons = [];
         CF.removeDisplayObject(this._infoBar);
         CF.removeDisplayObject(this._bottomBar);
         CF.removeDisplayObject(this._costume);
         this._bottomBar = null;
      }
      
      public function timedRemove() : void
      {
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
      
      private function createInterface() : void
      {
         if(!this._bottomBar)
         {
            this._bottomBar = new MC_MEM_Interface();
            this._costume.addChild(this._bottomBar);
            this._bottomBar.x = 10;
            this._bottomBar.y = 490;
            TweenLite.to(this._bottomBar,0.5,{"y":420});
            this._bottomBar.txt_memories.text = LM.ins.cp.numberOfMemoriesSaved().toString() + " / " + Memory.NUMBER_OF_MEMORIES.toString();
            this._memoryHolder = new MovieClip();
            this._memoryHolder.graphics.beginFill(0,0.9);
            this._memoryHolder.graphics.drawRoundRect(10,10,620,320,10,10);
            this._memoryHolder.graphics.endFill();
            this._memoryHolder.y = 40;
            this._costume.addChild(this._memoryHolder);
            this._memoryHolder.alpha = 0;
            TweenLite.to(this._memoryHolder,0.5,{
               "alpha":1,
               "delay":0.2
            });
            this._infoBar = new MC_MEM_InfoBar();
            this._infoBar.x = 10;
            this._infoBar.y = 340;
            this._costume.addChild(this._infoBar);
            this._infoBar.alpha = 0;
         }
      }
      
      private function removeInterface() : void
      {
         if(this._bottomBar)
         {
            TweenLite.to(this._bottomBar,0.5,{"y":490});
            TweenLite.to(this._infoBar,0.5,{
               "alpha":0,
               "delay":1
            });
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_bottomBar);
               CF.removeDisplayObject(_infoBar);
            },1.5);
         }
      }
      
      private function createButtons() : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var memory:Memory = null;
         var cl:Class = null;
         var badge:MovieClip = null;
         var memButton:MC_MEM_MemoryIcon = null;
         var rank:MovieClip = null;
         var lockedMem:MC_MEM_MemoryIconLocked = null;
         if(this._memoryButtons && this._memoryButtons.length > 0)
         {
            return;
         }
         var i:int = 0;
         this._memoryButtons = [];
         for(i = 0; i < Memory.list.length; i++)
         {
            memory = Memory.list[i];
            xpos = 50 + 60 * (i % 10);
            ypos = 80 + 60 * int(i / 10);
            cl = getDefinitionByName(memory.className) as Class;
            badge = new cl() as MovieClip;
            if(LM.ins.cp.isMemorySaved(memory.id))
            {
               memButton = new MC_MEM_MemoryIcon();
               memButton.addChild(badge);
               badge.filters = [new BevelFilter(2,45,16777215,1,0,1,4,4,0.4,1)];
               memButton.x = xpos;
               memButton.y = ypos;
               memButton.alpha = 0;
               if(memory.level == 1)
               {
                  rank = new MC_BronzeRank();
               }
               else if(memory.level == 2)
               {
                  rank = new MC_SilverRank();
               }
               else if(memory.level == 3)
               {
                  rank = new MC_GoldRank();
               }
               else if(memory.level == 4)
               {
                  rank = new MC_PlatinumRank();
               }
               else if(memory.level == 5)
               {
                  rank = new MC_DiamondRank();
               }
               rank.x = 21.5;
               rank.y = 21.5;
               memButton.addChild(rank);
               rank.filters = [new BevelFilter(1,90,16777215,1,0,1,2,2,0.3)];
               TweenLite.to(memButton,0.25,{
                  "alpha":1,
                  "delay":i * 0.03
               });
               this._memoryHolder.addChild(memButton);
               this._memoryButtons.push(memButton);
            }
            else
            {
               lockedMem = new MC_MEM_MemoryIconLocked();
               lockedMem.addChild(badge);
               badge.filters = [new GlowFilter(0,1,5,5,0.75,1,true,true)];
               lockedMem.x = xpos;
               lockedMem.y = ypos;
               lockedMem.alpha = 0;
               TweenLite.to(lockedMem,0.25,{
                  "alpha":1,
                  "delay":i * 0.03
               });
               this._memoryHolder.addChild(lockedMem);
               this._memoryButtons.push(lockedMem);
            }
         }
      }
      
      private function removeButtons() : void
      {
         for(var i:int = 0; i < this._memoryButtons.length; i++)
         {
            TweenLite.to(this._memoryButtons[i],0.2,{
               "alpha":0,
               "delay":0.01 * i
            });
         }
         if(this._memoryHolder)
         {
            TweenLite.to(this._memoryHolder,0.25,{
               "alpha":0,
               "delay":1
            });
            TM.ins.tf(function():void
            {
               CF.removeDisplayObject(_memoryHolder);
            },1.25);
         }
      }
      
      private function memoryOverHandler(e:MouseEvent) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         var i:int = this._memoryButtons.indexOf(e.currentTarget);
         var id:int = Memory.list[i].id;
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.parent.setChildIndex(mc,mc.parent.numChildren - 1);
         TweenLite.to(e.currentTarget,0.2,{
            "scaleX":2,
            "scaleY":2
         });
         TweenLite.to(this._infoBar,0.5,{
            "alpha":1,
            "delay":0.2
         });
         TweenLite.to(this._memoryHolder,0.5,{"y":0});
         if(LM.ins.cp.isMemorySaved(id))
         {
            this._infoBar.txt_info.text = Memory.list[i].explanation;
            this._infoBar.txt_info.textColor = 16777215;
            this._infoBar.txt_title.text = Memory.list[i].title;
            this._infoBar.txt_title.textColor = 16711680;
         }
         else
         {
            this._infoBar.txt_info.text = Memory.list[i].explanation;
            this._infoBar.txt_info.textColor = 6710886;
            this._infoBar.txt_title.text = "Memory Locked";
            this._infoBar.txt_title.textColor = 6684672;
         }
      }
      
      private function memoryOutHandler(e:MouseEvent) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         TweenLite.to(e.currentTarget,0.2,{
            "scaleX":1,
            "scaleY":1
         });
         TweenLite.to(this._infoBar,0.5,{
            "alpha":0,
            "delay":0.5
         });
         TweenLite.to(this._memoryHolder,0.5,{
            "y":40,
            "delay":0.8
         });
      }
      
      private function addEvents() : void
      {
         var i:int = 0;
         this._bottomBar.btn_back.addEventListener(MouseEvent.CLICK,this.buttonClickHandler,false,0,true);
         this._bottomBar.btn_back.addEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler,false,0,true);
         this._bottomBar.btn_back.addEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler,false,0,true);
         this._bottomBar.btn_back.buttonMode = true;
         this._bottomBar.btn_back.mouseChildren = false;
         for(i = 0; i < this._memoryButtons.length; i++)
         {
            this._memoryButtons[i].buttonMode = true;
            this._memoryButtons[i].mouseChildren = false;
            this._memoryButtons[i].addEventListener(MouseEvent.ROLL_OVER,this.memoryOverHandler,false,0,true);
            this._memoryButtons[i].addEventListener(MouseEvent.ROLL_OUT,this.memoryOutHandler,false,0,true);
         }
      }
      
      private function removeEvents() : void
      {
         var i:int = 0;
         this._bottomBar.btn_back.removeEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._bottomBar.btn_back.removeEventListener(MouseEvent.ROLL_OVER,this.buttonOverHandler);
         this._bottomBar.btn_back.removeEventListener(MouseEvent.ROLL_OUT,this.buttonOutHandler);
         this._bottomBar.btn_back.buttonMode = false;
         for(i = 0; i < this._memoryButtons.length; i++)
         {
            this._memoryButtons[i].buttonMode = false;
            this._memoryButtons[i].removeEventListener(MouseEvent.ROLL_OVER,this.memoryOverHandler);
            this._memoryButtons[i].removeEventListener(MouseEvent.ROLL_OUT,this.memoryOutHandler);
         }
      }
      
      private function buttonClickHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._bottomBar.btn_back)
         {
            this.timedRemove();
            TM.ins.tf(function():void
            {
               MainMenu.ins.create();
            },2.7);
         }
      }
      
      private function buttonOverHandler(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function buttonOutHandler(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).gotoAndStop("out");
      }
   }
}
