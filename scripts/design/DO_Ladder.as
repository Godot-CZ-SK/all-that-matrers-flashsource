package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_Data;
   import design.data.DO_LadderData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Ladder extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _movingPoint:Point;
      
      protected var _lastPosition:Point;
      
      protected var _movePosition:Point;
      
      protected var _drawBody:Sprite;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _countSlider:HUISlider;
      
      protected var _data:DO_LadderData;
      
      public function DO_Ladder(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.LADDER);
         this._data = new DO_LadderData();
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
         _propCostume.graphics.drawRect(0,440,160,40);
         _propCostume.graphics.endFill();
         DM.ins.menu.addChild(_propCostume);
         this._scaleSlider = new HUISlider(_propCostume,0,460,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = 50;
         this._scaleSlider.maximum = 150;
         this._scaleSlider.value = this._data.scale * 100;
         this._countSlider = new HUISlider(_propCostume,0,440,"Count");
         this._countSlider.setSize(150,20);
         this._countSlider.addEventListener(Event.CHANGE,this.countChangeHandler,false,0,true);
         this._countSlider.minimum = 1;
         this._countSlider.maximum = 20;
         this._countSlider.value = this._data.count;
         super.drawProperties();
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(this._countSlider);
         CF.removeDisplayObject(_propCostume);
         this._scaleSlider = null;
         this._countSlider = null;
         _propCostume = null;
         super.removeProperties();
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var scale:Number = int(this._scaleSlider.value / 10) * 10;
         this._data.scale = scale / 100;
         this.drawUpdate();
      }
      
      private function countChangeHandler(e:Event) : void
      {
         this._data.count = this._countSlider.value;
         this.drawUpdate();
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
         if(!_isCreated || _isMultipleSelected || _isDrawing)
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
         this._drawBody.graphics.lineStyle(LT,52224,1);
         this._drawBody.graphics.beginFill(13369344,0.5);
         this._drawBody.graphics.moveTo(this._data.x,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x + this._data.scale * this._data.WIDTH,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x + this._data.scale * this._data.WIDTH,this._data.y + (this._data.count + 2) * this._data.scale * this._data.HEIGHT);
         this._drawBody.graphics.lineTo(this._data.x,this._data.y + (this._data.count + 2) * this._data.scale * this._data.HEIGHT);
         this._drawBody.graphics.lineTo(this._data.x,this._data.y);
         this._drawBody.graphics.endFill();
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
         var part:MovieClip = null;
         _realCostume = new MovieClip();
         for(var i:int = 0; i < this._data.count + 2; i++)
         {
            if(i == 0)
            {
               part = new MC_LadderTop();
            }
            else if(i < this._data.count + 1)
            {
               part = new MC_LadderMid();
            }
            else
            {
               part = new MC_LadderBot();
            }
            part.scaleX = this._data.scale;
            part.scaleY = this._data.scale;
            part.y = i * this._data.HEIGHT * this._data.scale;
            _realCostume.addChild(part);
         }
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.5,0,-0.5,1,0.5,0,0.5,0],1.5);
         _realCostume.filters = [cf];
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
         this.drawUpdate();
         super.endMoving();
      }
      
      protected function get data() : DO_LadderData
      {
         return this._data;
      }
      
      protected function set data(data:DO_LadderData) : void
      {
         this._data = data;
      }
      
      override public function getData() : DO_Data
      {
         return this.data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         this.data = newData as DO_LadderData;
         this.drawRealCostume();
      }
   }
}
