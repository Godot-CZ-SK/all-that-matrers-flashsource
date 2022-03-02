package design.data
{
   public class DO_SignData extends DO_Data
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var scale:Number;
      
      public var tf_x:Number;
      
      public var tf_y:Number;
      
      public var tf_width:Number;
      
      public var tf_height:Number;
      
      public var textHeight:int;
      
      public var text:String;
      
      public var rotation:Number;
      
      public const WIDTH:Number = 10;
      
      public const HEIGHT:Number = 50;
      
      public function DO_SignData()
      {
         super(TYPE_SIGN);
         this.x = 0;
         this.y = 0;
         this.tf_x = -75;
         this.tf_y = -120;
         this.tf_width = 150;
         this.tf_height = 50;
         this.textHeight = 12;
         this.scale = 1;
         this.rotation = 0;
         this.text = "";
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_SignData = new DO_SignData();
         result.x = this.x;
         result.y = this.y;
         result.scale = this.scale;
         result.tf_x = this.tf_x;
         result.tf_y = this.tf_y;
         result.tf_width = this.tf_width;
         result.tf_height = this.tf_height;
         result.textHeight = this.textHeight;
         result.text = this.text;
         result.rotation = this.rotation;
         return result;
      }
      
      override public function convertToString() : String
      {
         return type + ";" + this.x.toString() + ";" + this.y.toString() + ";" + this.scale.toString() + ";" + this.tf_x.toString() + ";" + this.tf_y.toString() + ";" + this.tf_width.toString() + ";" + this.tf_height.toString() + ";" + this.textHeight.toString() + ";" + this.text + ";" + this.rotation.toString();
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         if(data.length != 10 && data.length != 11)
         {
            return false;
         }
         type = data[0];
         this.x = Number(data[1]);
         this.y = Number(data[2]);
         this.scale = Number(data[3]);
         this.tf_x = Number(data[4]);
         this.tf_y = Number(data[5]);
         this.tf_width = Number(data[6]);
         this.tf_height = Number(data[7]);
         this.textHeight = Number(data[8]);
         this.text = data[9];
         if(data.length == 10)
         {
            this.rotation = 0;
         }
         else
         {
            this.rotation = data[10];
         }
         return true;
      }
   }
}
