package game.bonus
{
   import com.greensock.TweenLite;
   import effects.FilmNoirEffect;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.Background;
   import game.BonusInterface;
   import game.GameCamera;
   import game.SafeScore;
   import managers.DM;
   import managers.GM;
   import managers.KM;
   import managers.LM;
   import managers.PM;
   import managers.TM;
   import managers.UM;
   import menus.BL_EndMenu;
   import menus.LevelSelectionMenu;
   import menus.PauseMenu;
   import menus.TitleScreen;
   import particle.Particle;
   import particle.units.P_Unit;
   
   public class BonusLevel
   {
      
      public static const TOBYS_DREAM:String = "Toby\'s Dream";
      
      public static const BILLYS_ADVENTURE:String = "Billy\'s Adventure";
      
      public static const ELDER_ROLLS:String = "Elder Rolls";
       
      
      protected var _isCreated:Boolean;
      
      protected var _isPaused:Boolean;
      
      protected var _isStarted:Boolean;
      
      protected var _isEnded:Boolean;
      
      protected var _isFastStart:Boolean;
      
      protected var _name:String;
      
      protected var _background:Background;
      
      protected var _interface:BonusInterface;
      
      protected var _filmNoir:FilmNoirEffect;
      
      protected var _photoRibbon:Sprite;
      
      protected var _tfName:TextField;
      
      protected var _tfSpace:TextField;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _area:Rectangle;
      
      protected var _particles:Vector.<Particle>;
      
      protected var _tracked:Particle;
      
      protected var _isShaking:int;
      
      protected var _shakeDuration:int;
      
      protected var _shakeFactor:int;
      
      protected var _heartsCollected:SafeScore;
      
      protected var _frameList:Array;
      
      protected var _pauseList:Array;
      
      protected var _compareNo:int;
      
      protected var _nextLevelNo:int;
      
      protected var _replayNo:int;
      
      protected var _startSprite:Sprite;
      
      protected var _startCounter:int;
      
      protected var _startPosX:Number;
      
      protected var _startPosY:Number;
      
      protected var _startTime:int = 30;
      
      protected var _endSprite:Sprite;
      
      protected var _endCounter:int;
      
      protected var _endPosX:Number;
      
      protected var _endPosY:Number;
      
      protected var _endTime:int = 30;
      
      protected var _units:Vector.<P_Unit>;
      
      private var _frameCounter:int;
      
      public function BonusLevel()
      {
         super();
         this._replayNo = 0;
      }
      
      public function setReplayNo(replayNo:int) : void
      {
         this._replayNo = replayNo;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._units = new Vector.<P_Unit>();
         this._photoRibbon = new Sprite();
         DM.ins.fg.addChild(this._photoRibbon);
         this._tfName = new TextField();
         var tFormat:TextFormat = new TextFormat("calibri",24,16777215,true,null,null,null,null,TextFormatAlign.CENTER);
         this._tfName.defaultTextFormat = tFormat;
         this._tfName.embedFonts = true;
         this._tfName.selectable = false;
         this._tfName.wordWrap = true;
         this._tfName.multiline = true;
         this._tfName.width = 640;
         this._tfName.height = 40;
         this._tfName.x = 0;
         this._tfName.y = 425;
         this._tfName.text = "Bonus Level: " + this._name;
         DM.ins.fg.addChild(this._tfName);
         this._tfSpace = new TextField();
         var tFormat2:TextFormat = new TextFormat("calibri",16,14540253,true,null,null,null,null,TextFormatAlign.CENTER);
         this._tfSpace.defaultTextFormat = tFormat2;
         this._tfSpace.embedFonts = true;
         this._tfSpace.selectable = false;
         this._tfSpace.wordWrap = true;
         this._tfSpace.multiline = true;
         this._tfSpace.width = 640;
         this._tfSpace.height = 40;
         this._tfSpace.x = 0;
         this._tfSpace.y = 455;
         this._tfSpace.text = "Press anykey to start.";
         DM.ins.fg.addChild(this._tfSpace);
         TitleScreen.ins.remove();
         this._isShaking = 0;
         this._shakeFactor = 0;
         this._shakeDuration = 0;
         this._heartsCollected = new SafeScore(0);
         this._nextLevelNo = 1;
         GameCamera.ins.reset();
         this._particles = new Vector.<Particle>();
         this._interface = new BonusInterface(DM.ins.iface);
         this._background = new Background(DM.ins.bg,Background.MOUNTAIN);
         this._background.create();
         this._filmNoir = new FilmNoirEffect(DM.ins.fg);
         this._filmNoir.create();
         this._area = new Rectangle(-40,-40,this._width + 80,this._height + 80);
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyboardHandler,false,0,true);
         Tracking.beginLevel(30,LM.ins.cp.getTotalHearts(),null,"BonusLevel " + this._name + " is started.");
      }
      
      protected function commence() : void
      {
         if(this._replayNo > 0)
         {
            this.startFast();
         }
         else
         {
            this.start();
         }
      }
      
      protected function startFast() : void
      {
         this._isFastStart = true;
         this.start();
      }
      
      protected function start() : void
      {
         var posX:Number = NaN;
         var posY:Number = NaN;
         var rs:Number = NaN;
         for(var i:int = 0; i < 5; i++)
         {
            PM.ins.update();
         }
         this.pauseGame(false);
         DM.ins.setBlackAndWhite(true);
         if(this._tracked)
         {
            posX = Math.min(0,Math.max(-this._width + 640,-this._tracked.body.GetPosition().x * Constants.SCALE + 320));
            posY = Math.min(0,Math.max(-this._height + 480,-this._tracked.body.GetPosition().y * Constants.SCALE + 240));
         }
         else
         {
            posX = 320;
            posY = 240;
         }
         GameCamera.ins.setPosition(posX,posY);
         this._background.setPosition(posX,posY);
         if(this._tracked)
         {
            this._startPosX = this._tracked.body.GetPosition().x * Constants.SCALE + GameCamera.ins.x;
            this._startPosY = this._tracked.body.GetPosition().y * Constants.SCALE + GameCamera.ins.y;
         }
         else
         {
            this._startPosX = 320;
            this._startPosY = 240;
         }
         this._startCounter = this._startTime;
         this._startSprite = new Sprite();
         this._startSprite.graphics.clear();
         this._startSprite.graphics.beginFill(0,1);
         this._startSprite.graphics.drawRect(0,0,640,480);
         if(!this._isFastStart)
         {
            rs = 30;
            this._photoRibbon.graphics.clear();
            this._photoRibbon.graphics.beginFill(3355443,1);
            this._photoRibbon.graphics.drawRect(rs,0,640 - 2 * rs,rs);
            this._photoRibbon.graphics.drawRect(640 - rs,0,rs,480 - 2 * rs);
            this._photoRibbon.graphics.drawRect(0,0,rs,480 - 2 * rs);
            this._photoRibbon.graphics.drawRect(0,480 - 2 * rs,640,2 * rs);
         }
         else
         {
            this._tfName.visible = false;
            this._tfSpace.visible = false;
            this._photoRibbon.visible = false;
         }
         DM.ins.menu.addChild(this._startSprite);
         TM.ins.tf(function():void
         {
            Main.s.addEventListener(KeyboardEvent.KEY_UP,startKeyHandler,false,0,true);
            Main.s.addEventListener(Event.ENTER_FRAME,startHandler,false,0,true);
         },0.1);
      }
      
      private function startHandler(e:Event) : void
      {
         --this._startCounter;
         if(this._startCounter == 0)
         {
            Main.s.removeEventListener(Event.ENTER_FRAME,this.startHandler);
            CF.removeDisplayObject(this._startSprite);
            if(this._isFastStart)
            {
               this.startReal();
            }
         }
         var radius:Number = (1 - this._startCounter / this._startTime) * 640;
         this._startSprite.graphics.clear();
         this._startSprite.graphics.beginFill(0,1);
         this._startSprite.graphics.drawRect(0,0,640,480);
         this._startSprite.graphics.drawCircle(this._startPosX,this._startPosY,radius);
         this._startSprite.graphics.endFill();
      }
      
      private function startKeyHandler(e:KeyboardEvent) : void
      {
         if(this._isFastStart)
         {
            return;
         }
         this.startReal();
      }
      
      private function startReal() : void
      {
         if(this._isStarted)
         {
            return;
         }
         this._isStarted = true;
         trace("START REAL");
         DM.ins.timedBlackAndWhite(60);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.startKeyHandler);
         CF.removeDisplayObject(this._startSprite);
         this._interface.create(this._name);
         this._interface.addEventListener("pause",this.interfaceHandler);
         this._interface.addEventListener("replay",this.interfaceHandler);
         TweenLite.to(this._photoRibbon,1,{"alpha":0});
         TweenLite.to(this._tfName,1,{"alpha":0});
         TweenLite.to(this._tfSpace,1,{"alpha":0});
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_photoRibbon);
            CF.removeDisplayObject(_tfName);
            CF.removeDisplayObject(_tfSpace);
         },1);
         this.resumeGame();
      }
      
      private function interfaceHandler(e:Event) : void
      {
         if(!this._isCreated || this._isEnded || !this._isStarted)
         {
            return;
         }
         if(e.type == "pause")
         {
            this.pauseGame();
         }
         else if(e.type == "replay")
         {
            this.replayLevel();
         }
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this._isEnded = false;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            this._particles[i].safeRemove();
         }
         this._particles = new Vector.<Particle>();
         this._background.remove();
         this._interface.remove();
         this._filmNoir.remove();
         CF.removeDisplayObject(this._photoRibbon);
         CF.removeDisplayObject(this._tfName);
         CF.removeDisplayObject(this._endSprite);
         CF.removeDisplayObject(this._startSprite);
         PM.ins.reset();
         LM.ins.savePlayers();
         GameCamera.ins.reset();
         PauseMenu.ins.removeEventListener("resume",this.resumeHandler);
         PauseMenu.ins.removeEventListener("menu",this.menuHandler);
         PauseMenu.ins.removeEventListener("replay",this.pauseMenuHandler);
         PauseMenu.ins.remove();
         BL_EndMenu.ins.removeEventListener("continue",this.continueHandler);
         BL_EndMenu.ins.removeEventListener("menu",this.menuHandler);
         BL_EndMenu.ins.removeEventListener("replay",this.replayHandler);
         BL_EndMenu.ins.remove();
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyboardHandler);
         Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
      }
      
      protected function particleRemovedHandler(e:Event) : void
      {
         (e.currentTarget as Particle).removeEventListener(Event.REMOVED,this.particleRemovedHandler);
         var i:int = this._particles.indexOf(e.currentTarget as Particle);
         if(i >= 0)
         {
            this._particles.splice(i,1);
         }
      }
      
      protected function keyboardHandler(e:KeyboardEvent) : void
      {
         if(this._isEnded || !this._isStarted || this._isPaused)
         {
            return;
         }
         if(e.keyCode == KM.ESCAPE || e.keyCode == KM.KEY_P)
         {
            if(this._isPaused)
            {
               this.resumeGame();
            }
            else
            {
               this.pauseGame();
            }
         }
         else if(e.keyCode == KM.KEY_R)
         {
            this.replayLevel();
         }
         else if(e.keyCode == 77)
         {
            this._interface.toggleMute();
         }
      }
      
      public function update() : void
      {
         var power:Number = NaN;
         if(!this._isCreated)
         {
            return;
         }
         this._background.update();
         this._filmNoir.update();
         if(!this._tracked)
         {
            return;
         }
         var posX:Number = Math.min(0,Math.max(-this._width + 640,-this._tracked.body.GetPosition().x * Constants.SCALE + 320));
         var posY:Number = Math.min(0,Math.max(-this._height + 480,-this._tracked.body.GetPosition().y * Constants.SCALE + 240));
         var disX:Number = 0;
         var disY:Number = 0;
         if(this._isShaking > 0)
         {
            --this._isShaking;
            power = this._shakeFactor * Math.sqrt(this._isShaking / this._shakeDuration);
            disX = power * (Math.random() - 0.5);
            disY = power * (Math.random() - 0.5);
         }
         GameCamera.ins.updatePosition(posX,posY,disX,disY);
         DM.ins.setPhysicsPosition(posX,posY,disX,disY);
         this._background.tweenPosition(posX,posY,disX,disY);
      }
      
      protected function unitRemoveListener(e:Event) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._tracked = null;
         this._units = new Vector.<P_Unit>();
         this.endLevel();
      }
      
      public function collectHeart() : void
      {
         this._heartsCollected.addValue(1);
      }
      
      public function shakeCamera(power:int, duration:int) : void
      {
         this._shakeDuration = duration;
         this._isShaking = this._shakeDuration;
         this._shakeFactor = power;
      }
      
      public function speedUp(duration:int) : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
      }
      
      public function shield() : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
      }
      
      public function attract(duration:int) : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
      }
      
      public function tripleJump(duration:int) : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
      }
      
      public function heal() : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
      }
      
      public function killAll() : void
      {
         var eff:Sprite = null;
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
         eff = new Sprite();
         eff.graphics.beginFill(16777215,1);
         eff.graphics.drawRect(0,0,640,480);
         TweenLite.to(eff,1.3,{
            "alpha":0,
            "delay":0.3
         });
         DM.ins.iface.addChild(eff);
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(eff);
         },1.6);
      }
      
      protected function endLevel() : void
      {
         if(this._isEnded)
         {
            return;
         }
         this._isEnded = true;
         BL_EndMenu.ins.create(this._name,this._heartsCollected);
         BL_EndMenu.ins.addEventListener("continue",this.continueHandler,false,0,true);
         BL_EndMenu.ins.addEventListener("menu",this.menuHandler,false,0,true);
         BL_EndMenu.ins.addEventListener("replay",this.replayHandler,false,0,true);
         LM.ins.cp.setBLCollected(this._name,this._heartsCollected.value);
         var speNo:int = 0;
         if(this._name == TOBYS_DREAM)
         {
            speNo = 0;
         }
         else if(this._name == BILLYS_ADVENTURE)
         {
            speNo = 1;
         }
         else if(this._name == ELDER_ROLLS)
         {
            speNo = 2;
         }
         LM.ins.cp.setSpecialHearts(speNo,this._heartsCollected.value);
      }
      
      protected function pauseGame(enableMenu:Boolean = true) : void
      {
         if(this._isPaused)
         {
            return;
         }
         this._isPaused = true;
         UM.ins.pause();
         if(enableMenu)
         {
            PauseMenu.ins.create(this._name);
            PauseMenu.ins.addEventListener("resume",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.addEventListener("menu",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.addEventListener("replay",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.hideSkipButton();
         }
         this._frameList = [];
         this._frameCounter = 0;
         this.getFrames(GameCamera.ins.costume);
         Main.s.addEventListener(Event.ENTER_FRAME,this.frameHandler,false,0,true);
      }
      
      private function pauseMenuHandler(e:Event) : void
      {
         PauseMenu.ins.removeEventListener("resume",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("menu",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("replay",this.pauseMenuHandler);
         if(e.type == "resume")
         {
            this.resumeGame();
         }
         else if(e.type == "menu")
         {
            this.resumeGame();
            this.remove();
            LevelSelectionMenu.ins.create();
         }
         else if(e.type == "replay")
         {
            this.replayLevel();
         }
      }
      
      protected function resumeGame() : void
      {
         if(!this._isPaused)
         {
            return;
         }
         this._isPaused = false;
         UM.ins.resume();
         PauseMenu.ins.removeEventListener("resume",this.resumeHandler);
         PauseMenu.ins.removeEventListener("menu",this.menuHandler);
         PauseMenu.ins.remove();
         this._compareNo = 0;
         this.resumeMovieclip(GameCamera.ins.costume);
      }
      
      protected function frameHandler(e:Event) : void
      {
         ++this._frameCounter;
         if(this._frameCounter == 2)
         {
            Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
            this._compareNo = 0;
            this._pauseList = [];
            this.compareFrames(GameCamera.ins.costume);
            this._frameList = [];
         }
      }
      
      protected function getFrames(mc:MovieClip) : void
      {
         for(var i:int = 0; i < mc.numChildren; i++)
         {
            if(mc.getChildAt(i) is MovieClip)
            {
               this.getFrames(mc.getChildAt(i) as MovieClip);
            }
         }
         this._frameList.push(mc.currentFrame);
      }
      
      protected function compareFrames(mc:MovieClip) : void
      {
         for(var i:int = 0; i < mc.numChildren; i++)
         {
            if(mc.getChildAt(i) is MovieClip)
            {
               this.compareFrames(mc.getChildAt(i) as MovieClip);
            }
         }
         if(this._frameList[this._compareNo] == mc.currentFrame)
         {
            this._pauseList.push(false);
         }
         else
         {
            mc.gotoAndStop(this._frameList[this._compareNo]);
            this._pauseList.push(true);
         }
         ++this._compareNo;
      }
      
      protected function resumeMovieclip(mc:MovieClip) : void
      {
         for(var i:int = 0; i < mc.numChildren; i++)
         {
            if(mc.getChildAt(i) is MovieClip)
            {
               this.resumeMovieclip(mc.getChildAt(i) as MovieClip);
            }
         }
         if(this._pauseList[this._compareNo])
         {
            mc.play();
         }
         ++this._compareNo;
      }
      
      protected function resumeHandler(e:Event) : void
      {
         this.resumeGame();
      }
      
      protected function menuHandler(e:Event) : void
      {
         this.resumeGame();
         this.remove();
         LevelSelectionMenu.ins.create();
      }
      
      protected function replayHandler(e:Event) : void
      {
         this.replayLevel();
      }
      
      protected function continueHandler(e:Event) : void
      {
         this.remove();
         GM.ins.startFirstAvailable();
      }
      
      private function replayLevel() : void
      {
         this.pauseGame(false);
         if(this._tracked && this._tracked.body)
         {
            this._endPosX = Math.min(660,Math.max(-20,this._tracked.body.GetPosition().x * Constants.SCALE + GameCamera.ins.x));
            this._endPosY = this._tracked.body.GetPosition().y * Constants.SCALE + GameCamera.ins.y;
         }
         else
         {
            this._endPosX = 320;
            this._endPosY = 240;
         }
         this._isEnded = true;
         this._endSprite = new Sprite();
         this._endSprite.graphics.clear();
         this._endCounter = this._endTime;
         DM.ins.menu.addChild(this._endSprite);
         Main.s.addEventListener(Event.ENTER_FRAME,this.endHandler);
         Tracking.endLevel(LM.ins.cp.getTotalHearts(),"REPLAY","BONUS LEVEL: " + this._name + " (REPLAY): collected " + this._heartsCollected.value.toString() + " hearts.");
         TM.ins.tf(function():void
         {
            remove();
            GM.ins.replayBonusLevel(_name,_replayNo + 1);
         },1.2);
      }
      
      private function endHandler(e:Event) : void
      {
         --this._endCounter;
         if(this._endCounter == 0)
         {
            Main.s.removeEventListener(Event.ENTER_FRAME,this.endHandler);
         }
         var radius:Number = this._endCounter / this._endTime * 640;
         this._endSprite.graphics.clear();
         this._endSprite.graphics.beginFill(0,1);
         this._endSprite.graphics.drawRect(0,0,640,480);
         this._endSprite.graphics.drawCircle(this._endPosX,this._endPosY,radius);
         this._endSprite.graphics.endFill();
      }
      
      public function get heartsCollected() : SafeScore
      {
         return this._heartsCollected;
      }
      
      public function get tracked() : Particle
      {
         return this._tracked;
      }
      
      public function get units() : Vector.<P_Unit>
      {
         return this._units;
      }
   }
}
