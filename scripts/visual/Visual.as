package visual
{
   public class Visual
   {
       
      
      protected var _layerNo:int;
      
      protected var _isCreated:Boolean;
      
      public function Visual(layerNo:int)
      {
         super();
         this._layerNo = layerNo;
      }
      
      public function create() : void
      {
         this._isCreated = true;
      }
      
      public function remove() : void
      {
         this._isCreated = false;
      }
   }
}
