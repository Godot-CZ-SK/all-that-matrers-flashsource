package Playtomic
{
   public final class GameVars
   {
      
      private static var SECTION:String;
      
      private static var LOAD:String;
       
      
      public function GameVars()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("gamevars-" + apikey);
         LOAD = Encode.MD5("gamevars-load-" + apikey);
      }
      
      public static function Load(callback:Function) : void
      {
         Request.Load(SECTION,LOAD,LoadComplete,callback,null);
      }
      
      private static function LoadComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var entries:XMLList = null;
         var name:String = null;
         var value:String = null;
         var item:XML = null;
         if(callback == null)
         {
            return;
         }
         var result:Object = new Object();
         if(response.Success)
         {
            entries = data["gamevar"];
            for each(item in entries)
            {
               name = item["name"];
               value = item["value"];
               result[name] = value;
            }
         }
         postdata = postdata;
         callback(result,response);
      }
   }
}
