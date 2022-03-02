package design
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.HUISlider;
   import com.bit101.components.TextArea;
   import design.data.DO_Data;
   import design.data.DO_TextData;
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
   
   public class DO_Text extends DesignObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _data:DO_TextData;
      
      protected var _movingPoint:Point;
      
      protected var _movePosition:Point;
      
      protected var _lastPosition:Point;
      
      protected var _drawBody:MovieClip;
      
      protected var _vertice:Sprite;
      
      protected var _textField:TextField;
      
      protected var _textArea:TextArea;
      
      protected var _textHeightSlider:HUISlider;
      
      protected var _backgroundBox:CheckBox;
      
      public function DO_Text(parent:DisplayObjectContainer)
      {
         this._data = new DO_TextData();
         super(parent,GameCamera.TEXT);
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
         _propCostume.graphics.drawRect(0,380,160,100);
         _propCostume.graphics.endFill();
         DM.ins.menu.addChild(_propCostume);
         this._backgroundBox = new CheckBox(_propCostume,5,385,"Background");
         this._backgroundBox.setSize(150,20);
         this._backgroundBox.addEventListener(MouseEvent.CLICK,this.bgBoxClickHandler);
         this._backgroundBox.selected = this._data.background;
         this._textArea = new TextArea(_propCostume,0,400,this._data.text);
         this._textArea.setSize(150,60);
         this._textArea.addEventListener(Event.CHANGE,this.textChangeHandler,false,0,true);
         this._textHeightSlider = new HUISlider(_propCostume,0,460,"Text Size");
         this._textHeightSlider.setSize(150,20);
         this._textHeightSlider.addEventListener(Event.CHANGE,this.textHeightChangeHandler,false,0,true);
         this._textHeightSlider.minimum = 12;
         this._textHeightSlider.maximum = 24;
         this._textHeightSlider.value = this._data.textHeight;
         super.drawProperties();
      }
      
      private function bgBoxClickHandler(e:MouseEvent) : void
      {
         this._data.background = this._backgroundBox.selected;
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
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._textHeightSlider);
         CF.removeDisplayObject(this._textArea);
         CF.removeDisplayObject(_propCostume);
         this._textHeightSlider = null;
         this._textArea = null;
         _propCostume = null;
         super.removeProperties();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         this._drawBody = new MovieClip();
         this._vertice = new Sprite();
         this._vertice.addEventListener(MouseEvent.MOUSE_DOWN,this.verticeDownHandler,false,0,true);
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         _fakeCostume.addChild(this._drawBody);
         _fakeCostume.addChild(this._vertice);
         this.drawUpdate();
         super.drawFakeCostume();
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
         this._data.width = Math.max(xpos - this._data.x,50);
         this._data.height = Math.max(ypos - this._data.y,30);
         this.drawUpdate();
      }
      
      private function verticeUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.verticeMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.verticeUpHandler);
      }
      
      override public function removeFakeCostume() : void
      {
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
         this._movePosition = new Point(_parent.mouseX - this._data.x,_parent.mouseY - this._data.y);
         this._lastPosition = new Point(this._data.x,this._data.y);
      }
      
      override protected function drawUpdate() : void
      {
         this._drawBody.graphics.clear();
         this._drawBody.graphics.lineStyle(LT,52224,1);
         this._drawBody.graphics.beginFill(13369344,0.5);
         this._drawBody.graphics.drawRect(this._data.x,this._data.y,this._data.width,this._data.height);
         this._drawBody.graphics.endFill();
         this._vertice.graphics.clear();
         this._vertice.graphics.lineStyle(LT * 2,52224,1);
         this._vertice.graphics.beginFill(65280,0.5);
         this._vertice.graphics.drawCircle(this._data.x + this._data.width,this._data.y + this._data.height,3);
         this._vertice.graphics.endFill();
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
         _realCostume = new MovieClip();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.graphics.clear();
         if(this._data.background)
         {
            _realCostume.graphics.lineStyle(1,3154453,1);
            _realCostume.graphics.beginFill(8029033,1);
         }
         else
         {
            _realCostume.graphics.beginFill(16777215,0);
         }
         _realCostume.graphics.drawRect(0,0,this._data.width,this._data.height);
         _realCostume.graphics.endFill();
         this._textField = new TextField();
         var tf:TextFormat = new TextFormat("calibri",this._data.textHeight,14937586,true,null,null,null,null,TextFormatAlign.CENTER);
         this._textField.defaultTextFormat = tf;
         this._textField.x = 5;
         this._textField.y = 5;
         this._textField.width = this._data.width - 10;
         this._textField.height = this._data.height - 10;
         this._textField.multiline = true;
         this._textField.wordWrap = true;
         this._textField.embedFonts = true;
         this._textField.selectable = false;
         this._textField.text = this._data.text;
         _realCostume.addChild(this._textField);
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.3,0,-0.3,1,0.3,0,0.3,0],1.2);
         _realCostume.filters = [cf];
         super.drawRealCostume();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(this._textField);
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
         this._data = newData as DO_TextData;
         this.drawRealCostume();
      }
   }
}
