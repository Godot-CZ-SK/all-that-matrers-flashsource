package menus
{
   import com.bit101.components.ComboBox;
   import com.bit101.components.Label;
   import com.bit101.components.ListItem;
   import com.bit101.components.Panel;
   import com.bit101.components.Window;
   import design.DO_Blower;
   import design.DO_Bouncer;
   import design.DO_Button;
   import design.DO_Cannon;
   import design.DO_Chain;
   import design.DO_Checkpoint;
   import design.DO_Cloud;
   import design.DO_Door;
   import design.DO_Elevator;
   import design.DO_Flower;
   import design.DO_GravitySwitcher;
   import design.DO_Heart;
   import design.DO_Key;
   import design.DO_Ladder;
   import design.DO_Lamp;
   import design.DO_Laser;
   import design.DO_Lever;
   import design.DO_Obstacle;
   import design.DO_Others;
   import design.DO_PistonDoor;
   import design.DO_PistonPlate;
   import design.DO_Platform;
   import design.DO_Portal;
   import design.DO_Seeker;
   import design.DO_Sign;
   import design.DO_SlideDoor;
   import design.DO_Stone;
   import design.DO_Text;
   import design.DO_Thing;
   import design.DO_Trap;
   import design.DO_UO;
   import design.DO_Unit;
   import design.DO_Wall;
   import design.DO_Wheel;
   import design.DesignList;
   import design.DesignObject;
   import design.data.DO_Data;
   import design.data.DO_PolyData;
   import design.data.DO_TrapData;
   import design.data.DO_UOData;
   import design.data.DO_UnitData;
   import design.data.LevelData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import game.Background;
   import game.GameCamera;
   import managers.DM;
   import managers.GM;
   import managers.KM;
   import managers.LM;
   import managers.TM;
   
   public class DesignMenu
   {
      
      public static const GRID_CELL_SIZE:Number = 40;
      
      public static const EDGE_OFFSET:Number = 40;
      
      public static const MENU_WIDTH:Number = 640;
      
      public static const MENU_HEIGHT:Number = 480;
      
      public static const BUFFER_SIZE:Number = 200;
      
      private static var _ins:DesignMenu;
      
      private static var _options:DM_Options;
       
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MovieClip;
      
      protected var _menuCostume:MovieClip;
      
      protected var _drawCostume:MovieClip;
      
      protected var _selectArea:MovieClip;
      
      protected var _levelCostume:MovieClip;
      
      protected var _gridCostume:MovieClip;
      
      protected var _gravityAngle:Number;
      
      protected var _background:Background;
      
      protected var _menuBG:Sprite;
      
      protected var _fileButton:ListItem;
      
      protected var _windowButton:ListItem;
      
      protected var _shareButton:ListItem;
      
      protected var _testButton:ListItem;
      
      protected var _windowCostume:MovieClip;
      
      protected var _unitsButton:ListItem;
      
      protected var _objectsButton:ListItem;
      
      protected var _enemiesButton:ListItem;
      
      protected var _visualsButton:ListItem;
      
      protected var _mapButton:ListItem;
      
      protected var _fileCostume:MovieClip;
      
      protected var _newButton:ListItem;
      
      protected var _propertiesButton:ListItem;
      
      protected var _saveLoadButton:ListItem;
      
      protected var _exitButton:ListItem;
      
      protected var _objectsWindow:Window;
      
      protected var _movePoint:Point;
      
      protected var _firstPos:Point;
      
      protected var _visualsWindow:Window;
      
      protected var _bgSelector:ComboBox;
      
      protected var _unitsWindow:Window;
      
      protected var _enemiesWindow:Window;
      
      protected var _infoPanel:Panel;
      
      protected var _infoLabel:Label;
      
      protected var _mapWindow:Window;
      
      protected var _mapContent:Sprite;
      
      protected var _propertiesPanel:DM_PropertiesPanel;
      
      protected var _saveLoadPanel:DM_SaveLoadPanel;
      
      protected var _sharePanel:DM_SharePanel;
      
      protected var _lastCreated:String;
      
      protected var _beingDrawn:DesignObject;
      
      protected var _designObjects:Vector.<DesignObject>;
      
      protected var _selectedObjects:Vector.<DesignObject>;
      
      public function DesignMenu()
      {
         super();
      }
      
      public static function get ins() : DesignMenu
      {
         if(!_ins)
         {
            _ins = new DesignMenu();
         }
         return _ins;
      }
      
      public function create() : void
      {
         var obj:String = null;
         var cl:Class = null;
         var mc:MovieClip = null;
         var scale:Number = NaN;
         if(this._isCreated)
         {
            return;
         }
         if(!_options)
         {
            _options = new DM_Options();
         }
         this._isCreated = true;
         this._width = 1280;
         this._height = 960;
         this._gravityAngle = 0;
         var i:int = 0;
         var j:int = 0;
         this._costume = new MovieClip();
         this._menuCostume = new MovieClip();
         this._drawCostume = new MovieClip();
         this._selectArea = new MovieClip();
         this._levelCostume = new MovieClip();
         this._gridCostume = new MovieClip();
         this._drawCostume.addChild(this._gridCostume);
         this._drawCostume.addChild(this._selectArea);
         this._costume.addChild(this._menuCostume);
         DM.ins.bg.addChild(this._levelCostume);
         DM.ins.bg.addChild(this._drawCostume);
         DM.ins.menu.addChild(this._costume);
         this._background = new Background(this._levelCostume,Background.MOUNTAIN);
         this._background.create();
         this.createGrid();
         this._gridCostume.addEventListener(MouseEvent.MOUSE_DOWN,this.bgDownHandler,false,0,true);
         this._mapWindow = new Window(this._menuCostume,_options.map_pos.x,_options.map_pos.y,"Map (M)");
         this._mapWindow.setSize(_options.map_size.x,_options.map_size.y);
         this._mapWindow.hasMinimizeButton = true;
         this._mapWindow.draggable = false;
         this._mapWindow.hasCloseButton = false;
         this._mapContent = new Sprite();
         this._mapContent.x = 2;
         this._mapContent.y = 2;
         this._mapWindow.content.addChild(this._mapContent);
         this._mapContent.mouseChildren = false;
         this._mapContent.addEventListener(MouseEvent.MOUSE_DOWN,this.mapDownHandler,false,0,true);
         this._menuBG = new Sprite();
         this._menuBG.graphics.beginFill(14540253,1);
         this._menuBG.graphics.drawRect(0,0,MENU_WIDTH,20);
         this._menuBG.graphics.endFill();
         this._menuCostume.addChild(this._menuBG);
         this._fileButton = new ListItem(this._menuCostume,0,0,"File");
         this._fileButton.setSize(80,20);
         this._fileButton.buttonMode = true;
         this._fileButton.addEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler,false,0,true);
         this._fileButton.addEventListener(MouseEvent.ROLL_OUT,this.mouseOutHandler,false,0,true);
         this._windowButton = new ListItem(this._menuCostume,80,0,"Window");
         this._windowButton.setSize(80,20);
         this._windowButton.buttonMode = true;
         this._windowButton.addEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler,false,0,true);
         this._windowButton.addEventListener(MouseEvent.ROLL_OUT,this.mouseOutHandler,false,0,true);
         this._shareButton = new ListItem(this._menuCostume,160,0,"Share");
         this._shareButton.setSize(80,20);
         this._shareButton.buttonMode = true;
         this._shareButton.addEventListener(MouseEvent.CLICK,this.menuButtonClickHandler,false,0,true);
         this._testButton = new ListItem(this._menuCostume,240,0,"Test (T)");
         this._testButton.setSize(80,20);
         this._testButton.buttonMode = true;
         this._testButton.addEventListener(MouseEvent.CLICK,this.menuButtonClickHandler,false,0,true);
         this._fileCostume = new MovieClip();
         this._fileCostume.visible = false;
         this._fileCostume.x = 0;
         this._fileCostume.y = 20;
         this._fileButton.addChild(this._fileCostume);
         this._newButton = new ListItem(this._fileCostume,0,0,"New");
         this._newButton.setSize(80,20);
         this._newButton.buttonMode = true;
         this._newButton.addEventListener(MouseEvent.CLICK,this.fileButtonClickHandler,false,0,true);
         this._propertiesButton = new ListItem(this._fileCostume,0,20,"Properties");
         this._propertiesButton.setSize(80,20);
         this._propertiesButton.buttonMode = true;
         this._propertiesButton.addEventListener(MouseEvent.CLICK,this.fileButtonClickHandler);
         this._saveLoadButton = new ListItem(this._fileCostume,0,40,"Save & Load");
         this._saveLoadButton.setSize(80,20);
         this._saveLoadButton.buttonMode = true;
         this._saveLoadButton.addEventListener(MouseEvent.CLICK,this.fileButtonClickHandler);
         this._exitButton = new ListItem(this._fileCostume,0,60,"Exit");
         this._exitButton.setSize(80,20);
         this._exitButton.buttonMode = true;
         this._exitButton.addEventListener(MouseEvent.CLICK,this.fileButtonClickHandler,false,0,true);
         this._windowCostume = new MovieClip();
         this._windowCostume.visible = false;
         this._windowCostume.x = 0;
         this._windowCostume.y = 20;
         this._windowButton.addChild(this._windowCostume);
         this._unitsButton = new ListItem(this._windowCostume,0,0,"Units (U)");
         this._unitsButton.setSize(80,20);
         this._unitsButton.buttonMode = true;
         this._unitsButton.addEventListener(MouseEvent.CLICK,this.windowClickHandler,false,0,true);
         this._objectsButton = new ListItem(this._windowCostume,0,20,"Objects (O)");
         this._objectsButton.setSize(80,20);
         this._objectsButton.buttonMode = true;
         this._objectsButton.addEventListener(MouseEvent.CLICK,this.windowClickHandler,false,0,true);
         this._enemiesButton = new ListItem(this._windowCostume,0,40,"Enemies (E)");
         this._enemiesButton.setSize(80,20);
         this._enemiesButton.buttonMode = true;
         this._enemiesButton.addEventListener(MouseEvent.CLICK,this.windowClickHandler,false,0,true);
         this._visualsButton = new ListItem(this._windowCostume,0,60,"Visuals (V)");
         this._visualsButton.setSize(80,20);
         this._visualsButton.buttonMode = true;
         this._visualsButton.addEventListener(MouseEvent.CLICK,this.windowClickHandler,false,0,true);
         this._mapButton = new ListItem(this._windowCostume,0,80,"Map (M)");
         this._mapButton.setSize(80,20);
         this._mapButton.buttonMode = true;
         this._mapButton.addEventListener(MouseEvent.CLICK,this.windowClickHandler,false,0,true);
         this._unitsWindow = new Window(this._menuCostume,_options.units_pos.x,_options.units_pos.y,"Units (U)");
         this._unitsWindow.setSize(120,110);
         this._unitsWindow.hasMinimizeButton = true;
         this._unitsWindow.draggable = false;
         this._unitsWindow.hasCloseButton = false;
         this._unitsWindow.addEventListener(Event.RESIZE,this.windowResizeHandler);
         for(i = 0; i < DesignList.UNITS_LIST.length; i++)
         {
            obj = DesignList.UNITS_LIST[i];
            cl = getDefinitionByName(obj) as Class;
            mc = new cl() as MovieClip;
            mc.x = i % 3 * 40 + 20;
            mc.y = int(i / 3) * 40 + 20;
            mc.buttonMode = true;
            scale = Math.min(1,30 / mc.width,30 / mc.height);
            mc.scaleX = scale;
            mc.scaleY = scale;
            this._unitsWindow.content.addChild(mc);
            mc.addEventListener(MouseEvent.CLICK,this.windowDownHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         }
         this._objectsWindow = new Window(this._menuCostume,_options.objects_pos.x,_options.objects_pos.y,"Objects (O)");
         this._objectsWindow.setSize(120,320);
         this._objectsWindow.hasMinimizeButton = true;
         this._objectsWindow.draggable = false;
         this._objectsWindow.hasCloseButton = false;
         this._objectsWindow.addEventListener(Event.RESIZE,this.windowResizeHandler);
         for(i = 0; i < DesignList.PARTICLE_LIST.length; i++)
         {
            obj = DesignList.PARTICLE_LIST[i];
            cl = getDefinitionByName(obj) as Class;
            mc = new cl() as MovieClip;
            mc.x = i % 3 * 40 + 20;
            mc.y = int(i / 3) * 40 + 20;
            mc.buttonMode = true;
            scale = Math.min(1,30 / mc.width,30 / mc.height);
            mc.scaleX = scale;
            mc.scaleY = scale;
            this._objectsWindow.content.addChild(mc);
            mc.addEventListener(MouseEvent.CLICK,this.windowDownHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         }
         this._enemiesWindow = new Window(this._menuCostume,_options.enemies_pos.x,_options.enemies_pos.y,"Enemies (E)");
         this._enemiesWindow.setSize(120,110);
         this._enemiesWindow.hasMinimizeButton = true;
         this._enemiesWindow.draggable = false;
         this._enemiesWindow.hasCloseButton = false;
         this._enemiesWindow.addEventListener(Event.RESIZE,this.windowResizeHandler);
         for(i = 0; i < DesignList.ENEMIES_LIST.length; i++)
         {
            obj = DesignList.ENEMIES_LIST[i];
            cl = getDefinitionByName(obj) as Class;
            mc = new cl() as MovieClip;
            mc.x = i % 3 * 40 + 20;
            mc.y = int(i / 3) * 40 + 20;
            mc.buttonMode = true;
            scale = Math.min(1,30 / mc.width,30 / mc.height);
            mc.scaleX = scale;
            mc.scaleY = scale;
            this._enemiesWindow.content.addChild(mc);
            mc.addEventListener(MouseEvent.CLICK,this.windowDownHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         }
         this._visualsWindow = new Window(this._menuCostume,_options.visuals_pos.x,_options.visuals_pos.y,"Visuals (V)");
         this._visualsWindow.setSize(120,160);
         this._visualsWindow.hasMinimizeButton = true;
         this._visualsWindow.draggable = false;
         this._visualsWindow.hasCloseButton = false;
         this._visualsWindow.addEventListener(Event.RESIZE,this.windowResizeHandler);
         for(i = 0; i < DesignList.VISUAL_LIST.length; i++)
         {
            obj = DesignList.VISUAL_LIST[i];
            cl = getDefinitionByName(obj) as Class;
            mc = new cl() as MovieClip;
            mc.x = i % 3 * 40 + 20;
            mc.y = int(i / 3) * 40 + 20;
            mc.buttonMode = true;
            scale = Math.min(1,30 / mc.width,30 / mc.height);
            mc.scaleX = scale;
            mc.scaleY = scale;
            this._visualsWindow.content.addChild(mc);
            mc.addEventListener(MouseEvent.CLICK,this.windowDownHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         }
         this._bgSelector = new ComboBox(this._visualsWindow.content,5,120,"Mountain");
         this._bgSelector.numVisibleItems = 4;
         for(i = 0; i < DesignList.BG_LIST.length; i++)
         {
            this._bgSelector.addItem(DesignList.BG_LIST[i]);
         }
         this._bgSelector.setSize(110,15);
         this._bgSelector.addEventListener(Event.SELECT,this.bgSelectHandler,false,0,true);
         this._bgSelector.addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
         this._bgSelector.addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         this._infoPanel = new Panel(this._menuCostume,_options.info_pos.x,_options.info_pos.y);
         this._infoPanel.setSize(120,25);
         this._infoLabel = new Label(this._infoPanel.content,5,5,"Info Panel");
         this._infoLabel.setSize(120,25);
         this.openWindow("units");
         this._designObjects = new Vector.<DesignObject>();
         this._selectedObjects = new Vector.<DesignObject>();
         this._propertiesPanel = new DM_PropertiesPanel(this._costume);
         this._saveLoadPanel = new DM_SaveLoadPanel(this._costume);
         this._sharePanel = new DM_SharePanel(this._costume);
         Main.s.addEventListener(Event.ENTER_FRAME,this.updateHandler,false,0,true);
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,0,true);
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler,false,0,true);
         this.setPosition(MENU_WIDTH / 2,MENU_HEIGHT / 2);
      }
      
      private function createGrid() : void
      {
         var i:Number = NaN;
         this._gridCostume.graphics.clear();
         this._gridCostume.graphics.beginFill(0,0);
         this._gridCostume.graphics.drawRect(0,0,this._width,this._height);
         this._gridCostume.graphics.endFill();
         this._gridCostume.graphics.lineStyle(5);
         this._gridCostume.graphics.moveTo(EDGE_OFFSET,EDGE_OFFSET);
         this._gridCostume.graphics.lineTo(this._width - EDGE_OFFSET,EDGE_OFFSET);
         this._gridCostume.graphics.lineTo(this._width - EDGE_OFFSET,this._height - EDGE_OFFSET);
         this._gridCostume.graphics.lineTo(EDGE_OFFSET,this._height - EDGE_OFFSET);
         this._gridCostume.graphics.lineTo(EDGE_OFFSET,EDGE_OFFSET);
         this._gridCostume.graphics.lineStyle(0.1,0);
         for(i = EDGE_OFFSET; i < this._width - EDGE_OFFSET; i += GRID_CELL_SIZE)
         {
            this._gridCostume.graphics.moveTo(i,EDGE_OFFSET);
            this._gridCostume.graphics.lineTo(i,this._height - EDGE_OFFSET);
         }
         for(i = EDGE_OFFSET; i < this._height - EDGE_OFFSET; i += GRID_CELL_SIZE)
         {
            this._gridCostume.graphics.moveTo(EDGE_OFFSET,i);
            this._gridCostume.graphics.lineTo(this._width - EDGE_OFFSET,i);
         }
      }
      
      private function isPanelOpen() : Boolean
      {
         if(this._propertiesPanel.isCreated || this._saveLoadPanel.isCreated || this._sharePanel.isCreated)
         {
            return true;
         }
         return false;
      }
      
      public function loadLastSave() : void
      {
         if(LM.ins.getLastSave())
         {
            this.loadData(LM.ins.getLastSave().clone());
         }
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this.clearSelectedObjects();
         this.clearLevel();
         this._propertiesPanel.remove();
         this._saveLoadPanel.remove();
         this._sharePanel.remove();
         this._background.remove();
         CF.removeDisplayObject(this._drawCostume);
         CF.removeDisplayObject(this._levelCostume);
         CF.removeDisplayObject(this._costume);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.mapMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.mapUpHandler);
         Main.s.removeEventListener(Event.ENTER_FRAME,this.updateHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.designObjectUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.designObjectMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.bgMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.bgUpHandler);
         GameCamera.ins.reset();
      }
      
      private function addDesignObject(design_object:DesignObject) : void
      {
         this._designObjects.push(design_object);
         design_object.addEventListener("selected",this.designObjectSelectedHandler,false,0,true);
         design_object.addEventListener(Event.REMOVED,this.designObjectRemovedHandler,false,0,true);
         design_object.addEventListener(Event.COMPLETE,this.designObjectCompleteHandler,false,0,true);
         design_object.addEventListener(MouseEvent.MOUSE_DOWN,this.designObjectDownHandler,false,0,true);
      }
      
      private function removeDesignObject(design_object:DesignObject) : void
      {
         var i:int = this._designObjects.indexOf(design_object);
         if(i >= 0)
         {
            this._designObjects.splice(i,1);
         }
         i = this._selectedObjects.indexOf(design_object);
         if(i >= 0)
         {
            this._selectedObjects.splice(i,1);
         }
         design_object.removeEventListener("selected",this.designObjectSelectedHandler);
         design_object.removeEventListener(Event.REMOVED,this.designObjectRemovedHandler);
         design_object.removeEventListener(Event.COMPLETE,this.designObjectCompleteHandler);
         design_object.removeEventListener(MouseEvent.MOUSE_DOWN,this.designObjectDownHandler);
         design_object.remove();
      }
      
      private function keyDownHandler(e:KeyboardEvent) : void
      {
         var i:int = 0;
         if(this.isPanelOpen())
         {
            return;
         }
         if(e.keyCode == KM.KEY_W || e.keyCode == KM.UP)
         {
            this.addPosition(0,-20);
         }
         else if(e.keyCode == KM.KEY_A || e.keyCode == KM.LEFT)
         {
            this.addPosition(-20,0);
         }
         else if(e.keyCode == KM.KEY_S || e.keyCode == KM.DOWN)
         {
            this.addPosition(0,20);
         }
         else if(e.keyCode == KM.KEY_D || e.keyCode == KM.RIGHT)
         {
            this.addPosition(20,0);
         }
         else if(e.keyCode == KM.DELETE)
         {
            if(this._selectedObjects.length > 0)
            {
               for(i = this._selectedObjects.length - 1; i >= 0; i--)
               {
                  this.removeDesignObject(this._selectedObjects[i]);
               }
               this._selectedObjects = new Vector.<DesignObject>();
            }
         }
         else if(e.keyCode == KM.ESCAPE)
         {
            if(this._beingDrawn)
            {
               this.removeDesignObject(this._beingDrawn);
               this._beingDrawn = null;
            }
         }
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(this.isPanelOpen())
         {
            return;
         }
         if(this._selectedObjects.length > 0)
         {
            return;
         }
         if(e.keyCode == 85)
         {
            this.openWindow("units");
         }
         else if(e.keyCode == 79)
         {
            this.openWindow("objects");
         }
         else if(e.keyCode == 86)
         {
            this.openWindow("visuals");
         }
         else if(e.keyCode == 77)
         {
            this.openWindow("map");
         }
         else if(e.keyCode == 69)
         {
            this.openWindow("enemies");
         }
         else if(e.keyCode == 84)
         {
            this.test();
         }
      }
      
      private function addPosition(xpos:Number, ypos:Number) : void
      {
         this._drawCostume.x = Math.min(BUFFER_SIZE,Math.max(MENU_WIDTH - 1280 - BUFFER_SIZE,this._drawCostume.x - xpos));
         this._drawCostume.y = Math.min(BUFFER_SIZE,Math.max(MENU_HEIGHT - 960 - BUFFER_SIZE,this._drawCostume.y - ypos));
         this._background.setPosition(this._drawCostume.x,this._drawCostume.y);
         GameCamera.ins.setPosition(this._drawCostume.x,this._drawCostume.y);
      }
      
      private function setPosition(xpos:Number, ypos:Number) : void
      {
         this._drawCostume.x = Math.min(BUFFER_SIZE,Math.max(MENU_WIDTH - 1280 - BUFFER_SIZE,MENU_WIDTH / 2 - xpos));
         this._drawCostume.y = Math.min(BUFFER_SIZE,Math.max(MENU_HEIGHT - 960 - BUFFER_SIZE,MENU_HEIGHT / 2 - ypos));
         this._background.setPosition(this._drawCostume.x,this._drawCostume.y);
         GameCamera.ins.setPosition(this._drawCostume.x,this._drawCostume.y);
      }
      
      private function clearSelectedObjects() : void
      {
         for(var i:int = 0; i < this._selectedObjects.length; i++)
         {
            this._selectedObjects[i].unselect();
            this._selectedObjects[i].removeFromMultipleSelection();
            this._selectedObjects[i].endMoving();
         }
         this._selectedObjects = new Vector.<DesignObject>();
      }
      
      private function updateHandler(e:Event) : void
      {
         this._mapContent.graphics.clear();
         this._mapContent.graphics.beginFill(16777215,0);
         this._mapContent.graphics.drawRect(0,0,80,60);
         this._mapContent.graphics.endFill();
         for(var i:int = 0; i < this._designObjects.length; i++)
         {
            this._designObjects[i].getData().debugDraw(0.06,this._mapContent.graphics);
         }
         this._mapContent.graphics.endFill();
         this._mapContent.graphics.beginFill(16763904,0.15);
         this._mapContent.graphics.lineStyle(1.5,16763904,1);
         this._mapContent.graphics.moveTo(-this._drawCostume.x * 0.06,-this._drawCostume.y * 0.06);
         this._mapContent.graphics.drawRect(-this._drawCostume.x * 0.06,-this._drawCostume.y * 0.06,MENU_WIDTH * 0.06,MENU_HEIGHT * 0.06);
         this._mapContent.graphics.endFill();
      }
      
      private function bgDownHandler(e:MouseEvent) : void
      {
         if(this._beingDrawn)
         {
            return;
         }
         this.clearSelectedObjects();
         CF.removeDisplayObject(this._selectArea);
         this._selectArea = new MovieClip();
         this._drawCostume.addChild(this._selectArea);
         this._movePoint = new Point(this._drawCostume.mouseX,this._drawCostume.mouseY);
         this._firstPos = new Point(this._drawCostume.x,this._drawCostume.y);
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.bgMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.bgUpHandler,false,0,true);
      }
      
      private function bgUpHandler(e:MouseEvent) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         this.clearSelectedObjects();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.bgMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.bgUpHandler);
         if(this._movePoint.x > this._drawCostume.mouseX)
         {
            x = this._drawCostume.mouseX;
            w = this._movePoint.x - this._drawCostume.mouseX;
         }
         else
         {
            x = this._movePoint.x;
            w = this._drawCostume.mouseX - this._movePoint.x;
         }
         if(this._movePoint.y > this._drawCostume.mouseY)
         {
            y = this._drawCostume.mouseY;
            h = this._movePoint.y - this._drawCostume.mouseY;
         }
         else
         {
            y = this._movePoint.y;
            h = this._drawCostume.mouseY - this._movePoint.y;
         }
         this._selectArea.graphics.clear();
         if(w < 10 && h < 10)
         {
            return;
         }
         var r:Rectangle = new Rectangle(x,y,w,h);
         for(var i:int = 0; i < this._designObjects.length; i++)
         {
            if(this._designObjects[i].getHitArea().intersects(r))
            {
               if(this._designObjects[i].doesItIntersect(r))
               {
                  this.addObjectToSelection(this._designObjects[i]);
               }
            }
         }
      }
      
      private function bgMoveHandler(e:MouseEvent) : void
      {
         this._selectArea.graphics.clear();
         this._selectArea.graphics.beginFill(1179409,0.6);
         this._selectArea.graphics.lineStyle(2.5,1179409);
         this._selectArea.graphics.drawRect(this._movePoint.x,this._movePoint.y,this._drawCostume.mouseX - this._movePoint.x,this._drawCostume.mouseY - this._movePoint.y);
         this._selectArea.graphics.endFill();
      }
      
      private function windowDownHandler(e:MouseEvent) : void
      {
         if(this._beingDrawn)
         {
            return;
         }
         this.clearSelectedObjects();
         this.createDesignObject(getQualifiedClassName(e.currentTarget));
      }
      
      private function createDesignObject(className:String) : void
      {
         var design_object:DesignObject = null;
         if(className == DesignList.DAD)
         {
            design_object = new DO_Unit(this._drawCostume,DO_UnitData.DAD);
         }
         else if(className == DesignList.MOM)
         {
            design_object = new DO_Unit(this._drawCostume,DO_UnitData.MOM);
         }
         else if(className == DesignList.KID)
         {
            design_object = new DO_Unit(this._drawCostume,DO_UnitData.KID);
         }
         else if(className == DesignList.BABY)
         {
            design_object = new DO_Unit(this._drawCostume,DO_UnitData.BABY);
         }
         else if(className == DesignList.ELDER)
         {
            design_object = new DO_Unit(this._drawCostume,DO_UnitData.ELDER);
         }
         else if(className == DesignList.WALL)
         {
            design_object = new DO_Wall(this._drawCostume);
         }
         else if(className == DesignList.OBSTACLE)
         {
            design_object = new DO_Obstacle(this._drawCostume);
         }
         else if(className == DesignList.HEART)
         {
            design_object = new DO_Heart(this._drawCostume);
         }
         else if(className == DesignList.FIRE_TRAP)
         {
            design_object = new DO_Trap(this._drawCostume,DO_TrapData.FIRE);
         }
         else if(className == DesignList.SPIKE_TRAP)
         {
            design_object = new DO_Trap(this._drawCostume,DO_TrapData.SPIKE);
         }
         else if(className == DesignList.PORTAL)
         {
            design_object = new DO_Portal(this._drawCostume);
         }
         else if(className == DesignList.UO)
         {
            design_object = new DO_UO(this._drawCostume,DO_UOData.UMO);
         }
         else if(className == DesignList.PLATFORM)
         {
            design_object = new DO_Platform(this._drawCostume);
         }
         else if(className == DesignList.CANNON)
         {
            design_object = new DO_Cannon(this._drawCostume);
         }
         else if(className == DesignList.LEVER)
         {
            design_object = new DO_Lever(this._drawCostume);
         }
         else if(className == DesignList.CLOUD)
         {
            design_object = new DO_Cloud(this._drawCostume);
         }
         else if(className == DesignList.DOOR)
         {
            design_object = new DO_Door(this._drawCostume);
         }
         else if(className == DesignList.KEY)
         {
            design_object = new DO_Key(this._drawCostume);
         }
         else if(className == DesignList.BOUNCER)
         {
            design_object = new DO_Bouncer(this._drawCostume);
         }
         else if(className == DesignList.LAMP)
         {
            design_object = new DO_Lamp(this._drawCostume);
         }
         else if(className == DesignList.BLOWER)
         {
            design_object = new DO_Blower(this._drawCostume);
         }
         else if(className == DesignList.LASER)
         {
            design_object = new DO_Laser(this._drawCostume);
         }
         else if(className == DesignList.LADDER)
         {
            design_object = new DO_Ladder(this._drawCostume);
         }
         else if(className == DesignList.BUTTON)
         {
            design_object = new DO_Button(this._drawCostume);
         }
         else if(className == DesignList.SLIDE_DOOR)
         {
            design_object = new DO_SlideDoor(this._drawCostume);
         }
         else if(className == DesignList.GRAVITY_SWITCHER)
         {
            design_object = new DO_GravitySwitcher(this._drawCostume);
         }
         else if(className == DesignList.WHEEL)
         {
            design_object = new DO_Wheel(this._drawCostume);
         }
         else if(className == DesignList.SEEKER)
         {
            design_object = new DO_Seeker(this._drawCostume);
         }
         else if(className == DesignList.PISTON_DOOR)
         {
            design_object = new DO_PistonDoor(this._drawCostume);
         }
         else if(className == DesignList.PISTON_PLATE)
         {
            design_object = new DO_PistonPlate(this._drawCostume);
         }
         else if(className == DesignList.CHAIN)
         {
            design_object = new DO_Chain(this._drawCostume);
         }
         else if(className == DesignList.TEXT)
         {
            design_object = new DO_Text(this._drawCostume);
         }
         else if(className == DesignList.SIGN)
         {
            design_object = new DO_Sign(this._drawCostume);
         }
         else if(className == DesignList.STONE)
         {
            design_object = new DO_Stone(this._drawCostume);
         }
         else if(className == DesignList.FLOWER)
         {
            design_object = new DO_Flower(this._drawCostume);
         }
         else if(className == DesignList.THING)
         {
            design_object = new DO_Thing(this._drawCostume);
         }
         else if(className == DesignList.OTHERS)
         {
            design_object = new DO_Others(this._drawCostume);
         }
         else if(className == DesignList.ELEVATOR)
         {
            design_object = new DO_Elevator(this._drawCostume);
         }
         else if(className == DesignList.CHECKPOINT)
         {
            design_object = new DO_Checkpoint(this._drawCostume);
         }
         this._lastCreated = className;
         design_object.create();
         TM.ins.tf(function():void
         {
            design_object.startDrawing();
         },0.01);
         this._beingDrawn = design_object;
         this.addDesignObject(design_object);
      }
      
      private function designObjectDownHandler(e:MouseEvent) : void
      {
         var data:DO_Data = null;
         var d_obj:DesignObject = null;
         var i:int = 0;
         var design_object:DesignObject = e.currentTarget as DesignObject;
         var newGroup:Vector.<DesignObject> = new Vector.<DesignObject>();
         if(!KM.ins.isDown(KM.SHIFT) && !KM.ins.isDown(KM.CTRL) && this._selectedObjects.length == 0)
         {
            this.addObjectToSelection(design_object);
         }
         if(KM.ins.isDown(KM.SHIFT))
         {
            if(design_object.isSelected || design_object.isMultipleSelected)
            {
               if(this._selectedObjects.length <= 1)
               {
                  return;
               }
               this.removeObjectFromSelection(design_object);
            }
            else
            {
               this.addObjectToSelection(design_object);
            }
            return;
         }
         if(KM.ins.isDown(KM.CTRL))
         {
            for(i = 0; i < this._selectedObjects.length; i++)
            {
               data = this._selectedObjects[i].getData().clone();
               d_obj = this.createObjectFromData(data);
               d_obj.create();
               d_obj.setData(data);
               this.addDesignObject(d_obj);
               newGroup.push(d_obj);
            }
            this.clearSelectedObjects();
            for(i = 0; i < newGroup.length; i++)
            {
               this.addObjectToSelection(newGroup[i]);
            }
         }
         if(this._selectedObjects.length <= 1 && newGroup.length == 0)
         {
            return;
         }
         this._movePoint = new Point(Main.s.mouseX,Main.s.mouseY);
         for(i = 0; i < this._selectedObjects.length; i++)
         {
            this._selectedObjects[i].startMoving();
         }
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.designObjectUpHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.designObjectMoveHandler,false,0,true);
      }
      
      private function designObjectUpHandler(e:MouseEvent) : void
      {
         for(var i:int = 0; i < this._selectedObjects.length; i++)
         {
            this._selectedObjects[i].endMoving();
         }
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.designObjectUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.designObjectMoveHandler);
      }
      
      private function designObjectMoveHandler(e:MouseEvent) : void
      {
         for(var i:int = 0; i < this._selectedObjects.length; i++)
         {
            this._selectedObjects[i].moveBy(-Main.s.mouseX + this._movePoint.x,-Main.s.mouseY + this._movePoint.y);
         }
      }
      
      private function designObjectRemovedHandler(e:Event) : void
      {
         this._designObjects.splice(this._designObjects.indexOf(e.currentTarget),1);
      }
      
      private function designObjectSelectedHandler(e:Event) : void
      {
         if(this._selectedObjects.length > 1)
         {
            return;
         }
         var design_object:DesignObject = e.currentTarget as DesignObject;
         for(var i:int = 0; i < this._designObjects.length; i++)
         {
            if(design_object != this._designObjects[i])
            {
               this._designObjects[i].unselect();
            }
         }
         this._selectedObjects = new Vector.<DesignObject>();
         this._selectedObjects.push(design_object);
      }
      
      private function removeObjectFromSelection(design_object:DesignObject) : void
      {
         var i:int = this._selectedObjects.indexOf(design_object);
         if(i >= 0)
         {
            this._selectedObjects.splice(i,1);
         }
         if(this._selectedObjects.length == 0)
         {
            design_object.unselect();
         }
         else if(this._selectedObjects.length == 1)
         {
            this._selectedObjects[0].removeFromMultipleSelection();
            this._selectedObjects[0].select();
            design_object.removeFromMultipleSelection();
         }
         else
         {
            design_object.removeFromMultipleSelection();
         }
      }
      
      private function addObjectToSelection(design_object:DesignObject) : void
      {
         if(this._selectedObjects.indexOf(design_object) < 0)
         {
            if(this._selectedObjects.length == 1)
            {
               this._selectedObjects[0].unselect();
               this._selectedObjects[0].addToMultipleSelection();
               design_object.addToMultipleSelection();
               this._selectedObjects.push(design_object);
            }
            else if(this._selectedObjects.length == 0)
            {
               design_object.select();
            }
            else
            {
               design_object.addToMultipleSelection();
               this._selectedObjects.push(design_object);
            }
         }
      }
      
      private function designObjectCompleteHandler(e:Event) : void
      {
         this._beingDrawn = null;
         if(KM.ins.isDown(KM.SHIFT))
         {
            this.clearSelectedObjects();
            this.createDesignObject(this._lastCreated);
         }
      }
      
      private function mouseOverHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._fileButton)
         {
            this._fileCostume.visible = true;
         }
         else if(e.currentTarget == this._windowButton)
         {
            this._windowCostume.visible = true;
         }
      }
      
      private function mouseOutHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._fileButton)
         {
            this._fileCostume.visible = false;
         }
         else if(e.currentTarget == this._windowButton)
         {
            this._windowCostume.visible = false;
         }
      }
      
      private function test() : void
      {
         if(this._beingDrawn)
         {
            this._beingDrawn.remove();
            this._beingDrawn = null;
         }
         this.clearSelectedObjects();
         var ld:LevelData = new LevelData();
         ld.setLevelName("Test");
         ld.setBackground(this._background.type);
         ld.setSize(this._width,this._height);
         ld.setGravity(this._gravityAngle);
         for(var i:int = 0; i < this._designObjects.length; i++)
         {
            ld.addData(this._designObjects[i].getData().clone());
         }
         this.remove();
         GM.ins.testLevel(ld);
         LM.ins.setLastSave(ld);
         LM.ins.cp.setLevelTested();
      }
      
      public function getData() : LevelData
      {
         var ld:LevelData = new LevelData();
         ld.setBackground(this._background.type);
         ld.setSize(this._width,this._height);
         ld.setGravity(this._gravityAngle);
         for(var i:int = 0; i < this._designObjects.length; i++)
         {
            ld.addData(this._designObjects[i].getData().clone());
         }
         return ld;
      }
      
      public function loadData(ld:LevelData) : void
      {
         var d_obj:DesignObject = null;
         var i:int = 0;
         this.clearLevel();
         for(i = 0; i < ld.list.length; i++)
         {
            d_obj = this.createObjectFromData(ld.list[i]);
            d_obj.create();
            d_obj.setData(ld.list[i]);
            this.addDesignObject(d_obj);
         }
         this._gravityAngle = ld.gravity;
         this._background.changeType(ld.background);
         this._bgSelector.selectedItem = ld.background;
         this._width = ld.width;
         this._height = ld.height;
      }
      
      public function createObjectFromData(data:DO_Data) : DesignObject
      {
         var result:DesignObject = null;
         if(data.type == DO_Data.TYPE_UNIT)
         {
            result = new DO_Unit(this._drawCostume,(data as DO_UnitData).unitType);
         }
         else if(data.type == DO_Data.TYPE_POLY)
         {
            if((data as DO_PolyData).polyType == DO_PolyData.WALL)
            {
               result = new DO_Wall(this._drawCostume);
            }
            else if((data as DO_PolyData).polyType == DO_PolyData.OBSTACLE)
            {
               result = new DO_Obstacle(this._drawCostume);
            }
         }
         else if(data.type == DO_Data.TYPE_HEART)
         {
            result = new DO_Heart(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_TRAP)
         {
            result = new DO_Trap(this._drawCostume,(data as DO_TrapData).trapType);
         }
         else if(data.type == DO_Data.TYPE_PORTAL)
         {
            result = new DO_Portal(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_UO)
         {
            result = new DO_UO(this._drawCostume,(data as DO_UOData).uoType);
         }
         else if(data.type == DO_Data.TYPE_PLATFORM)
         {
            result = new DO_Platform(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_CANNON)
         {
            result = new DO_Cannon(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_LEVER)
         {
            result = new DO_Lever(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_CLOUD)
         {
            result = new DO_Cloud(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_KEY)
         {
            result = new DO_Key(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_DOOR)
         {
            result = new DO_Door(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_BOUNCER)
         {
            result = new DO_Bouncer(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_LAMP)
         {
            result = new DO_Lamp(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_BLOWER)
         {
            result = new DO_Blower(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_LASER)
         {
            result = new DO_Laser(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_LADDER)
         {
            result = new DO_Ladder(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_BUTTON)
         {
            result = new DO_Button(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_SLIDE_DOOR)
         {
            result = new DO_SlideDoor(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_GRAVITY_SWITCHER)
         {
            result = new DO_GravitySwitcher(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_WHEEL)
         {
            result = new DO_Wheel(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_SEEKER)
         {
            result = new DO_Seeker(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_PISTON_DOOR)
         {
            result = new DO_PistonDoor(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_PISTON_PLATE)
         {
            result = new DO_PistonPlate(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_CHAIN)
         {
            result = new DO_Chain(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_TEXT)
         {
            result = new DO_Text(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_SIGN)
         {
            result = new DO_Sign(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_STONE)
         {
            result = new DO_Stone(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_FLOWER)
         {
            result = new DO_Flower(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_THING)
         {
            result = new DO_Thing(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_OTHERS)
         {
            result = new DO_Others(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_ELEVATOR)
         {
            result = new DO_Elevator(this._drawCostume);
         }
         else if(data.type == DO_Data.TYPE_CHECKPOINT)
         {
            result = new DO_Checkpoint(this._drawCostume);
         }
         return result;
      }
      
      private function mapDownHandler(e:MouseEvent) : void
      {
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.mapMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.mapUpHandler,false,0,true);
         var xpos:Number = this._mapContent.mouseX;
         var ypos:Number = this._mapContent.mouseY;
         if(xpos > 80)
         {
            xpos = 80;
         }
         if(xpos < 0)
         {
            xpos = 0;
         }
         if(ypos > 60)
         {
            ypos = 60;
         }
         if(ypos < 0)
         {
            ypos = 0;
         }
         this.setPosition(xpos * 16,ypos * 16);
      }
      
      private function mapUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.mapMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.mapUpHandler);
      }
      
      private function mapMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = this._mapContent.mouseX;
         var ypos:Number = this._mapContent.mouseY;
         if(xpos > 80)
         {
            xpos = 80;
         }
         if(xpos < 0)
         {
            xpos = 0;
         }
         if(ypos > 60)
         {
            ypos = 60;
         }
         if(ypos < 0)
         {
            ypos = 0;
         }
         this.setPosition(xpos * 16,ypos * 16);
      }
      
      private function infoOutHandler(e:MouseEvent) : void
      {
         this._infoLabel.text = "";
      }
      
      private function infoOverHandler(e:MouseEvent) : void
      {
         var text:String = null;
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc is MC_DO_Dad)
         {
            text = "Walter (Dad)";
         }
         else if(mc is MC_DO_Mom)
         {
            text = "Sydney (Mom)";
         }
         else if(mc is MC_DO_Elder)
         {
            text = "Mr. Greer (Elder)";
         }
         else if(mc is MC_DO_Kid)
         {
            text = "Billy (Kid)";
         }
         else if(mc is MC_DO_Baby)
         {
            text = "Toby (Baby)";
         }
         else if(mc is MC_DO_FireTrap)
         {
            text = "Fire Trap";
         }
         else if(mc is MC_DO_SpikeTrap)
         {
            text = "Spike Trap";
         }
         else if(mc is MC_DO_UMO)
         {
            text = "Unidentified Bomb Object";
         }
         else if(mc is MC_DO_Cannon)
         {
            text = "Cannon";
         }
         else if(mc is MC_DO_LeverShow)
         {
            text = "Lever";
         }
         else if(mc is MC_DO_Wall)
         {
            text = "Static Wall";
         }
         else if(mc is MC_DO_Obstacle)
         {
            text = "Dynamic Box";
         }
         else if(mc is MC_DO_Cloud)
         {
            text = "One Way Platform";
         }
         else if(mc is MC_DO_Heart)
         {
            text = "<3";
         }
         else if(mc is MC_DO_Platform)
         {
            text = "Moving Platform";
         }
         else if(mc is MC_DO_Portal)
         {
            text = "Portal";
         }
         else if(mc is MC_DO_Key)
         {
            text = "Key";
         }
         else if(mc is MC_DO_Door)
         {
            text = "Door";
         }
         else if(mc is MC_DO_Bouncer)
         {
            text = "Bouncer";
         }
         else if(mc is MC_Blower)
         {
            text = "Blower";
         }
         else if(mc is MC_Laser)
         {
            text = "Laser";
         }
         else if(mc is MC_DO_Ladder)
         {
            text = "Ladder";
         }
         else if(mc is MC_DO_Button)
         {
            text = "Button";
         }
         else if(mc is MC_DO_SHOW_SlideDoor)
         {
            text = "Sliding Door";
         }
         else if(mc is MC_GravitySwitcher)
         {
            text = "Gravity Switcher";
         }
         else if(mc is MC_Wheel)
         {
            text = "Wheel";
         }
         else if(mc is MC_Seeker)
         {
            text = "Seeker";
         }
         else if(mc is MC_PistonDoor)
         {
            text = "Piston Door";
         }
         else if(mc is MC_PistonPlate)
         {
            text = "Piston Plate";
         }
         else if(mc is MC_DO_Chain)
         {
            text = "Chain";
         }
         else if(mc is MC_DO_Elevator)
         {
            text = "Elevator";
         }
         else if(mc is MC_DO_Checkpoint)
         {
            text = "Checkpoint";
         }
         else if(mc is MC_DO_Text)
         {
            text = "Text";
         }
         else if(mc is MC_DO_Sign)
         {
            text = "Sign";
         }
         else if(mc is MC_DO_Stone)
         {
            text = "Stone";
         }
         else if(mc is MC_DO_Flower)
         {
            text = "Flower";
         }
         else if(mc is MC_DO_Thing)
         {
            text = "Stuff";
         }
         else if(mc is MC_DO_Lamp)
         {
            text = "Lamp";
         }
         else if(mc is MC_DO_Others)
         {
            text = "Others";
         }
         else
         {
            text = "";
         }
         this._infoLabel.text = text;
      }
      
      private function bgSelectHandler(e:Event) : void
      {
         this._background.changeType((e.currentTarget as ComboBox).selectedItem as String);
      }
      
      private function menuButtonClickHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._testButton)
         {
            this.test();
         }
         else if(e.currentTarget == this._shareButton)
         {
            this._sharePanel.create();
         }
      }
      
      private function fileButtonClickHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._newButton)
         {
            this.clearLevel();
         }
         else if(e.currentTarget == this._propertiesButton)
         {
            this._propertiesPanel.create();
         }
         else if(e.currentTarget == this._saveLoadButton)
         {
            this._saveLoadPanel.create();
         }
         else if(e.currentTarget == this._exitButton)
         {
            this.remove();
            MainMenu.ins.create();
         }
      }
      
      private function windowClickHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._unitsButton)
         {
            this.openWindow("units");
         }
         else if(e.currentTarget == this._objectsButton)
         {
            this.openWindow("objects");
         }
         else if(e.currentTarget == this._visualsButton)
         {
            this.openWindow("visuals");
         }
         else if(e.currentTarget == this._enemiesButton)
         {
            this.openWindow("enemies");
         }
         else if(e.currentTarget == this._mapButton)
         {
            this.openWindow("map");
         }
      }
      
      private function windowResizeHandler(e:Event) : void
      {
         if(e.currentTarget == this._unitsWindow)
         {
            if(!this._unitsWindow.minimized)
            {
               this._objectsWindow.minimized = true;
               this._visualsWindow.minimized = true;
               this._enemiesWindow.minimized = true;
            }
         }
         else if(e.currentTarget == this._objectsWindow)
         {
            if(!this._objectsWindow.minimized)
            {
               this._unitsWindow.minimized = true;
               this._visualsWindow.minimized = true;
               this._enemiesWindow.minimized = true;
            }
         }
         else if(e.currentTarget == this._visualsWindow)
         {
            if(!this._visualsWindow.minimized)
            {
               this._unitsWindow.minimized = true;
               this._objectsWindow.minimized = true;
               this._enemiesWindow.minimized = true;
            }
         }
         else if(e.currentTarget == this._enemiesWindow)
         {
            if(!this._enemiesWindow.minimized)
            {
               this._unitsWindow.minimized = true;
               this._objectsWindow.minimized = true;
               this._visualsWindow.minimized = true;
            }
         }
         this._objectsWindow.y = this._unitsWindow.y + this._unitsWindow.height;
         this._enemiesWindow.y = this._objectsWindow.y + this._objectsWindow.height;
         this._visualsWindow.y = this._enemiesWindow.y + this._enemiesWindow.height;
         this._infoPanel.y = this._visualsWindow.y + this._visualsWindow.height + 2;
      }
      
      private function openWindow(windowName:String) : void
      {
         if(windowName == "units")
         {
            this._unitsWindow.minimized = false;
         }
         else if(windowName == "objects")
         {
            this._objectsWindow.minimized = false;
         }
         else if(windowName == "visuals")
         {
            this._visualsWindow.minimized = false;
         }
         else if(windowName == "enemies")
         {
            this._enemiesWindow.minimized = false;
         }
         else if(windowName == "map")
         {
            this._mapWindow.visible = !this._mapWindow.visible;
         }
      }
      
      private function clearLevel() : void
      {
         var i:int = 0;
         this.clearSelectedObjects();
         for(i = this._designObjects.length - 1; i >= 0; i--)
         {
            this._designObjects[i].remove();
         }
         this._designObjects = new Vector.<DesignObject>();
      }
      
      public function get gravityAngle() : Number
      {
         return this._gravityAngle;
      }
      
      public function set gravityAngle(value:Number) : void
      {
         this._gravityAngle = value;
      }
   }
}
