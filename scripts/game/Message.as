package game
{
   public class Message
   {
      
      public static const THE_END:int = 0;
      
      public static const TEST:int = 1;
      
      public static const NUMBER_OF_MESSAGES:int = 8;
      
      public static var list:Vector.<Message>;
       
      
      protected var _id:int;
      
      protected var _title:String;
      
      protected var _story:String;
      
      protected var _conLevel:int;
      
      public function Message(id:int, conLevel:int, title:String, story:String)
      {
         super();
         this._id = id;
         this._conLevel = conLevel;
         this._title = title;
         this._story = story;
      }
      
      public static function init() : void
      {
         list = new Vector.<Message>();
         list.push(new Message(THE_END,1,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(TEST,4,"Testing","Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),new Message(THE_END,7,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(THE_END,12,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(THE_END,16,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(THE_END,19,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(THE_END,22,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."),new Message(THE_END,25,"The End","Hello, my name is John. I am 45 years old and I have an illness that has no cure. Shortly I\'m going to pass away and leave everything behind. That is a feeling I can not describe. And I don\'t want to talk about that either."));
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get story() : String
      {
         return this._story;
      }
      
      public function get conLevel() : int
      {
         return this._conLevel;
      }
   }
}
