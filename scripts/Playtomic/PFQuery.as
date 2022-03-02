package Playtomic
{
   public final class PFQuery
   {
       
      
      public var ClassName:String;
      
      public var WherePointers:Vector.<PFPointer>;
      
      public var WhereData:Object;
      
      public var Order:String;
      
      public var Limit:int = 10;
      
      public function PFQuery()
      {
         this.WherePointers = new Vector.<PFPointer>();
         this.WhereData = {};
         super();
      }
   }
}
