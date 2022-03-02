package Playtomic
{
   import flash.external.ExternalInterface;
   
   public final class Leaderboards
   {
      
      public static const TODAY:String = "today";
      
      public static const LAST7DAYS:String = "last7days";
      
      public static const LAST30DAYS:String = "last30days";
      
      public static const ALLTIME:String = "alltime";
      
      public static const NEWEST:String = "newest";
      
      private static var SECTION:String;
      
      private static var CREATEPRIVATELEADERBOARD:String;
      
      private static var LOADPRIVATELEADERBOARD:String;
      
      private static var SAVEANDLIST:String;
      
      private static var SAVE:String;
      
      private static var LIST:String;
       
      
      public function Leaderboards()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("leaderboards-" + apikey);
         CREATEPRIVATELEADERBOARD = Encode.MD5("leaderboards-createprivateleaderboard-" + apikey);
         LOADPRIVATELEADERBOARD = Encode.MD5("leaderboards-loadprivateleaderboard-" + apikey);
         SAVEANDLIST = Encode.MD5("leaderboards-saveandlist-" + apikey);
         SAVE = Encode.MD5("leaderboards-save-" + apikey);
         LIST = Encode.MD5("leaderboards-list-" + apikey);
      }
      
      public static function CreatePrivateLeaderboard(table:String, permalink:String, callback:Function = null, highest:Boolean = true) : void
      {
         var postdata:Object = new Object();
         postdata["table"] = table;
         postdata["highest"] = !!highest ? "y" : "n";
         postdata["permalink"] = permalink;
         Request.Load(SECTION,CREATEPRIVATELEADERBOARD,CreatePrivateLeaderboardComplete,callback,postdata);
      }
      
      private static function CreatePrivateLeaderboardComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var leaderboard:PrivateLeaderboard = null;
         if(response.Success)
         {
            leaderboard = new PrivateLeaderboard(data["tableid"],data["name"],data["bitly"],data["permalink"],data["highest"] == "true",data["realname"]);
         }
         callback(leaderboard,response);
         postdata = postdata;
      }
      
      public static function LoadPrivateLeaderboard(tableid:String, callback:Function = null) : void
      {
         var postdata:Object = new Object();
         postdata["tableid"] = tableid;
         Request.Load(SECTION,LOADPRIVATELEADERBOARD,LoadPrivateLeaderboardComplete,callback,postdata);
      }
      
      private static function LoadPrivateLeaderboardComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var leaderboard:PrivateLeaderboard = null;
         if(response.Success)
         {
            leaderboard = new PrivateLeaderboard(data["tableid"],data["name"],data["bitly"],data["permalink"],data["highest"] == "true",data["realname"]);
         }
         callback(leaderboard,response);
         postdata = postdata;
      }
      
      public static function GetLeaderboardFromUrl() : String
      {
         var url:String = null;
         var leaderboardid:String = null;
         if(!ExternalInterface.available)
         {
            return null;
         }
         try
         {
            url = String(ExternalInterface.call("window.location.href.toString"));
            if(url.indexOf("?") == -1)
            {
               return null;
            }
            leaderboardid = url.substring(url.indexOf("leaderboard=") + 12);
            if(leaderboardid.indexOf("&") > -1)
            {
               leaderboardid = leaderboardid.substring(0,leaderboardid.indexOf("&"));
            }
            if(leaderboardid.indexOf("#") > -1)
            {
               leaderboardid = leaderboardid.substring(0,leaderboardid.indexOf("#"));
            }
            return leaderboardid;
         }
         catch(s:Error)
         {
            return null;
         }
      }
      
      public static function SaveAndList(score:PlayerScore, table:String, callback:Function = null, options:Object = null) : void
      {
         var dkey:String = null;
         var fkey:String = null;
         if(options == null)
         {
            options = new Object();
         }
         var allowduplicates:Boolean = !!options.hasOwnProperty("allowduplicates") ? Boolean(options["allowduplicates"]) : Boolean(false);
         var global:Boolean = !!options.hasOwnProperty("global") ? Boolean(options["global"]) : Boolean(true);
         var highest:Boolean = !!options.hasOwnProperty("highest") ? Boolean(options["highest"]) : Boolean(true);
         var mode:String = !!options.hasOwnProperty("mode") ? options["mode"] : "alltime";
         var customfilters:Object = !!options.hasOwnProperty("customfilters") ? options["customfilters"] : {};
         var page:int = !!options.hasOwnProperty("page") ? int(options["page"]) : int(1);
         var perpage:int = !!options.hasOwnProperty("perpage") ? int(options["perpage"]) : int(20);
         var friendslist:Array = !!options.hasOwnProperty("friendslist") ? options["friendslist"] : new Array();
         var postdata:Object = new Object();
         postdata["url"] = Log.SourceUrl;
         postdata["table"] = table;
         postdata["highest"] = !!highest ? "y" : "n";
         postdata["name"] = score.Name;
         postdata["points"] = score.Points.toString();
         postdata["allowduplicates"] = !!allowduplicates ? "y" : "n";
         postdata["auth"] = Encode.MD5(Log.BaseUrl + score.Points.toString());
         var numfields:int = 0;
         if(score.CustomData != null)
         {
            for(postdata["ckey" + numfields] in score.CustomData)
            {
               postdata["cdata" + numfields] = score.CustomData[dkey];
               numfields++;
            }
         }
         postdata["numfields"] = numfields;
         postdata["global"] = !!global ? "y" : "n";
         postdata["mode"] = mode;
         postdata["page"] = page;
         postdata["perpage"] = perpage;
         var numfilters:int = 0;
         if(customfilters != null)
         {
            for(postdata["lkey" + numfilters] in customfilters)
            {
               postdata["ldata" + numfilters] = customfilters[fkey];
               numfilters++;
            }
         }
         postdata["numfilters"] = numfilters;
         if(score.FBUserId != null && score.FBUserId != "")
         {
            if(friendslist.length > 0)
            {
               postdata["friendslist"] = friendslist.join(",");
            }
            postdata["fbuserid"] = score.FBUserId;
         }
         Request.Load(SECTION,SAVEANDLIST,SaveAndListComplete,callback,postdata);
      }
      
      private static function SaveAndListComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         if(response.Success)
         {
            ProcessScores(data,response,callback);
         }
         else
         {
            callback([],0,response);
         }
         postdata = postdata;
      }
      
      public static function Save(score:PlayerScore, table:String, callback:Function = null, options:Object = null) : void
      {
         var key:String = null;
         if(options == null)
         {
            options = new Object();
         }
         var allowduplicates:Boolean = !!options.hasOwnProperty("allowduplicates") ? Boolean(options["allowduplicates"]) : Boolean(false);
         var highest:Boolean = !!options.hasOwnProperty("highest") ? Boolean(options["highest"]) : Boolean(true);
         var s:String = score.Points.toString();
         if(s.indexOf(".") > -1)
         {
            s = s.substring(0,s.indexOf("."));
         }
         var postdata:Object = new Object();
         var customfields:int = 0;
         if(score.CustomData != null)
         {
            for(postdata["ckey" + customfields] in score.CustomData)
            {
               postdata["cdata" + customfields] = score.CustomData[key];
               customfields++;
            }
         }
         postdata["url"] = Log.BaseUrl;
         postdata["table"] = table;
         postdata["highest"] = !!highest ? "y" : "n";
         postdata["name"] = score.Name;
         postdata["points"] = s;
         postdata["allowduplicates"] = !!allowduplicates ? "y" : "n";
         postdata["auth"] = Encode.MD5(Log.BaseUrl + s);
         postdata["fb"] = score.FBUserId != "" && score.FBUserId != null ? "y" : "n";
         postdata["fbuserid"] = score.FBUserId;
         postdata["customfields"] = customfields;
         Request.Load(SECTION,SAVE,SaveComplete,callback,postdata);
      }
      
      private static function SaveComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         data = data;
         postdata = postdata;
         callback(response);
      }
      
      public static function List(table:String, callback:Function, options:Object = null) : void
      {
         var key:String = null;
         if(options == null)
         {
            options = new Object();
         }
         var global:Boolean = !!options.hasOwnProperty("global") ? Boolean(options["global"]) : Boolean(true);
         var highest:Boolean = !!options.hasOwnProperty("highest") ? Boolean(options["highest"]) : Boolean(true);
         var mode:String = !!options.hasOwnProperty("mode") ? options["mode"] : "alltime";
         var customfilters:Object = !!options.hasOwnProperty("customfilters") ? options["customfilters"] : new Object();
         var page:int = !!options.hasOwnProperty("page") ? int(options["page"]) : int(1);
         var perpage:int = !!options.hasOwnProperty("perpage") ? int(options["perpage"]) : int(20);
         var facebook:Boolean = !!options.hasOwnProperty("facebook") ? Boolean(options["facebook"]) : Boolean(false);
         var friendslist:Array = !!options.hasOwnProperty("friendslist") ? options["friendslist"] : new Array();
         var postdata:Object = new Object();
         var numfilters:int = 0;
         for(postdata["ckey" + numfilters] in customfilters)
         {
            postdata["cdata" + numfilters] = customfilters[key];
            numfilters++;
         }
         postdata["url"] = global || Log.BaseUrl == null ? "global" : Log.BaseUrl;
         postdata["mode"] = mode;
         postdata["page"] = page;
         postdata["perpage"] = perpage;
         postdata["highest"] = !!highest ? "y" : "n";
         postdata["filters"] = numfilters;
         postdata["table"] = table;
         if(facebook)
         {
            if(friendslist.length > 0)
            {
               postdata["friendslist"] = friendslist.join(",");
            }
         }
         Request.Load(SECTION,LIST,ListComplete,callback,postdata);
      }
      
      private static function ListComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         if(response.Success)
         {
            ProcessScores(data,response,callback);
         }
         else
         {
            callback([],0,response);
         }
         postdata = postdata;
      }
      
      private static function ProcessScores(data:XML, response:Response, callback:Function) : void
      {
         var datestring:String = null;
         var year:int = 0;
         var month:int = 0;
         var day:int = 0;
         var item:XML = null;
         var score:PlayerScore = null;
         var custom:XMLList = null;
         var cfield:XML = null;
         var numscores:int = parseInt(data["numscores"]);
         var results:Array = new Array();
         var entries:XMLList = data["score"];
         for each(item in entries)
         {
            datestring = item["sdate"];
            year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
            month = int(datestring.substring(0,datestring.indexOf("/")));
            day = int(datestring.substring(datestring.indexOf("/") + 1).substring(0,2));
            score = new PlayerScore();
            score.SDate = new Date(year,month - 1,day);
            score.RDate = item["rdate"];
            score.Name = item["name"];
            score.Points = item["points"];
            score.Website = item["website"];
            score.Rank = item["rank"];
            if(item["submittedorbest"] != null)
            {
               score.SubmittedOrBest = item["submittedorbest"] == "true";
            }
            if(item["fbuserid"])
            {
               score.FBUserId = item["fbuserid"];
            }
            if(item["custom"])
            {
               custom = item["custom"];
               for each(cfield in custom.children())
               {
                  score.CustomData[cfield.name()] = cfield.text();
               }
            }
            results.push(score);
         }
         callback(results,numscores,response);
      }
   }
}
