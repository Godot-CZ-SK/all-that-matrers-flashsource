package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.PushButton;
   import design.data.DO_PathObjectData;
   import design.data.DO_PlatformData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.ConvolutionFilter;
   import game.GameCamera;
   
   public class DO_Platform extends DO_PathObject
   {
      
      protected static const LT:Number = 5;
       
      
      protected var _drawPathButton:PushButton;
      
      protected var _countSlider:HUISlider;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _waitSlider:HUISlider;
      
      protected var _data:DO_PlatformData;
      
      public function DO_Platform(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.PLATFORM);
         this._data = new DO_PlatformData();
      }
      
      override protected function get data() : DO_PathObjectData
      {
         return this._data as DO_PathObjectData;
      }
      
      override protected function set data(newData:DO_PathObjectData) : void
      {
         this._data = newData as DO_PlatformData;
      }
      
      override public function drawRealCostume() : void
      {
         var mid:MC_PlatformMid = null;
         _realCostume = new MovieClip();
         var first:MC_PlatformStart = new MC_PlatformStart();
         first.x = this._data.WIDTH / 2;
         first.y = this._data.HEIGHT / 2;
         _realCostume.addChild(first);
         for(var i:int = 0; i < this._data.count; i++)
         {
            mid = new MC_PlatformMid();
            _realCostume.addChild(mid);
            mid.x = this._data.WIDTH * (i + 1.5);
            mid.y = this._data.HEIGHT / 2;
         }
         var last:MC_PlatformStart = new MC_PlatformStart();
         _realCostume.addChild(last);
         last.x = this._data.WIDTH * (this._data.count + 1.5);
         last.y = this._data.HEIGHT / 2;
         last.scaleX = -1;
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.5,0,-0.5,1,0.5,0,0.5,0],1.5);
         _realCostume.filters = [cf];
         super.drawRealCostume();
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,360,160,60);
         _propCostume.graphics.endFill();
         this._waitSlider = new HUISlider(_propCostume,0,360,"Wait Time");
         this._waitSlider.setSize(150,20);
         this._waitSlider.addEventListener(Event.CHANGE,this.waitChangeHandler,false,0,true);
         this._waitSlider.minimum = 0;
         this._waitSlider.maximum = 5;
         this._waitSlider.value = this._data.timeToWait;
         this._countSlider = new HUISlider(_propCostume,0,380,"Count");
         this._countSlider.setSize(150,20);
         this._countSlider.addEventListener(Event.CHANGE,this.countChangeHandler,false,0,true);
         this._countSlider.minimum = this._data.min_count;
         this._countSlider.maximum = this._data.max_count;
         this._countSlider.value = this._data.count;
         this._scaleSlider = new HUISlider(_propCostume,0,400,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = this._data.min_scale * 100;
         this._scaleSlider.maximum = this._data.max_scale * 100;
         this._scaleSlider.value = this._data.scale * 100;
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._countSlider);
         CF.removeDisplayObject(this._scaleSlider);
         super.removeProperties();
      }
      
      override protected function speedChangeHandler(e:Event) : void
      {
         this._data.speed = _speedSlider.value / 4;
      }
      
      protected function waitChangeHandler(e:Event) : void
      {
         this._data.timeToWait = this._waitSlider.value;
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
      
      override protected function drawUpdate() : void
      {
         var w:Number = (this._data.count + 2) * this._data.WIDTH * this._data.scale;
         var h:Number = this._data.HEIGHT * this._data.scale;
         _drawBody.graphics.clear();
         _drawBody.graphics.lineStyle(LT,52224,1);
         _drawBody.graphics.beginFill(13369344,0.5);
         _drawBody.graphics.drawRect(this._data.x,this._data.y,w,h);
         _drawBody.graphics.endFill();
      }
   }
}
