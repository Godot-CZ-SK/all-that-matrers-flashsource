package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.PushButton;
   import com.bit101.components.RadioButton;
   import design.data.DO_Data;
   import design.data.DO_Path;
   import design.data.DO_PathObjectData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameCamera;
   import managers.DM;
   import managers.KM;
   
   public class DO_PathObject extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _firstClick:Boolean;
      
      protected var _canChange:Boolean;
      
      protected var _movingVertexNo:int;
      
      protected var _movingLineNo:int;
      
      protected var _movingPoint:Point;
      
      protected var _lastPathVertices:Vector.<Point>;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:Sprite;
      
      protected var _speedSlider:HUISlider;
      
      protected var _setPathButton:PushButton;
      
      protected var _clearPathButton:PushButton;
      
      protected var _circularPathButton:RadioButton;
      
      protected var _linePathButton:RadioButton;
      
      protected var _pathLines:Vector.<Sprite>;
      
      protected var _pathVertices:Vector.<Sprite>;
      
      protected var _pathCostume:MovieClip;
      
      protected var _pathVerticeCostume:MovieClip;
      
      protected var _pathLineCostume:MovieClip;
      
      protected var _isDrawingPath:Boolean;
      
      public function DO_PathObject(parent:DisplayObjectContainer, layerNo:int)
      {
         super(parent,layerNo);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._pathLines = new Vector.<Sprite>();
         this._pathVertices = new Vector.<Sprite>();
         this._lastPathVertices = new Vector.<Point>();
         this._canChange = true;
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
         this.data.path.waypoints.push(new Point(0,0));
         drawRealCostume();
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
         this._pathCostume = new MovieClip();
         this._pathVerticeCostume = new MovieClip();
         this._pathLineCostume = new MovieClip();
         DM.ins.menu.addChild(_propCostume);
         this._speedSlider = new HUISlider(_propCostume,0,440,"Speed");
         this._speedSlider.setSize(150,20);
         this._speedSlider.addEventListener(Event.CHANGE,this.speedChangeHandler,false,0,true);
         this._speedSlider.minimum = 1;
         this._speedSlider.maximum = 25;
         this._speedSlider.value = this.data.speed * 5;
         this._setPathButton = new PushButton(_propCostume,0,460,"Set Path");
         this._setPathButton.setSize(80,20);
         this._clearPathButton = new PushButton(_propCostume,80,460,"Clear Path");
         this._clearPathButton.setSize(80,20);
         this._setPathButton.addEventListener(MouseEvent.CLICK,this.setPathHandler,false,0,true);
         this._clearPathButton.addEventListener(MouseEvent.CLICK,this.clearPathHandler,false,0,true);
         this._circularPathButton = new RadioButton(_propCostume,5,425,"Circular Path");
         this._linePathButton = new RadioButton(_propCostume,85,425,"Line Path");
         this._circularPathButton.addEventListener(MouseEvent.CLICK,this.pathStyleHandler,false,0,true);
         this._linePathButton.addEventListener(MouseEvent.CLICK,this.pathStyleHandler,false,0,true);
         if(this.data.path.style == DO_Path.LINE)
         {
            this._linePathButton.selected = true;
         }
         else if(this.data.path.style == DO_Path.CIRCULAR)
         {
            this._circularPathButton.selected = true;
         }
         GameCamera.ins.addChildTo(this._pathCostume,_layerNo);
         this._pathCostume.addChild(this._pathLineCostume);
         this._pathCostume.addChild(this._pathVerticeCostume);
         this.drawPropertiesUpdate();
         super.drawProperties();
      }
      
      protected function speedChangeHandler(e:Event) : void
      {
         this.data.speed = this._speedSlider.value / 5;
      }
      
      private function pathStyleHandler(e:MouseEvent) : void
      {
         if(this._linePathButton.selected)
         {
            this.data.path.style = DO_Path.LINE;
         }
         else if(this._circularPathButton.selected)
         {
            this.data.path.style = DO_Path.CIRCULAR;
         }
         this.drawPropertiesUpdate();
      }
      
      override public function removeProperties() : void
      {
         var i:int = 0;
         for(i = 0; i < this._pathVertices.length; CF.removeDisplayObject(this._pathVertices[i]),i++)
         {
         }
         for(i = 0; i < this._pathLines.length; CF.removeDisplayObject(this._pathLines[i]),i++)
         {
         }
         this._pathVertices = new Vector.<Sprite>();
         this._pathLines = new Vector.<Sprite>();
         CF.removeDisplayObject(this._pathLineCostume);
         CF.removeDisplayObject(this._pathVerticeCostume);
         CF.removeDisplayObject(this._pathCostume);
         CF.removeDisplayObject(_propCostume);
         _propCostume = null;
         super.removeProperties();
      }
      
      private function drawPropertiesUpdate() : void
      {
         var vs:Sprite = null;
         var ls:Sprite = null;
         while(this._pathVertices.length < this.data.path.waypoints.length)
         {
            vs = new Sprite();
            vs.addEventListener(MouseEvent.MOUSE_DOWN,this.pathVertexDownHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OVER,this.pathVertexOverHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OUT,this.pathVertexOutHandler,false,0,true);
            vs.graphics.beginFill(13369344,1);
            vs.graphics.drawCircle(0,0,5);
            vs.graphics.endFill();
            this._pathVertices.push(vs);
            this._pathVerticeCostume.addChild(vs);
         }
         while(this._pathLines.length < this.data.path.waypoints.length - 1)
         {
            ls = new Sprite();
            ls.addEventListener(MouseEvent.MOUSE_DOWN,this.pathLineDownHandler,false,0,true);
            ls.addEventListener(MouseEvent.ROLL_OVER,this.pathLineOverHandler,false,0,true);
            ls.addEventListener(MouseEvent.ROLL_OUT,this.pathLineOutHandler,false,0,true);
            this._pathLines.push(ls);
            this._pathLineCostume.addChild(ls);
         }
         for(var i:int = 0; i < this.data.path.waypoints.length; i++)
         {
            this._pathVertices[i].x = this.data.path.waypoints[i].x + this.data.x;
            this._pathVertices[i].y = this.data.path.waypoints[i].y + this.data.y;
            if(i == 0)
            {
               this._pathLineCostume.graphics.clear();
               this._pathLineCostume.graphics.lineStyle(LT,65280);
               this._pathLineCostume.graphics.moveTo(this.data.x,this.data.y);
               this._pathLineCostume.graphics.lineTo(this.data.path.waypoints[0].x + this.data.x,this.data.path.waypoints[0].y + this.data.y);
            }
            else
            {
               this._pathLines[i - 1].graphics.clear();
               this._pathLines[i - 1].graphics.lineStyle(LT,65280,1);
               this._pathLines[i - 1].graphics.moveTo(this.data.path.waypoints[i - 1].x + this.data.x,this.data.path.waypoints[i - 1].y + this.data.y);
               this._pathLines[i - 1].graphics.lineTo(this.data.path.waypoints[i].x + this.data.x,this.data.path.waypoints[i].y + this.data.y);
            }
         }
         if(this.data.path.waypoints.length > 1)
         {
            if(this.data.path.style == DO_Path.CIRCULAR)
            {
               this._pathLineCostume.graphics.lineStyle(LT,65280,0.5);
               this._pathLineCostume.graphics.moveTo(this.data.path.waypoints[this.data.path.waypoints.length - 1].x + this.data.x,this.data.path.waypoints[this.data.path.waypoints.length - 1].y + this.data.y);
               this._pathLineCostume.graphics.lineTo(this.data.path.waypoints[0].x + this.data.x,this.data.path.waypoints[0].y + this.data.y);
            }
         }
      }
      
      private function pathVertexDownHandler(e:MouseEvent) : void
      {
         this._movingVertexNo = this._pathVertices.indexOf(Sprite(e.currentTarget),0);
         if(KM.ins.isDown(KM.SHIFT))
         {
            if(this.data.path.waypoints.length > 1)
            {
               this.data.path.waypoints.splice(this._movingVertexNo,1);
               CF.removeDisplayObject(this._pathVertices.pop());
               CF.removeDisplayObject(this._pathLines.pop());
               this.drawPropertiesUpdate();
               return;
            }
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.pathVertexMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.pathVertexUpHandler,false,0,true);
         this._movingPoint = new Point(this.data.path.waypoints[this._movingVertexNo].x + this.data.x,this.data.path.waypoints[this._movingVertexNo].y + this.data.y);
      }
      
      private function pathVertexUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.pathVertexMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.pathVertexUpHandler);
         if(!this._canChange)
         {
            this.data.path.waypoints[this._movingVertexNo].x = this._movingPoint.x - this.data.x;
            this.data.path.waypoints[this._movingVertexNo].y = this._movingPoint.y - this.data.y;
            this.drawPropertiesUpdate();
         }
         this._movingVertexNo = -1;
      }
      
      private function pathVertexMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = Math.round(_parent.mouseX / 5) * 5;
         var ypos:Number = Math.round(_parent.mouseY / 5) * 5;
         this.data.path.waypoints[this._movingVertexNo].x = properX(xpos) - this.data.x;
         this.data.path.waypoints[this._movingVertexNo].y = properY(ypos) - this.data.y;
         this.drawPropertiesUpdate();
         this._canChange = true;
      }
      
      private function pathVertexOverHandler(e:MouseEvent) : void
      {
      }
      
      private function pathVertexOutHandler(e:MouseEvent) : void
      {
      }
      
      private function pathLineDownHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         this._movingLineNo = this._pathLines.indexOf(Sprite(e.currentTarget),0);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / 5) * 5,Math.round(Main.s.mouseY / 5) * 5);
         if(KM.ins.isDown(KM.SHIFT))
         {
            this.data.path.waypoints.push(new Point());
            for(i = this.data.path.waypoints.length - 1; i > this._movingLineNo; i--)
            {
               this.data.path.waypoints[i].x = this.data.path.waypoints[(i - 1 + this.data.path.waypoints.length) % this.data.path.waypoints.length].x;
               this.data.path.waypoints[i].y = this.data.path.waypoints[(i - 1 + this.data.path.waypoints.length) % this.data.path.waypoints.length].y;
            }
            this.data.path.waypoints[this._movingLineNo + 1].x = this._movingPoint.x - _parent.x - this.data.x;
            this.data.path.waypoints[this._movingLineNo + 1].y = this._movingPoint.y - _parent.y - this.data.y;
            this.drawPropertiesUpdate();
            return;
         }
         this._lastPathVertices = new Vector.<Point>();
         this._lastPathVertices.push(this.data.path.waypoints[this._movingLineNo].clone());
         this._lastPathVertices.push(this.data.path.waypoints[(this._movingLineNo + 1) % this.data.path.waypoints.length].clone());
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.pathLineMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.pathLineUpHandler,false,0,true);
      }
      
      private function pathLineMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = Math.round(Main.s.mouseX / 5) * 5;
         var ypos:Number = Math.round(Main.s.mouseY / 5) * 5;
         var displacement:Point = new Point(this._movingPoint.x - xpos,this._movingPoint.y - ypos);
         var realPos1:Point = new Point(this._lastPathVertices[0].x - displacement.x + this.data.x,this._lastPathVertices[0].y - displacement.y + this.data.y);
         var realPos2:Point = new Point(this._lastPathVertices[1].x - displacement.x + this.data.x,this._lastPathVertices[1].y - displacement.y + this.data.y);
         this.data.path.waypoints[this._movingLineNo].x = properX(realPos1.x) - this.data.x;
         this.data.path.waypoints[this._movingLineNo].y = properY(realPos1.y) - this.data.y;
         this.data.path.waypoints[this._movingLineNo + 1].x = properX(realPos2.x) - this.data.x;
         this.data.path.waypoints[this._movingLineNo + 1].y = properY(realPos2.y) - this.data.y;
         this.drawPropertiesUpdate();
         this._canChange = true;
      }
      
      private function pathLineUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.pathLineMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.pathLineUpHandler);
         if(!this._canChange)
         {
            this.data.path.waypoints[this._movingLineNo].x = this._lastPathVertices[0].x;
            this.data.path.waypoints[this._movingLineNo].y = this._lastPathVertices[0].y;
            this.data.path.waypoints[this._movingLineNo + 1].x = this._lastPathVertices[1].x;
            this.data.path.waypoints[this._movingLineNo + 1].y = this._lastPathVertices[1].y;
            this.drawPropertiesUpdate();
            return;
         }
         this._movingLineNo = -1;
      }
      
      private function pathLineOverHandler(e:MouseEvent) : void
      {
      }
      
      private function pathLineOutHandler(e:MouseEvent) : void
      {
      }
      
      private function clearPathHandler(e:MouseEvent) : void
      {
         this.clearPath();
      }
      
      private function setPathHandler(e:MouseEvent) : void
      {
         this.clearPath();
         this.startDrawingPath();
      }
      
      private function startDrawingPath() : void
      {
         this._isDrawingPath = true;
         this._firstClick = true;
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.pathMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.CLICK,this.pathClickHandler,false,0,true);
      }
      
      private function stopDrawingPath() : void
      {
         this._isDrawingPath = false;
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.pathMoveHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.pathClickHandler);
      }
      
      private function clearPath() : void
      {
         var i:int = 0;
         for(i = 0; i < this._pathVertices.length; CF.removeDisplayObject(this._pathVertices[i]),i++)
         {
         }
         for(i = 0; i < this._pathLines.length; CF.removeDisplayObject(this._pathLines[i]),i++)
         {
         }
         this._pathVertices = new Vector.<Sprite>();
         this._pathLines = new Vector.<Sprite>();
         this.data.path.clear();
         this.data.path.waypoints.push(new Point(0,0));
         this.drawPropertiesUpdate();
      }
      
      private function pathClickHandler(e:MouseEvent) : void
      {
         if(this._firstClick)
         {
            this._firstClick = false;
            return;
         }
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5) - this.data.x;
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5) - this.data.y;
         var last:int = this.data.path.waypoints.length - 1;
         if(this.data.path.waypoints.length > 1 && xpos == this.data.path.waypoints[last].x && ypos == this.data.path.waypoints[last].y)
         {
            this.stopDrawingPath();
            return;
         }
         this.data.path.waypoints.push(new Point(xpos,ypos));
         this.drawPropertiesUpdate();
      }
      
      private function pathMoveHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         var last:int = this.data.path.waypoints.length - 1;
         this._pathLineCostume.graphics.clear();
         this._pathLineCostume.graphics.lineStyle(LT,65280,1);
         if(this.data.path.waypoints.length > 0)
         {
            this._pathLineCostume.graphics.moveTo(this.data.path.waypoints[last].x + this.data.x,this.data.path.waypoints[last].y + this.data.y);
         }
         else
         {
            this._pathLineCostume.graphics.moveTo(this.data.x,this.data.y);
         }
         this._pathLineCostume.graphics.lineTo(xpos,ypos);
         this._pathLineCostume.graphics.lineStyle(2,13369344,1);
         this._pathLineCostume.graphics.beginFill(13369344,0.5);
         this._pathLineCostume.graphics.drawCircle(xpos,ypos,5);
         this._pathLineCostume.graphics.endFill();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new Sprite();
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         _fakeCostume.addChild(this._drawBody);
         drawUpdate();
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
         this._movingPoint = new Point(Math.round(Main.s.mouseX / 5) * 5,Math.round(Main.s.mouseY / 5) * 5);
         this._movePosition = new Point(_fakeCostume.mouseX - this.data.x,_fakeCostume.mouseY - this.data.y);
         this._lastPosition = new Point(this.data.x,this.data.y);
         this._lastPathVertices = new Vector.<Point>();
         for(var i:int = 0; i < this.data.path.waypoints.length; i++)
         {
            this._lastPathVertices.push(this.data.path.waypoints[i].clone());
         }
      }
      
      private function fakeBodyUpHandler(e:MouseEvent) : void
      {
         drawUpdate();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
      }
      
      private function fakeBodyMoveHandler(e:MouseEvent) : void
      {
         var realX:Number = NaN;
         var realY:Number = NaN;
         var xpos:Number = properX(Math.round((_parent.mouseX - this._movePosition.x) / 5) * 5);
         var ypos:Number = properY(Math.round((_parent.mouseY - this._movePosition.y) / 5) * 5);
         this.data.x = xpos;
         this.data.y = ypos;
         var displacement:Point = new Point(this.data.x - this._lastPosition.x,this.data.y - this._lastPosition.y);
         for(var i:int = 0; i < this.data.path.waypoints.length; i++)
         {
            realX = this._lastPathVertices[i].x + this.data.x;
            realY = this._lastPathVertices[i].y + this.data.y;
            if(KM.ins.isDown(KM.SHIFT))
            {
               realX -= displacement.x;
               realY -= displacement.y;
            }
            this.data.path.waypoints[i].x = properX(realX) - this.data.x;
            this.data.path.waypoints[i].y = properY(realY) - this.data.y;
         }
         drawUpdate();
         this.drawPropertiesUpdate();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(_realCostume);
         super.removeRealCostume();
      }
      
      private function drawClickHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         this.data.x = xpos;
         this.data.y = ypos;
         this.completeDrawing();
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         this.data.x = xpos;
         this.data.y = ypos;
         drawUpdate();
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
         this.data.x = properX(this._movingPoint.x - Math.round(xpos / G_INTERVAL) * G_INTERVAL);
         this.data.y = properY(this._movingPoint.y - Math.round(ypos / G_INTERVAL) * G_INTERVAL);
         drawUpdate();
         super.moveBy(xpos,ypos);
      }
      
      override public function endMoving() : void
      {
         if(!_isMoving)
         {
            return;
         }
         drawUpdate();
         super.endMoving();
      }
      
      protected function get data() : DO_PathObjectData
      {
         return null;
      }
      
      protected function set data(data:DO_PathObjectData) : void
      {
      }
      
      override public function getData() : DO_Data
      {
         return this.data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         super.setData(newData);
         this.data = newData as DO_PathObjectData;
         drawRealCostume();
      }
   }
}
