package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.TextArea;
   import design.data.DO_Data;
   import design.data.DO_SignData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Sign extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _vertice:Sprite;
      
      protected var _textField:TextField;
      
      protected var _textFormat:TextFormat;
      
      protected var _tfCostume:MovieClip;
      
      protected var _drawBody:MC_SignFake;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _rotSlider:HUISlider;
      
      protected var _textArea:TextArea;
      
      protected var _textHeightSlider:HUISlider;
      
      protected var _data:DO_SignData;
      
      public function DO_Sign(parent:DisplayObjectContainer)
      {
         this._data = new DO_SignData();
         super(parent,GameCamera.SIGN);
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
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.tfMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.tfUpHandler);
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
         _propCostume.graphics.drawRect(0,360,160,120);
         _propCostume.graphics.endFill();
         DM.ins.menu.addChild(_propCostume);
         this._rotSlider = new HUISlider(_propCostume,0,360,"Rotation");
         this._rotSlider.setSize(150,20);
         this._rotSlider.addEventListener(Event.CHANGE,this.rotationChangeHandler,false,0,true);
         this._rotSlider.minimum = 0;
         this._rotSlider.maximum = 360;
         this._rotSlider.value = this._data.rotation;
         this._textArea = new TextArea(_propCostume,0,400,this._data.text);
         this._textArea.setSize(150,60);
         this._textArea.addEventListener(Event.CHANGE,this.textChangeHandler,false,0,true);
         this._scaleSlider = new HUISlider(_propCostume,0,380,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = 50;
         this._scaleSlider.maximum = 150;
         this._scaleSlider.value = this._data.scale * 100;
         this._textHeightSlider = new HUISlider(_propCostume,0,460,"Text Size");
         this._textHeightSlider.setSize(150,20);
         this._textHeightSlider.addEventListener(Event.CHANGE,this.textHeightChangeHandler,false,0,true);
         this._textHeightSlider.minimum = 12;
         this._textHeightSlider.maximum = 24;
         this._textHeightSlider.value = this._data.textHeight;
         super.drawProperties();
      }
      
      private function rotationChangeHandler(e:Event) : void
      {
         var rot:Number = Math.round(this._rotSlider.value / 45) * 45;
         this._data.rotation = rot;
         this.drawUpdate();
      }
      
      private function textChangeHandler(e:Event) : void
      {
         this._data.text = this._textArea.text;
         this.drawUpdate();
      }
      
      private function textHeightChangeHandler(e:Event) : void
      {
         this._data.textHeight = this._textHeightSlider.value;
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
         CF.removeDisplayObject(this._scaleSlider);
         CF.removeDisplayObject(this._rotSlider);
         CF.removeDisplayObject(_propCostume);
         CF.removeDisplayObject(this._textHeightSlider);
         CF.removeDisplayObject(this._textArea);
         this._scaleSlider = null;
         this._textArea = null;
         this._textHeightSlider = null;
         _propCostume = null;
         super.removeProperties();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new MC_SignFake();
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         this._tfCostume = new MovieClip();
         this._tfCostume.addEventListener(MouseEvent.MOUSE_DOWN,this.tfDownHandler,false,0,true);
         this._vertice = new Sprite();
         this._vertice.addEventListener(MouseEvent.MOUSE_DOWN,this.verticeDownHandler,false,0,true);
         _fakeCostume.addChild(this._drawBody);
         _fakeCostume.addChild(this._tfCostume);
         _fakeCostume.addChild(this._vertice);
         this.drawUpdate();
         super.drawFakeCostume();
      }
      
      override public function removeFakeCostume() : void
      {
         CF.removeDisplayObject(this._drawBody);
         CF.removeDisplayObject(this._tfCostume);
         CF.removeDisplayObject(this._vertice);
         CF.removeDisplayObject(_fakeCostume);
         super.removeFakeCostume();
      }
      
      private function verticeDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.verticeMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.verticeUpHandler,false,0,true);
      }
      
      private function verticeMoveHandler(e:MouseEvent) : void
      {
         if(!_isCreated)
         {
            return;
         }
         var xpos:Number = Math.round(_parent.mouseX / INTERVAL) * INTERVAL;
         var ypos:Number = Math.round(_parent.mouseY / INTERVAL) * INTERVAL;
         this._data.tf_width = Math.max(xpos - this._data.tf_x - this._data.x,50);
         this._data.tf_height = Math.max(ypos - this._data.tf_y - this._data.y,30);
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
         this._movingPoint = new Point(Math.round(Main.s.mouseX / INTERVAL) * INTERVAL,Math.round(Main.s.mouseY / INTERVAL) * INTERVAL);
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
         var xpos:Number = properX(Math.round((_parent.mouseX - this._movePosition.x) / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round((_parent.mouseY - this._movePosition.y) / INTERVAL) * INTERVAL);
         this._data.x = xpos;
         this._data.y = ypos;
         this.drawUpdate();
      }
      
      protected function tfDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated || _isMultipleSelected || _isDrawing || !_isSelected)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.tfMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.tfUpHandler,false,0,true);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / INTERVAL) * INTERVAL,Math.round(Main.s.mouseY / INTERVAL) * INTERVAL);
         this._movePosition = new Point(_costume.mouseX - this._data.tf_x,_costume.mouseY - this._data.tf_y);
      }
      
      private function tfUpHandler(e:MouseEvent) : void
      {
         this.drawUpdate();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.tfMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.tfUpHandler);
      }
      
      private function tfMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = Math.round((_parent.mouseX - this._movePosition.x) / INTERVAL) * INTERVAL;
         var ypos:Number = Math.round((_parent.mouseY - this._movePosition.y) / INTERVAL) * INTERVAL;
         this._data.tf_x = xpos;
         this._data.tf_y = ypos;
         this.drawUpdate();
      }
      
      override protected function drawUpdate() : void
      {
         this._drawBody.x = this._data.x;
         this._drawBody.y = this._data.y;
         this._drawBody.scaleX = this._data.scale;
         this._drawBody.scaleY = this._data.scale;
         this._drawBody.rotation = this._data.rotation;
         this._tfCostume.graphics.clear();
         this._tfCostume.graphics.beginFill(16711680,0.5);
         this._tfCostume.graphics.lineStyle(LT,52224,1);
         this._tfCostume.graphics.drawRoundRect(this._data.tf_x + this._data.x,this._data.tf_y + this._data.y,this._data.tf_width,this._data.tf_height,5,5);
         this._tfCostume.graphics.endFill();
         this._vertice.graphics.clear();
         this._vertice.graphics.lineStyle(LT * 2,52224,1);
         this._vertice.graphics.beginFill(65280,0.5);
         this._vertice.graphics.drawCircle(this._data.x + this._data.tf_x + this._data.tf_width,this._data.y + this._data.tf_y + this._data.tf_height,3);
         this._vertice.graphics.endFill();
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_Sign();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         _realCostume.rotation = this._data.rotation;
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.3,0,-0.3,1,0.3,0,0.3,0],1.2);
         _realCostume.filters = [cf];
         this._tfCostume = new MovieClip();
         this._tfCostume.graphics.beginFill(16777215,0.75);
         this._tfCostume.graphics.lineStyle(1.5,18432,1);
         this._tfCostume.graphics.drawRoundRect(0,0,this._data.tf_width,this._data.tf_height,5,5);
         this._tfCostume.graphics.endFill();
         this._textField = new TextField();
         this._textFormat = new TextFormat("calibri",this._data.textHeight,13056,true,null,null,null,null,TextFormatAlign.CENTER);
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.embedFonts = true;
         this._textField.selectable = false;
         this._textField.wordWrap = true;
         this._textField.multiline = true;
         this._textField.width = this._data.tf_width - 10;
         this._textField.height = this._data.tf_height - 10;
         this._textField.x = 5;
         this._textField.y = 5;
         this._textField.text = this._data.text;
         this._tfCostume.x = this._data.x + this._data.tf_x;
         this._tfCostume.y = this._data.y + this._data.tf_y;
         this._tfCostume.addChild(this._textField);
         _costume.addChild(this._tfCostume);
         super.drawRealCostume();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(_realCostume);
         CF.removeDisplayObject(this._textField);
         CF.removeDisplayObject(this._tfCostume);
         super.removeRealCostume();
      }
      
      private function drawClickHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
         this.data.x = xpos;
         this.data.y = ypos;
         this.completeDrawing();
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / INTERVAL) * INTERVAL);
         var ypos:Number = properY(Math.round(_parent.mouseY / INTERVAL) * INTERVAL);
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
      
      protected function get data() : DO_SignData
      {
         return this._data;
      }
      
      protected function set data(data:DO_SignData) : void
      {
         this._data = data;
      }
      
      override public function getData() : DO_Data
      {
         return this._data as DO_Data;
      }
      
      override public function setData(newData:DO_Data) : void
      {
         this._data = newData as DO_SignData;
         this.drawRealCostume();
      }
   }
}
