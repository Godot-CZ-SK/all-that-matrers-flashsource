package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_Data;
   import design.data.DO_ElevatorData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Elevator extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var INTERVAL:Number = 1;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _movedVertice:Sprite;
      
      protected var _lineSprite:Sprite;
      
      protected var _drawBody:MovieClip;
      
      protected var _data:DO_ElevatorData;
      
      protected var _distanceSlider:HUISlider;
      
      protected var _v1:Sprite;
      
      protected var _v2:Sprite;
      
      protected var _typeSlider:HUISlider;
      
      protected var _speedSlider:HUISlider;
      
      protected var _scaleSlider:HUISlider;
      
      public function DO_Elevator(parent:DisplayObjectContainer)
      {
         this._data = new DO_ElevatorData();
         super(parent,GameCamera.ELEVATOR);
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
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.verticeMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.verticeUpHandler);
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
         this._speedSlider = new HUISlider(_propCostume,0,420,"Speed");
         this._speedSlider.setSize(150,20);
         this._speedSlider.addEventListener(Event.CHANGE,this.speedChangeHandler,false,0,true);
         this._speedSlider.minimum = 1;
         this._speedSlider.maximum = 25;
         this._speedSlider.value = this._data.speed * 5;
         this._scaleSlider = new HUISlider(_propCostume,0,440,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = 80;
         this._scaleSlider.maximum = 120;
         this._scaleSlider.value = this._data.scale * 100;
         this._typeSlider = new HUISlider(_propCostume,0,460,"Type");
         this._typeSlider.setSize(150,20);
         this._typeSlider.addEventListener(Event.CHANGE,this.typeChangeHandler,false,0,true);
         this._typeSlider.minimum = 1;
         this._typeSlider.maximum = 1;
         this._typeSlider.value = this._data.elevatorType;
      }
      
      protected function speedChangeHandler(e:Event) : void
      {
         this._data.speed = this._speedSlider.value / 5;
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._speedSlider);
         CF.removeDisplayObject(this._typeSlider);
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(_propCostume);
         super.removeProperties();
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var val:Number = Math.round(this._scaleSlider.value / 5) * 5;
         this._data.scale = val / 100;
         this.drawUpdate();
      }
      
      private function typeChangeHandler(e:Event) : void
      {
         var val:Number = this._typeSlider.value;
         this._data.scale = val;
         this.drawUpdate();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new MC_Elevator();
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         this._drawBody.alpha = 0.6;
         this._lineSprite = new Sprite();
         this._v1 = new Sprite();
         this._v1.addEventListener(MouseEvent.MOUSE_DOWN,this.verticeDownHandler,false,0,true);
         this._v2 = new Sprite();
         this._v2.addEventListener(MouseEvent.MOUSE_DOWN,this.verticeDownHandler,false,0,true);
         _fakeCostume.addChild(this._lineSprite);
         _fakeCostume.addChild(this._drawBody);
         _fakeCostume.addChild(this._v1);
         _fakeCostume.addChild(this._v2);
         this.drawUpdate();
         super.drawFakeCostume();
      }
      
      override public function removeFakeCostume() : void
      {
         CF.removeDisplayObject(this._drawBody);
         CF.removeDisplayObject(this._lineSprite);
         CF.removeDisplayObject(this._v1);
         CF.removeDisplayObject(this._v2);
         CF.removeDisplayObject(_fakeCostume);
         super.removeFakeCostume();
      }
      
      private function verticeDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated)
         {
            return;
         }
         this._movedVertice = e.currentTarget as Sprite;
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.verticeMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.verticeUpHandler,false,0,true);
      }
      
      private function verticeMoveHandler(e:MouseEvent) : void
      {
         if(!_isCreated)
         {
            return;
         }
         if(this._movedVertice == this._v1)
         {
            this._data.pos1 = Math.max(0,Math.round(_parent.mouseY / this.INTERVAL) * this.INTERVAL - this._data.y);
         }
         if(this._movedVertice == this._v2)
         {
            this._data.pos2 = Math.max(0,Math.round(_parent.mouseY / this.INTERVAL) * this.INTERVAL - this._data.y);
         }
         this.drawUpdate();
      }
      
      private function verticeUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.verticeMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.verticeUpHandler);
      }
      
      protected function fakeBodyDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated || _isMultipleSelected || _isDrawing || !_isSelected)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler,false,0,true);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / this.INTERVAL) * this.INTERVAL,Math.round(Main.s.mouseY / this.INTERVAL) * this.INTERVAL);
         this._movePosition = new Point(_costume.mouseX - this.data.x,_costume.mouseY - this.data.y);
         this._lastPosition = new Point(this.data.x,this.data.y);
      }
      
      private function fakeBodyUpHandler(e:MouseEvent) : void
      {
         this.drawUpdate();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
      }
      
      private function fakeBodyMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round((_parent.mouseX - this._movePosition.x) / this.INTERVAL) * this.INTERVAL);
         var ypos:Number = properY(Math.round((_parent.mouseY - this._movePosition.y) / this.INTERVAL) * this.INTERVAL);
         this._data.x = xpos;
         this._data.y = ypos;
         this.drawUpdate();
      }
      
      override protected function drawUpdate() : void
      {
         this._drawBody.x = this._data.x;
         this._drawBody.y = this._data.y;
         this._drawBody.scaleX = this._data.scale;
         this._drawBody.scaleY = this._data.scale;
         (this._drawBody as MC_Elevator).mc_elevator.y = this._data.pos1;
         var total:Number = 75 + Math.max(this._data.pos1,this._data.pos2);
         var l1:Number = 15 + this._data.pos1;
         var l2:Number = (total - l1) / 2;
         var start:Number = this._data.y - 85;
         this._lineSprite.graphics.clear();
         this._lineSprite.graphics.lineStyle(4,666666,1);
         this._lineSprite.graphics.moveTo(this._data.x,start);
         this._lineSprite.graphics.lineTo(this._data.x,start + l1);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start);
         this._lineSprite.graphics.lineTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x + 25,start);
         this._lineSprite.graphics.lineTo(this._data.x + 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.curveTo(this._data.x - 25,start + l2 + 15,this._data.x,start + l2 + 15);
         this._lineSprite.graphics.moveTo(this._data.x,start + l2 + 15);
         this._lineSprite.graphics.curveTo(this._data.x + 25,start + l2 + 15,this._data.x + 25,start + l2);
         this._v1.graphics.clear();
         this._v1.graphics.lineStyle(LT,52224,1);
         this._v1.graphics.beginFill(65280,0.5);
         this._v1.graphics.drawCircle(this._data.x,this._data.y + this._data.pos1,8);
         this._v1.graphics.endFill();
         this._v2.graphics.clear();
         this._v2.graphics.lineStyle(LT,13369344,1);
         this._v2.graphics.beginFill(16711680,0.5);
         this._v2.graphics.drawCircle(this._data.x,this._data.y + this._data.pos2,8);
         this._v2.graphics.endFill();
      }
      
      override public function drawRealCostume() : void
      {
         this._lineSprite = new Sprite();
         this._lineSprite.graphics.clear();
         var total:Number = 75 + Math.max(this._data.pos1,this._data.pos2);
         var l1:Number = 15 + this._data.pos1;
         var l2:Number = (total - l1) / 2;
         var start:Number = this._data.y - 85;
         this._lineSprite.graphics.lineStyle(4,666666,1);
         this._lineSprite.graphics.moveTo(this._data.x,start);
         this._lineSprite.graphics.lineTo(this._data.x,start + l1);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start);
         this._lineSprite.graphics.lineTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x + 25,start);
         this._lineSprite.graphics.lineTo(this._data.x + 25,start + l2);
         this._lineSprite.graphics.moveTo(this._data.x - 25,start + l2);
         this._lineSprite.graphics.curveTo(this._data.x - 25,start + l2 + 15,this._data.x,start + l2 + 15);
         this._lineSprite.graphics.moveTo(this._data.x,start + l2 + 15);
         this._lineSprite.graphics.curveTo(this._data.x + 25,start + l2 + 15,this._data.x + 25,start + l2);
         _realCostume = new MC_Elevator();
         _costume.addChild(this._lineSprite);
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         (_realCostume as MC_Elevator).mc_elevator.y = this._data.pos1;
         super.drawRealCostume();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(this._lineSprite);
         CF.removeDisplayObject(_realCostume);
         super.removeRealCostume();
      }
      
      private function drawClickHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / this.INTERVAL) * this.INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / this.INTERVAL) * this.INTERVAL);
         this.data.x = xpos;
         this.data.y = ypos;
         this.completeDrawing();
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / this.INTERVAL) * this.INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / this.INTERVAL) * this.INTERVAL);
         this.data.x = xpos;
         this.data.y = ypos;
         this.drawUpdate();
      }
      
      override public function startMoving() : void
      {
         if(_isMoving)
         {
            return;
         }
         this._movingPoint = new Point(this.data.x,this.data.y);
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
      
      protected function get data() : DO_ElevatorData
      {
         return this._data;
      }
      
      protected function set data(data:DO_ElevatorData) : void
      {
         this._data = data;
      }
      
      override public function getData() : DO_Data
      {
         return this._data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         this._data = newData as DO_ElevatorData;
         this.drawRealCostume();
      }
   }
}
