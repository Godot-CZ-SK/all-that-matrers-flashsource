package design
{
   import com.bit101.components.HUISlider;
   import design.data.DO_CircleData;
   import design.data.DO_UnitData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import game.GameCamera;
   
   public class DO_Unit extends DO_Circle
   {
       
      
      protected var _data:DO_UnitData;
      
      protected var _rotationSlider:HUISlider;
      
      public function DO_Unit(parent:DisplayObjectContainer, unitType:String)
      {
         super(parent,GameCamera.UNIT);
         this._data = new DO_UnitData(unitType);
      }
      
      override protected function get data() : DO_CircleData
      {
         return this._data as DO_CircleData;
      }
      
      override protected function set data(newData:DO_CircleData) : void
      {
         this._data = newData as DO_UnitData;
      }
      
      override public function drawProperties() : void
      {
         super.drawProperties();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,440,160,20);
         _propCostume.graphics.endFill();
         this._rotationSlider = new HUISlider(_propCostume,0,440,"Rotation");
         this._rotationSlider.setSize(150,20);
         this._rotationSlider.addEventListener(Event.CHANGE,this.rotationChangeHandler,false,0,true);
         this._rotationSlider.minimum = 0;
         this._rotationSlider.maximum = 360;
         this._rotationSlider.value = this._data.rotation;
      }
      
      private function rotationChangeHandler(e:Event) : void
      {
         var val:Number = Math.round(this._rotationSlider.value / 15) * 15;
         this._data.rotation = val;
         this.drawUpdate();
      }
      
      override public function drawRealCostume() : void
      {
         if(this._data.unitType == DO_UnitData.DAD)
         {
            _realCostume = new MC_DO_Dad();
         }
         else if(this._data.unitType == DO_UnitData.MOM)
         {
            _realCostume = new MC_DO_Mom();
         }
         else if(this._data.unitType == DO_UnitData.ELDER)
         {
            _realCostume = new MC_DO_Elder();
         }
         else if(this._data.unitType == DO_UnitData.KID)
         {
            _realCostume = new MC_DO_Kid();
         }
         else if(this._data.unitType == DO_UnitData.BABY)
         {
            _realCostume = new MC_DO_Baby();
         }
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         _realCostume.rotation = this._data.rotation;
         _realCostume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _realCostume.scaleY = this._data.radius * 2 / this._data.SIZE;
         super.drawRealCostume();
      }
      
      override protected function drawUpdate() : void
      {
         super.drawUpdate();
         _drawBody.graphics.moveTo(this._data.x,this._data.y);
         _drawBody.graphics.lineTo(this._data.x + this._data.radius * Math.cos(this._data.rotation / 180 * Math.PI - Math.PI / 2),this._data.y + this._data.radius * Math.sin(this._data.rotation / 180 * Math.PI - Math.PI / 2));
      }
   }
}
