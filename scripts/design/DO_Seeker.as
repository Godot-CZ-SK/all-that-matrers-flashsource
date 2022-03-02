package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_PathObjectData;
   import design.data.DO_SeekerData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameCamera;
   
   public class DO_Seeker extends DO_PathObject
   {
       
      
      protected var _data:DO_SeekerData;
      
      protected var _scaleSlider:HUISlider;
      
      public function DO_Seeker(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.UO);
         this._data = new DO_SeekerData();
      }
      
      override protected function get data() : DO_PathObjectData
      {
         return this._data as DO_PathObjectData;
      }
      
      override protected function set data(newData:DO_PathObjectData) : void
      {
         this._data = newData as DO_SeekerData;
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_Seeker();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         super.drawRealCostume();
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,400,160,20);
         _propCostume.graphics.endFill();
         this._scaleSlider = new HUISlider(_propCostume,0,400,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
         this._scaleSlider.minimum = 50;
         this._scaleSlider.maximum = 150;
         this._scaleSlider.value = this._data.scale * 100;
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._scaleSlider);
         super.removeProperties();
      }
      
      private function mouseUpHandler(e:MouseEvent) : void
      {
         this._scaleSlider.value = int(this._scaleSlider.value / 5) * 5;
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var scale:Number = int(this._scaleSlider.value / 10) * 10;
         this._data.scale = scale / 100;
         this.drawUpdate();
      }
      
      override protected function drawUpdate() : void
      {
         _drawBody.graphics.clear();
         _drawBody.graphics.lineStyle(LT,52224,1);
         _drawBody.graphics.beginFill(13369344,0.5);
         _drawBody.graphics.drawCircle(this._data.x,this._data.y,this._data.SIZE * this._data.scale / 2);
         _drawBody.graphics.endFill();
      }
   }
}
