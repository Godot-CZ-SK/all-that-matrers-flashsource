package managers
{
   import effects.Effect;
   
   public class EM
   {
      
      private static var _ins:EM;
       
      
      private var _effects:Vector.<Effect>;
      
      public function EM()
      {
         super();
      }
      
      public static function get ins() : EM
      {
         if(!_ins)
         {
            _ins = new EM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         this._effects = new Vector.<Effect>();
      }
      
      public function update() : void
      {
         for(var i:int = 0; i < this._effects.length; i++)
         {
            this._effects[i].update();
         }
      }
      
      public function addEffect(e:Effect) : void
      {
         if(this._effects.indexOf(e) < 0)
         {
            this._effects.push(e);
         }
      }
      
      public function removeEffect(e:Effect) : void
      {
         if(this._effects.indexOf(e) >= 0)
         {
            e.remove();
            this._effects.splice(this._effects.indexOf(e),1);
         }
      }
      
      public function removeAllEffects() : void
      {
         for(var i:int = 0; i < this._effects.length; i++)
         {
            this._effects[i].remove();
         }
         this._effects = new Vector.<Effect>();
      }
   }
}
