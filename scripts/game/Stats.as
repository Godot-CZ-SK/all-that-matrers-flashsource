package game
{
   import Playtomic.Log;
   import flash.system.Security;
   
   public class Stats
   {
      
      protected static var _isEnabled:Boolean = true;
      
      protected static const GAME_ID:int = 4099;
      
      protected static const GU_ID:String = "80e9a3f6f971496e";
      
      protected static const API_KEY:String = "ef249b5dbc6b45589d9c0bc319bc45";
      
      public static const STAT_UNIT_DEATH:String = "unit_death";
      
      public static const STAT_UNIT_SAVED:String = "unit_saved";
      
      public static const STAT_UNIT_ENCOUNTER:String = "unit_encounter";
      
      public static const STAT_LEVEL_COMPLETED:String = "level_completed";
      
      public static const STAT_SEEKER_DEATH:String = "seeker_death";
      
      public static const STAT_LEVEL_DEATH:String = "level_death";
      
      public static const STAT_LONGEST_SWING_TIME:String = "longest_swing_time";
      
      public static const STAT_TOTAL_SWING_TIME:String = "total_swing_time";
      
      public static const STAT_LASER_SHOT:String = "laser_shot";
      
      public static const STAT_HEARTS_COLLECTED:String = "hearts_collected";
      
      public static const STAT_UBO_DEATH:String = "ubo_death";
      
      public static const STAT_TRAP_DEATH:String = "trap_death";
      
      public static const STAT_LONGEST_ON_AIR_TIME:String = "longest_on_air";
      
      public static const STAT_TOTAL_ON_AIR_TIME:String = "total_on_air";
      
      public static const STAT_PLAYED_TIME:String = "played_time";
      
      public static const STAT_OUT_OF_BOUNDS:String = "out_of_bounds";
      
      public static const STAT_MOST_TD_COLLECTED:String = "most_td_collected";
      
      public static const STAT_TOTAL_TD_COLLECTED:String = "total_td_collected";
      
      public static const STAT_MOST_ER_COLLECTED:String = "most_er_collected";
      
      public static const STAT_TOTAL_ER_COLLECTED:String = "total_er_collected";
      
      public static const STAT_MOST_BA_COLLECTED:String = "most_ba_collected";
      
      public static const STAT_TOTAL_BA_COLLECTED:String = "total_ba_collected";
      
      public static const STAT_LEVEL_TESTED:String = "level_tested";
       
      
      public function Stats()
      {
         super();
      }
      
      public static function view() : void
      {
         if(!_isEnabled)
         {
            return;
         }
         trace("Playtomic View...");
         Security.allowDomain("www.playtomic.com");
         Log.View(GAME_ID,GU_ID,API_KEY,Main.s.loaderInfo.loaderURL);
      }
   }
}
