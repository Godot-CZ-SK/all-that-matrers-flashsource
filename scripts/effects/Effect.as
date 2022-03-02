package effects
{
   import managers.EM;
   
   public class Effect
   {
       
      
      protected var _isCreated:Boolean;
      
      public function Effect()
      {
         super();
      }
      
      public function create() : void
      {
         this._isCreated = true;
         EM.ins.addEffect(this);
      }
      
      public function remove() : void
      {
         this._isCreated = false;
         EM.ins.removeEffect(this);
      }
      
      public function update() : void
      {
      }
   }
}
