package menus
{
   import Playtomic.PlayerLevel;
   import Playtomic.PlayerLevels;
   import com.bit101.components.InputText;
   import com.bit101.components.Label;
   import com.bit101.components.PushButton;
   import com.bit101.components.TextArea;
   import com.bit101.components.Window;
   import design.data.LevelData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameSound;
   import game.LevelWarning;
   import managers.KM;
   import managers.LM;
   import managers.SM;
   
   public class DM_SharePanel
   {
       
      
      protected var _costume:MovieClip;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _isCreated:Boolean;
      
      protected var _window:Window;
      
      protected var _mapNameLabel:Label;
      
      protected var _creatorNameLabel:Label;
      
      protected var _mapNameInput:InputText;
      
      protected var _creatorNameInput:InputText;
      
      protected var _shareButton:PushButton;
      
      protected var _outputArea:TextArea;
      
      protected const ww:Number = 320;
      
      protected const wh:Number = 320;
      
      public function DM_SharePanel(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
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
         this._window = new Window(this._costume,(640 - this.ww) / 2,(480 - this.wh) / 2,"Share");
         this._window.setSize(this.ww,this.wh);
         this._window.draggable = false;
         this._window.hasCloseButton = true;
         this._window.hasMinimizeButton = false;
         this._window.addEventListener(Event.CLOSE,this.closeHandler,false,0,true);
         this._mapNameInput = new InputText(this._window.content,20,20,"");
         this._mapNameInput.setSize(80,20);
         this._shareButton = new PushButton(this._window.content,120,20,"PUBLISH");
         this._shareButton.setSize(120,20);
         this._shareButton.addEventListener(MouseEvent.CLICK,this.shareClickHandler);
         this._outputArea = new TextArea(this._window.content,10,50,"");
         this._outputArea.setSize(this.ww - 20,this.wh - 120);
         this._outputArea.editable = false;
         this._outputArea.autoHideScrollBar = true;
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.ESCAPE)
         {
            this.remove();
         }
      }
      
      private function shareCompleted(params:Object) : void
      {
         this.remove();
         if(params.success)
         {
            trace("Save completed.");
         }
         else
         {
            trace("Save failed.");
         }
      }
      
      private function shareClickHandler(e:MouseEvent) : void
      {
         var minimap:MovieClip = null;
         var levelData:String = null;
         var pl:PlayerLevel = null;
         var ld:LevelData = DesignMenu.ins.getData();
         ld.setLevelName(this._mapNameInput.text);
         var errors:Vector.<LevelWarning> = new Vector.<LevelWarning>();
         errors = ld.isValid();
         var i:int = 0;
         var textToDisplay:String = "No errors. Your level is published.";
         if(errors.length > 0)
         {
            SM.ins.playSound(GameSound.SHARE_ALERT);
            textToDisplay = "There are some errors you need to fix before publishing your level.\n\n";
            for(i = 0; i < errors.length; i++)
            {
               textToDisplay += "* " + errors[i].message + "\n";
            }
            LM.ins.cp.setErrorGot();
         }
         else
         {
            minimap = DM_SaveLoadPanel.convertLevelToMinimap(ld);
            levelData = ld.convertToString();
            Main.k.sharedContent.save("UserLevel",levelData,this.shareCompleted,minimap,ld.levelName);
            pl = new PlayerLevel();
            pl.Name = this._mapNameInput.text;
            pl.Data = levelData;
            PlayerLevels.Save(pl,minimap,this.saveCompleteHandler);
         }
         this._outputArea.text = textToDisplay;
      }
      
      private function saveCompleteHandler(level:PlayerLevel, response:Object) : void
      {
         if(response.Success)
         {
            trace("Shared successfuly");
            trace(level.Data);
         }
         else
         {
            trace("Error saving player level: " + response.ErrorCode);
         }
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._costume);
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      protected function closeHandler(e:Event) : void
      {
         this.remove();
      }
      
      public function get isCreated() : Boolean
      {
         return this._isCreated;
      }
   }
}
