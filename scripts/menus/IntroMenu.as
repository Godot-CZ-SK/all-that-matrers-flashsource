package menus
{
   import com.bit101.components.HUISlider;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import game.GameMusic;
   import game.GameVoice;
   import game.IntroItem;
   import managers.DM;
   import managers.LM;
   import managers.SM;
   import managers.TM;
   
   public class IntroMenu
   {
      
      public static const WALTER_INTRO:String = "walter_intro";
      
      public static const WALTER_OUTRO:String = "walter_outro";
      
      public static const BILLY_OUTRO:String = "billy_outro";
      
      protected static var _ins:IntroMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _isEnded:Boolean;
      
      protected var _costume:MovieClip;
      
      protected var _yellow:Sprite;
      
      protected var _white:Sprite;
      
      protected var _noiseBitmap:Bitmap;
      
      protected var _textBitmap:Bitmap;
      
      protected var _pageBitmap:Bitmap;
      
      protected var _display:String;
      
      protected var _page:MovieClip;
      
      protected var _skipButton:STORY_Skip;
      
      protected var _menuButton:STORY_MenuButton;
      
      protected var _beginButton:STORY_Begin;
      
      protected var _fadeCostume:Sprite;
      
      protected var _noiseData:BitmapData;
      
      protected var _introDialogue:GameVoice;
      
      protected var _timeSlider:HUISlider;
      
      protected var _isPaused:Boolean;
      
      protected var _counter:int;
      
      protected var _step:int;
      
      protected var _totalStep:int;
      
      protected var _textPos:int;
      
      protected var _items:Vector.<IntroItem>;
      
      protected var _speed:Number;
      
      protected var _textFormat:TextFormat;
      
      protected var _textField:TextField;
      
      protected var TEXT_OFFSET:Point;
      
      protected var START_DELAY:int = 50;
      
      protected var _lineNo:int;
      
      protected var _waitPositions:Array;
      
      protected var _waitTimes:Array;
      
      protected var _type:String;
      
      protected var _endFunction:Function;
      
      protected var _endColor:int;
      
      protected var _startTime:int;
      
      public function IntroMenu()
      {
         this.TEXT_OFFSET = new Point(20,400);
         super();
      }
      
      public static function get ins() : IntroMenu
      {
         if(!_ins)
         {
            _ins = new IntroMenu();
         }
         return _ins;
      }
      
      public function create(type:String) : void
      {
         var dID:int = 0;
         var tFont:String = null;
         var tColor:uint = 0;
         var bColor:uint = 0;
         if(this._isCreated)
         {
            return;
         }
         LM.ins.cp.setIntroPlayed(true);
         this._type = type;
         this._isCreated = true;
         this._isEnded = false;
         this._costume = new MovieClip();
         DM.ins.menu.addChild(this._costume);
         this._speed = 0.7;
         if(this._type == WALTER_INTRO)
         {
            SM.ins.playMusic(GameMusic.VIEW_FROM_ABOVE,0.5);
            tFont = "Joy Like Sunshine Through My Wi";
            dID = GameVoice.WALTER_INTRO;
            tColor = 0;
            bColor = 16777215;
            this._endColor = 0;
            this.TEXT_OFFSET.x = 20;
            this.TEXT_OFFSET.y = 400;
            this._totalStep = 3750;
            this._endFunction = this.walterIntroEnd;
         }
         else if(this._type == WALTER_OUTRO)
         {
            SM.ins.stopMusic();
            tFont = "Joy Like Sunshine Through My Wi";
            dID = GameVoice.WALTER_OUTRO;
            tColor = 0;
            bColor = 16777215;
            this._endColor = 16777215;
            this.TEXT_OFFSET.x = 60;
            this.TEXT_OFFSET.y = 150;
            this._totalStep = 380;
            this._endFunction = this.walterOutroEnd;
            this._speed = 0;
         }
         else if(this._type == BILLY_OUTRO)
         {
            SM.ins.playMusic(GameMusic.HIS_GREATNESS,0.5);
            tFont = "Talking to the Moon";
            dID = GameVoice.BILLY_OUTRO;
            tColor = 0;
            bColor = 16777215;
            this._endColor = 0;
            this.TEXT_OFFSET.x = 20;
            this.TEXT_OFFSET.y = 420;
            this._totalStep = 2550;
            this._endFunction = this.billyOutroEnd;
            this.START_DELAY = 120;
         }
         TM.ins.tf(function():void
         {
            _introDialogue = SM.ins.playVoice(dID);
         },this.START_DELAY / Constants.FRAME_RATE);
         this._lineNo = 0;
         this._white = new Sprite();
         this._white.graphics.beginFill(bColor,1);
         this._white.graphics.drawRect(0,0,640,480);
         this._white.graphics.endFill();
         this._costume.addChild(this._white);
         this._yellow = new Sprite();
         this._yellow.graphics.beginFill(13421568,0.1);
         this._yellow.graphics.drawRect(0,0,640,480);
         this._yellow.graphics.endFill();
         this._costume.addChild(this._yellow);
         var cf1:ConvolutionFilter = new ConvolutionFilter(3,3,[0.5,0.5,0.5,0.5,1,0.5,0.5,0.5,0.5],5);
         var cf2:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,1,1,0,1,0],1.5);
         this._noiseData = new BitmapData(640,3000,true,16777215);
         var base:Number = 400;
         this._noiseData.perlinNoise(100,200,4,int(Math.random() * 10000),false,false,7,true);
         this._noiseData.applyFilter(this._noiseData,this._noiseData.rect,new Point(),cf1);
         this._noiseData.applyFilter(this._noiseData,this._noiseData.rect,new Point(),cf2);
         var partData:BitmapData = new BitmapData(640,480,true,16777215);
         partData.copyPixels(this._noiseData,new Rectangle(0,0,640,480),new Point(0,0));
         this._noiseBitmap = new Bitmap(partData);
         this._noiseBitmap.alpha = 0.12;
         this._textBitmap = new Bitmap(new BitmapData(640,480,true,16777215));
         this._pageBitmap = new Bitmap(new BitmapData(640,480,true,16777215));
         this._page = new MovieClip();
         this._costume.addChild(this._pageBitmap);
         this._costume.addChild(this._noiseBitmap);
         this._costume.addChild(this._textBitmap);
         this._textFormat = new TextFormat();
         this._textFormat.font = tFont;
         this._textFormat.size = 24;
         this._textFormat.color = tColor;
         this._textField = new TextField();
         this._textField.width = 600;
         this._textField.height = 3000;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.selectable = false;
         this._textField.embedFonts = true;
         this._textField.antiAliasType = AntiAliasType.NORMAL;
         this._textField.text = "";
         this.setDisplayText();
         this.setIntroItems();
         this._step = 0;
         this._counter = 0;
         this._textPos = 0;
         Main.s.addEventListener(Event.ENTER_FRAME,this.frameListener,false,0,true);
         this._timeSlider = new HUISlider(this._costume,20,450,"Time");
         this._timeSlider.addEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler,false,0,true);
         this._timeSlider.setSize(600,20);
         this._timeSlider.minimum = this._step;
         this._timeSlider.maximum = this._totalStep;
         if(!Constants.IS_TEST)
         {
            this._timeSlider.visible = false;
         }
         this._menuButton = new STORY_MenuButton();
         this._costume.addChild(this._menuButton);
         this._menuButton.x = 40;
         this._menuButton.y = 440;
         this._menuButton.addEventListener(MouseEvent.CLICK,this.menuHandler,false,0,true);
         this._menuButton.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._menuButton.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._menuButton.visible = false;
         this._menuButton.buttonMode = true;
         this._menuButton.mouseChildren = false;
         this._skipButton = new STORY_Skip();
         this._costume.addChild(this._skipButton);
         this._skipButton.x = 600;
         this._skipButton.y = 450;
         this._skipButton.addEventListener(MouseEvent.CLICK,this.skipHandler,false,0,true);
         this._skipButton.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._skipButton.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._skipButton.visible = false;
         this._skipButton.buttonMode = true;
         this._skipButton.mouseChildren = false;
         this._beginButton = new STORY_Begin();
         this._costume.addChild(this._beginButton);
         this._beginButton.x = 320;
         this._beginButton.y = 280;
         this._beginButton.addEventListener(MouseEvent.CLICK,this.beginHandler,false,0,true);
         this._beginButton.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._beginButton.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._beginButton.visible = false;
         this._beginButton.buttonMode = true;
         this._beginButton.mouseChildren = false;
         if(this._type == WALTER_OUTRO)
         {
            this._yellow.visible = false;
            this._noiseBitmap.visible = false;
         }
         this._costume.alpha = 0;
         TweenLite.to(this._costume,3,{"alpha":1});
         this._startTime = getTimer();
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc == this._beginButton)
         {
            if(mc.currentLabel == "out")
            {
               mc.gotoAndStop("over");
            }
         }
         else
         {
            mc.gotoAndStop("over");
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc == this._beginButton)
         {
            if(mc.currentLabel == "over")
            {
               mc.gotoAndStop("out");
            }
         }
         else
         {
            mc.gotoAndStop("out");
         }
      }
      
      private function skipHandler(e:MouseEvent) : void
      {
         this.timedRemove();
         TM.ins.tf(function():void
         {
            LevelSelectionMenu.ins.create();
         },1.5);
      }
      
      private function menuHandler(e:MouseEvent) : void
      {
         this.timedRemove();
         TM.ins.tf(function():void
         {
            MainMenu.ins.create();
         },1.5);
      }
      
      private function beginHandler(e:MouseEvent) : void
      {
         this.timedRemove();
         TM.ins.tf(function():void
         {
            LevelSelectionMenu.ins.create();
         },1.5);
         LM.ins.cp.setPatient();
      }
      
      private function sliderDownHandler(e:MouseEvent) : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i].mc)
            {
               CF.removeDisplayObject(this._items[i].mc);
            }
         }
         this._isPaused = true;
         this._timeSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.sliderUpHandler,false,0,true);
         this._timeSlider.addEventListener(Event.CHANGE,this.sliderChangeHandler,false,0,true);
      }
      
      private function sliderUpHandler(e:MouseEvent) : void
      {
         this._timeSlider.addEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler,false,0,true);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.sliderUpHandler);
         this._timeSlider.removeEventListener(Event.CHANGE,this.sliderChangeHandler);
         this._isPaused = false;
         this.setStep(this._timeSlider.value);
      }
      
      private function sliderChangeHandler(e:Event) : void
      {
         this.setStep(this._timeSlider.value);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this._timeSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler);
         this._timeSlider.removeEventListener(Event.CHANGE,this.sliderChangeHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.sliderUpHandler);
         Main.s.removeEventListener(Event.ENTER_FRAME,this.update);
         this._introDialogue.stop();
         for(var i:int = 0; i < this._items.length; i++)
         {
            CF.removeDisplayObject(this._items[i].mc);
         }
         this._items = new Vector.<IntroItem>();
         CF.removeDisplayObject(this._yellow);
         CF.removeDisplayObject(this._white);
         CF.removeDisplayObject(this._textField);
         CF.removeDisplayObject(this._noiseBitmap);
         CF.removeDisplayObject(this._page);
         CF.removeDisplayObject(this._menuButton);
         CF.removeDisplayObject(this._timeSlider);
         CF.removeDisplayObject(this._skipButton);
         CF.removeDisplayObject(this._beginButton);
         CF.removeDisplayObject(this._costume);
      }
      
      private function setStep(step:int) : void
      {
         var lim:int = 0;
         var j:int = 0;
         this._isEnded = false;
         this._step = step;
         this._counter = 0;
         this._textPos = 0;
         this._lineNo = 0;
         var pos:Number = this._speed * Math.min(step,3650);
         this._page.y = -pos;
         if(this._step > 3720)
         {
            this._beginButton.visible = true;
         }
         else
         {
            this._beginButton.visible = false;
         }
         for(var i:int = 0; i < step; i++)
         {
            ++this._counter;
            lim = 1;
            for(j = 0; j < this._waitPositions.length; j++)
            {
               if(this._waitPositions[j] == this._textPos)
               {
                  lim = 1 + this._waitTimes[j];
               }
            }
            if(this._counter == lim)
            {
               this._counter = 0;
               ++this._textPos;
            }
         }
         this._textField.text = this._display.substr(0,this._textPos);
         this._textBitmap.bitmapData.dispose();
         this._textBitmap.bitmapData = new BitmapData(640,480,true,16777215);
         this._noiseBitmap.bitmapData.copyPixels(this._noiseData,new Rectangle(0,pos,640,480),new Point(0,0));
         var m:Matrix = new Matrix();
         m.tx = this.TEXT_OFFSET.x;
         m.ty = this.TEXT_OFFSET.y - pos;
         this._textBitmap.bitmapData.draw(this._textField,m,null,null,new Rectangle(0,0,640,480),true);
      }
      
      private function frameListener(e:Event) : void
      {
         if(this._isPaused || this._isEnded)
         {
            return;
         }
         var timePassed:int = getTimer() - this._startTime;
         var stepPassed:int = timePassed / 1000 * 30;
         this.update();
         if(stepPassed > this._step + 5)
         {
            while(stepPassed > this._step)
            {
               this.update();
            }
         }
      }
      
      private function update() : void
      {
         var logo:STORY_Logo = null;
         var cl:Class = null;
         var mc:MovieClip = null;
         var num:int = 0;
         if(this._isPaused || this._isEnded)
         {
            return;
         }
         if(this._step >= this._totalStep)
         {
            this._endFunction();
            return;
         }
         ++this._counter;
         ++this._step;
         var lim:int = 1;
         for(var j:int = 0; j < this._waitPositions.length; j++)
         {
            if(this._waitPositions[j] == this._textPos)
            {
               lim = 1 + this._waitTimes[j];
            }
         }
         if(this._counter == lim)
         {
            this._counter = 0;
            ++this._textPos;
            this._textField.text = this._display.substr(0,this._textPos);
         }
         if(this._type == BILLY_OUTRO)
         {
            if(this._step == 2350)
            {
               TweenLite.to(this._textBitmap,3,{"alpha":0});
            }
            else if(this._step == 2510)
            {
               this._menuButton.visible = true;
               this._menuButton.alpha = 0;
               TweenLite.to(this._menuButton,1,{"alpha":1});
               logo = new STORY_Logo();
               this._costume.addChild(logo);
               logo.y = 200;
               logo.alpha = 0;
               TweenLite.to(logo,2,{"alpha":1});
            }
         }
         if(this._type == WALTER_INTRO)
         {
            if(this._step == 300)
            {
               this._skipButton.visible = true;
               this._skipButton.alpha = 0;
               TweenLite.to(this._skipButton,1,{"alpha":1});
            }
            else if(this._step == 3720)
            {
               this._beginButton.visible = true;
               this._beginButton.alpha = 0;
               this._beginButton.gotoAndPlay("start");
               TweenLite.to(this._beginButton,1,{"alpha":1});
               TweenLite.to(this._skipButton,1,{"alpha":0});
               TM.ins.tf(function():void
               {
                  _skipButton.visible = false;
               },1);
            }
         }
         this._timeSlider.value = this._step;
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i].appear == this._step)
            {
               cl = this._items[i].cl;
               mc = new cl() as MovieClip;
               this._page.addChildAt(mc,0);
               mc.x = this._items[i].x;
               mc.y = this._items[i].y;
               mc.scaleX = this._items[i].scale;
               mc.scaleY = this._items[i].scale;
               if(this._items[i].blackWhite)
               {
                  this.blackAndWhite(mc);
               }
               if(this._items[i].convolution)
               {
                  this.convolute(mc);
               }
               mc.alpha = 0;
               this._items[i].mc = mc;
               TweenLite.to(mc,this._items[i].appearTime,{"alpha":this._items[i].alpha});
            }
            if(this._items[i].disappear == this._step)
            {
               if(this._items[i].mc)
               {
                  TweenLite.to(this._items[i].mc,this._items[i].disappearTime,{"alpha":0});
                  num = i;
                  TM.ins.tf(function():void
                  {
                     if(_isEnded || !_isCreated)
                     {
                        return;
                     }
                     if(_items && _items[num])
                     {
                        CF.removeDisplayObject(_items[num].mc);
                     }
                  },this._items[num].disappearTime);
               }
            }
         }
         var pos:Number = Math.min(3650,this._step) * this._speed;
         this._page.y = -pos;
         this._noiseBitmap.bitmapData.copyPixels(this._noiseData,new Rectangle(0,pos,640,480),new Point(0,0));
         this._textBitmap.bitmapData.dispose();
         this._textBitmap.bitmapData = new BitmapData(640,480,true,16777215);
         var m:Matrix = new Matrix();
         m.tx = this.TEXT_OFFSET.x;
         m.ty = this.TEXT_OFFSET.y - pos;
         this._textBitmap.bitmapData.draw(this._textField,m,null,null,new Rectangle(0,0,640,480),true);
         var m2:Matrix = new Matrix();
         m2.ty = -pos;
         this._pageBitmap.bitmapData.dispose();
         this._pageBitmap.bitmapData = new BitmapData(640,480,true,16777215);
         this._pageBitmap.bitmapData.draw(this._page,m2,null,null,new Rectangle(0,0,640,480),true);
      }
      
      private function blackAndWhite(mc:MovieClip) : void
      {
         var xc:Number = 1 / 3;
         var yc:Number = 1 / 3;
         var cmf:ColorMatrixFilter = new ColorMatrixFilter([xc,yc,yc,0,0,yc,xc,yc,0,0,yc,yc,xc,0,0,0,0,0,1,0]);
         if(!mc.filters || mc.filters.length == 0)
         {
            mc.filters = [cmf];
         }
         else
         {
            mc.filters.push(cmf);
         }
      }
      
      private function convolute(mc:MovieClip) : void
      {
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,1,1,0,1,0],1.5);
         if(!mc.filters || mc.filters.length == 0)
         {
            mc.filters = [cf];
         }
         mc.filters.push(cf);
      }
      
      private function setIntroItems() : void
      {
         this._items = new Vector.<IntroItem>();
         if(this._type == WALTER_INTRO)
         {
            this._items.push(new IntroItem(STORY_Clock,480,460,210,5,440,2,1,0.8,true,false),new IntroItem(STORY_Clock,550,570,230,5,380,2,0.8,0.8,true,false),new IntroItem(STORY_Clock,440,620,245,5,395,2,0.7,0.8,true,false),new IntroItem(STORY_Clock,570,380,260,5,415,2,0.5,0.7,true,false),new IntroItem(STORY_Clock,420,330,275,5,430,2,0.6,0.7,true,false),new IntroItem(STORY_Wing,550,1100,800,1,950,1,1.3,0.4,false,false),new IntroItem(STORY_Wing,650,980,815,1,975,1,0.9,0.4,false,false),new IntroItem(STORY_Wing,600,1080,830,1,1000,1,1,0.4,false,false),new IntroItem(STORY_Wall,370,930,920,1,1600,1,1.3,0.4,true,true),new IntroItem(STORY_Feather,460,1580,1550,1,1800,1.5,1,0.6,true,false),new IntroItem(STORY_Mom,460,1910,2220,2,2600,3,1.2,1,true,false),new IntroItem(STORY_Kid,480,2060,2500,2,2900,3,1.2,1,true,false),new IntroItem(STORY_Baby,470,2200,2770,2,3100,3,1.2,1,true,false),new IntroItem(STORY_Elder,380,2360,2960,2,3360,3,1.2,1,true,false),new IntroItem(STORY_Heart,500,2510,3400,1,3650,1,1.3,0.4,true,false));
         }
         else if(this._type != WALTER_OUTRO)
         {
            if(this._type == BILLY_OUTRO)
            {
            }
         }
      }
      
      public function timedRemove() : void
      {
         this._introDialogue.fadeVolumeCoef(0,1.5);
         if(this._type != WALTER_OUTRO)
         {
            SM.ins.currentMusic.fadeVolumeCoef(1,1.5);
         }
         this.removeEvents();
         this._fadeCostume = new Sprite();
         this._fadeCostume.graphics.beginFill(this._endColor,1);
         this._fadeCostume.graphics.drawRect(0,0,640,480);
         this._fadeCostume.graphics.endFill();
         this._fadeCostume.alpha = 0;
         TweenLite.to(this._fadeCostume,1.45,{"alpha":1});
         this._costume.addChild(this._fadeCostume);
         TM.ins.tf(function():void
         {
            remove();
         },1.45);
      }
      
      public function addEvents() : void
      {
      }
      
      public function removeEvents() : void
      {
         Main.s.removeEventListener(Event.ENTER_FRAME,this.frameListener);
         this._timeSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler);
         this._skipButton.removeEventListener(MouseEvent.CLICK,this.skipHandler);
         this._skipButton.removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         this._skipButton.removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         this._beginButton.removeEventListener(MouseEvent.CLICK,this.beginHandler);
         this._beginButton.removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         this._beginButton.removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         this._timeSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderDownHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.sliderUpHandler);
         this._timeSlider.removeEventListener(Event.CHANGE,this.sliderChangeHandler);
      }
      
      private function setDisplayText() : void
      {
         var dis:String = null;
         if(this._type == WALTER_INTRO)
         {
            this._display = "%55%In fact%35%\n" + "being lost%20% is not%10% to be asked for%60%\n" + "\n" + "You are there for hours,%25% days%25% and years%30%\n" + "People see you%20%\n" + "Friends know where you are%35%\n" + "Neighbours%10% hear your voice%30%\n" + "But they never ask for you%35%\n" + "\n" + "Family%10% step on you everyday%10% and%15% pass you by%35%\n" + "But they never.%5%.%5%.%5% touch you%50%\n" + "\n" + "That’s%20% how my soul%20% flew away%55%\n" + "There%15% left the shell%15% getting heavier day by day...%55%\n" + "Like a stone...%35%\n" + "And like all stones%40%\n" + "I started to fall down%60%\n" + "When?\n%90%" + "I don\'t remember...%30%\n" + "\n" + "But this morning,%25% I woke up earlier than usual\n%45%" + "\n" + "When I woke up,\n%40%" + "I felt.%10%.%10%.%10% as light as a feather\n%60%" + "Time%20% slowed down%30%\n" + "Then it just stopped%60%\n" + "\n" + "I managed to stop it%50%\n" + "And I remembered%5% everything...%65%\n" + "How I lost everyone%35%\n" + "How I got lost in my house%50%\n" + "I remembered%15% how I forgot people...%50%\n" + "\n" + "This%5% is Sydney,%10% my wife\n%50%" + "She seems so distant now%55%\n" + "She was not like this before...%65%\n" + "Billy is now a young man%60%\n" + "Fast,%15% energetic,%15% vivid%55%\n" + "The day he was born…%30% It\'s like yesterday%70%\n" + "Here is the real newborn!%15% Toby%40%\n" + "Hey!%20% When did you start crawling?%50%\n" + "My dad,%10% he\'s never got out of his room after mom died%80%\n" + "Hello Mr Greer%50%\n" + "Dad?%30%\n" + "I guess he\'s sleeping...%75%\n" + "\n" + "Today,%15% I remembered%15% how people forgot me%85%\n" + "\n" + "Now I will tell you a story%60%\n" + "This%20% will be the story of my journey%45%\n" + "as I try to get my family back...";
         }
         else if(this._type == BILLY_OUTRO)
         {
            this._display = "%125%Daddy didn’t wake up on time this morning.%30%\n" + "In fact%10% he didn’t wake up anymore.%60%\n" + "\n" + "Docs said he died in his sleep.%25%\n" + "He didn’t suffer at all.%45%\n" + "\n" + "I do remember%25% when I was a little boy%40%\n" + "I thought my dad%3% was the biggest,%12% strongest man in the world.%45%\n" + "\n" + "Then%10% slowly,%10% he moved away...%30%\n" + "And faded out,%25% so I couldn’t see him anymore.%70%\n" + "\n" + "This morning Walter Greer,%15% My Dad,%50%\n" + "passed away%20% like a feather%10% caught in the wind...%60%\n" + "                                      Billy Greer\n%100%" + "\n\n\n\n\n\n\n\n\n" + "Created By:%15% Ahmet Ali Batı\n%50%" + "Story:%15% Nedim Murat Gür\n%50%" + "Art:%15% Sean Parnell\n%50%" + "Voices:%15% Sean Crisden\n%50%" + "Music:%15% Jewelbeat\n%50%" + "Sound Effects:%15% Alex Petersen,%15% freeSFX.co.uk,%15% sfxr%50%\n\n" + "Special Thanks To:%30%\n" + "Mehmet Orhan Batı%30%\n" + "Mine Gür%30%\n" + "Gökçe Altun%30%\n" + "Ebru Şaylan%60%\n\n" + "Flash Develop%40%\n" + "Box2D%40%\n" + "Flash Game License%40%\n\n" + "and...\n%20%" + "KONGREGATE";
         }
         else if(this._type == WALTER_OUTRO)
         {
            this._display = "%55%I’m Walter,%30% Walter Greer%30%\n" + "Today,%15% I woke up earlier than usual%50%\n" + "I remembered%30%\n" + "I realized%30%\n" + "I changed\n";
         }
         this._waitPositions = [];
         this._waitTimes = [];
         for(var pos:int = 0; pos < this._display.length; pos++)
         {
            if(this._display.charAt(pos) == "%")
            {
               this._waitPositions.push(pos);
               dis = this._display.slice(pos + 1,this._display.indexOf("%",pos + 1));
               this._waitTimes.push(int(dis));
               this._display = this._display.slice(0,pos) + this._display.slice(this._display.indexOf("%",pos + 1) + 1);
            }
         }
      }
      
      private function walterOutroEnd() : void
      {
         if(this._isEnded)
         {
            return;
         }
         this._isEnded = true;
         this.timedRemove();
         TM.ins.tf(function():void
         {
            IntroMenu.ins.create(BILLY_OUTRO);
         },1.6);
      }
      
      private function walterIntroEnd() : void
      {
         if(this._isEnded)
         {
            return;
         }
         this._isEnded = true;
      }
      
      private function billyOutroEnd() : void
      {
         if(this._isEnded)
         {
            return;
         }
         this._isEnded = true;
      }
   }
}
