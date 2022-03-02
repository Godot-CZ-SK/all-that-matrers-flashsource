package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_Data;
   import design.data.DO_LaserData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Laser extends DesignObject
   {
       
      
      protected var _data:DO_LaserData;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:MC_DO_LaserFake;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _bodyRotSlider:HUISlider;
      
      protected var _headRotSlider:HUISlider;
      
      public function DO_Laser(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.LASER);
         this._data = new DO_LaserData();
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
         this._headRotSlider = new HUISlider(_propCostume,0,420,"Head Rot.");
         this._headRotSlider.setSize(150,20);
         this._headRotSlider.addEventListener(Event.CHANGE,this.headRotHandler,false,0,true);
         this._headRotSlider.addEventListener(MouseEvent.MOUSE_UP,this.headUpHandler,false,0,true);
         this._headRotSlider.minimum = this._data.min_head_rot * 180 / Math.PI;
         this._headRotSlider.maximum = this._data.max_head_rot * 180 / Math.PI;
         this._headRotSlider.value = this._data.head_rot * 180 / Math.PI;
         this._bodyRotSlider = new HUISlider(_propCostume,0,440,"Body Rot.");
         this._bodyRotSlider.setSize(150,20);
         this._bodyRotSlider.addEventListener(Event.CHANGE,this.bodyRotHandler,false,0,true);
         this._bodyRotSlider.addEventListener(MouseEvent.MOUSE_UP,this.bodyUpHandler,false,0,true);
         this._bodyRotSlider.minimum = this._data.min_body_rot * 180 / Math.PI;
         this._bodyRotSlider.maximum = this._data.max_body_rot * 180 / Math.PI;
         this._bodyRotSlider.value = this._data.body_rot * 180 / Math.PI;
         this._scaleSlider = new HUISlider(_propCostume,0,460,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = this._data.min_scale * 100;
         this._scaleSlider.maximum = this._data.max_scale * 100;
         this._scaleSlider.value = this._data.scale * 100;
      }
      
      private function bodyUpHandler(e:MouseEvent) : void
      {
         var rot:Number = this._bodyRotSlider.value;
         rot = Math.round(rot / 45) * 45;
         this._bodyRotSlider.value = rot;
      }
      
      private function headUpHandler(e:MouseEvent) : void
      {
         var rot:Number = this._headRotSlider.value;
         rot = Math.round(rot / 30) * 30;
         this._headRotSlider.value = rot;
      }
      
      private function headRotHandler(e:Event) : void
      {
         var rot:Number = this._headRotSlider.value;
         rot = Math.round(rot / 30) * 30;
         this._data.head_rot = rot * Math.PI / 180;
         this.drawUpdate();
      }
      
      private function bodyRotHandler(e:Event) : void
      {
         var rot:Number = this._bodyRotSlider.value;
         rot = Math.round(rot / 45) * 45;
         this._data.body_rot = rot * Math.PI / 180;
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
         CF.removeDisplayObject(this._headRotSlider);
         CF.removeDisplayObject(this._bodyRotSlider);
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(_propCostume);
         this._scaleSlider = null;
         this._headRotSlider = null;
         this._bodyRotSlider = null;
         _propCostume = null;
         super.removeProperties();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new MC_DO_LaserFake();
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
         this._drawBody.x = this._data.x;
         this._drawBody.y = this._data.y;
         this._drawBody.scaleX = this._data.scale;
         this._drawBody.scaleY = this._data.scale;
         this._drawBody.rotation = this._data.body_rot * 180 / Math.PI;
         this._drawBody.mc_fakehead.rotation = this._data.head_rot * 180 / Math.PI;
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
         _realCostume = new MC_Laser();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         _realCostume.rotation = this._data.body_rot * 180 / Math.PI;
         (_realCostume as MC_Laser).mc_head.rotation = this._data.head_rot * 180 / Math.PI;
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
         this._data = newData as DO_LaserData;
         this.drawRealCostume();
      }
   }
}
