package Playtomic
{
   public final class PFPointer
   {
       
      
      public var FieldName:String;
      
      public var PObject:PFObject;
      
      public function PFPointer(fieldname:String, po:PFObject)
      {
         super();
         this.FieldName = fieldname;
         this.PObject = po;
      }
   }
}
