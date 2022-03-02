package effects
{
   import flash.display.DisplayObjectContainer;
   
   public class LevelEffect extends Effect
   {
       
      
      protected var _parent:DisplayObjectContainer;
      
      public function LevelEffect(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
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
         super.remove();
      }
   }
}
