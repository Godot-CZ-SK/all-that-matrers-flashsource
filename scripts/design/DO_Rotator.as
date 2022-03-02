package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.PushButton;
   import com.bit101.components.RadioButton;
   import design.data.DO_Data;
   import design.data.DO_RotationMap;
   import design.data.DO_RotatorData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import managers.DM;
   import managers.KM;
   
   public class DO_Rotator extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _firstClick:Boolean;
      
      protected var _canChange:Boolean;
      
      protected var _movingVertexNo:int;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:Sprite;
      
      protected var _speedSlider:HUISlider;
      
      protected var _setMapButton:PushButton;
      
      protected var _clearMapButton:PushButton;
      
      protected var _circularMapButton:RadioButton;
      
      protected var _lineMapButton:RadioButton;
      
      protected var _mapVertices:Vector.<MC_MapVertice>;
      
      protected var _mapCostume:MovieClip;
      
      protected var _mapVerticeCostume:MovieClip;
      
      protected var _isDrawingMap:Boolean;
      
      public function DO_Rotator(parent:DisplayObjectContainer, layerNo:int)
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
         this._mapVertices = new Vector.<MC_MapVertice>();
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
         this.data.map.angles.push(0);
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
         this._mapCostume = new MovieClip();
         this._mapVerticeCostume = new MovieClip();
         DM.ins.menu.addChild(_propCostume);
         this._speedSlider = new HUISlider(_propCostume,0,440,"Speed");
         this._speedSlider.setSize(150,20);
         this._speedSlider.addEventListener(Event.CHANGE,this.speedChangeHandler,false,0,true);
         this._speedSlider.minimum = this.data.min_speed;
         this._speedSlider.maximum = this.data.max_speed;
         this._speedSlider.value = this.data.speed;
         this._setMapButton = new PushButton(_propCostume,0,460,"Shooting Angles");
         this._setMapButton.setSize(100,20);
         this._clearMapButton = new PushButton(_propCostume,100,460,"Clear");
         this._clearMapButton.setSize(60,20);
         this._setMapButton.addEventListener(MouseEvent.CLICK,this.setMapHandler,false,0,true);
         this._clearMapButton.addEventListener(MouseEvent.CLICK,this.clearMapHandler,false,0,true);
         this._circularMapButton = new RadioButton(_propCostume,5,425,"Circular");
         this._lineMapButton = new RadioButton(_propCostume,85,425,"Line");
         this._circularMapButton.addEventListener(MouseEvent.CLICK,this.mapStyleHandler,false,0,true);
         this._lineMapButton.addEventListener(MouseEvent.CLICK,this.mapStyleHandler,false,0,true);
         if(this.data.map.style == DO_RotationMap.LINE)
         {
            this._lineMapButton.selected = true;
         }
         else if(this.data.map.style == DO_RotationMap.CIRCULAR)
         {
            this._circularMapButton.selected = true;
         }
         _parent.addChild(this._mapCostume);
         this._mapCostume.addChild(this._mapVerticeCostume);
         this.drawPropertiesUpdate();
         super.drawProperties();
      }
      
      private function speedChangeHandler(e:Event) : void
      {
         this.data.speed = this._speedSlider.value;
      }
      
      private function mapStyleHandler(e:MouseEvent) : void
      {
         if(this._lineMapButton.selected)
         {
            this.data.map.style = DO_RotationMap.LINE;
         }
         else if(this._circularMapButton.selected)
         {
            this.data.map.style = DO_RotationMap.CIRCULAR;
         }
         this.drawPropertiesUpdate();
      }
      
      override public function removeProperties() : void
      {
         var i:int = 0;
         for(i = 0; i < this._mapVertices.length; CF.removeDisplayObject(this._mapVertices[i]),i++)
         {
         }
         this._mapVertices = new Vector.<MC_MapVertice>();
         CF.removeDisplayObject(this._mapVerticeCostume);
         CF.removeDisplayObject(this._mapCostume);
         CF.removeDisplayObject(_propCostume);
         _propCostume = null;
         super.removeProperties();
      }
      
      protected function drawPropertiesUpdate() : void
      {
         var vs:MC_MapVertice = null;
         var distance:Number = NaN;
         var angle:Number = NaN;
         while(this._mapVertices.length < this.data.map.angles.length)
         {
            vs = new MC_MapVertice();
            vs.addEventListener(MouseEvent.MOUSE_DOWN,this.mapVertexDownHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OVER,this.mapVertexOverHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OUT,this.mapVertexOutHandler,false,0,true);
            this._mapVertices.push(vs);
            this._mapVerticeCostume.addChild(vs);
         }
         for(var i:int = 0; i < this.data.map.angles.length; i++)
         {
            distance = 100;
            angle = this.data.map.angles[i];
            this._mapVertices[i].x = distance * Math.cos(angle) + this.data.x;
            this._mapVertices[i].y = distance * Math.sin(angle) + this.data.y;
            this._mapVertices[i].txt_num.text = (i + 1).toString();
         }
      }
      
      protected function mapVertexDownHandler(e:MouseEvent) : void
      {
         this._movingVertexNo = this._mapVertices.indexOf(Sprite(e.currentTarget),0);
         if(KM.ins.isDown(KM.SHIFT))
         {
            if(this.data.map.angles.length > 1)
            {
               this.data.map.angles.splice(this._movingVertexNo,1);
               CF.removeDisplayObject(this._mapVertices.pop());
               this.drawPropertiesUpdate();
               return;
            }
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.mapVertexMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.mapVertexUpHandler,false,0,true);
         this._movingPoint = new Point(this._mapVertices[this._movingVertexNo].x,this._mapVertices[this._movingVertexNo].y);
      }
      
      protected function mapVertexUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.mapVertexMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.mapVertexUpHandler);
         this._movingVertexNo = -1;
      }
      
      protected function mapVertexMoveHandler(e:MouseEvent) : void
      {
         var angle:Number = Math.round(Math.atan2(_parent.mouseY - this.data.y,_parent.mouseX - this.data.x) * 10) / 10;
         if(angle > 0 && angle < Math.PI / 2)
         {
            angle = this.data.max_angle;
         }
         else if(angle >= Math.PI / 2 && angle < Math.PI)
         {
            angle = this.data.min_angle;
         }
         var distance:Number = 100;
         this.data.map.angles[this._movingVertexNo] = angle;
         this.drawPropertiesUpdate();
      }
      
      protected function mapVertexOverHandler(e:MouseEvent) : void
      {
      }
      
      protected function mapVertexOutHandler(e:MouseEvent) : void
      {
      }
      
      protected function clearMapHandler(e:MouseEvent) : void
      {
         this.clearMap();
      }
      
      protected function setMapHandler(e:MouseEvent) : void
      {
         this.clearMap();
         this.startDrawingMap();
      }
      
      protected function startDrawingMap() : void
      {
         this._isDrawingMap = true;
         this._firstClick = true;
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.mapMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.CLICK,this.mapClickHandler,false,0,true);
      }
      
      protected function stopDrawingMap() : void
      {
         this._isDrawingMap = false;
         this._mapVerticeCostume.graphics.clear();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.mapMoveHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.mapClickHandler);
      }
      
      protected function clearMap() : void
      {
         var i:int = 0;
         for(i = 0; i < this._mapVertices.length; CF.removeDisplayObject(this._mapVertices[i]),i++)
         {
         }
         this._mapVertices = new Vector.<MC_MapVertice>();
         this.data.map.clear();
         this.data.map.angles.push(this.data.rotation);
         this.drawPropertiesUpdate();
      }
      
      protected function mapClickHandler(e:MouseEvent) : void
      {
         if(this._firstClick)
         {
            this._firstClick = false;
            return;
         }
         var angle:Number = Math.round(Math.atan2(_parent.mouseY - this.data.y,_parent.mouseX - this.data.x) * 10) / 10;
         if(angle > 0 && angle < Math.PI / 2)
         {
            angle = this.data.max_angle;
         }
         else if(angle >= Math.PI / 2 && angle < Math.PI)
         {
            angle = this.data.min_angle;
         }
         var last:int = this.data.map.angles.length - 1;
         if(this.data.map.angles.length > 1 && angle == this.data.map.angles[last])
         {
            this.stopDrawingMap();
            return;
         }
         this.data.map.angles.push(angle);
         this.drawPropertiesUpdate();
      }
      
      protected function mapMoveHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         var angle:Number = Math.round(Math.atan2(_parent.mouseY - this.data.y,_parent.mouseX - this.data.x) * 10) / 10;
         if(angle > 0 && angle < Math.PI / 2)
         {
            angle = this.data.max_angle;
         }
         else if(angle >= Math.PI / 2 && angle < Math.PI)
         {
            angle = this.data.min_angle;
         }
         var distance:Number = 100;
         var xpos:Number = distance * Math.cos(angle) + this.data.x;
         var ypos:Number = distance * Math.sin(angle) + this.data.y;
         var last:int = this.data.map.angles.length - 1;
         this._mapVerticeCostume.graphics.clear();
         this._mapVerticeCostume.graphics.beginFill(16777215,0.5);
         this._mapVerticeCostume.graphics.drawCircle(_parent.mouseX,_parent.mouseY,5);
         this._mapVerticeCostume.graphics.beginFill(13369344,1);
         this._mapVerticeCostume.graphics.drawCircle(xpos,ypos,10);
         this._mapVerticeCostume.graphics.endFill();
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
         CF.removeDisplayObject(this._drawBody);
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
         this._movePosition = new Point(_fakeCostume.mouseX - this.data.x,_fakeCostume.mouseY - this.data.y);
         this._lastPosition = new Point(this.data.x,this.data.y);
      }
      
      protected function fakeBodyUpHandler(e:MouseEvent) : void
      {
         drawUpdate();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
      }
      
      protected function fakeBodyMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round((_parent.mouseX - this._movePosition.x) / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round((_parent.mouseY - this._movePosition.y) / INTERVAL) * INTERVAL);
         this.data.x = xpos;
         this.data.y = ypos;
         drawUpdate();
         this.drawPropertiesUpdate();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(_realCostume);
         super.removeRealCostume();
      }
      
      protected function drawClickHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
         this.data.x = xpos;
         this.data.y = ypos;
         this.completeDrawing();
      }
      
      protected function moveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
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
      
      protected function get data() : DO_RotatorData
      {
         return null;
      }
      
      protected function set data(data:DO_RotatorData) : void
      {
      }
      
      override public function getData() : DO_Data
      {
         return this.data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         super.setData(newData);
         this.data = newData as DO_RotatorData;
         drawRealCostume();
      }
   }
}
