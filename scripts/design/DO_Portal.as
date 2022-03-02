package design
{
   import design.data.DO_CircleData;
   import design.data.DO_PortalData;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import game.GameCamera;
   
   public class DO_Portal extends DO_Circle
   {
       
      
      protected var _data:DO_PortalData;
      
      public function DO_Portal(parent:DisplayObjectContainer)
      {
         super(parent,GameCamera.PORTAL);
         this._data = new DO_PortalData();
      }
      
      override protected function get data() : DO_CircleData
      {
         return this._data as DO_CircleData;
      }
      
      override protected function set data(newData:DO_CircleData) : void
      {
         this._data = newData as DO_PortalData;
      }
      
      override public function drawRealCostume() : void
      {
         _realCostume = new MC_DO_Portal();
         _costume.addChild(_realCostume);
         _realCostume.x = this._data.x;
         _realCostume.y = this._data.y;
         var scale:Number = this._data.radius * 2 / this._data.SIZE;
         _realCostume.scaleX = scale;
         _realCostume.scaleY = scale;
         super.drawRealCostume();
      }
      
      override public function drawFakeCostume() : void
      {
         _fakeCostume = new MC_DO_PortalFake();
         _costume.addChild(_fakeCostume);
         this.drawUpdate();
         _fakeCostume.addEventListener(MouseEvent.MOUSE_DOWN,fakeBodyDownHandler,false,0,true);
      }
      
      override protected function drawUpdate() : void
      {
         _fakeCostume.x = this._data.x;
         _fakeCostume.y = this._data.y;
         _fakeCostume.scaleX = this._data.radius * 2 / this._data.SIZE;
         _fakeCostume.scaleY = this._data.radius * 2 / this._data.SIZE;
      }
   }
}
