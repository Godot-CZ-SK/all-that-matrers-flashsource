package Playtomic
{
   public class PrivateLeaderboard
   {
       
      
      public var TableId:String;
      
      public var Name:String;
      
      public var Bitly:String;
      
      public var Permalink:String;
      
      public var Highest:Boolean = true;
      
      public var RealName:String;
      
      public function PrivateLeaderboard(tableid:String = null, name:String = null, bitly:String = null, permalink:String = null, highest:Boolean = false, realname:String = null)
      {
         super();
         this.TableId = tableid;
         this.Name = name;
         this.Bitly = bitly;
         this.Permalink = permalink;
         this.Highest = highest;
         this.RealName = realname;
      }
      
      public function toString() : String
      {
         return "Playtomic.PrivateLeaderboard:" + "\nTableId: " + this.TableId + "\nName: " + this.Name + "\nBitly: " + this.Bitly + "\nPermalink: " + this.Permalink + "\nHighest: " + this.Highest + "\nRealName: " + this.RealName;
      }
   }
}
