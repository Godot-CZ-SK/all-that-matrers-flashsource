package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_Data;
   import design.data.DO_WheelData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Wheel extends DesignObject
   {
       
      
      protected var _data:DO_WheelData;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:Sprite;
      
      protected var _scaleSlider:HUISlider;
      
      public function DO_Wheel(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.WHEEL);
         this._data = new DO_WheelData();
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.drawClickHandler);
         super.remove();
      }
      
      override public function startDrawing() : void
      {
         if(_isDrawing)
         {
            return;
         }
         super.startDrawing();
         this.drawFakeCostume();
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.CLICK,this.drawClickHandler,false,0,true);
      }
      
      override public function completeDrawing() : void
      {
         if(!_isDrawing)
         {
            return;
         }
         super.completeDrawing();
         this.drawRealCostume();
         this.removeFakeCostume();
         this.removeProperties();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.drawClickHandler);
      }
      
      override public function select() : void
      {
         if(_isSelected)
         {
            return;
         }
         super.select();
      }
      
      override public function unselect() : void
      {
         if(!_isSelected)
         {
            return;
         }
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
         super.unselect();
      }
      
      override public function addToMultipleSelection() : void
      {
         if(_isMultipleSelected)
         {
            return;
         }
         super.addToMultipleSelection();
      }
      
      override public function removeFromMultipleSelection() : void
      {
         if(!_isMultipleSelected)
         {
            return;
         }
         super.removeFromMultipleSelection();
      }
      
      override public function drawProperties() : void
      {
         _propCostume = new MovieClip();
         _propCostume.graphics.clear();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,420,160,60);
         _propCostume.graphics.endFill();
         DM.ins.menu.addChild(_propCostume);
         this._scaleSlider = new HUISlider(_propCostume,0,460,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = 50;
         this._scaleSlider.maximum = 200;
         this._scaleSlider.value = this._data.scale * 100;
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var scale:Number = Math.round(this._scaleSlider.value / 5) * 5;
         this._data.scale = scale / 100;
         this.drawUpdate();
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(_propCostume);
         this._scaleSlider = null;
         _propCostume = null;
         super.removeProperties();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new Sprite();
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         _fakeCostume.addChild(this._drawBody);
         this.drawUpdate();
         super.drawFakeCostume();
      }
      
      override public function removeFakeCostume() : void
      {
         CF.removeDisplayObject(_fakeCostume);
         super.removeFakeCostume();
      }
      
      private function fakeBodyDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated || _isMultipleSelected || _isDrawing || !_isSelected)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler,false,0,true);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / INTERVAL) * INTERVAL,Math.round(Main.s.mouseY / INTERVAL) * INTERVAL);
         this._movePosition = new Point(_fakeCostume.mouseX - this._data.x,_fakeCostume.mouseY - this._data.y);
         this._lastPosition = new Point(this._data.x,this._data.y);
      }
      
      override protected function drawUpdate() : void
      {
         this._drawBody.graphics.clear();
         this._drawBody.graphics.lineStyle(2,65280);
         this._drawBody.graphics.beginFill(13369344,0.5);
         this._drawBody.graphics.drawCircle(this._data.x,this._data.y,this._data.RADIUS * this._data.scale);
      }
      
      private function fakeBodyUpHandler(e:MouseEvent) : void
      {
         this.drawUpdate();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
      }
      
      private function fakeBodyMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round((_parent.mouseX - this._movePosition.x) / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round((_parent.mouseY - this._movePosition.y) / INTERVAL) * INTERVAL);
         this._data.x = xpos;
         this._data.y = ypos;
         this.drawUpdate();
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_Wheel();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         super.drawRealCostume();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(_realCostume);
         super.removeRealCostume();
      }
      
      private function drawClickHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
         this._data.x = xpos;
         this._data.y = ypos;
         this.completeDrawing();
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
         this._data.x = xpos;
         this._data.y = ypos;
         this.drawUpdate();
      }
      
      override public function startMoving() : void
      {
         if(_isMoving)
         {
            return;
         }
         this._movingPoint = new Point(this._data.x,this._data.y);
         super.startMoving();
      }
      
      override public function moveBy(xpos:Number, ypos:Number) : void
      {
         if(!_isMoving)
         {
            return;
         }
         this._data.x = properX(this._movingPoint.x - Math.round(xpos / G_INTERVAL) * G_INTERVAL);
         this._data.y = properY(this._movingPoint.y - Math.round(ypos / G_INTERVAL) * G_INTERVAL);
         this.drawUpdate();
         super.moveBy(xpos,ypos);
      }
      
      override public function endMoving() : void
      {
         if(!_isMoving)
         {
            return;
         }
         this.drawUpdate();
         super.endMoving();
      }
      
      override public function getData() : DO_Data
      {
         return this._data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         this._data = newData as DO_WheelData;
         this.drawRealCostume();
      }
   }
}
