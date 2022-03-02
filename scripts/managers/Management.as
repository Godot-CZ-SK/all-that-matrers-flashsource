package managers
{
   import game.LevelInfos;
   import game.Memory;
   import game.Message;
   
   public class Management
   {
       
      
      public function Management()
      {
         super();
      }
      
      public static function init() : void
      {
         Memory.init();
         Message.init();
         Tracking.init();
         LevelInfos.ins.init();
         FM.ins.init();
         SM.ins.init();
         EM.ins.init();
         DM.ins.init(Main.s);
         UM.ins.init(Main.s);
         PM.ins.init(DM.ins.physics);
         GM.ins.init();
         TM.ins.init();
         LM.ins.init();
         KM.ins.init(Main.s);
      }
   }
}
