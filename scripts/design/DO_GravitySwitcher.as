package design
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.HUISlider;
   import design.data.DO_Data;
   import design.data.DO_GravitySwitcherData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_GravitySwitcher extends DesignObject
   {
       
      
      protected var _data:DO_GravitySwitcherData;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:Sprite;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _rotationSlider:HUISlider;
      
      protected var _isSensorBox:CheckBox;
      
      protected var _hasFootBox:CheckBox;
      
      public function DO_GravitySwitcher(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.GRAVITY_SWITCHER);
         this._data = new DO_GravitySwitcherData();
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
         this._rotationSlider = new HUISlider(_propCostume,0,420,"Rotation");
         this._rotationSlider.setSize(150,20);
         this._rotationSlider.addEventListener(Event.CHANGE,this.rotationChangeHandler,false,0,true);
         this._rotationSlider.addEventListener(MouseEvent.MOUSE_UP,this.rotationUpHandler,false,0,true);
         this._rotationSlider.minimum = 0;
         this._rotationSlider.maximum = 360;
         this._rotationSlider.value = this._data.rotation * 180 / Math.PI;
         this._scaleSlider = new HUISlider(_propCostume,0,440,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = 150;
         this._scaleSlider.maximum = 50;
         this._scaleSlider.value = this._data.scale * 100;
         this._isSensorBox = new CheckBox(_propCostume,5,460,"Sensor");
         this._isSensorBox.setSize(70,20);
         this._isSensorBox.addEventListener(MouseEvent.CLICK,this.boolChangeHandler,false,0,true);
         this._hasFootBox = new CheckBox(_propCostume,80,460,"Legs?");
         this._hasFootBox.setSize(70,20);
         this._hasFootBox.addEventListener(MouseEvent.CLICK,this.boolChangeHandler,false,0,true);
         if(this._data.isSensor)
         {
            this._isSensorBox.selected = true;
         }
         else
         {
            this._isSensorBox.selected = false;
         }
         if(this._data.hasFoot)
         {
            this._hasFootBox.selected = true;
         }
         else
         {
            this._hasFootBox.selected = false;
         }
      }
      
      private function boolChangeHandler(e:MouseEvent) : void
      {
         this._data.hasFoot = this._hasFootBox.selected;
         this._data.isSensor = this._isSensorBox.selected;
         this.drawUpdate();
      }
      
      private function rotationUpHandler(e:MouseEvent) : void
      {
         var rot:Number = Math.round(this._rotationSlider.value / 90) * 90;
         this._rotationSlider.value = rot;
      }
      
      private function rotationChangeHandler(e:Event) : void
      {
         var rot:Number = Math.round(this._rotationSlider.value / 90) * 90;
         this._data.rotation = rot * Math.PI / 180;
         this.drawUpdate();
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var scale:Number = int(this._scaleSlider.value / 10) * 10;
         this._data.scale = scale / 100;
         this.drawUpdate();
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._hasFootBox);
         CF.removeDisplayObject(this._isSensorBox);
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(_propCostume);
         this._scaleSlider = null;
         _propCostume = null;
         this._hasFootBox = null;
         this._isSensorBox = null;
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
         this._drawBody.x = this._data.x;
         this._drawBody.y = this._data.y;
         var w:Number = this._data.scale * this._data.WIDTH;
         var h:Number = this._data.scale * this._data.HEIGHT;
         this._drawBody.graphics.lineStyle(2,65280);
         this._drawBody.graphics.beginFill(13369344,0.5);
         this._drawBody.graphics.drawRect(-w / 2,-h / 2,w,h);
         this._drawBody.graphics.endFill();
         if(this._data.hasFoot)
         {
            this._drawBody.graphics.lineStyle(2,65280);
            this._drawBody.graphics.beginFill(13369344,0.5);
            this._drawBody.graphics.drawRect(-w / 8,h / 2,w / 4,h / 2.5);
         }
         this._drawBody.rotation = this._data.rotation * 180 / Math.PI;
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
         _realCostume = new MC_GravitySwitcher();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         _realCostume.rotation = this._data.rotation * 180 / Math.PI;
         if(!this._data.hasFoot)
         {
            (_realCostume as MC_GravitySwitcher).mc_bottom.visible = false;
         }
         if(this._data.isSensor)
         {
            _realCostume.gotoAndStop("s_closed");
         }
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
         this._data = newData as DO_GravitySwitcherData;
         this.drawRealCostume();
      }
   }
}
