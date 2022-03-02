package FGL.GameTracker
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.NetConnection;
   import flash.net.Responder;
   import flash.utils.Timer;
   
   public class GameTracker extends EventDispatcher
   {
      
      public static const GAMETRACKER_SERVER_ERROR:String = "gametracker_server_error";
      
      public static const GAMETRACKER_CODING_ERROR:String = "gametracker_coding_error";
      
      private static const TIMER_DELAY:int = 15000;
       
      
      protected var _timer:Timer = null;
      
      protected var _currentGame:int = 0;
      
      protected var _currentLevel:int = 0;
      
      protected var _inGame:Boolean = false;
      
      protected var _inLevel:Boolean = false;
      
      protected var _msg_queue:Array;
      
      protected var _conn:NetConnection = null;
      
      protected var _responder:Responder = null;
      
      protected var _sessionID:uint;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _serverVersionMajor:int = 0;
      
      protected var _serverVersionMinor:int = 0;
      
      protected var _hostUrl:String = "";
      
      protected var _serviceName:String = "";
      
      protected var _passphrase:String = "";
      
      public function GameTracker()
      {
         this._msg_queue = new Array();
         super();
         this.setGlobalConfig();
         if(this._isEnabled)
         {
            this._responder = new Responder(this.onSuccess,this.onNetworkingError);
            this._conn = new NetConnection();
            this._conn.connect(this._hostUrl);
            this._timer = new Timer(TIMER_DELAY);
            this._timer.addEventListener("timer",this.onTimer);
            this._timer.start();
            this._sessionID = Math.floor(new Date().getTime() / 1000);
            this.addToMsgQueue("begin_app",null,0,null,null);
         }
      }
      
      public function isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function beginGame(currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         if(this._inGame)
         {
            this.endGame(currentScore,currentGameState,"AUTO:(this game automatically ended when new game was started)");
         }
         ++this._currentGame;
         this._inGame = true;
         this.addToMsgQueue("begin_game",null,currentScore,currentGameState,customMsg);
      }
      
      public function endGame(currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         if(!this._inGame)
         {
            dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_CODING_ERROR,"endGame() called before beginGame() was called!"));
         }
         else
         {
            if(this._inLevel)
            {
               this.endLevel(currentScore,currentGameState,"AUTO:(this level automatically ended when game ended)");
            }
            this.addToMsgQueue("end_game",null,currentScore,currentGameState,customMsg);
            this._inGame = false;
            this.submitMsgQueue();
         }
      }
      
      public function beginLevel(newLevel:int, currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         if(!this._inGame)
         {
            dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_CODING_ERROR,"beginLevel() called before beginGame() was called!"));
         }
         else
         {
            if(this._inLevel)
            {
               this.endLevel(currentScore,currentGameState,"AUTO:(this level automatically ended when new level was started)");
            }
            this._currentLevel = newLevel;
            this._inLevel = true;
            this.addToMsgQueue("begin_level",null,currentScore,currentGameState,customMsg);
         }
      }
      
      public function endLevel(currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         if(!this._inLevel)
         {
            dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_CODING_ERROR,"endLevel() called before beginLevel() was called!"));
         }
         else
         {
            this._inLevel = false;
            this.addToMsgQueue("end_level",null,currentScore,currentGameState,customMsg);
         }
      }
      
      public function checkpoint(currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         if(!this._inGame)
         {
            dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_CODING_ERROR,"checkpoint() called before startGame() was called!"));
         }
         else
         {
            this.addToMsgQueue("checkpoint",null,currentScore,currentGameState,customMsg);
         }
      }
      
      public function alert(currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         this.addToMsgQueue("alert",null,currentScore,currentGameState,customMsg);
         this.submitMsgQueue();
      }
      
      public function customMsg(msgType:String, currentScore:Number = 0, currentGameState:String = null, customMsg:String = null) : void
      {
         this.addToMsgQueue("custom",msgType,currentScore,currentGameState,customMsg);
      }
      
      protected function addToMsgQueue(action:String, subaction:String, score:Number, gamestate:String, custom_msg:String) : void
      {
         var msg:Object = null;
         if(this._isEnabled)
         {
            msg = new Object();
            msg["action"] = action;
            msg["custom_action"] = subaction;
            msg["session_id"] = this._sessionID;
            msg["game_idx"] = this._currentGame;
            msg["level"] = this._currentLevel;
            msg["score"] = score;
            msg["game_state"] = gamestate;
            msg["time"] = Math.floor(new Date().getTime() / 1000);
            msg["msg"] = custom_msg;
            this._msg_queue.push(msg);
         }
      }
      
      protected function submitMsgQueue() : void
      {
         var obj:Object = null;
         if(this._isEnabled && this._msg_queue.length > 0)
         {
            obj = new Object();
            obj["actions"] = this._msg_queue;
            obj["identifier"] = this._passphrase;
            this._conn.call(this._serviceName,this._responder,obj);
            this._msg_queue = new Array();
         }
      }
      
      protected function setGlobalConfig() : void
      {
         var ret:Array = null;
         this._isEnabled = false;
         this._serverVersionMajor = 0;
         this._serverVersionMinor = 0;
         this._hostUrl = "";
         this._serviceName = "";
         this._passphrase = "";
         try
         {
            if(ExternalInterface.available)
            {
               ret = ExternalInterface.call("get_gametracker_info");
               this._serverVersionMajor = ret[0];
               this._serverVersionMinor = ret[1];
               this._hostUrl = ret[2];
               this._serviceName = ret[3];
               this._passphrase = ret[4];
               this._isEnabled = this._serverVersionMajor == 1;
            }
         }
         catch(e:*)
         {
         }
      }
      
      protected function onSuccess(evt:*) : void
      {
         if(evt.toString() != "")
         {
            dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_SERVER_ERROR,evt.toString()));
         }
      }
      
      protected function onNetworkingError(evt:*) : void
      {
         dispatchEvent(new GameTrackerErrorEvent(GAMETRACKER_SERVER_ERROR,"Networking error"));
      }
      
      protected function onTimer(evt:TimerEvent) : void
      {
         this.submitMsgQueue();
      }
   }
}
