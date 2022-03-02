package managers
{
   import flash.text.Font;
   
   public class FM
   {
      
      private static var _ins:FM;
       
      
      public function FM()
      {
         super();
      }
      
      public static function get ins() : FM
      {
         if(!_ins)
         {
            _ins = new FM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         Font.registerFont(JoyClass);
         Font.registerFont(TalkingMoon);
      }
   }
}
