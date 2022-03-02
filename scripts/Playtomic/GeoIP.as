package Playtomic
{
   public final class GeoIP
   {
      
      private static var SECTION:String;
      
      private static var LOAD:String;
       
      
      public function GeoIP()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("geoip-" + apikey);
         LOAD = Encode.MD5("geoip-lookup-" + apikey);
      }
      
      public static function Lookup(callback:Function) : void
      {
         Request.Load(SECTION,LOAD,LookupComplete,callback);
      }
      
      private static function LookupComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         var result:Object = {
            "Code":"N/A",
            "Name":"UNKNOWN"
         };
         if(response.Success)
         {
            result["Code"] = data["location"]["code"];
            result["Name"] = data["location"]["name"];
         }
         callback(result,response);
         postdata = postdata;
      }
   }
}
