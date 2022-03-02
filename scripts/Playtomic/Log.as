package Playtomic
{
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.system.Security;
   import flash.utils.Timer;
   
   public final class Log
   {
      
      private static var Enabled:Boolean = false;
      
      private static var Queue:Boolean = true;
      
      static var SWFID:int = 0;
      
      static var GUID:String = "";
      
      static var SourceUrl:String;
      
      static var BaseUrl:String;
      
      private static var Cookie:SharedObject;
      
      static var LogQueue:LogRequest;
      
      private static const PingF:Timer = new Timer(60000);
      
      private static const PingR:Timer = new Timer(30000);
      
      private static var FirstPing:Boolean = true;
      
      private static var Pings:int = 0;
      
      private static var Plays:int = 0;
      
      private static var Frozen:Boolean = false;
      
      private static var FrozenQueue:Array = new Array();
      
      private static var Customs:Array = new Array();
      
      private static var LevelCounters:Array = new Array();
      
      private static var LevelAverages:Array = new Array();
      
      private static var LevelRangeds:Array = new Array();
       
      
      public function Log()
      {
         super();
      }
      
      public static function View(swfid:int = 0, guid:String = "", apikey:String = "", defaulturl:String = "") : void
      {
         if(SWFID > 0)
         {
            return;
         }
         SWFID = swfid;
         GUID = guid;
         Enabled = true;
         if(SWFID == 0 || GUID == "")
         {
            Enabled = false;
            return;
         }
         if(defaulturl.indexOf("http://") != 0 && Security.sandboxType != "localWithNetwork" && Security.sandboxType != "localTrusted")
         {
            Enabled = false;
            return;
         }
         SourceUrl = GetUrl(defaulturl);
         if(SourceUrl == null || SourceUrl == "")
         {
            Enabled = false;
            return;
         }
         BaseUrl = SourceUrl.split("://")[1];
         BaseUrl = BaseUrl.substring(0,BaseUrl.indexOf("/"));
         Parse.Initialise(apikey);
         GeoIP.Initialise(apikey);
         Data.Initialise(apikey);
         Leaderboards.Initialise(apikey);
         GameVars.Initialise(apikey);
         PlayerLevels.Initialise(apikey);
         Request.Initialise();
         LogQueue = LogRequest.Create();
         Cookie = SharedObject.getLocal("playtomic");
         Security.loadPolicyFile("http://g" + guid + ".api.playtomic.com/crossdomain.xml");
         var views:int = GetCookie("views");
         Send("v/" + (views + 1),true);
         PingF.addEventListener(TimerEvent.TIMER,PingServer);
         PingF.start();
      }
      
      static function IncreaseViews() : void
      {
         var views:int = GetCookie("views");
         views++;
         SaveCookie("views",views);
      }
      
      static function IncreasePlays() : void
      {
         ++Plays;
      }
      
      public static function Play() : void
      {
         if(!Enabled)
         {
            return;
         }
         LevelCounters = new Array();
         LevelAverages = new Array();
         LevelRangeds = new Array();
         Send("p/" + (Plays + 1),true);
      }
      
      private static function PingServer(e:TimerEvent) : void
      {
         if(!Enabled)
         {
            return;
         }
         ++Pings;
         Send("t/" + (!!FirstPing ? "y" : "n") + "/" + Pings,true);
         if(FirstPing)
         {
            PingF.stop();
            PingR.addEventListener(TimerEvent.TIMER,PingServer);
            PingR.start();
            FirstPing = false;
         }
      }
      
      public static function CustomMetric(name:String, group:String = null, unique:Boolean = false) : void
      {
         if(!Enabled)
         {
            return;
         }
         if(group == null)
         {
            group = "";
         }
         if(unique)
         {
            if(Customs.indexOf(name) > -1)
            {
               return;
            }
            Customs.push(name);
         }
         Send("c/" + Clean(name) + "/" + Clean(group));
      }
      
      public static function LevelCounterMetric(name:String, level:*, unique:Boolean = false) : void
      {
         var key:String = null;
         if(!Enabled)
         {
            return;
         }
         if(unique)
         {
            key = name + "." + (level as String);
            if(LevelCounters.indexOf(key) > -1)
            {
               return;
            }
            LevelCounters.push(key);
         }
         Send("lc/" + Clean(name) + "/" + Clean(level));
      }
      
      public static function LevelRangedMetric(name:String, level:*, value:int, unique:Boolean = false) : void
      {
         var key:String = null;
         if(!Enabled)
         {
            return;
         }
         if(unique)
         {
            key = name + "." + (level as String);
            if(LevelRangeds.indexOf(key) > -1)
            {
               return;
            }
            LevelRangeds.push(key);
         }
         Send("lr/" + Clean(name) + "/" + Clean(level) + "/" + value);
      }
      
      public static function LevelAverageMetric(name:String, level:*, value:int, unique:Boolean = false) : void
      {
         var key:String = null;
         if(!Enabled)
         {
            return;
         }
         if(unique)
         {
            key = name + "." + (level as String);
            if(LevelAverages.indexOf(key) > -1)
            {
               return;
            }
            LevelAverages.push(key);
         }
         Send("la/" + Clean(name) + "/" + Clean(level) + "/" + value);
      }
      
      static function Link(url:String, name:String, group:String, unique:int, total:int, fail:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("l/" + Clean(name) + "/" + Clean(group) + "/" + Clean(url) + "/" + unique + "/" + total + "/" + fail);
      }
      
      public static function Heatmap(metric:String, heatmap:String, x:int, y:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("h/" + Clean(metric) + "/" + Clean(heatmap) + "/" + x + "/" + y);
      }
      
      static function Funnel(name:String, step:String, stepnum:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("f/" + Clean(name) + "/" + Clean(step) + "/" + stepnum);
      }
      
      static function PlayerLevelStart(levelid:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("pls/" + levelid);
      }
      
      static function PlayerLevelWin(levelid:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plw/" + levelid);
      }
      
      static function PlayerLevelQuit(levelid:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plq/" + levelid);
      }
      
      static function PlayerLevelFlag(levelid:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plf/" + levelid);
      }
      
      static function PlayerLevelRetry(levelid:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plr/" + levelid);
      }
      
      public static function Freeze() : void
      {
         Frozen = true;
      }
      
      public static function UnFreeze() : void
      {
         Frozen = false;
         LogQueue.MassQueue(FrozenQueue);
      }
      
      public static function ForceSend() : void
      {
         if(!Enabled)
         {
            return;
         }
         if(LogQueue == null)
         {
            LogQueue = LogRequest.Create();
         }
         LogQueue.Send();
         LogQueue = LogRequest.Create();
         if(FrozenQueue.length > 0)
         {
            LogQueue.MassQueue(FrozenQueue);
         }
      }
      
      private static function Send(s:String, view:Boolean = false) : void
      {
         if(Frozen)
         {
            FrozenQueue.push(s);
            return;
         }
         LogQueue.Queue(s);
         if(LogQueue.ready || view || !Queue)
         {
            LogQueue.Send();
            LogQueue = LogRequest.Create();
         }
      }
      
      private static function Clean(s:String) : String
      {
         while(s.indexOf("/") > -1)
         {
            s = s.replace("/","\\");
         }
         while(s.indexOf("~") > -1)
         {
            s = s.replace("~","-");
         }
         return escape(s);
      }
      
      private static function GetCookie(n:String) : int
      {
         if(Cookie.data[n] == undefined)
         {
            return 0;
         }
         return int(Cookie.data[n]);
      }
      
      private static function SaveCookie(n:String, v:int) : void
      {
         Cookie.data[n] = v.toString();
         try
         {
            Cookie.flush();
         }
         catch(s:Error)
         {
         }
      }
      
      private static function GetUrl(defaulturl:String) : String
      {
         var url:String = null;
         if(ExternalInterface.available)
         {
            try
            {
               url = String(ExternalInterface.call("window.location.href.toString"));
            }
            catch(s:Error)
            {
               url = defaulturl;
            }
         }
         else if(defaulturl.indexOf("http://") == 0 || defaulturl.indexOf("https://") == 0)
         {
            url = defaulturl;
         }
         if(url == null || url == "" || url == "null")
         {
            if(Security.sandboxType == "localWithNetwork" || Security.sandboxType == "localTrusted")
            {
               url = "http://localhost/";
            }
            else
            {
               url = null;
            }
         }
         if(url.indexOf("http://") != 0)
         {
            url = "http://localhost/";
         }
         return url;
      }
   }
}
