package
{
   import FGL.GameTracker.GameTracker;
   
   public class Tracking
   {
      
      public static var gt:GameTracker;
       
      
      public function Tracking()
      {
         super();
      }
      
      public static function init() : void
      {
         gt = new GameTracker();
      }
      
      public static function beginGame(currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.beginGame(currentScore,currentGameState,customMessage);
      }
      
      public static function endGame(currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.endGame(currentScore,currentGameState,customMessage);
      }
      
      public static function beginLevel(newLevel:int, currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.beginLevel(newLevel,currentScore,currentGameState,customMessage);
      }
      
      public static function endLevel(currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.endLevel(currentScore,currentGameState,customMessage);
      }
      
      public static function alert(currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.alert(currentScore,currentGameState,customMessage);
      }
      
      public static function customMessage(messageType:String, currentScore:Number = 0, currentGameState:String = null, customMessage:String = null) : void
      {
         if(!Constants.TRACKING_ENABLED)
         {
            return;
         }
         gt.customMsg(messageType,currentScore,currentGameState,customMessage);
      }
   }
}
