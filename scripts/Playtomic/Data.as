package Playtomic
{
   public final class Data
   {
      
      private static var SECTION:String;
      
      private static var VIEWS:String;
      
      private static var PLAYS:String;
      
      private static var PLAYTIME:String;
      
      private static var CUSTOMMETRIC:String;
      
      private static var LEVELCOUNTERMETRIC:String;
      
      private static var LEVELRANGEDMETRIC:String;
      
      private static var LEVELAVERAGEMETRIC:String;
       
      
      public function Data()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("data-" + apikey);
         VIEWS = Encode.MD5("data-views-" + apikey);
         PLAYS = Encode.MD5("data-plays-" + apikey);
         PLAYTIME = Encode.MD5("data-playtime-" + apikey);
         CUSTOMMETRIC = Encode.MD5("data-custommetric-" + apikey);
         LEVELCOUNTERMETRIC = Encode.MD5("data-levelcountermetric-" + apikey);
         LEVELRANGEDMETRIC = Encode.MD5("data-levelrangedmetric-" + apikey);
         LEVELAVERAGEMETRIC = Encode.MD5("data-levelaveragemetric-" + apikey);
      }
      
      public static function Views(callback:Function, options:Object = null) : void
      {
         General(VIEWS,"Views",callback,options);
      }
      
      public static function Plays(callback:Function, options:Object = null) : void
      {
         General(PLAYS,"Plays",callback,options);
      }
      
      public static function PlayTime(callback:Function, options:Object = null) : void
      {
         General(PLAYTIME,"Playtime",callback,options);
      }
      
      private static function General(action:String, type:String, callback:Function, options:Object) : void
      {
         if(options == null)
         {
            options = new Object();
         }
         var postdata:Object = new Object();
         postdata["type"] = type;
         postdata["day"] = !!options.hasOwnProperty("day") ? options["day"] : 0;
         postdata["month"] = !!options.hasOwnProperty("month") ? options["month"] : 0;
         postdata["year"] = !!options.hasOwnProperty("year") ? options["year"] : 0;
         Request.Load(SECTION,action,GeneralComplete,callback,postdata);
      }
      
      private static function GeneralComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success == 1)
         {
            result["Name"] = postdata["type"];
            result["Day"] = postdata["day"];
            result["Month"] = postdata["month"];
            result["Year"] = postdata["year"];
            result["Value"] = int(data["value"]);
         }
         callback(result,response);
      }
      
      public static function CustomMetric(metric:String, callback:Function, options:Object = null) : void
      {
         if(options == null)
         {
            options = new Object();
         }
         var postdata:Object = new Object();
         postdata["metric"] = metric;
         postdata["day"] = !!options.hasOwnProperty("day") ? options["day"] : 0;
         postdata["month"] = !!options.hasOwnProperty("month") ? options["month"] : 0;
         postdata["year"] = !!options.hasOwnProperty("year") ? options["year"] : 0;
         Request.Load(SECTION,CUSTOMMETRIC,CustomMetricComplete,callback,postdata);
      }
      
      private static function CustomMetricComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success)
         {
            result["Name"] = "CustomMetric";
            result["Metric"] = postdata["metric"];
            result["Day"] = postdata["day"];
            result["Month"] = postdata["month"];
            result["Year"] = postdata["year"];
            result["Value"] = int(data["value"]);
         }
         callback(result,response);
      }
      
      public static function LevelCounterMetric(metric:String, level:*, callback:Function, options:Object = null) : void
      {
         LevelMetric(LEVELCOUNTERMETRIC,metric,level,LevelCounterMetricComplete,callback,options);
      }
      
      private static function LevelCounterMetricComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success)
         {
            result["Name"] = "LevelAverageMetric";
            result["Metric"] = postdata["metric"];
            result["Level"] = postdata["level"];
            result["Day"] = postdata["day"];
            result["Month"] = postdata["month"];
            result["Year"] = postdata["year"];
            result["Value"] = int(data["value"]);
         }
         callback(result,response);
      }
      
      public static function LevelRangedMetric(metric:String, level:*, callback:Function, options:Object = null) : void
      {
         LevelMetric(LEVELRANGEDMETRIC,metric,level,LevelRangedMetricComplete,callback,options);
      }
      
      private static function LevelRangedMetricComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var values:Array = null;
         var list:XMLList = null;
         var n:XML = null;
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success)
         {
            result["Name"] = "LevelAverageMetric";
            result["Metric"] = postdata["metric"];
            result["Level"] = postdata["level"];
            result["Day"] = postdata["day"];
            result["Month"] = postdata["month"];
            result["Year"] = postdata["year"];
            values = new Array();
            list = data["value"];
            for each(n in list)
            {
               values.push({
                  "TrackValue":int(n.@trackvalue),
                  "Value":int(n)
               });
            }
            result["Values"] = values;
         }
         callback(result,response);
      }
      
      public static function LevelAverageMetric(metric:String, level:*, callback:Function, options:Object = null) : void
      {
         LevelMetric(LEVELAVERAGEMETRIC,metric,level,LevelAverageMetricComplete,callback,options);
      }
      
      private static function LevelAverageMetricComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success)
         {
            result["Name"] = "LevelAverageMetric";
            result["Metric"] = postdata["metric"];
            result["Level"] = postdata["level"];
            result["Day"] = postdata["day"];
            result["Month"] = postdata["month"];
            result["Year"] = postdata["year"];
            result["Min"] = int(data["min"]);
            result["Max"] = int(data["max"]);
            result["Average"] = int(data["average"]);
            result["Total"] = Number(data["total"]);
         }
         callback(result,response);
      }
      
      private static function LevelMetric(action:String, metric:String, level:String, complete:Function, callback:Function, options:Object) : void
      {
         if(options == null)
         {
            options = new Object();
         }
         var postdata:Object = new Object();
         postdata["metric"] = metric;
         postdata["level"] = level;
         postdata["day"] = !!options.hasOwnProperty("day") ? options["day"] : 0;
         postdata["month"] = !!options.hasOwnProperty("month") ? options["month"] : 0;
         postdata["year"] = !!options.hasOwnProperty("year") ? options["year"] : 0;
         Request.Load(SECTION,action,complete,callback,postdata);
      }
   }
}
