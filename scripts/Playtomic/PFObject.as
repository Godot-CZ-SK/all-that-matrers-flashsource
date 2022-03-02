package Playtomic
{
   public class PFObject
   {
       
      
      public var ObjectId:String;
      
      public var ClassName:String;
      
      public var Pointers:Vector.<PFPointer>;
      
      public var Data:Object;
      
      public var UpdatedAt:Date;
      
      public var CreatedAt:Date;
      
      public var Password:String;
      
      public function PFObject()
      {
         this.Pointers = new Vector.<PFPointer>();
         this.Data = {};
         super();
      }
   }
}
