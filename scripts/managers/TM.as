package managers
{
   public class TM
   {
      
      private static var _ins:TM;
       
      
      private var _functions:Vector.<Function>;
      
      private var _times:Vector.<Number>;
      
      public function TM()
      {
         super();
      }
      
      public static function get ins() : TM
      {
         if(!_ins)
         {
            _ins = new TM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         this._functions = new Vector.<Function>();
         this._times = new Vector.<Number>();
      }
      
      public function update() : void
      {
         for(var i:int = this._times.length - 1; i >= 0; i--)
         {
            this._times[i] -= Constants.timeStep;
            if(this._times[i] <= 0)
            {
               this._times.splice(i,1);
               this._functions[i]();
               this._functions.splice(i,1);
            }
         }
      }
      
      public function tf(fnc:Function, time:Number) : void
      {
         this._functions.push(fnc);
         this._times.push(time);
      }
   }
}
