package Playtomic
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.net.SharedObject;
   
   public final class PlayerLevels
   {
      
      public static const NEWEST:String = "newest";
      
      public static const POPULAR:String = "popular";
      
      private static var KongAPI = null;
      
      private static var KongLevelReceiver:Function;
      
      private static var SECTION:String;
      
      private static var SAVE:String;
      
      private static var LIST:String;
      
      private static var LOAD:String;
      
      private static var RATE:String;
       
      
      public function PlayerLevels()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("playerlevels-" + apikey);
         RATE = Encode.MD5("playerlevels-rate-" + apikey);
         LIST = Encode.MD5("playerlevels-list-" + apikey);
         SAVE = Encode.MD5("playerlevels-save-" + apikey);
         LOAD = Encode.MD5("playerlevels-load-" + apikey);
      }
      
      public static function DeferToKongregate(kongapi:*, levelreceiver:Function) : void
      {
         KongLevelReceiver = levelreceiver;
         KongAPI = kongapi;
         KongAPI.sharedContent.addLoadListener("level",KongLevelLoaded);
      }
      
      public static function LogStart(levelid:String) : void
      {
         Log.PlayerLevelStart(levelid);
      }
      
      public static function LogWin(levelid:String) : void
      {
         Log.PlayerLevelWin(levelid);
      }
      
      public static function LogQuit(levelid:String) : void
      {
         Log.PlayerLevelQuit(levelid);
      }
      
      public static function LogRetry(levelid:String) : void
      {
         Log.PlayerLevelRetry(levelid);
      }
      
      public static function Flag(levelid:String) : void
      {
         Log.PlayerLevelFlag(levelid);
      }
      
      public static function Rate(levelid:String, rating:int, callback:Function = null) : void
      {
         var cookie:SharedObject = SharedObject.getLocal("ratings");
         if(cookie.data[levelid] != null)
         {
            if(callback != null)
            {
               callback(new Response(0,402));
            }
            return;
         }
         if(rating < 0 || rating > 10)
         {
            if(callback != null)
            {
               callback(new Response(0,401));
            }
            return;
         }
         var postdata:Object = new Object();
         postdata["levelid"] = levelid;
         postdata["rating"] = rating;
         cookie.data[levelid] = rating;
         Request.Load(SECTION,RATE,RateComplete,callback,postdata);
      }
      
      private static function RateComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         callback(response);
         data = data;
         postdata = postdata;
      }
      
      public static function Load(levelid:String, callback:Function = null) : void
      {
         var postdata:Object = new Object();
         postdata["levelid"] = levelid;
         Request.Load(SECTION,LOAD,LoadComplete,callback,postdata);
      }
      
      private static function LoadComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var item:XML = null;
         var datestring:String = null;
         var year:int = 0;
         var month:int = 0;
         var day:int = 0;
         var custom:XMLList = null;
         var cfield:XML = null;
         if(callback == null)
         {
            return;
         }
         var level:PlayerLevel = null;
         if(response.Success)
         {
            item = XML(data["level"]);
            datestring = item["sdate"];
            year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
            month = int(datestring.substring(0,datestring.indexOf("/")));
            day = int(datestring.substring(datestring.indexOf("/") + 1).substring(0,2));
            level = new PlayerLevel();
            level.LevelId = item["levelid"];
            level.PlayerName = item["playername"];
            level.PlayerId = item["playerid"];
            level.Name = item["name"];
            level.Score = item["score"];
            level.Votes = item["votes"];
            level.Rating = item["rating"];
            level.Data = item["data"];
            level.ThumbData = item["thumb"];
            level.Wins = item["wins"];
            level.Starts = item["starts"];
            level.Retries = item["retries"];
            level.Quits = item["quits"];
            level.Flags = item["flags"];
            level.SDate = new Date(year,month - 1,day);
            level.RDate = item["rdate"];
            if(item["custom"])
            {
               custom = item["custom"];
               for each(cfield in custom.children())
               {
                  level.CustomData[cfield.name()] = cfield.text();
               }
            }
         }
         callback(level,response);
         postdata = postdata;
      }
      
      public static function List(callback:Function = null, options:Object = null) : void
      {
         var key:String = null;
         if(options == null)
         {
            options = new Object();
         }
         var mode:String = !!options.hasOwnProperty("mode") ? options["mode"] : "popular";
         var page:int = !!options.hasOwnProperty("page") ? int(options["page"]) : int(1);
         var perpage:int = !!options.hasOwnProperty("perpage") ? int(options["perpage"]) : int(20);
         var datemin:String = !!options.hasOwnProperty("datemin") ? options["datemin"] : "";
         var datemax:String = !!options.hasOwnProperty("datemax") ? options["datemax"] : "";
         var data:Boolean = !!options.hasOwnProperty("data") ? Boolean(options["data"]) : Boolean(false);
         var thumbs:Boolean = !!options.hasOwnProperty("thumbs") ? Boolean(options["thumbs"]) : Boolean(false);
         var customfilters:Object = !!options.hasOwnProperty("customfilters") ? options["customfilters"] : {};
         if(KongAPI != null)
         {
            if(mode == "popular")
            {
               KongAPI.sharedContent.browse("level",KongAPI.sharedContent.BY_RATING);
            }
            else
            {
               KongAPI.sharedContent.browse("level",KongAPI.sharedContent.BY_NEWEST);
            }
            return;
         }
         var postdata:Object = new Object();
         postdata["mode"] = mode;
         postdata["page"] = page;
         postdata["perpage"] = perpage;
         postdata["data"] = data;
         postdata["thumbs"] = thumbs;
         postdata["datemin"] = datemin;
         postdata["datemax"] = datemax;
         var numcustomfilters:int = 0;
         if(customfilters != null)
         {
            for(postdata["ckey" + numcustomfilters] in customfilters)
            {
               postdata["cdata" + numcustomfilters] = customfilters[key];
               numcustomfilters++;
            }
         }
         postdata["filters"] = numcustomfilters;
         Request.Load(SECTION,LIST,ListComplete,callback,postdata);
      }
      
      private static function ListComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var entries:XMLList = null;
         var cfield:XML = null;
         var datestring:String = null;
         var year:int = 0;
         var month:int = 0;
         var day:int = 0;
         var item:XML = null;
         var level:PlayerLevel = null;
         var custom:XMLList = null;
         if(callback == null)
         {
            return;
         }
         var levels:Array = [];
         var numresults:int = 0;
         if(response.Success)
         {
            entries = data["level"];
            numresults = data["numresults"];
            for each(item in entries)
            {
               datestring = item["sdate"];
               year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
               month = int(datestring.substring(0,datestring.indexOf("/")));
               day = int(datestring.substring(datestring.indexOf("/") + 1).substring(0,2));
               level = new PlayerLevel();
               level.LevelId = item["levelid"];
               level.PlayerId = item["playerid"];
               level.PlayerName = item["playername"];
               level.Name = item["name"];
               level.Score = item["score"];
               level.Rating = item["rating"];
               level.Votes = item["votes"];
               level.Wins = item["wins"];
               level.Starts = item["starts"];
               level.Retries = item["retries"];
               level.Quits = item["quits"];
               level.Flags = item["flags"];
               level.SDate = new Date(year,month - 1,day);
               level.RDate = item["rdate"];
               if(item["data"])
               {
                  level.Data = item["data"];
               }
               if(item["thumb"])
               {
                  level.ThumbData = item["thumb"];
               }
               custom = item["custom"];
               if(custom != null)
               {
                  for each(cfield in custom.children())
                  {
                     level.CustomData[cfield.name()] = cfield.text();
                  }
               }
               levels.push(level);
            }
         }
         callback(levels,numresults,response);
         postdata = postdata;
      }
      
      public static function Save(level:PlayerLevel, thumb:DisplayObject = null, callback:Function = null) : void
      {
         var kcallback:Function = null;
         var scale:Number = NaN;
         var w:int = 0;
         var h:int = 0;
         var scaler:Matrix = null;
         var image:BitmapData = null;
         var key:String = null;
         if(KongAPI != null)
         {
            kcallback = function(kparam:Object):void
            {
               level.LevelId = kparam["id"];
               level.Permalink = kparam["permalink"];
               level.Name = kparam["name"];
               if(callback != null)
               {
                  callback(level,new Response(Boolean(kparam["success"]) ? int(1) : int(0),0));
               }
            };
            KongAPI.sharedContent.save("level",level.Data,kcallback,thumb,level.Name);
            return;
         }
         var postdata:Object = new Object();
         postdata["data"] = level.Data;
         postdata["playerid"] = level.PlayerId;
         postdata["playersource"] = level.PlayerSource;
         postdata["playername"] = level.PlayerName;
         postdata["name"] = level.Name;
         if(thumb != null)
         {
            scale = 1;
            w = thumb.width;
            h = thumb.height;
            if(thumb.width > 100 || thumb.height > 100)
            {
               if(thumb.width >= thumb.height)
               {
                  scale = 100 / thumb.width;
                  w = 100;
                  h = Math.ceil(scale * thumb.height);
               }
               else if(thumb.height > thumb.width)
               {
                  scale = 100 / thumb.height;
                  w = Math.ceil(scale * thumb.width);
                  h = 100;
               }
            }
            scaler = new Matrix();
            scaler.scale(scale,scale);
            image = new BitmapData(w,h,true,0);
            image.draw(thumb,scaler,null,null,null,true);
            postdata["image"] = Encode.Base64(Encode.PNG(image));
            postdata["arrp"] = RandomSample(image);
            postdata["hash"] = Encode.MD5(postdata["image"] + postdata["arrp"]);
         }
         else
         {
            postdata["nothumb"] = "y";
         }
         var customfields:int = 0;
         if(level.CustomData != null)
         {
            for(key in level.CustomData)
            {
               postdata["ckey" + customfields] = key;
               postdata["cdata" + customfields] = level.CustomData[key];
               customfields++;
            }
         }
         postdata["customfields"] = customfields;
         Request.Load(SECTION,SAVE,SaveComplete,callback,postdata);
      }
      
      private static function SaveComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var key:* = null;
         var num:String = null;
         var name:String = null;
         var value:String = null;
         if(callback == null)
         {
            return;
         }
         var level:PlayerLevel = new PlayerLevel();
         level.Data = postdata["data"];
         level.PlayerId = postdata["playerid"];
         level.PlayerSource = postdata["playersource"];
         level.PlayerName = postdata["playername"];
         level.Name = postdata["name"];
         for(key in postdata)
         {
            if(key.indexOf("ckey") == 0)
            {
               num = key.substring(4);
               name = postdata["ckey" + num];
               value = postdata["cdata" + num];
               level.CustomData[name] = value;
            }
         }
         postdata["data"] = level.Data;
         postdata["playerid"] = level.PlayerId;
         postdata["playersource"] = level.PlayerSource;
         postdata["playername"] = level.PlayerName;
         postdata["name"] = level.Name;
         if(response.Success || response.ErrorCode == 406)
         {
            level.LevelId = data["levelid"];
            level.SDate = new Date();
            level.RDate = "Just now";
         }
         callback(level,response);
      }
      
      private static function KongLevelLoaded(params:Object) : void
      {
         var level:PlayerLevel = new PlayerLevel();
         level.Data = params["content"];
         level.Permalink = params["permalink"];
         level.Name = params["name"];
         level.LevelId = params["id"];
         if(KongLevelReceiver != null)
         {
            KongLevelReceiver(level);
         }
      }
      
      private static function RandomSample(b:BitmapData) : String
      {
         var x:int = 0;
         var y:int = 0;
         var c:String = null;
         var arr:Array = new Array();
         while(arr.length < 10)
         {
            x = Math.random() * b.width;
            y = Math.random() * b.height;
            c = b.getPixel32(x,y).toString(16);
            while(c.length < 6)
            {
               c = "0" + c;
            }
            arr.push(x + "/" + y + "/" + c);
         }
         return arr.join(",");
      }
   }
}
