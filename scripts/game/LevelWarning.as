package game
{
   public class LevelWarning
   {
      
      public static const TYPE_ERROR:String = "E:";
      
      public static const TYPE_WARNING:String = "W:";
       
      
      protected var _type:String;
      
      protected var _message:String;
      
      protected var _priority:int;
      
      public function LevelWarning(type:String = "warning", message:String = "")
      {
         super();
         this._type = type;
         this._message = message;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(value:String) : void
      {
         this._message = value;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
