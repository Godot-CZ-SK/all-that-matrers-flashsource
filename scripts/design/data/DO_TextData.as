package design.data
{
   public class DO_TextData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var background:Boolean;
      
      public var textHeight:int;
      
      public var text:String;
      
      public function DO_TextData()
      {
         super(TYPE_TEXT);
         this.x = 0;
         this.y = 0;
         this.width = 50;
         this.height = 30;
         this.textHeight = 12;
         this.text = "";
         this.background = true;
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_TextData = new DO_TextData();
         result.x = this.x;
         result.y = this.y;
         result.width = this.width;
         result.height = this.height;
         result.background = this.background;
         result.textHeight = this.textHeight;
         result.text = this.text;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.width.toString() + ";" + this.height.toString() + ";" + this.background.toString() + ";" + this.textHeight.toString() + ";" + this.text;
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 8)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.width = Number(data[3]);
         this.height = Number(data[4]);
         if(data[5] == false)
         {
            this.background = false;
         }
         else
         {
            this.background = true;
         }
         this.textHeight = int(data[6]);
         this.text = data[7];
         return true;
      }
   }
}
