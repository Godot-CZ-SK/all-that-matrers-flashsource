package game
{
   public class GameMusic extends GameSound
   {
      
      public static var num:int = 200;
      
      public static const HIS_GREATNESS:int = num++;
      
      public static const LEAP_OF_FAITH:int = num++;
      
      public static const VIEW_FROM_ABOVE:int = num++;
       
      
      public function GameMusic(id:int = 0, volume:Number = 1)
      {
         super();
         _id = id;
         _volume = volume;
         _isMusic = true;
         _volCoef = 1;
         var rand:Number = Math.random();
         switch(id)
         {
            case LEAP_OF_FAITH:
               _class = MUS_LeapOfFaith;
               _volCoef = 0.6;
               break;
            case HIS_GREATNESS:
               _class = MUS_HisGreatness;
               break;
            case VIEW_FROM_ABOVE:
               _class = MUS_ViewFromAbove;
               _volCoef = 0.4;
               break;
            default:
               _class = SND_Default;
         }
      }
   }
}
