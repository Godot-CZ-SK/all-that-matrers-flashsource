package menus
{
   import com.bit101.components.InputText;
   import com.bit101.components.List;
   import com.bit101.components.Panel;
   import com.bit101.components.PushButton;
   import com.bit101.components.TextArea;
   import com.bit101.components.Window;
   import design.data.LevelData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.System;
   import game.Background;
   import managers.KM;
   import managers.LM;
   
   public class DM_SaveLoadPanel
   {
       
      
      protected var _costume:MovieClip;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _isCreated:Boolean;
      
      protected var _window:Window;
      
      protected var _newSaveInput:InputText;
      
      protected var _newSaveButton:PushButton;
      
      protected var _overWriteButton:PushButton;
      
      protected var _getCodeButton:PushButton;
      
      protected var _loadPanel:Panel;
      
      protected var _loadButton:PushButton;
      
      protected var _deleteButton:PushButton;
      
      protected var _levelNameInput:InputText;
      
      protected var _changeNameButton:PushButton;
      
      protected var _moveUpButton:PushButton;
      
      protected var _moveDownButton:PushButton;
      
      protected var _levelList:List;
      
      protected var _minimap:MovieClip;
      
      protected var _infoArea:TextArea;
      
      protected const ww:Number = 280;
      
      protected const wh:Number = 320;
      
      public function DM_SaveLoadPanel(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
      }
      
      public static function convertLevelToMinimap(ld:LevelData) : MovieClip
      {
         var bg:MovieClip = null;
         var mc:MovieClip = new MovieClip();
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
         mc.addChild(bg);
         var objects:MovieClip = new MovieClip();
         mc.addChild(objects);
         for(var i:int = 0; i < ld.list.length; i++)
         {
            ld.list[i].debugDraw(0.08,objects.graphics);
         }
         return mc;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MovieClip();
         this._costume.graphics.beginFill(0,0.8);
         this._costume.graphics.drawRect(0,0,640,480);
         this._costume.graphics.endFill();
         this._parent.addChild(this._costume);
         this._window = new Window(this._costume,(640 - this.ww) / 2,(480 - this.wh) / 2,"Save & Load");
         this._window.setSize(this.ww,this.wh);
         this._window.draggable = false;
         this._window.hasCloseButton = true;
         this._window.hasMinimizeButton = false;
         this._window.addEventListener(Event.CLOSE,this.closeHandler,false,0,true);
         this._newSaveInput = new InputText(this._window.content,5,10,"New Level");
         this._newSaveInput.setSize(125,20);
         this._newSaveInput.restrict = "A-Z a-z 0-9 _-\',.+&/";
         this._newSaveButton = new PushButton(this._window.content,5,35,"Create");
         this._newSaveButton.addEventListener(MouseEvent.CLICK,this.newSaveHandler,false,0,true);
         this._newSaveButton.setSize(60,20);
         this._overWriteButton = new PushButton(this._window.content,70,35,"Overwrite");
         this._overWriteButton.setSize(60,20);
         this._overWriteButton.addEventListener(MouseEvent.CLICK,this.overwriteHandler,false,0,true);
         this._getCodeButton = new PushButton(this._window.content,5,60,"Get Code");
         this._getCodeButton.setSize(125,20);
         this._getCodeButton.addEventListener(MouseEvent.CLICK,this.getCodeHandler,false,0,true);
         this._loadPanel = new Panel(this._window.content,5,90);
         this._loadPanel.setSize(135,75);
         this._levelNameInput = new InputText(this._loadPanel.content,5,5,"");
         this._levelNameInput.setSize(95,20);
         this._levelNameInput.restrict = "A-Z a-z 0-9 _-\',.+&/";
         this._changeNameButton = new PushButton(this._loadPanel.content,105,5,">");
         this._changeNameButton.setSize(20,20);
         this._changeNameButton.addEventListener(MouseEvent.CLICK,this.changeNameHandler,false,0,true);
         this._moveUpButton = new PushButton(this._loadPanel.content,70,30,"UP");
         this._moveUpButton.setSize(60,20);
         this._moveUpButton.addEventListener(MouseEvent.CLICK,this.moveUpHandler,false,0,true);
         this._moveDownButton = new PushButton(this._loadPanel.content,70,52,"DOWN");
         this._moveDownButton.setSize(60,20);
         this._moveDownButton.addEventListener(MouseEvent.CLICK,this.moveDownHandler,false,0,true);
         this._loadButton = new PushButton(this._loadPanel.content,5,30,"Load");
         this._loadButton.setSize(60,20);
         this._loadButton.addEventListener(MouseEvent.CLICK,this.loadHandler,false,0,true);
         this._deleteButton = new PushButton(this._loadPanel.content,5,52,"Delete");
         this._deleteButton.setSize(60,20);
         this._deleteButton.addEventListener(MouseEvent.CLICK,this.deleteHandler,false,0,true);
         this._loadPanel.visible = false;
         this._overWriteButton.visible = false;
         this._infoArea = new TextArea(this._window.content,5,200,"Roll your mouse over a button to get more information.");
         this._infoArea.editable = false;
         this._infoArea.setSize(135,80);
         this._infoArea.autoHideScrollBar = true;
         this._infoArea.selectable = false;
         var buttons:Array = [this._newSaveButton,this._overWriteButton,this._getCodeButton,this._changeNameButton,this._deleteButton,this._loadButton,this._moveDownButton,this._moveUpButton];
         for(var i:int = 0; i < buttons.length; i++)
         {
            buttons[i].addEventListener(MouseEvent.ROLL_OVER,this.infoOverHandler,false,0,true);
            buttons[i].addEventListener(MouseEvent.ROLL_OUT,this.infoOutHandler,false,0,true);
         }
         this.updateList();
         this.updateSelection();
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.ESCAPE)
         {
            this.remove();
         }
      }
      
      private function changeNameHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0)
         {
            return;
         }
         LM.ins.changeNameOfLevelById(id,this._levelNameInput.text);
         this.updateList();
         this.selectLevelById(id);
         this.updateSelection();
      }
      
      private function infoOverHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._newSaveButton)
         {
            this._infoArea.text = "Creates a new save file in your local disc.";
         }
         else if(e.currentTarget == this._overWriteButton)
         {
            this._infoArea.text = "Overwrites to the selected level from the list on the right.";
         }
         else if(e.currentTarget == this._getCodeButton)
         {
            this._infoArea.text = "Copies the level code to your clipboard. Press ctrl-v to paste it to your friends.";
         }
         else if(e.currentTarget == this._changeNameButton)
         {
            this._infoArea.text = "Applies the change of selected level\'s name.";
         }
         else if(e.currentTarget == this._loadButton)
         {
            this._infoArea.text = "Loads the selected level. All unsaved data will be lost.";
         }
         else if(e.currentTarget == this._moveDownButton)
         {
            this._infoArea.text = "Moves the selected level down in the list.";
         }
         else if(e.currentTarget == this._moveUpButton)
         {
            this._infoArea.text = "Moves the selected level up in the list.";
         }
         else if(e.currentTarget == this._deleteButton)
         {
            this._infoArea.text = "Deletes the selected level from the list.";
         }
      }
      
      private function moveUpHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 1)
         {
            return;
         }
         LM.ins.moveLevelUpById(id);
         this.updateList();
         this.selectLevelById(id - 1);
         this.updateSelection();
      }
      
      private function moveDownHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0 || id > LM.ins.list.length - 2)
         {
            return;
         }
         LM.ins.moveLevelDownById(id);
         this.updateList();
         this.selectLevelById(id + 1);
         this.updateSelection();
      }
      
      private function infoOutHandler(e:MouseEvent) : void
      {
         this._infoArea.text = "Roll your mouse over a button to get more information.";
      }
      
      protected function getCodeHandler(e:MouseEvent) : void
      {
         var init:String = "var levels:Array = [];";
         var levels:String = "";
         var push:String = "levels.push(";
         var result:String = "";
         for(var i:int = 0; i < LM.ins.list.length; i++)
         {
            levels += "var lev" + (i + 1).toString() + "str:String = \'" + LM.ins.list[i].convertToString() + "\';\n";
            if(i > 0)
            {
               push += ", ";
            }
            push += "lev" + (i + 1).toString() + "str";
         }
         push += ");";
         result = init + "\n\n" + levels + "\n" + push + "\n";
         System.setClipboard(result);
         trace(result);
      }
      
      protected function newSaveHandler(e:MouseEvent) : void
      {
         var ld:LevelData = DesignMenu.ins.getData();
         ld.setLevelName(this._newSaveInput.text);
         LM.ins.addLevel(ld);
         trace(ld.convertToString());
         this.updateList();
         this.updateSelection();
      }
      
      protected function updateList() : void
      {
         CF.removeDisplayObject(this._levelList);
         var arr:Array = [];
         for(var i:int = 0; i < LM.ins.list.length; i++)
         {
            arr.push(LM.ins.list[i].levelName);
         }
         this._levelList = new List(this._window.content,this.ww - 125,100,arr);
         this._levelList.setSize(120,this.wh - 130);
         this._levelList.addEventListener(MouseEvent.CLICK,this.listClickHandler,false,0,true);
         this._levelList.autoHideScrollBar = true;
      }
      
      protected function updateSelection() : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0 || id == 0 && LM.ins.list.length <= 0 || id >= LM.ins.list.length)
         {
            this.clearSelection();
            return;
         }
         this._overWriteButton.visible = true;
         this._loadPanel.visible = true;
         this._levelNameInput.text = LM.ins.list[id].levelName;
         CF.removeDisplayObject(this._minimap);
         this._minimap = convertLevelToMinimap(LM.ins.list[id]);
         this._minimap.x = this.ww - 125;
         this._minimap.y = 5;
         this._window.content.addChild(this._minimap);
      }
      
      protected function clearSelection() : void
      {
         CF.removeDisplayObject(this._minimap);
         this._minimap = new MC_BG_EmptyMinimap();
         this._minimap.x = this.ww - 125;
         this._minimap.y = 5;
         this._window.content.addChild(this._minimap);
         this._loadPanel.visible = false;
         this._overWriteButton.visible = false;
      }
      
      private function selectLevelById(id:int) : void
      {
         this._levelList.selectedIndex = id;
      }
      
      private function listClickHandler(e:MouseEvent) : void
      {
         this.updateSelection();
      }
      
      protected function loadHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0)
         {
            return;
         }
         var ld:LevelData = LM.ins.list[id];
         DesignMenu.ins.loadData(ld.clone());
         this.remove();
      }
      
      protected function deleteHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0)
         {
            return;
         }
         LM.ins.removeLevelById(id);
         this.updateList();
         this.updateSelection();
      }
      
      protected function overwriteHandler(e:MouseEvent) : void
      {
         var id:int = this._levelList.selectedIndex;
         if(id < 0)
         {
            return;
         }
         var ld:LevelData = DesignMenu.ins.getData();
         ld.setLevelName(LM.ins.list[id].levelName);
         LM.ins.overwrite(id,ld);
         this.updateList();
         this.selectLevelById(id);
         this.updateSelection();
      }
      
      protected function closeHandler(e:Event) : void
      {
         this.remove();
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         CF.removeDisplayObject(this._loadButton);
         CF.removeDisplayObject(this._costume);
         LM.ins.saveLevels();
      }
      
      public function get isCreated() : Boolean
      {
         return this._isCreated;
      }
   }
}
