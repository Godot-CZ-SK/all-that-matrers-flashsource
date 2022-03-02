package game
{
   import Playtomic.Link;
   import com.bit101.components.ListItem;
   import com.greensock.TweenLite;
   import design.data.DO_BlowerData;
   import design.data.DO_BouncerData;
   import design.data.DO_ButtonData;
   import design.data.DO_CannonData;
   import design.data.DO_ChainData;
   import design.data.DO_CheckpointData;
   import design.data.DO_CloudData;
   import design.data.DO_Data;
   import design.data.DO_DoorData;
   import design.data.DO_ElevatorData;
   import design.data.DO_FlowerData;
   import design.data.DO_GravitySwitcherData;
   import design.data.DO_HeartData;
   import design.data.DO_KeyData;
   import design.data.DO_LadderData;
   import design.data.DO_LampData;
   import design.data.DO_LaserData;
   import design.data.DO_LeverData;
   import design.data.DO_OthersData;
   import design.data.DO_PistonDoorData;
   import design.data.DO_PistonPlateData;
   import design.data.DO_PlatformData;
   import design.data.DO_PolyData;
   import design.data.DO_PortalData;
   import design.data.DO_SeekerData;
   import design.data.DO_SignData;
   import design.data.DO_SlideDoorData;
   import design.data.DO_StoneData;
   import design.data.DO_TextData;
   import design.data.DO_ThingData;
   import design.data.DO_TrapData;
   import design.data.DO_UOData;
   import design.data.DO_UnitData;
   import design.data.DO_WheelData;
   import design.data.LevelData;
   import effects.FilmNoirEffect;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getQualifiedClassName;
   import managers.DM;
   import managers.GM;
   import managers.KM;
   import managers.LM;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import managers.UM;
   import menus.DesignMenu;
   import menus.EndMenu;
   import menus.IntroMenu;
   import menus.LevelSelectionMenu;
   import menus.MainMenu;
   import menus.PauseMenu;
   import menus.SkipMenu;
   import menus.TitleScreen;
   import menus.UL_EndMenu;
   import particle.P_Blower;
   import particle.P_Bouncer;
   import particle.P_Button;
   import particle.P_Cannon;
   import particle.P_Chain;
   import particle.P_Checkpoint;
   import particle.P_Cloud;
   import particle.P_Door;
   import particle.P_Elevator;
   import particle.P_GravitySwitcher;
   import particle.P_Heart;
   import particle.P_Key;
   import particle.P_Ladder;
   import particle.P_Lamp;
   import particle.P_Laser;
   import particle.P_Lever;
   import particle.P_Obstacle;
   import particle.P_PistonDoor;
   import particle.P_PistonPlate;
   import particle.P_Platform;
   import particle.P_Portal;
   import particle.P_Seeker;
   import particle.P_Sign;
   import particle.P_SlideDoor;
   import particle.P_Thing;
   import particle.P_Trap;
   import particle.P_UO;
   import particle.P_Wall;
   import particle.P_Wheel;
   import particle.Particle;
   import particle.units.P_Baby;
   import particle.units.P_Dad;
   import particle.units.P_Elder;
   import particle.units.P_Kid;
   import particle.units.P_Mom;
   import particle.units.P_Unit;
   import visual.V_Flower;
   import visual.V_Others;
   import visual.V_Stone;
   import visual.V_Text;
   import visual.Visual;
   
   public class Level
   {
       
      
      protected var _isCreated:Boolean;
      
      protected var _isTest:Boolean;
      
      protected var _isUserLevel:Boolean;
      
      protected var _isPaused:Boolean;
      
      protected var _isTracking:Boolean;
      
      protected var _isStarted:Boolean;
      
      protected var _isEnded:Boolean;
      
      protected var _isFastStart:Boolean;
      
      protected var _tfName:TextField;
      
      protected var _tfSpace:TextField;
      
      protected var _data:LevelData;
      
      protected var _particles:Vector.<Particle>;
      
      protected var _visuals:Vector.<Visual>;
      
      protected var _units:Vector.<P_Unit>;
      
      protected var _background:Background;
      
      protected var _interface:Interface;
      
      protected var _photoRibbon:Sprite;
      
      protected var _filmNoir:FilmNoirEffect;
      
      protected var _tracked:P_Unit;
      
      protected var _trackNo:int = -1;
      
      protected var _maxShakeDuration:int;
      
      protected var _isShaking:int;
      
      protected var _shakeFactor:Number;
      
      protected var _gravityAngle:Number;
      
      protected var _heartsCollected:int;
      
      protected var _unitsCollected:int;
      
      protected var _levelId:String;
      
      protected var _levelNo:int;
      
      protected var _replayNo:int;
      
      protected var _backButton:ListItem;
      
      protected var _frameList:Array;
      
      protected var _pauseList:Array;
      
      protected var _compareNo:int;
      
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
      
      private var _frameCounter:int;
      
      public function Level(data:LevelData, levelNo:int = 0)
      {
         super();
         this._levelNo = levelNo;
         this._replayNo = 0;
         this._data = data.clone();
      }
      
      public function setTest(bool:Boolean) : void
      {
         this._isTest = bool;
      }
      
      public function setReplayNo(replayNo:int) : void
      {
         this._replayNo = replayNo;
      }
      
      public function setUserLevel(levelId:String) : void
      {
         this._isUserLevel = true;
         this._levelId = levelId;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         TitleScreen.ins.remove();
         GameCamera.ins.reset();
         this._particles = new Vector.<Particle>();
         this._visuals = new Vector.<Visual>();
         this._interface = new Interface(DM.ins.iface);
         this._background = new Background(DM.ins.bg,this._data.background);
         this._background.create();
         this._units = new Vector.<P_Unit>();
         this.createParticles();
         this.createVisuals();
         this._photoRibbon = new Sprite();
         DM.ins.fg.addChild(this._photoRibbon);
         this._filmNoir = new FilmNoirEffect(DM.ins.fg);
         this._filmNoir.create();
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
         this._tfName.text = this._data.levelName;
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
         if(this._isTest)
         {
            this._backButton = new ListItem(DM.ins.fg,580,0,"Back");
            this._backButton.buttonMode = true;
            this._backButton.setSize(60,20);
            this._backButton.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         }
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyboardHandler,false,0,true);
         this.changeGravity(this._data.gravity);
         this._heartsCollected = 0;
         this._isShaking = 0;
         if(this._replayNo > 0)
         {
            this.startFast();
         }
         else
         {
            this.start();
         }
         Tracking.beginLevel(this._levelNo,LM.ins.cp.getTotalHearts(),null,"Level " + this._levelNo.toString() + " is started.");
         Main.s.focus = Main.s;
      }
      
      private function startFast() : void
      {
         this._isFastStart = true;
         this.start();
      }
      
      private function start() : void
      {
         var posX:Number = NaN;
         var posY:Number = NaN;
         var rs:Number = NaN;
         for(var i:int = 0; i < 10; i++)
         {
            PM.ins.update();
         }
         this.pauseGame(false);
         DM.ins.setBlackAndWhite(true);
         if(this._tracked)
         {
            posX = Math.min(0,Math.max(-this._data.width + 640,-this._tracked.body.GetPosition().x * Constants.SCALE + 320));
            posY = Math.min(0,Math.max(-this._data.height + 480,-this._tracked.body.GetPosition().y * Constants.SCALE + 240));
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
         DM.ins.timedBlackAndWhite(60);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.startKeyHandler);
         CF.removeDisplayObject(this._startSprite);
         this._interface.create(this._data.levelName);
         this._interface.addEventListener("pause",this.interfaceHandler);
         this._interface.addEventListener("replay",this.interfaceHandler);
         this._interface.addEventListener("hint",this.interfaceHandler);
         TweenLite.to(this._photoRibbon,1,{"alpha":0});
         TweenLite.to(this._tfName,1,{"alpha":0});
         TweenLite.to(this._tfSpace,1,{"alpha":0});
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_photoRibbon);
            CF.removeDisplayObject(_tfName);
            CF.removeDisplayObject(_tfSpace);
         },1);
         if(this._replayNo == 3)
         {
            TM.ins.tf(function():void
            {
               if(_isStarted && _isCreated)
               {
                  _interface.focusWalkthrough();
               }
            },1.5);
         }
         if(this._replayNo == 5 && !LM.ins.cp.hideSkip && LM.ins.cp.isLevelUnlocked(this._levelNo + 1) && this._levelNo != 24)
         {
            this.openSkipMenu();
         }
         else
         {
            this.resumeGame();
         }
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
         else if(e.type == "hint")
         {
            Link.Open(Constants.WALKTHROUGH_LINK,"inGame","walkthrough");
         }
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         DM.ins.setBlackAndWhite(false);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyboardHandler);
         Main.s.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.startKeyHandler);
         Main.s.removeEventListener(Event.ENTER_FRAME,this.startHandler);
         var i:int = 0;
         for(i = 0; i < this._particles.length; i++)
         {
            this._particles[i].safeRemove();
         }
         for(i = 0; i < this._visuals.length; i++)
         {
            this._visuals[i].remove();
         }
         this._particles = new Vector.<Particle>();
         this._visuals = new Vector.<Visual>();
         this._units = new Vector.<P_Unit>();
         if(this._backButton)
         {
            this._backButton.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         this._background.remove();
         this._interface.removeEventListener(DO_UnitData.ELDER,this.unitSelectionHandler);
         this._interface.removeEventListener(DO_UnitData.BABY,this.unitSelectionHandler);
         this._interface.removeEventListener(DO_UnitData.DAD,this.unitSelectionHandler);
         this._interface.removeEventListener(DO_UnitData.MOM,this.unitSelectionHandler);
         this._interface.removeEventListener(DO_UnitData.KID,this.unitSelectionHandler);
         this._interface.removeEventListener("pause",this.interfaceHandler);
         this._interface.removeEventListener("replay",this.interfaceHandler);
         this._interface.removeEventListener("hint",this.interfaceHandler);
         this._interface.remove();
         this._interface = null;
         this._filmNoir.remove();
         CF.removeDisplayObject(this._photoRibbon);
         CF.removeDisplayObject(this._tfName);
         CF.removeDisplayObject(this._tfSpace);
         CF.removeDisplayObject(this._backButton);
         CF.removeDisplayObject(this._endSprite);
         CF.removeDisplayObject(this._startSprite);
         PM.ins.reset();
         LM.ins.savePlayers();
         GameCamera.ins.reset();
         UL_EndMenu.ins.removeEventListener("menu",this.ulMenuHandler);
         UL_EndMenu.ins.removeEventListener("replay",this.ulMenuHandler);
         UL_EndMenu.ins.removeEventListener("editor",this.ulMenuHandler);
         UL_EndMenu.ins.remove();
         PauseMenu.ins.removeEventListener("resume",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("menu",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("skip",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("replay",this.pauseMenuHandler);
         PauseMenu.ins.remove();
         EndMenu.ins.removeEventListener("replay",this.endMenuHandler);
         EndMenu.ins.removeEventListener("back",this.endMenuHandler);
         EndMenu.ins.removeEventListener("next",this.endMenuHandler);
         EndMenu.ins.removeEventListener("remove",this.endMenuHandler);
         EndMenu.ins.remove();
         SkipMenu.ins.removeEventListener("resume",this.skipMenuHandler);
         SkipMenu.ins.removeEventListener("skip",this.skipMenuHandler);
         SkipMenu.ins.removeEventListener("menu",this.skipMenuHandler);
         SkipMenu.ins.remove();
      }
      
      private function unitSelectionHandler(e:Event) : void
      {
         this.track(e.type);
      }
      
      public function getUnitCheckpoint(unit:P_Unit) : P_Checkpoint
      {
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Checkpoint && (this._particles[i] as P_Checkpoint).activeUnit == unit)
            {
               return this._particles[i] as P_Checkpoint;
            }
         }
         return null;
      }
      
      private function unitCollectionHandler(e:Event) : void
      {
         var i:int = 0;
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
         ++this._unitsCollected;
         var u:P_Unit = e.currentTarget as P_Unit;
         u.removeEventListener("collected",this.unitCollectionHandler);
         i = this._units.indexOf(u);
         if(i >= 0)
         {
            this._units.splice(i,1);
         }
         if(this._units.length > 0)
         {
            if(!this._tracked || this._tracked == u)
            {
               this.trackNextUnit();
            }
            else
            {
               this.updateInterface();
            }
            i = this._particles.indexOf(u);
            if(i >= 0)
            {
               this._particles.splice(i,1);
            }
            return;
         }
         this._endPosX = this.getPortal().body.GetPosition().x * Constants.SCALE + GameCamera.ins.x;
         this._endPosY = this.getPortal().body.GetPosition().y * Constants.SCALE + GameCamera.ins.y;
         this.completeLevel();
      }
      
      private function getPortal() : P_Portal
      {
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Portal)
            {
               return this._particles[i] as P_Portal;
            }
         }
         return null;
      }
      
      private function particleRemovedHandler(e:Event) : void
      {
         var i:int = 0;
         var end:Boolean = false;
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
         var p:Particle = e.currentTarget as Particle;
         p.removeEventListener(Event.REMOVED,this.particleRemovedHandler);
         if(p is P_Unit)
         {
            i = this._units.indexOf(p);
            if(i >= 0)
            {
               this._units.splice(i,1);
            }
            end = true;
            for(i = 0; i < this._units.length; i++)
            {
               if(getQualifiedClassName(this._units[i]) == getQualifiedClassName(p))
               {
                  end = false;
                  break;
               }
            }
            if(!end)
            {
               this.trackNextUnit();
            }
            else if(!(p as P_Unit).isCollected)
            {
               this._endPosX = p.body.GetPosition().x * Constants.SCALE + GameCamera.ins.x;
               this._endPosY = p.body.GetPosition().y * Constants.SCALE + GameCamera.ins.y;
               if(!this._isTest && !this._isUserLevel)
               {
                  LM.ins.cp.addLevelDeath(this._levelNo);
               }
               this.loseLevel();
            }
         }
         i = this._particles.indexOf(p);
         if(i >= 0)
         {
            this._particles.splice(i,1);
         }
      }
      
      private function keyboardHandler(e:KeyboardEvent) : void
      {
         if(this._isEnded || !this._isStarted || this._isPaused)
         {
            return;
         }
         if(e.keyCode == 9)
         {
            this.trackNextUnit();
         }
         else if(e.keyCode == KM.ESCAPE || e.keyCode == KM.KEY_P)
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
      
      private function track(member:String) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         for(var i:int = 0; i < this._units.length; i++)
         {
            if(this._units[i].data.unitType == member)
            {
               if(this._tracked && this._tracked.data.unitType == member)
               {
                  return;
               }
               if(this._tracked)
               {
                  this._tracked.stopTracking();
               }
               this._isTracking = true;
               this._trackNo = i;
               this._tracked = this._units[i];
               this._tracked.startTracking();
            }
         }
      }
      
      private function trackNextUnit() : void
      {
         if(!this._isCreated || this._isEnded)
         {
            return;
         }
         if(this._tracked)
         {
            this._tracked.stopTracking();
            this._tracked = null;
            this._isTracking = false;
         }
         if(this._units.length == 0)
         {
            return;
         }
         this._isTracking = true;
         this._trackNo = (this._trackNo + 1) % this._units.length;
         this._tracked = this._units[this._trackNo];
         this._tracked.startTracking();
         this.updateInterface();
      }
      
      private function closePortals() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Portal)
            {
               (this._particles[i] as P_Portal).closePortal();
            }
         }
      }
      
      private function updateInterface() : void
      {
         var dad:Boolean = false;
         var mom:Boolean = false;
         var kid:Boolean = false;
         var baby:Boolean = false;
         var elder:Boolean = false;
         for(var i:int = 0; i < this._units.length; i++)
         {
            if(this._units[i] is P_Dad)
            {
               dad = true;
            }
            else if(this._units[i] is P_Mom)
            {
               mom = true;
            }
            else if(this._units[i] is P_Elder)
            {
               elder = true;
            }
            else if(this._units[i] is P_Kid)
            {
               kid = true;
            }
            else if(this._units[i] is P_Baby)
            {
               baby = true;
            }
         }
         this._interface.updateCharacters(dad,mom,kid,baby,elder);
         if(this._tracked)
         {
            this._interface.selectPortraitWithName(this._tracked.data.unitType);
         }
         else
         {
            this._interface.selectPortraitWithName("none");
         }
      }
      
      private function disableButtons() : void
      {
         if(this._backButton)
         {
            this._backButton.enabled = false;
         }
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         if(this._isEnded)
         {
            return;
         }
         if(e.currentTarget == this._backButton)
         {
            this.loadEditor(this._data);
         }
      }
      
      private function loseLevel(force:Boolean = false) : void
      {
         if(!force)
         {
            if(this._isEnded)
            {
               return;
            }
         }
         this._isEnded = true;
         this._endSprite = new Sprite();
         this._endSprite.graphics.clear();
         this._endCounter = this._endTime;
         DM.ins.menu.addChild(this._endSprite);
         Main.s.addEventListener(Event.ENTER_FRAME,this.endHandler);
         Tracking.endLevel(LM.ins.cp.getTotalHearts(),this._levelNo.toString(),"LOST: collected " + this._heartsCollected.toString() + " hearts.");
         this.disableButtons();
         if(this._isTest)
         {
            TM.ins.tf(function():void
            {
               remove();
               loadEditor(_data);
            },2);
         }
         else if(this._isUserLevel)
         {
            TM.ins.tf(function():void
            {
               remove();
               GM.ins.startUserLevel(_levelId,_data);
            },2);
         }
         else
         {
            TM.ins.tf(function():void
            {
               remove();
               GM.ins.replayLevelNo(_levelNo,_replayNo + 1);
            },1.2);
         }
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
      
      private function completeLevel() : void
      {
         if(this._isEnded)
         {
            return;
         }
         this._isEnded = true;
         this.disableButtons();
         Tracking.endLevel(LM.ins.cp.getTotalHearts(),this._levelNo.toString(),"COMPLETED: collected " + this._heartsCollected.toString() + " hearts.");
         if(this._isTest)
         {
            TM.ins.tf(function():void
            {
               remove();
               loadEditor(_data);
            },1.5);
         }
         else if(this._isUserLevel)
         {
            TM.ins.tf(function():void
            {
               UL_EndMenu.ins.create(_data.levelName,_levelId,_heartsCollected);
               UL_EndMenu.ins.addEventListener("replay",ulMenuHandler,false,0,true);
               UL_EndMenu.ins.addEventListener("menu",ulMenuHandler,false,0,true);
               UL_EndMenu.ins.addEventListener("editor",ulMenuHandler,false,0,true);
            },1.5);
         }
         else
         {
            TM.ins.tf(function():void
            {
               LM.ins.cp.setLevelsCompleted(_levelNo + 1);
               LM.ins.cp.setLevelHearts(_levelNo,_heartsCollected);
               EndMenu.ins.create(_levelNo,_heartsCollected);
               EndMenu.ins.addEventListener("replay",endMenuHandler,false,0,true);
               EndMenu.ins.addEventListener("back",endMenuHandler,false,0,true);
               EndMenu.ins.addEventListener("next",endMenuHandler,false,0,true);
               EndMenu.ins.addEventListener("remove",endMenuHandler,false,0,true);
               if(LM.ins.cp.isLevelUnlocked(_levelNo + 1))
               {
                  EndMenu.ins.setAvailable(true);
               }
               else
               {
                  EndMenu.ins.setAvailable(false);
               }
            },1);
         }
      }
      
      private function ulMenuHandler(e:Event) : void
      {
         UL_EndMenu.ins.removeEventListener("replay",this.ulMenuHandler);
         UL_EndMenu.ins.removeEventListener("menu",this.ulMenuHandler);
         UL_EndMenu.ins.removeEventListener("editor",this.ulMenuHandler);
         if(e.type == "replay")
         {
            GM.ins.startUserLevel(this._levelId,this._data);
         }
         else if(e.type == "menu")
         {
            this.remove();
            MainMenu.ins.create();
         }
         else if(e.type == "editor")
         {
            this.remove();
            DesignMenu.ins.create();
         }
      }
      
      private function endMenuHandler(e:Event) : void
      {
         EndMenu.ins.removeEventListener("replay",this.endMenuHandler);
         EndMenu.ins.removeEventListener("remove",this.endMenuHandler);
         EndMenu.ins.removeEventListener("back",this.endMenuHandler);
         EndMenu.ins.removeEventListener("next",this.endMenuHandler);
         if(e.type == "replay")
         {
            this.replayLevel();
         }
         else if(e.type == "back")
         {
            this.remove();
            LevelSelectionMenu.ins.create();
         }
         else if(e.type == "next")
         {
            if(LM.ins.cp.isLevelUnlocked(this._levelNo + 1))
            {
               if(this._levelNo == 24)
               {
                  SM.ins.fadeMusic(1.5);
                  this._endSprite = new Sprite();
                  this._endSprite.graphics.beginFill(16777215,1);
                  this._endSprite.graphics.drawRect(0,0,640,480);
                  this._endSprite.graphics.endFill();
                  this._endSprite.alpha = 0;
                  DM.ins.menu.addChild(this._endSprite);
                  TweenLite.to(this._endSprite,2.5,{"alpha":1});
                  TM.ins.tf(function():void
                  {
                     CF.removeDisplayObject(_endSprite);
                  },2.5);
                  TM.ins.tf(function():void
                  {
                     remove();
                     IntroMenu.ins.create(IntroMenu.WALTER_OUTRO);
                  },2.5);
               }
               else
               {
                  this.nextLevel();
               }
            }
            else
            {
               this.replayLevel();
            }
         }
         else if(e.type == "remove")
         {
            this.remove();
         }
      }
      
      private function loadEditor(data:LevelData) : void
      {
         this.remove();
         DesignMenu.ins.create();
         DesignMenu.ins.loadData(this._data);
      }
      
      public function update() : void
      {
         var posX:Number = NaN;
         var posY:Number = NaN;
         var disX:Number = NaN;
         var disY:Number = NaN;
         var power:Number = NaN;
         if(!this._isCreated)
         {
            return;
         }
         if(this._isPaused)
         {
            return;
         }
         this._filmNoir.update();
         this._background.update();
         if(this._isTracking && this._tracked && this._tracked.body)
         {
            posX = Math.min(0,Math.max(-this._data.width + 640,-this._tracked.body.GetPosition().x * Constants.SCALE + 320));
            posY = Math.min(0,Math.max(-this._data.height + 480,-this._tracked.body.GetPosition().y * Constants.SCALE + 240));
            disX = 0;
            disY = 0;
            if(this._isShaking > 0)
            {
               --this._isShaking;
               power = this._shakeFactor * Math.sqrt(this._isShaking / this._maxShakeDuration);
               disX = power * (Math.random() - 0.5);
               disY = power * (Math.random() - 0.5);
            }
            GameCamera.ins.updatePosition(posX,posY,disX,disY);
            DM.ins.setPhysicsPosition(posX,posY,disX,disY);
            this._background.tweenPosition(posX,posY,disX,disY);
         }
      }
      
      public function enableObjects() : void
      {
         var cannon:P_Cannon = null;
         var lever:P_Lever = null;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Cannon)
            {
               cannon = this._particles[i] as P_Cannon;
               cannon.activate();
            }
            else if(this._particles[i] is P_Lever)
            {
               lever = this._particles[i] as P_Lever;
               lever.unpull();
            }
         }
      }
      
      public function changeGravity(rotation:Number) : void
      {
         var grs:P_GravitySwitcher = null;
         var clear:Number = ((rotation + Math.PI / 2) * 180 / Math.PI + 360) % 360 / 180 * Math.PI;
         this._gravityAngle = clear;
         var newGravity:Point = new Point(Constants.GRAVITY * Math.cos(this._gravityAngle),Constants.GRAVITY * Math.sin(this._gravityAngle));
         var clearNew:Number = ((this._gravityAngle + Math.PI / 2) * 180 / Math.PI + 360) % 360 / 180 * Math.PI;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(!(this._particles[i] is P_Elder))
            {
               this._particles[i].setGravity(newGravity);
            }
            if(this._particles[i] is P_GravitySwitcher)
            {
               grs = this._particles[i] as P_GravitySwitcher;
               if(grs.rotation == clearNew)
               {
                  grs.activate();
               }
               else
               {
                  grs.deactivate();
               }
            }
         }
      }
      
      public function pushPlates() : void
      {
         var door:P_PistonDoor = null;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_PistonDoor)
            {
               door = this._particles[i] as P_PistonDoor;
               if(!door.isOpened)
               {
                  door.open();
               }
            }
         }
      }
      
      public function unpushPlates() : void
      {
         var i:int = 0;
         var door:P_PistonDoor = null;
         var unpush:Boolean = true;
         for(i = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_PistonPlate)
            {
               if((this._particles[i] as P_PistonPlate).isPushed)
               {
                  unpush = false;
                  break;
               }
            }
         }
         if(!unpush)
         {
            return;
         }
         for(i = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_PistonDoor)
            {
               door = this._particles[i] as P_PistonDoor;
               if(door.isOpened)
               {
                  door.close();
               }
            }
         }
      }
      
      public function pushButton() : void
      {
         var button:P_Button = null;
         var door:P_SlideDoor = null;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Button)
            {
               button = this._particles[i] as P_Button;
               if(!button.isPushed)
               {
                  button.push();
               }
            }
            else if(this._particles[i] is P_SlideDoor)
            {
               door = this._particles[i] as P_SlideDoor;
               if(!door.isOpened)
               {
                  door.open();
               }
            }
         }
      }
      
      public function activateCheckpoint(cp:P_Checkpoint, unit:P_Unit) : void
      {
         var check:P_Checkpoint = null;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Checkpoint)
            {
               check = this._particles[i] as P_Checkpoint;
               if(check != cp && check.activeUnit == unit)
               {
                  check.deactivate();
               }
            }
         }
      }
      
      public function disableObjects() : void
      {
         var cannon:P_Cannon = null;
         var lever:P_Lever = null;
         for(var i:int = 0; i < this._particles.length; i++)
         {
            if(this._particles[i] is P_Cannon)
            {
               cannon = this._particles[i] as P_Cannon;
               cannon.deactivate();
            }
            else if(this._particles[i] is P_Lever)
            {
               lever = this._particles[i] as P_Lever;
               lever.pull();
            }
         }
      }
      
      public function shakeCamera(duration:int, shakeFactor:Number) : void
      {
         this._maxShakeDuration = duration;
         this._isShaking = this._maxShakeDuration;
         this._shakeFactor = shakeFactor;
      }
      
      public function collectHeart() : void
      {
         ++this._heartsCollected;
         this._interface.collectHeart(this._heartsCollected);
      }
      
      private function openSkipMenu() : void
      {
         this.pauseGame(false);
         SkipMenu.ins.create();
         SkipMenu.ins.addEventListener("resume",this.skipMenuHandler,false,0,true);
         SkipMenu.ins.addEventListener("skip",this.skipMenuHandler,false,0,true);
         SkipMenu.ins.addEventListener("menu",this.skipMenuHandler,false,0,true);
      }
      
      private function skipMenuHandler(e:Event) : void
      {
         SkipMenu.ins.removeEventListener("resume",this.skipMenuHandler);
         SkipMenu.ins.removeEventListener("skip",this.skipMenuHandler);
         SkipMenu.ins.removeEventListener("menu",this.skipMenuHandler);
         SkipMenu.ins.remove();
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
         else if(e.type == "skip")
         {
            Tracking.customMessage("SKIP",LM.ins.cp.getTotalHearts(),null,"skipped level: " + this._levelNo.toString());
            this.resumeGame();
            this.remove();
            this.nextLevel();
         }
      }
      
      private function pauseGame(enableMenu:Boolean = true) : void
      {
         if(this._isPaused)
         {
            return;
         }
         this._isPaused = true;
         UM.ins.pause();
         if(enableMenu)
         {
            PauseMenu.ins.create(this._data.levelName);
            PauseMenu.ins.addEventListener("resume",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.addEventListener("menu",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.addEventListener("skip",this.pauseMenuHandler,false,0,true);
            PauseMenu.ins.addEventListener("replay",this.pauseMenuHandler,false,0,true);
            if(this._levelNo == 24 || this._isTest || this._isUserLevel || !LM.ins.cp.isLevelUnlocked(this._levelNo + 1))
            {
               PauseMenu.ins.hideSkipButton();
            }
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
         PauseMenu.ins.removeEventListener("skip",this.pauseMenuHandler);
         PauseMenu.ins.removeEventListener("replay",this.pauseMenuHandler);
         if(e.type == "resume")
         {
            this.resumeGame();
         }
         else if(e.type == "menu")
         {
            this.resumeGame();
            this.remove();
            if(this._isUserLevel)
            {
               MainMenu.ins.create();
            }
            else
            {
               LevelSelectionMenu.ins.create();
            }
         }
         else if(e.type == "skip")
         {
            this.resumeGame();
            this.remove();
            this.nextLevel();
         }
         else if(e.type == "replay")
         {
            this.replayLevel();
         }
      }
      
      private function nextLevel() : void
      {
         this.remove();
         GM.ins.startLevelNo(this._levelNo + 1);
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
         this.loseLevel(true);
      }
      
      private function resumeGame() : void
      {
         if(!this._isPaused)
         {
            return;
         }
         this._isPaused = false;
         UM.ins.resume();
         this._compareNo = 0;
         this.resumeMovieclip(GameCamera.ins.costume);
      }
      
      private function frameHandler(e:Event) : void
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
      
      private function getFrames(mc:MovieClip) : void
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
      
      private function compareFrames(mc:MovieClip) : void
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
      
      private function resumeMovieclip(mc:MovieClip) : void
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
      
      private function createParticles() : void
      {
         var p:Particle = null;
         var i:int = 0;
         var area:Rectangle = new Rectangle(-40,-40,this._data.width + 80,this._data.height + 80);
         var dad:Boolean = false;
         var mom:Boolean = false;
         var kid:Boolean = false;
         var baby:Boolean = false;
         var elder:Boolean = false;
         for(i = 0; i < this._data.list.length; i++)
         {
            if(this._data.list[i].type == DO_Data.TYPE_POLY)
            {
               if((this._data.list[i] as DO_PolyData).polyType == DO_PolyData.WALL)
               {
                  p = new P_Wall(GameCamera.WALL,this._data.list[i] as DO_PolyData);
               }
               else if((this._data.list[i] as DO_PolyData).polyType == DO_PolyData.OBSTACLE)
               {
                  p = new P_Obstacle(GameCamera.OBSTACLE,this._data.list[i] as DO_PolyData);
               }
            }
            else if(this._data.list[i].type == DO_Data.TYPE_UNIT)
            {
               if((this._data.list[i] as DO_UnitData).unitType == DO_UnitData.DAD)
               {
                  p = new P_Dad(GameCamera.UNIT,this._data.list[i] as DO_UnitData);
                  dad = true;
                  this._interface.addEventListener(DO_UnitData.DAD,this.unitSelectionHandler,false,0,true);
               }
               else if((this._data.list[i] as DO_UnitData).unitType == DO_UnitData.MOM)
               {
                  p = new P_Mom(GameCamera.UNIT,this._data.list[i] as DO_UnitData);
                  mom = true;
                  this._interface.addEventListener(DO_UnitData.MOM,this.unitSelectionHandler,false,0,true);
               }
               else if((this._data.list[i] as DO_UnitData).unitType == DO_UnitData.KID)
               {
                  p = new P_Kid(GameCamera.UNIT,this._data.list[i] as DO_UnitData);
                  kid = true;
                  this._interface.addEventListener(DO_UnitData.KID,this.unitSelectionHandler,false,0,true);
               }
               else if((this._data.list[i] as DO_UnitData).unitType == DO_UnitData.BABY)
               {
                  p = new P_Baby(GameCamera.UNIT,this._data.list[i] as DO_UnitData);
                  baby = true;
                  this._interface.addEventListener(DO_UnitData.BABY,this.unitSelectionHandler,false,0,true);
               }
               else if((this._data.list[i] as DO_UnitData).unitType == DO_UnitData.ELDER)
               {
                  p = new P_Elder(GameCamera.UNIT,this._data.list[i] as DO_UnitData);
                  elder = true;
                  this._interface.addEventListener(DO_UnitData.ELDER,this.unitSelectionHandler,false,0,true);
               }
               this._units.push(p as P_Unit);
               p.addEventListener("collected",this.unitCollectionHandler,false,0,true);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_HEART)
            {
               p = new P_Heart(GameCamera.HEART,this._data.list[i] as DO_HeartData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_TRAP)
            {
               p = new P_Trap(GameCamera.TRAP,this._data.list[i] as DO_TrapData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_PORTAL)
            {
               p = new P_Portal(GameCamera.PORTAL,this._data.list[i] as DO_PortalData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_UO)
            {
               p = new P_UO(GameCamera.UO,this._data.list[i] as DO_UOData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_PLATFORM)
            {
               p = new P_Platform(GameCamera.PLATFORM,this._data.list[i] as DO_PlatformData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_CANNON)
            {
               p = new P_Cannon(GameCamera.CANNON,GameCamera.CANNON_BALL,this._data.list[i] as DO_CannonData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_LEVER)
            {
               p = new P_Lever(GameCamera.LEVER,this._data.list[i] as DO_LeverData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_CLOUD)
            {
               p = new P_Cloud(GameCamera.CLOUD,this._data.list[i] as DO_CloudData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_KEY)
            {
               p = new P_Key(GameCamera.KEY,this._data.list[i] as DO_KeyData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_DOOR)
            {
               p = new P_Door(GameCamera.DOOR,this._data.list[i] as DO_DoorData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_BOUNCER)
            {
               p = new P_Bouncer(GameCamera.BOUNCER,this._data.list[i] as DO_BouncerData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_LAMP)
            {
               p = new P_Lamp(GameCamera.LAMP,this._data.list[i] as DO_LampData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_BLOWER)
            {
               p = new P_Blower(GameCamera.BLOWER,this._data.list[i] as DO_BlowerData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_LASER)
            {
               p = new P_Laser(GameCamera.LASER,this._data.list[i] as DO_LaserData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_LADDER)
            {
               p = new P_Ladder(GameCamera.LADDER,this._data.list[i] as DO_LadderData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_BUTTON)
            {
               p = new P_Button(GameCamera.BUTTON,this._data.list[i] as DO_ButtonData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_SLIDE_DOOR)
            {
               p = new P_SlideDoor(GameCamera.SLIDE_DOOR,this._data.list[i] as DO_SlideDoorData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_GRAVITY_SWITCHER)
            {
               p = new P_GravitySwitcher(GameCamera.GRAVITY_SWITCHER,this._data.list[i] as DO_GravitySwitcherData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_WHEEL)
            {
               p = new P_Wheel(GameCamera.WHEEL,this._data.list[i] as DO_WheelData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_SEEKER)
            {
               p = new P_Seeker(GameCamera.UO,this._data.list[i] as DO_SeekerData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_PISTON_DOOR)
            {
               p = new P_PistonDoor(GameCamera.DOOR,this._data.list[i] as DO_PistonDoorData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_PISTON_PLATE)
            {
               p = new P_PistonPlate(GameCamera.BUTTON,this._data.list[i] as DO_PistonPlateData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_CHAIN)
            {
               p = new P_Chain(GameCamera.CHAIN,this._data.list[i] as DO_ChainData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_SIGN)
            {
               p = new P_Sign(GameCamera.SIGN,this._data.list[i] as DO_SignData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_THING)
            {
               p = new P_Thing(GameCamera.THING,this._data.list[i] as DO_ThingData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_ELEVATOR)
            {
               p = new P_Elevator(GameCamera.ELEVATOR,this._data.list[i] as DO_ElevatorData);
            }
            else
            {
               if(this._data.list[i].type != DO_Data.TYPE_CHECKPOINT)
               {
                  continue;
               }
               p = new P_Checkpoint(GameCamera.CHECKPOINT,this._data.list[i] as DO_CheckpointData);
            }
            p.create();
            p.setArea(area);
            p.addEventListener(Event.REMOVED,this.particleRemovedHandler,false,0,true);
            this._particles.push(p);
         }
         if(dad)
         {
            this.track(DO_UnitData.DAD);
         }
         else if(mom)
         {
            this.track(DO_UnitData.MOM);
         }
         else if(elder)
         {
            this.track(DO_UnitData.ELDER);
         }
         else if(kid)
         {
            this.track(DO_UnitData.KID);
         }
         else if(baby)
         {
            this.track(DO_UnitData.BABY);
         }
         this._interface.setCharacters(dad,mom,kid,baby,elder);
      }
      
      private function createVisuals() : void
      {
         var i:int = 0;
         var v:Visual = null;
         for(i = 0; i < this._data.list.length; i++)
         {
            if(this._data.list[i].type == DO_Data.TYPE_TEXT)
            {
               v = new V_Text(GameCamera.TEXT,this._data.list[i] as DO_TextData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_STONE)
            {
               v = new V_Stone(GameCamera.STONE_FRONT,this._data.list[i] as DO_StoneData);
            }
            else if(this._data.list[i].type == DO_Data.TYPE_FLOWER)
            {
               v = new V_Flower(GameCamera.FLOWER_FRONT,this._data.list[i] as DO_FlowerData);
            }
            else
            {
               if(this._data.list[i].type != DO_Data.TYPE_OTHERS)
               {
                  continue;
               }
               v = new V_Others(GameCamera.OTHERS,this._data.list[i] as DO_OthersData);
            }
            v.create();
            this._visuals.push(v);
         }
      }
      
      public function get tracked() : P_Unit
      {
         return this._tracked;
      }
      
      public function get gravityAngle() : Number
      {
         return this._gravityAngle;
      }
      
      public function get units() : Vector.<P_Unit>
      {
         return this._units;
      }
      
      public function get isTest() : Boolean
      {
         return this._isTest;
      }
      
      public function get isEnded() : Boolean
      {
         return this._isEnded;
      }
      
      public function get isTracking() : Boolean
      {
         return this._isTracking;
      }
      
      public function get isUserLevel() : Boolean
      {
         return this._isUserLevel;
      }
   }
}
