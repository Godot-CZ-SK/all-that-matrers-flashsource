package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_CircleData;
   import design.data.DO_HeartData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameCamera;
   
   public class DO_Heart extends DO_Circle
   {
       
      
      protected var _data:DO_HeartData;
      
      protected var _timeSlider:HUISlider;
      
      public function DO_Heart(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.HEART);
         this._data = new DO_HeartData();
      }
      
      override protected function get data() : DO_CircleData
      {
         return this._data as DO_CircleData;
      }
      
      override protected function set data(newData:DO_CircleData) : void
      {
         this._data = newData as DO_HeartData;
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_DO_Heart();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _realCostume.scaleY = this._data.radius * 2 / this._data.SIZE;
         super.drawRealCostume();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MC_DO_HeartFake();
         _fakeCostume.addEventListener(MouseEvent.MOUSE_DOWN,fakeBodyDownHandler,false,0,true);
         _costume.addChild(_fakeCostume);
         this.drawUpdate();
      }
      
      override protected function drawUpdate() : void
      {
         _fakeCostume.x = this._data.x;
         _fakeCostume.y = this._data.y;
         _fakeCostume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _fakeCostume.scaleY = this._data.radius * 2 / this._data.SIZE;
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,440,160,20);
         _propCostume.graphics.endFill();
         this._timeSlider = new HUISlider(_propCostume,0,440,"Time");
         this._timeSlider.setSize(150,20);
         this._timeSlider.addEventListener(Event.CHANGE,this.timeChangeHandler,false,0,true);
         this._timeSlider.minimum = 0;
         this._timeSlider.maximum = 120;
         this._timeSlider.value = this._data.time;
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._timeSlider);
         this._timeSlider = null;
         super.removeProperties();
      }
      
      private function timeChangeHandler(e:Event) : void
      {
         this._data.time = this._timeSlider.value;
      }
   }
}
