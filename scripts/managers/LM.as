package managers
{
   import design.data.LevelData;
   import flash.net.SharedObject;
   import game.LevelInfos;
   import game.Player;
   import game.Stats;
   
   public class LM
   {
      
      private static var _ins:LM;
       
      
      protected var _so:SharedObject;
      
      protected var _lastSave:LevelData;
      
      protected var _cp:Player;
      
      protected var _list:Vector.<LevelData>;
      
      protected var _players:Vector.<Player>;
      
      protected var _timer:Number;
      
      protected var _lastTime:Number;
      
      public function LM()
      {
         super();
      }
      
      public static function get ins() : LM
      {
         if(!_ins)
         {
            _ins = new LM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         var ld:LevelData = null;
         var data:String = null;
         var lev:LevelData = null;
         var obj:Object = null;
         var pl:Player = null;
         this._list = new Vector.<LevelData>();
         this._players = new Vector.<Player>();
         this._timer = 0;
         this._lastTime = 0;
         var i:int = 0;
         this._so = SharedObject.getLocal(Constants.LEVEL_DATA_LOC,Constants.LOCAL_PATH);
         if(!this._so.data || this._so.data && !this._so.data.list)
         {
            trace("got the level data from backup.");
            this._so = SharedObject.getLocal(Constants.LEVEL_DATA_LOC);
         }
         if(this._so.data && this._so.data.list)
         {
            for(i = 0; i < this._so.data.list.length; i++)
            {
               ld = new LevelData();
               data = this._so.data.list[i];
               ld.loadLevelFromString(data);
               this._list.push(ld);
            }
         }
         var clearLevels:Boolean = false;
         var copyLevels:Boolean = false;
         if(clearLevels)
         {
            this._list = new Vector.<LevelData>();
         }
         if(copyLevels)
         {
            for(i = 0; i < LevelInfos.ins.list.length; i++)
            {
               lev = LevelInfos.ins.list[i];
               this._list.push(lev);
            }
         }
         if(clearLevels || copyLevels)
         {
            this.saveLevels();
         }
         if(this._so.data && this._so.data.lastSave)
         {
            this._lastSave = new LevelData();
            this._lastSave.loadLevelFromString(this._so.data.lastSave);
         }
         this._so.close();
         this._so = SharedObject.getLocal(Constants.PLAYER_SAVE_LOC,Constants.LOCAL_PATH);
         if(!this._so.data || this._so.data && !this._so.data.list)
         {
            trace("got the player data from backup.");
            this._so = SharedObject.getLocal(Constants.PLAYER_SAVE_LOC);
         }
         if(this._so.data && this._so.data.list)
         {
            for(i = 0; i < this._so.data.list.length; i++)
            {
               obj = this._so.data.list[i];
               pl = new Player(obj.name,obj.hearts,obj.special,obj.memories,obj.messages,obj.statistics,obj.hideSkip,obj.isIntroPlayed,obj.soundSettings,obj.bonusSeen);
               this._players.push(pl);
            }
         }
         if(this._so.data && this._so.data.lastPlayer)
         {
            this.choosePlayerByName(this._so.data.lastPlayer);
         }
         this._so.close();
      }
      
      public function update() : void
      {
         if(this._cp)
         {
            this._timer += Constants.DT;
            if(this._timer > this._lastTime + 60)
            {
               this._lastTime = this._timer;
               this._cp.addPlayedTime();
            }
         }
      }
      
      public function getLastSave() : LevelData
      {
         return this._lastSave;
      }
      
      public function setLastSave(ld:LevelData) : void
      {
         this._lastSave = ld.clone();
         this.saveLevels();
      }
      
      public function addLevel(ld:LevelData) : void
      {
         this._list.push(ld);
         this.saveLevels();
      }
      
      public function overwrite(id:int, ld:LevelData) : void
      {
         if(this._list.length < id - 1)
         {
            return;
         }
         this._list[id] = ld;
         this.saveLevels();
      }
      
      public function changeNameOfLevelById(id:int, newName:String) : void
      {
         if(this._list.length < id - 1)
         {
            return;
         }
         this._list[id].setLevelName(newName);
         this.saveLevels();
      }
      
      public function moveLevelUpById(id:int) : void
      {
         if(this._list.length < id - 1 || id == 0)
         {
            return;
         }
         var temp:LevelData = this._list[id - 1];
         this._list[id - 1] = this._list[id];
         this._list[id] = temp;
      }
      
      public function moveLevelDownById(id:int) : void
      {
         if(id > this._list.length - 2 || id < 0)
         {
            return;
         }
         var temp:LevelData = this._list[id + 1];
         this._list[id + 1] = this._list[id];
         this._list[id] = temp;
      }
      
      public function removeLevelById(id:int) : void
      {
         if(this._list.length < id - 1)
         {
            return;
         }
         this._list.splice(id,1);
         this.saveLevels();
      }
      
      public function saveLevels() : void
      {
         var i:int = 0;
         this._so = SharedObject.getLocal(Constants.LEVEL_DATA_LOC,Constants.LOCAL_PATH);
         var arr:Array = [];
         for(i = 0; i < this._list.length; i++)
         {
            arr.push(this._list[i].convertToString());
         }
         this._so.data.list = arr;
         if(this._lastSave)
         {
            this._so.data.lastSave = this._lastSave.convertToString();
         }
         this._so.flush();
         this._so.close();
      }
      
      public function addPlayer(p:Player) : void
      {
         this._players.push(p);
         this.savePlayers();
      }
      
      public function removePlayerById(id:int) : void
      {
         if(this._players.length <= id)
         {
            return;
         }
         var p:Player = this._players.splice(id,1)[0] as Player;
         if(this._cp == p)
         {
            this._cp = null;
            p = null;
         }
         this.savePlayers();
      }
      
      public function choosePlayer(p:Player) : void
      {
         Tracking.beginGame(0,null,p.name + " has started playing.");
         var i:int = 0;
         for(i = 0; i < this._players.length; i++)
         {
            if(this._players[i] == p)
            {
               this._cp = this._players[i];
               break;
            }
         }
         SM.ins.setup(this._cp.soundSettings);
         this.savePlayers();
         var time:Number = this._cp.getStatistic(Stats.STAT_PLAYED_TIME);
         trace("asd");
         if(time && time > 0)
         {
            this._timer = time;
         }
         else
         {
            this._timer = 0;
            this._lastTime = 0;
         }
      }
      
      public function choosePlayerByName(name:String) : void
      {
         var i:int = 0;
         for(i = 0; i < this._players.length; i++)
         {
            if(this._players[i].name == name)
            {
               this.choosePlayer(this._players[i]);
               break;
            }
         }
      }
      
      public function savePlayers() : void
      {
         var i:int = 0;
         var obj:Object = null;
         this._so = SharedObject.getLocal(Constants.PLAYER_SAVE_LOC,Constants.LOCAL_PATH);
         var arr:Array = [];
         for(i = 0; i < this._players.length; i++)
         {
            obj = new Object();
            obj.name = this._players[i].name;
            obj.hearts = this._players[i].hearts;
            obj.special = this._players[i].special;
            obj.memories = this._players[i].memories;
            obj.messages = this._players[i].messages;
            obj.statistics = this._players[i].statistics;
            obj.hideSkip = this._players[i].hideSkip;
            obj.isIntroPlayed = this._players[i].isIntroPlayed;
            obj.soundSettings = this._players[i].soundSettings;
            obj.bonusSeen = this._players[i].bonusSeen;
            arr.push(obj);
         }
         this._so.data.list = arr;
         if(this._cp)
         {
            this._so.data.lastPlayer = this._cp.name;
         }
         else
         {
            this._so.data.lastPlayer = null;
         }
         this._so.flush();
         this._so.close();
      }
      
      public function get list() : Vector.<LevelData>
      {
         return this._list;
      }
      
      public function get cp() : Player
      {
         return this._cp;
      }
      
      public function get players() : Vector.<Player>
      {
         return this._players;
      }
   }
}
