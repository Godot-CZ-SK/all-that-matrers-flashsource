package design
{
   import design.data.DO_CloudData;
   import design.data.DO_Data;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Cloud extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _data:DO_CloudData;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _movingLineNo:int;
      
      protected var _drawBody:Sprite;
      
      protected var _drawLines:Sprite;
      
      protected var _lineSprites:Vector.<Sprite>;
      
      public function DO_Cloud(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.CLOUD);
         this._data = new DO_CloudData();
         this._lineSprites = new Vector.<Sprite>();
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
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler);
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
         DM.ins.menu.addChild(_propCostume);
         super.drawProperties();
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(_propCostume);
         _propCostume = null;
         super.removeProperties();
      }
      
      override public function drawFakeCostume() : void
      {
         var line:Sprite = null;
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new Sprite();
         this._drawLines = new Sprite();
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         _fakeCostume.addChild(this._drawBody);
         _fakeCostume.addChild(this._drawLines);
         this._lineSprites = new Vector.<Sprite>();
         for(var i:int = 0; i < 2; i++)
         {
            line = new Sprite();
            line.addEventListener(MouseEvent.MOUSE_DOWN,this.lineDownHandler,false,0,true);
            this._lineSprites.push(line);
            this._drawLines.addChild(line);
         }
         this.drawUpdate();
         super.drawFakeCostume();
      }
      
      override public function removeFakeCostume() : void
      {
         for(var i:int = 0; i < this._lineSprites.length; i++)
         {
            CF.removeDisplayObject(this._lineSprites[i]);
         }
         this._lineSprites = new Vector.<Sprite>();
         CF.removeDisplayObject(_fakeCostume);
         super.removeFakeCostume();
      }
      
      protected function fakeBodyDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated || _isMultipleSelected || _isDrawing || !_isSelected)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler,false,0,true);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / INTERVAL) * INTERVAL,Math.round(Main.s.mouseY / INTERVAL) * INTERVAL);
         this._movePosition = new Point(_costume.mouseX - this.data.x,_costume.mouseY - this.data.y);
         this._lastPosition = new Point(this.data.x,this.data.y);
      }
      
      override protected function drawUpdate() : void
      {
         var i:int = 0;
         for(i = 0; i < 2; i++)
         {
            this._lineSprites[i].graphics.clear();
            this._lineSprites[i].graphics.lineStyle(LT,52224);
         }
         this._lineSprites[0].graphics.moveTo(this._data.x + this._data.width,this._data.y);
         this._lineSprites[0].graphics.lineTo(this._data.x + this._data.width,this._data.y + this._data.height);
         this._lineSprites[1].graphics.moveTo(this._data.x + this._data.width,this._data.y + this._data.height);
         this._lineSprites[1].graphics.lineTo(this._data.x,this._data.y + this._data.height);
         this._drawBody.graphics.clear();
         this._drawBody.graphics.beginFill(13369344,0.5);
         this._drawBody.graphics.moveTo(this._data.x,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x + this._data.width,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x + this._data.width,this._data.y + this._data.height);
         this._drawBody.graphics.lineTo(this._data.x,this._data.y + this._data.height);
         this._drawBody.graphics.lineTo(this._data.x,this._data.y);
         this._drawBody.graphics.endFill();
         this._drawBody.graphics.lineStyle(LT,10066329);
         this._drawBody.graphics.moveTo(this._data.x,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x + this._data.width,this._data.y);
         this._drawBody.graphics.moveTo(this._data.x,this._data.y);
         this._drawBody.graphics.lineTo(this._data.x,this._data.y + this._data.height);
      }
      
      private function lineDownHandler(e:MouseEvent) : void
      {
         if(_isMultipleSelected)
         {
            return;
         }
         var line:Sprite = e.currentTarget as Sprite;
         this._movingLineNo = this._lineSprites.indexOf(line);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / INTERVAL) * INTERVAL,Math.round(Main.s.mouseY / INTERVAL) * INTERVAL);
         this._lastPosition = new Point(this._data.width,this._data.height);
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler,false,0,true);
      }
      
      private function lineMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = Math.round(Main.s.mouseX / INTERVAL) * INTERVAL;
         var ypos:Number = Math.round(Main.s.mouseY / INTERVAL) * INTERVAL;
         var displacement:Point = new Point(this._movingPoint.x - xpos,this._movingPoint.y - ypos);
         if(this._movingLineNo == 0)
         {
            this._data.width = Math.max(this._data.min_size,this._lastPosition.x - displacement.x);
         }
         else if(this._movingLineNo == 1)
         {
            this._data.height = Math.max(this._data.min_size,this._lastPosition.y - displacement.y);
         }
         this.drawUpdate();
      }
      
      private function lineUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler);
         this.drawUpdate();
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
         this.data.x = xpos;
         this.data.y = ypos;
         this.drawUpdate();
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MovieClip();
         _costume.addChild(_realCostume);
         _realCostume.graphics.clear();
         _realCostume.graphics.lineStyle(2,2497557);
         _realCostume.graphics.beginFill(5521966,1);
         _realCostume.graphics.moveTo(this._data.x,this._data.y);
         _realCostume.graphics.lineTo(this._data.x + this._data.width,this._data.y);
         _realCostume.graphics.lineTo(this._data.x + this._data.width,this._data.y + this._data.height);
         _realCostume.graphics.lineTo(this._data.x,this._data.y + this._data.height);
         _realCostume.graphics.lineTo(this._data.x,this._data.y);
         _realCostume.graphics.endFill();
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-2,0,-2,1,2,0,2,0],1);
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
      
      protected function get data() : DO_CloudData
      {
         return this._data;
      }
      
      protected function set data(data:DO_CloudData) : void
      {
         this._data = data;
      }
      
      override public function getData() : DO_Data
      {
         return this._data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         this._data = newData as DO_CloudData;
         this.drawRealCostume();
      }
   }
}
