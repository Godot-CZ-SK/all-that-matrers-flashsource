package managers
{
   import com.bit101.components.Label;
   import com.bit101.components.Panel;
   import design.data.LevelData;
   import flash.system.System;
   import flash.utils.getTimer;
   import game.Level;
   import game.LevelInfos;
   import game.bonus.BL_Baby;
   import game.bonus.BL_Elder;
   import game.bonus.BL_Kid;
   import game.bonus.BonusLevel;
   
   public class GM
   {
      
      private static var _ins:GM;
       
      
      protected var _cl:Level;
      
      protected var _bl:BonusLevel;
      
      protected var _performancePanel:Panel;
      
      protected var _fpsLabel:Label;
      
      protected var _memLabel:Label;
      
      protected var _startTime:int;
      
      protected var _frames:int;
      
      public function GM()
      {
         super();
      }
      
      public static function get ins() : GM
      {
         if(!_ins)
         {
            _ins = new GM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         this._performancePanel = new Panel(DM.ins.debug,5,425);
         this._performancePanel.setSize(100,50);
         this._frames = 0;
         this._startTime = getTimer();
         this._fpsLabel = new Label(this._performancePanel.content,5,5,"FPS: ");
         this._memLabel = new Label(this._performancePanel.content,5,25,"Memory: ");
      }
      
      public function update() : void
      {
         if(this._cl)
         {
            this._cl.update();
         }
         if(this._bl)
         {
            this._bl.update();
         }
         ++this._frames;
         var current:int = getTimer();
         if(current - this._startTime > 1000)
         {
            this._fpsLabel.text = "FPS: " + this._frames.toString();
            this._memLabel.text = "Memory: " + int(System.totalMemory / 1000000).toString() + "MB.";
            this._startTime = current;
            this._frames = 0;
         }
      }
      
      public function testLevel(levelData:LevelData) : void
      {
         this.endLevel();
         this._cl = new Level(levelData);
         this._cl.setTest(true);
         this._cl.create();
      }
      
      public function startLevel(levelData:LevelData) : void
      {
         this.endLevel();
         this._cl = new Level(levelData);
         this._cl.create();
      }
      
      public function startUserLevel(levelId:String, levelData:LevelData) : void
      {
         this.endLevel();
         this._cl = new Level(levelData);
         this._cl.setUserLevel(levelId);
         this._cl.create();
      }
      
      public function startFirstAvailable() : void
      {
         var lev:int = 0;
         for(var i:int = 0; i < 25; i++)
         {
            if(LM.ins.cp.isLevelUnlocked(i))
            {
               lev = i;
            }
         }
         for(i = lev - 1; i >= 0; i--)
         {
            if(LM.ins.cp.getLevelHearts(i) != 0)
            {
               break;
            }
            lev = i;
         }
         this.startLevelNo(lev);
      }
      
      public function startLevelNo(no:int) : void
      {
         this.endLevel();
         var ld:LevelData = LevelInfos.ins.getLevel(no);
         this._cl = new Level(ld,no);
         this._cl.create();
      }
      
      public function replayLevelNo(no:int, replayNo:int) : void
      {
         this.endLevel();
         var ld:LevelData = LevelInfos.ins.getLevel(no);
         this._cl = new Level(ld,no);
         this._cl.setReplayNo(replayNo);
         this._cl.create();
      }
      
      public function startBonusLevel(name:String) : void
      {
         this.endLevel();
         if(name == BonusLevel.TOBYS_DREAM)
         {
            this._bl = new BL_Baby();
         }
         else if(name == BonusLevel.BILLYS_ADVENTURE)
         {
            this._bl = new BL_Kid();
         }
         else if(name == BonusLevel.ELDER_ROLLS)
         {
            this._bl = new BL_Elder();
         }
         this._bl.create();
      }
      
      public function replayBonusLevel(name:String, replayNo:int) : void
      {
         this.endLevel();
         if(name == BonusLevel.TOBYS_DREAM)
         {
            this._bl = new BL_Baby();
         }
         else if(name == BonusLevel.BILLYS_ADVENTURE)
         {
            this._bl = new BL_Kid();
         }
         else if(name == BonusLevel.ELDER_ROLLS)
         {
            this._bl = new BL_Elder();
         }
         this._bl.setReplayNo(replayNo);
         this._bl.create();
      }
      
      public function endLevel() : void
      {
         if(this._cl)
         {
            this._cl.remove();
         }
         this._cl = null;
         if(this._bl)
         {
            this._bl.remove();
         }
         this._bl = null;
      }
      
      public function get cl() : Level
      {
         return this._cl;
      }
      
      public function get bl() : BonusLevel
      {
         return this._bl;
      }
   }
}
