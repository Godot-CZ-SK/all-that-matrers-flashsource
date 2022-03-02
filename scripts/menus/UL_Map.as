package menus
{
   import design.data.LevelData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class UL_Map extends EventDispatcher
   {
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_UL_Map;
      
      protected var _data:LevelData;
      
      protected var _id:String;
      
      protected var _xpos:Number;
      
      protected var _ypos:Number;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _name:String;
      
      protected var _rating:int;
      
      protected var _map:MovieClip;
      
      public function UL_Map(parent:DisplayObjectContainer, id:String, name:String, rating:int, xpos:Number, ypos:Number)
      {
         super();
         this._id = id;
         this._xpos = xpos;
         this._ypos = ypos;
         this._parent = parent;
         this._name = name;
         this._rating = rating;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_UL_Map();
         this._costume.x = this._xpos;
         this._costume.y = this._ypos;
         this._parent.addChild(this._costume);
         this._costume.txt_name.text = this._name;
         this._costume.mc_stars.gotoAndStop(this._rating + 1);
      }
      
      public function setData(levelData:String) : void
      {
         this._data = new LevelData();
         this._data.loadLevelFromString(levelData);
         this._data.setLevelName(this._name);
         this.addEvents();
         this._map = DM_SaveLoadPanel.convertLevelToMinimap(this._data);
         this._costume.mc_container.addChild(this._map);
         this._costume.mc_load.visible = false;
         this._costume.buttonMode = true;
         this._costume.mouseChildren = false;
      }
      
      public function addEvents() : void
      {
         this._costume.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function removeEvents() : void
      {
         this._costume.removeEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._costume);
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get data() : LevelData
      {
         return this._data;
      }
   }
}
