package game
{
   import design.data.DO_UnitData;
   import game.bonus.BonusLevel;
   import managers.LM;
   
   public class Player
   {
       
      
      protected var _name:String;
      
      protected var _hearts:Array;
      
      protected var _special:Array;
      
      protected var _memories:Array;
      
      protected var _messages:Array;
      
      protected var _bonusSeen:Array;
      
      protected var _statistics:Object;
      
      protected var _hideSkip:Boolean;
      
      protected var _isIntroPlayed:Boolean;
      
      protected var _soundSettings:Object;
      
      public function Player(name:String, hearts:Array = null, special:Array = null, memories:Array = null, messages:Array = null, statistics:Object = null, hideSkip:Boolean = false, isIntroPlayed:Boolean = false, soundSettings:Object = null, bonusSeen:Array = null)
      {
         var i:int = 0;
         super();
         this._name = name;
         this._hideSkip = hideSkip;
         this._isIntroPlayed = isIntroPlayed;
         this._hearts = [];
         this._messages = [];
         this._memories = [];
         this._special = [];
         this._bonusSeen = [];
         this._soundSettings = soundSettings;
         if(hearts == null)
         {
            for(i = 0; i < 25; i++)
            {
               this._hearts.push(0);
            }
         }
         else
         {
            for(i = 0; i < hearts.length; i++)
            {
               this._hearts.push(hearts[i]);
            }
         }
         if(bonusSeen == null)
         {
            for(i = 0; i < 3; i++)
            {
               this._bonusSeen.push(false);
            }
         }
         else
         {
            for(i = 0; i < 3; i++)
            {
               this._bonusSeen.push(bonusSeen[i]);
            }
         }
         if(name == "WalterGreer")
         {
            this.unlockLevels();
         }
         if(special == null)
         {
            for(i = 0; i < 5; i++)
            {
               this._special.push(0);
            }
         }
         else
         {
            for(i = 0; i < special.length; i++)
            {
               this._special.push(special[i]);
            }
         }
         if(memories != null)
         {
            for(i = 0; i < memories.length; i++)
            {
               this._memories.push(memories[i]);
            }
         }
         if(messages != null)
         {
            for(i = 0; i < messages.length; i++)
            {
               this._messages.push(messages[i]);
            }
         }
         if(statistics == null)
         {
            this._statistics = new Object();
         }
         else
         {
            this._statistics = statistics;
         }
         hearts = null;
         special = null;
         memories = null;
         messages = null;
         bonusSeen = null;
      }
      
      public function initKong() : void
      {
         if(Main.k && Main.k.stats)
         {
            Main.k.stats.submit("HeartsCollected",this.getTotalHearts());
            Main.k.stats.submit("LevelCompleted",this._statistics[Stats.STAT_LEVEL_COMPLETED]);
            Main.k.stats.submit("MemoriesUnlocked",this._memories.length);
         }
      }
      
      public function unlockLevels() : void
      {
         var i:int = 0;
         for(i = 0; i < this._hearts.length; this._hearts[i] = 3,i++)
         {
         }
      }
      
      public function getTotalHearts() : int
      {
         var total:int = 0;
         for(var i:int = 0; i < this._hearts.length; i++)
         {
            total += this._hearts[i];
         }
         return total;
      }
      
      public function isLevelUnlocked(levNo:int) : Boolean
      {
         if(this.getTotalHearts() >= this.getLevelHeartsNeeded(levNo))
         {
            return true;
         }
         return false;
      }
      
      public function getLevelHeartsNeeded(levNo:int) : int
      {
         return levNo * 2;
      }
      
      public function isSpecialUnlocked(speNo:int) : Boolean
      {
         if(this.getTotalHearts() >= this.getSpecialHeartsNeeded(speNo))
         {
            return true;
         }
         return false;
      }
      
      public function getSpecialHeartsNeeded(speNo:int) : int
      {
         if(speNo == 0)
         {
            return 15;
         }
         if(speNo == 1)
         {
            return 35;
         }
         if(speNo == 2)
         {
            return 65;
         }
         return 0;
      }
      
      public function isBonusSeen(no:int) : Boolean
      {
         if(no > this._bonusSeen.length - 1)
         {
            return false;
         }
         return this._bonusSeen[no];
      }
      
      public function setBonusSeen(no:int, bool:Boolean) : void
      {
         if(no > this._bonusSeen.length - 1)
         {
            return;
         }
         this._bonusSeen[no] = bool;
      }
      
      public function setLevelHearts(levNo:int, hearts:int) : void
      {
         if(this._hearts[levNo] < hearts)
         {
            this._hearts[levNo] = hearts;
            LM.ins.savePlayers();
         }
         if(Main.k && Main.k.stats)
         {
            Main.k.stats.submit("HeartsCollected",this.getTotalHearts());
         }
      }
      
      public function getLevelHearts(levNo:int) : int
      {
         return this._hearts[levNo];
      }
      
      public function setSpecialHearts(speNo:int, hearts:int) : void
      {
         if(hearts > this._special[speNo])
         {
            this._special[speNo] = hearts;
         }
         LM.ins.savePlayers();
         if(Main.k && Main.k.stats)
         {
            if(speNo == 0)
            {
               Main.k.stats.submit("TobysDream",hearts);
            }
            else if(speNo == 1)
            {
               Main.k.stats.submit("BillysAdventure",hearts);
            }
            else if(speNo == 2)
            {
               Main.k.stats.submit("ElderRolls",hearts);
            }
         }
      }
      
      public function getSpecialHearts(speNo:int) : int
      {
         return this._special[speNo];
      }
      
      public function isMemorySaved(memId:int) : Boolean
      {
         for(var i:int = 0; i < this._memories.length; i++)
         {
            if(memId == this._memories[i])
            {
               return true;
            }
         }
         return false;
      }
      
      public function numberOfMemoriesSaved() : int
      {
         return this._memories.length;
      }
      
      public function addMemory(memId:int) : void
      {
         if(this.isMemorySaved(memId))
         {
            return;
         }
         this._memories.push(memId);
         LM.ins.savePlayers();
         Memory.reward(memId);
         var mem:Memory = Memory.getMemory(memId);
         var exp:String = "";
         if(mem)
         {
            exp = mem.title;
         }
         Tracking.customMessage("MEMORY",this.getTotalHearts(),null,memId.toString() + " :" + mem);
         if(Main.k && Main.k.stats)
         {
            Main.k.stats.submit("MemoriesUnlocked",this._memories.length);
         }
      }
      
      public function messageUnlockNeeded(messageNo:int) : int
      {
         return messageNo * 10;
      }
      
      public function isMessageUnlocked(messageNo:int) : Boolean
      {
         if(this.getTotalHearts() >= this.messageUnlockNeeded(messageNo))
         {
            return true;
         }
         return false;
      }
      
      public function isMessageRead(messageNo:int) : Boolean
      {
         if(this._messages.length < messageNo + 1)
         {
            return false;
         }
         return this._messages[messageNo];
      }
      
      public function isAnyMessageUnread() : Boolean
      {
         for(var i:int = 0; i < this._messages.length; i++)
         {
            if(!this._messages[i])
            {
               return true;
            }
         }
         if(this.isMessageUnlocked(this._messages.length))
         {
            return true;
         }
         return false;
      }
      
      public function setMessageRead(messageNo:int, val:Boolean = true) : void
      {
         while(this._messages.length < messageNo + 1)
         {
            this._messages.push(false);
         }
         this._messages[messageNo] = val;
         LM.ins.savePlayers();
      }
      
      public function setLevelsCompleted(val:int) : void
      {
         var old:int = this._statistics[Stats.STAT_LEVEL_COMPLETED];
         if(old < val)
         {
            this._statistics[Stats.STAT_LEVEL_COMPLETED] = val;
         }
         if(val == 1)
         {
            this.addMemory(Memory.BEAT_IT);
         }
         else if(val == 6)
         {
            this.addMemory(Memory.PIECE_OF_CAKE);
         }
         else if(val == 12)
         {
            this.addMemory(Memory.INTERESTING);
         }
         else if(val == 18)
         {
            this.addMemory(Memory.MOAR_PLEASE);
         }
         else if(val == 25)
         {
            this.addMemory(Memory.FINISH_IT);
         }
         if(Main.k && Main.k.stats)
         {
            Main.k.stats.submit("LevelCompleted",val);
         }
      }
      
      public function addSeekerDeath() : void
      {
         var old:int = this._statistics[Stats.STAT_SEEKER_DEATH];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_SEEKER_DEATH] = val;
         if(val == 25)
         {
            this.addMemory(Memory.ACROBATIC);
         }
      }
      
      public function addLevelDeath(levNo:int) : void
      {
         var old:int = this._statistics[Stats.STAT_LEVEL_DEATH + levNo.toString()];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_LEVEL_DEATH + levNo.toString()] = val;
         if(val == 3)
         {
            this.addMemory(Memory.GETTING_UGLY);
         }
         else if(val == 6)
         {
            this.addMemory(Memory.NOT_AGAIN);
         }
         else if(val == 10)
         {
            this.addMemory(Memory.THIS_GAME_SUCKS);
         }
      }
      
      public function addUnitSaved() : void
      {
         var old:int = this._statistics[Stats.STAT_UNIT_SAVED];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_UNIT_SAVED] = val;
         if(val == 10)
         {
            this.addMemory(Memory.SAVE_ME);
         }
         else if(val == 25)
         {
            this.addMemory(Memory.HUG_ME);
         }
         else if(val == 50)
         {
            this.addMemory(Memory.LOVE_ME);
         }
      }
      
      public function setSwingTime(val:Number) : void
      {
         var old:Number = this._statistics[Stats.STAT_LONGEST_SWING_TIME];
         if(!old || old < val)
         {
            this._statistics[Stats.STAT_LONGEST_SWING_TIME] = val;
         }
         var oldTotal:Number = this._statistics[Stats.STAT_TOTAL_SWING_TIME];
         if(!oldTotal)
         {
            oldTotal = 0;
         }
         var valTotal:Number = oldTotal + val;
         this._statistics[Stats.STAT_TOTAL_SWING_TIME] = valTotal;
         if(val >= 10)
         {
            this.addMemory(Memory.LETS_SWING);
         }
      }
      
      public function setLevelTested() : void
      {
         this._statistics[Stats.STAT_LEVEL_TESTED] = true;
         this.addMemory(Memory.FAMOUS);
      }
      
      public function trackMember(member:String) : void
      {
         var old:int = this._statistics[Stats.STAT_UNIT_ENCOUNTER + "_" + member];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_UNIT_ENCOUNTER + "_" + member] = val;
         if(val == 1)
         {
            if(member == DO_UnitData.BABY)
            {
               this.addMemory(Memory.TOBY_THE_BABY);
            }
            else if(member == DO_UnitData.KID)
            {
               this.addMemory(Memory.BILLY_THE_KID);
            }
            else if(member == DO_UnitData.MOM)
            {
               this.addMemory(Memory.SIDNEY_MY_HONEY);
            }
            else if(member == DO_UnitData.ELDER)
            {
               this.addMemory(Memory.GREER_THE_ELDER);
            }
         }
      }
      
      public function addOutOfBounds() : void
      {
         var old:int = this._statistics[Stats.STAT_OUT_OF_BOUNDS];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_OUT_OF_BOUNDS] = val;
         if(val == 5)
         {
            this.addMemory(Memory.FREEDOM);
         }
      }
      
      public function setNotTouchingTime(val:Number) : void
      {
         var old:Number = this._statistics[Stats.STAT_LONGEST_ON_AIR_TIME];
         if(!old || old < val)
         {
            this._statistics[Stats.STAT_LONGEST_ON_AIR_TIME] = val;
         }
         var oldTotal:Number = this._statistics[Stats.STAT_TOTAL_ON_AIR_TIME];
         if(!oldTotal)
         {
            oldTotal = 0;
         }
         var valTotal:Number = oldTotal + val;
         this._statistics[Stats.STAT_TOTAL_ON_AIR_TIME] = valTotal;
         if(val >= 10)
         {
            this.addMemory(Memory.I_BELIEVE);
         }
      }
      
      public function addLaserShot() : void
      {
         var old:int = this._statistics[Stats.STAT_LASER_SHOT];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_LASER_SHOT] = val;
         if(val == 100)
         {
            this.addMemory(Memory.LASER_TAG);
         }
      }
      
      public function addUBODeath() : void
      {
         var old:int = this._statistics[Stats.STAT_UBO_DEATH];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_UBO_DEATH] = val;
         if(val == 10)
         {
            this.addMemory(Memory.UBO);
         }
      }
      
      public function addTrapDeath() : void
      {
         var old:int = this._statistics[Stats.STAT_TRAP_DEATH];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_TRAP_DEATH] = val;
         if(val == 10)
         {
            this.addMemory(Memory.TRAPPED);
         }
      }
      
      public function addHeartsCollected() : void
      {
         var old:int = this._statistics[Stats.STAT_HEARTS_COLLECTED];
         if(!old)
         {
            old = 0;
         }
         var val:int = old + 1;
         this._statistics[Stats.STAT_HEARTS_COLLECTED] = val;
         if(val == 15)
         {
            this.addMemory(Memory.BROKEN_HEART);
         }
         if(val == 75)
         {
            this.addMemory(Memory.FIXED_HEART);
         }
      }
      
      public function addPlayedTime(val:Number = 60) : void
      {
         var old:Number = this._statistics[Stats.STAT_PLAYED_TIME];
         if(!old)
         {
            old = 0;
         }
         var newVal:Number = old + val;
         this._statistics[Stats.STAT_PLAYED_TIME] = newVal;
         if(newVal >= 600)
         {
            this.addMemory(Memory.TEN_MINUTES);
         }
         if(newVal >= 1800)
         {
            this.addMemory(Memory.THIRTY_MINUTES);
         }
         if(newVal >= 3600)
         {
            this.addMemory(Memory.AN_HOUR);
         }
      }
      
      public function setBLCollected(blType:String, val:int) : void
      {
         var most:String = null;
         var total:String = null;
         if(blType == BonusLevel.TOBYS_DREAM)
         {
            most = Stats.STAT_MOST_TD_COLLECTED;
            total = Stats.STAT_TOTAL_TD_COLLECTED;
         }
         else if(blType == BonusLevel.ELDER_ROLLS)
         {
            most = Stats.STAT_MOST_ER_COLLECTED;
            total = Stats.STAT_TOTAL_ER_COLLECTED;
         }
         else if(blType == BonusLevel.BILLYS_ADVENTURE)
         {
            most = Stats.STAT_MOST_BA_COLLECTED;
            total = Stats.STAT_TOTAL_BA_COLLECTED;
         }
         var old:int = this._statistics[most];
         if(!old || old < val)
         {
            this._statistics[most] = val;
         }
         var oldTotal:int = this._statistics[total];
         if(!oldTotal)
         {
            oldTotal = 0;
         }
         var valTotal:int = oldTotal + val;
         this._statistics[total] = valTotal;
         if(val >= 15)
         {
            if(blType == BonusLevel.TOBYS_DREAM)
            {
               this.addMemory(Memory.TD_15);
            }
            else if(blType == BonusLevel.BILLYS_ADVENTURE)
            {
               this.addMemory(Memory.BA_15);
            }
            else if(blType == BonusLevel.ELDER_ROLLS)
            {
               this.addMemory(Memory.ER_15);
            }
         }
         if(val >= 30)
         {
            if(blType == BonusLevel.TOBYS_DREAM)
            {
               this.addMemory(Memory.TD_30);
            }
            else if(blType == BonusLevel.BILLYS_ADVENTURE)
            {
               this.addMemory(Memory.BA_30);
            }
            else if(blType == BonusLevel.ELDER_ROLLS)
            {
               this.addMemory(Memory.ER_30);
            }
         }
         if(val >= 45)
         {
            if(blType == BonusLevel.TOBYS_DREAM)
            {
               this.addMemory(Memory.TD_45);
            }
            else if(blType == BonusLevel.BILLYS_ADVENTURE)
            {
               this.addMemory(Memory.BA_45);
            }
            else if(blType == BonusLevel.ELDER_ROLLS)
            {
               this.addMemory(Memory.ER_45);
            }
         }
      }
      
      public function setPatient() : void
      {
         this.addMemory(Memory.PATIENT);
      }
      
      public function setErrorGot() : void
      {
         this.addMemory(Memory.DEBUGGING);
      }
      
      public function setCurious() : void
      {
         this.addMemory(Memory.CURIOUS);
      }
      
      public function setSkip(bool:Boolean) : void
      {
         this._hideSkip = bool;
      }
      
      public function setIntroPlayed(bool:Boolean) : void
      {
         this._isIntroPlayed = bool;
      }
      
      public function getStatistic(statisticsName:String) : *
      {
         return this._statistics[statisticsName];
      }
      
      public function setSoundSettings(settings:Object) : void
      {
         this._soundSettings = settings;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get hearts() : Array
      {
         return this._hearts;
      }
      
      public function get special() : Array
      {
         return this._special;
      }
      
      public function get memories() : Array
      {
         return this._memories;
      }
      
      public function get statistics() : Object
      {
         return this._statistics;
      }
      
      public function get messages() : Array
      {
         return this._messages;
      }
      
      public function get hideSkip() : Boolean
      {
         return this._hideSkip;
      }
      
      public function get isIntroPlayed() : Boolean
      {
         return this._isIntroPlayed;
      }
      
      public function get soundSettings() : Object
      {
         return this._soundSettings;
      }
      
      public function get bonusSeen() : Array
      {
         return this._bonusSeen;
      }
   }
}
