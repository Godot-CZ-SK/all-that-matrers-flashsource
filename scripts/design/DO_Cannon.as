package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_CannonData;
   import design.data.DO_RotatorData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameCamera;
   
   public class DO_Cannon extends DO_Rotator
   {
       
      
      protected var _data:DO_CannonData;
      
      protected var _scaleSlider:HUISlider;
      
      protected var _rotationSlider:HUISlider;
      
      protected var _drawFake:MC_DO_CannonFake;
      
      public function DO_Cannon(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.CANNON);
         this._data = new DO_CannonData();
      }
      
      override protected function get data() : DO_RotatorData
      {
         return this._data as DO_RotatorData;
      }
      
      override protected function set data(newData:DO_RotatorData) : void
      {
         this._data = newData as DO_CannonData;
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_DO_Cannon();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.scale;
         _realCostume.scaleY = this._data.scale;
         this.setRotation(_realCostume,this._data.rotation);
         super.drawRealCostume();
      }
      
      private function setRotation(clip:MovieClip, rotation:Number) : void
      {
         rotation = rotation * 180 / Math.PI;
         var left:Boolean = false;
         if(rotation < -90)
         {
            rotation = 180 - rotation;
            left = true;
         }
         if(left)
         {
            clip.scaleX = -this._data.scale;
         }
         else
         {
            clip.scaleX = this._data.scale;
         }
         clip.mc_dobody.rotation = rotation;
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,380,160,40);
         _propCostume.graphics.endFill();
         this._scaleSlider = new HUISlider(_propCostume,0,380,"Scale");
         this._scaleSlider.setSize(150,20);
         this._scaleSlider.addEventListener(Event.CHANGE,this.scaleChangeHandler,false,0,true);
         this._scaleSlider.minimum = this._data.min_scale * 100;
         this._scaleSlider.maximum = this._data.max_scale * 100;
         this._scaleSlider.value = this._data.scale * 100;
         this._rotationSlider = new HUISlider(_propCostume,0,400,"Rotation");
         this._rotationSlider.setSize(150,20);
         this._rotationSlider.addEventListener(Event.CHANGE,this.rotationChangeHandler,false,0,true);
         this._rotationSlider.minimum = this._data.max_angle * 180 / Math.PI;
         this._rotationSlider.maximum = -this._data.min_angle * 180 / Math.PI;
         this._rotationSlider.value = -this._data.rotation * 180 / Math.PI;
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._rotationSlider);
         CF.removeDisplayObject(this._scaleSlider);
         super.removeProperties();
      }
      
      private function rotationChangeHandler(e:Event) : void
      {
         this._data.rotation = -this._rotationSlider.value / 180 * Math.PI;
         this.drawUpdate();
      }
      
      private function scaleChangeHandler(e:Event) : void
      {
         var scale:Number = int(this._scaleSlider.value / 10) * 10;
         this._data.scale = scale / 100;
         this.drawUpdate();
      }
      
      override public function removeFakeCostume() : void
      {
         CF.removeDisplayObject(this._drawFake);
         super.removeFakeCostume();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MovieClip();
         _costume.addChild(_fakeCostume);
         _drawBody = new Sprite();
         _drawBody.addEventListener(MouseEvent.MOUSE_DOWN,fakeBodyDownHandler,false,0,true);
         _fakeCostume.addChild(_drawBody);
         if(!this._drawFake || !this._drawFake.parent)
         {
            CF.removeDisplayObject(this._drawFake);
            this._drawFake = new MC_DO_CannonFake();
            _drawBody.addChild(this._drawFake);
         }
         this.drawUpdate();
      }
      
      override protected function drawUpdate() : void
      {
         this._drawFake.x = this._data.x;
         this._drawFake.y = this._data.y;
         this._drawFake.scaleX = this._data.scale;
         this._drawFake.scaleY = this._data.scale;
         this.setRotation(this._drawFake,this._data.rotation);
      }
   }
}
