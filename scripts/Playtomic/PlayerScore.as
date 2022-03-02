package Playtomic
{
   public final class PlayerScore
   {
       
      
      public var Name:String;
      
      public var FBUserId:String;
      
      public var Points:Number;
      
      public var Rank:int;
      
      public var Website:String;
      
      public var SDate:Date;
      
      public var RDate:String;
      
      public var CustomData:Object;
      
      public var SubmittedOrBest:Boolean = false;
      
      public function PlayerScore(name:String = "", points:int = 0)
      {
         this.CustomData = {};
         super();
         this.Name = name;
         this.Points = points;
      }
      
      public function toString() : String
      {
         return "Playtomic.PlayerScore:" + "\nRank: " + this.Rank + "\nName: " + this.Name + "\nPoints: " + this.Points;
      }
      
      public function toStringAll() : String
      {
         var value:String = null;
         var str:String = "Playtomic.PlayerScore:" + "\nRank: " + this.Rank + "\nName: " + this.Name + "\nFBUserId: " + this.FBUserId + "\nPoints: " + this.Points + "\nWebsite: " + this.Website + "\nSDate: " + this.SDate + "\nRDate: " + this.RDate + "\nCustomData: ";
         for each(value in this.CustomData)
         {
            str += "\n  " + value + ": " + this.CustomData[value];
         }
         return str;
      }
   }
}
