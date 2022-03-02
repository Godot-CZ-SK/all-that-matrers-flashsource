package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.RadioButton;
   import design.data.DO_PathObjectData;
   import design.data.DO_UOData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameCamera;
   
   public class DO_UO extends DO_PathObject
   {
       
      
      protected var _data:DO_UOData;
      
      protected var _ufoButton:RadioButton;
      
      protected var _umoButton:RadioButton;
      
      protected var _radiusSlider:HUISlider;
      
      public function DO_UO(parent:DisplayObjectContainer, uoType:String)
      {
         super(parent,GameCamera.UO);
         this._data = new DO_UOData(uoType);
      }
      
      override protected function get data() : DO_PathObjectData
      {
         return this._data as DO_PathObjectData;
      }
      
      override protected function set data(newData:DO_PathObjectData) : void
      {
         this._data = newData as DO_UOData;
      }
      
      override public function drawRealCostume() : void
      {
         if(this._data.uoType == DO_UOData.UFO)
         {
            _realCostume = new MC_DO_UFO();
         }
         else if(this._data.uoType == DO_UOData.UMO)
         {
            _realCostume = new MC_DO_UMO();
         }
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _realCostume.scaleY = this._data.radius * 2 / this._data.SIZE;
         super.drawRealCostume();
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,380,160,40);
         _propCostume.graphics.endFill();
         this._radiusSlider = new HUISlider(_propCostume,0,380,"Radius");
         this._radiusSlider.setSize(150,20);
         this._radiusSlider.addEventListener(Event.CHANGE,this.radiusChangeHandler,false,0,true);
         this._radiusSlider.minimum = this._data.min_radius;
         this._radiusSlider.maximum = this._data.max_radius;
         this._radiusSlider.value = this._data.radius;
         this._ufoButton = new RadioButton(_propCostume,5,405,"UFO");
         this._umoButton = new RadioButton(_propCostume,85,405,"UMO");
         this._ufoButton.groupName = "uo";
         this._umoButton.groupName = "uo";
         if(this._data.uoType == DO_UOData.UFO)
         {
            this._ufoButton.selected = true;
         }
         else if(this._data.uoType == DO_UOData.UMO)
         {
            this._umoButton.selected = true;
         }
         this._ufoButton.addEventListener(MouseEvent.CLICK,this.uoTypeHandler,false,0,true);
         this._umoButton.addEventListener(MouseEvent.CLICK,this.uoTypeHandler,false,0,true);
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._radiusSlider);
         CF.removeDisplayObject(this._ufoButton);
         CF.removeDisplayObject(this._umoButton);
         super.removeProperties();
      }
      
      private function radiusChangeHandler(e:Event) : void
      {
         this._data.radius = this._radiusSlider.value;
         this.drawUpdate();
      }
      
      private function uoTypeHandler(e:MouseEvent) : void
      {
         if(this._ufoButton.selected)
         {
            this._data.uoType = DO_UOData.UFO;
         }
         else if(this._umoButton.selected)
         {
            this._data.uoType = DO_UOData.UMO;
         }
      }
      
      override protected function drawUpdate() : void
      {
         _drawBody.graphics.clear();
         _drawBody.graphics.lineStyle(LT,52224,1);
         _drawBody.graphics.beginFill(13369344,0.5);
         _drawBody.graphics.drawCircle(this._data.x,this._data.y,this._data.radius);
         _drawBody.graphics.endFill();
      }
   }
}
