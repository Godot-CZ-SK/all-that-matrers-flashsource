package Playtomic
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.utils.ByteArray;
   
   public final class PlayerLevel
   {
       
      
      public var LevelId:String;
      
      public var PlayerSource:String = "";
      
      public var PlayerId:String = "";
      
      public var PlayerName:String = "";
      
      public var Permalink:String;
      
      public var Name:String;
      
      public var Data:String;
      
      public var ThumbData:String;
      
      public var Votes:int;
      
      public var Starts:int;
      
      public var Quits:int;
      
      public var Retries:int;
      
      public var Flags:int;
      
      public var Wins:int;
      
      public var Rating:Number;
      
      public var Score:int;
      
      public var SDate:Date;
      
      public var RDate:String;
      
      public var CustomData:Object;
      
      public function PlayerLevel()
      {
         this.CustomData = {};
         super();
         this.SDate = new Date();
         this.RDate = "Just now";
      }
      
      public function Thumb() : BitmapData
      {
         var bytearray:ByteArray = Encode.Base64Decode(this.ThumbData);
         var loader:Loader = new Loader();
         loader.loadBytes(bytearray);
         return Bitmap(loader).bitmapData;
      }
      
      public function Thumbnail() : String
      {
         return "http://g" + Log.GUID + ".api.playtomic.com/playerlevels/thumb.aspx?swfid=" + Log.SWFID + "&levelid=" + this.LevelId;
      }
   }
}
