package effects
{
   import design.data.DO_BubbleData;
   import flash.display.Sprite;
   
   public class UnitEffect extends Effect
   {
       
      
      protected var _costume:Sprite;
      
      protected var _list:Vector.<DO_BubbleData>;
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      protected var _effect:Number;
      
      protected var _duration:int;
      
      protected var _life:int;
      
      public function UnitEffect(x:Number, y:Number, effect:Number, duration:int)
      {
         super();
         this._x = x;
         this._y = y;
         this._effect = effect;
         this._duration = duration;
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
