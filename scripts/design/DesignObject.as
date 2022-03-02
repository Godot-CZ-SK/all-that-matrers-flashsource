package design
{
   import design.data.DO_Data;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import game.GameCamera;
   import managers.KM;
   
   public class DesignObject extends EventDispatcher
   {
      
      protected static const G_INTERVAL:Number = 5;
      
      protected static const INTERVAL:Number = 1;
       
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _costume:MovieClip;
      
      protected var _propCostume:MovieClip;
      
      protected var _fakeCostume:MovieClip;
      
      protected var _realCostume:MovieClip;
      
      protected var _layerNo:int;
      
      protected var _isCreated:Boolean;
      
      protected var _isDrawing:Boolean;
      
      protected var _isSelected:Boolean;
      
      protected var _isMoving:Boolean;
      
      protected var _isMultipleSelected:Boolean;
      
      protected const AREA:Rectangle = new Rectangle(40,40,1200,880);
      
      public function DesignObject(parent:DisplayObjectContainer, layerNo:int)
      {
         super();
         this._parent = parent;
         this._layerNo = layerNo;
         this._isCreated = false;
         this._isDrawing = false;
      }
      
      public function create() : void
      {
         this._isCreated = true;
         this._costume = new MovieClip();
         GameCamera.ins.addChildTo(this._costume,this._layerNo);
         this.addEvents();
      }
      
      public function remove() : void
      {
         this._isCreated = false;
         this.removeEvents();
         this.removeProperties();
         this.removeFakeCostume();
         this.removeRealCostume();
         CF.removeDisplayObject(this._costume);
         this.clearData();
         dispatchEvent(new Event(Event.REMOVED));
      }
      
      public function startDrawing() : void
      {
         this._isDrawing = true;
      }
      
      public function completeDrawing() : void
      {
         this._isDrawing = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function clearData() : void
      {
         this._costume = null;
         this._fakeCostume = null;
         this._realCostume = null;
      }
      
      public function select() : void
      {
         this._isSelected = true;
         this.removeRealCostume();
         this.removeFakeCostume();
         this.removeProperties();
         this.drawFakeCostume();
         this.drawProperties();
         dispatchEvent(new Event("selected"));
         trace(this + " is selected.");
      }
      
      public function unselect() : void
      {
         this._isSelected = false;
         this.removeProperties();
         this.removeFakeCostume();
         this.removeRealCostume();
         this.drawRealCostume();
      }
      
      public function addToMultipleSelection() : void
      {
         this._isMultipleSelected = true;
         this.removeRealCostume();
         this.removeFakeCostume();
         this.removeProperties();
         this.drawFakeCostume();
      }
      
      public function removeFromMultipleSelection() : void
      {
         this._isMultipleSelected = false;
         this.removeFakeCostume();
         this.removeProperties();
         this.removeRealCostume();
         this.drawRealCostume();
      }
      
      protected function multipleDownHandler(e:MouseEvent) : void
      {
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      }
      
      public function addEvents() : void
      {
         Main.s.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,0,true);
         this._costume.addEventListener(MouseEvent.CLICK,this.costumeClickHandler,false,0,true);
         this._costume.addEventListener(MouseEvent.MOUSE_DOWN,this.costumeDownHandler,false,0,true);
      }
      
      public function removeEvents() : void
      {
         Main.s.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         this._costume.removeEventListener(MouseEvent.CLICK,this.costumeClickHandler);
         this._costume.removeEventListener(MouseEvent.MOUSE_DOWN,this.costumeDownHandler);
      }
      
      protected function costumeClickHandler(e:MouseEvent) : void
      {
         if(this._isDrawing || this._isMultipleSelected)
         {
            return;
         }
         this.select();
      }
      
      protected function costumeDownHandler(e:MouseEvent) : void
      {
         if(this._isCreated && !this._isDrawing)
         {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      protected function keyDownHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.DELETE)
         {
            if(this._isSelected)
            {
               this.remove();
            }
         }
      }
      
      public function drawRealCostume() : void
      {
      }
      
      public function removeRealCostume() : void
      {
      }
      
      public function drawFakeCostume() : void
      {
      }
      
      public function removeFakeCostume() : void
      {
      }
      
      public function drawProperties() : void
      {
      }
      
      public function removeProperties() : void
      {
      }
      
      protected function drawUpdate() : void
      {
      }
      
      public function addPosition(posX:Number, posY:Number) : void
      {
         if(this._isDrawing || !this._isCreated)
         {
            return;
         }
      }
      
      public function doesItIntersect(r:Rectangle) : Boolean
      {
         return true;
      }
      
      public function getHitArea() : Rectangle
      {
         if(!this._isCreated)
         {
            return null;
         }
         return this._costume.getBounds(this._parent);
      }
      
      public function setData(data:DO_Data) : void
      {
         this._isCreated = true;
      }
      
      public function getData() : DO_Data
      {
         return null;
      }
      
      public function properX(x:Number) : Number
      {
         if(x < this.AREA.left)
         {
            return this.AREA.left;
         }
         if(x > this.AREA.right)
         {
            return this.AREA.right;
         }
         return x;
      }
      
      public function properY(y:Number) : Number
      {
         if(y < this.AREA.top)
         {
            return this.AREA.top;
         }
         if(y > this.AREA.bottom)
         {
            return this.AREA.bottom;
         }
         return y;
      }
      
      public function startMoving() : void
      {
         this._isMoving = true;
      }
      
      public function endMoving() : void
      {
         this._isMoving = false;
      }
      
      public function moveBy(xpos:Number, ypos:Number) : void
      {
      }
      
      public function clone() : DesignObject
      {
         return null;
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function get isMultipleSelected() : Boolean
      {
         return this._isMultipleSelected;
      }
   }
}
