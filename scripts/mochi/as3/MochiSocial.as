package mochi.as3
{
   public class MochiSocial
   {
      
      public static const LOGGED_IN:String = "LoggedIn";
      
      public static const LOGGED_OUT:String = "LoggedOut";
      
      public static const LOGIN_SHOW:String = "LoginShow";
      
      public static const LOGIN_HIDE:String = "LoginHide";
      
      public static const LOGIN_SHOWN:String = "LoginShown";
      
      public static const PROFILE_SHOW:String = "ProfileShow";
      
      public static const PROFILE_HIDE:String = "ProfileHide";
      
      public static const PROPERTIES_SAVED:String = "PropertySaved";
      
      public static const WIDGET_LOADED:String = "WidgetLoaded";
      
      public static const FRIEND_LIST:String = "FriendsList";
      
      public static const PROFILE_DATA:String = "ProfileData";
      
      public static const GAMEPLAY_DATA:String = "GameplayData";
      
      public static const ACTION_CANCELED:String = "onCancel";
      
      public static const ACTION_COMPLETE:String = "onComplete";
      
      public static const USER_INFO:String = "UserInfo";
      
      public static const ERROR:String = "Error";
      
      public static const IO_ERROR:String = "IOError";
      
      public static const NO_USER:String = "NoUser";
      
      public static const PROPERTIES_SIZE:String = "PropertiesSize";
      
      private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
      
      public static var _user_info:Object = null;
      
      {
         MochiSocial.addEventListener(MochiSocial.LOGGED_IN,function(args:Object):void
         {
            _user_info = args;
         });
         MochiSocial.addEventListener(MochiSocial.LOGGED_OUT,function(args:Object):void
         {
            _user_info = null;
         });
      }
      
      public function MochiSocial()
      {
         super();
      }
      
      public static function getVersion() : String
      {
         return MochiServices.getVersion();
      }
      
      public static function getAPIURL() : String
      {
         if(!_user_info)
         {
            return null;
         }
         return _user_info.api_url;
      }
      
      public static function getAPIToken() : String
      {
         if(!_user_info)
         {
            return null;
         }
         return _user_info.api_token;
      }
      
      public static function showLoginWidget(options:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_showLoginWidget",{"options":options});
      }
      
      public static function hideLoginWidget() : void
      {
         MochiServices.send("social_hideLoginWidget");
      }
      
      public static function requestLogin(properties:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_requestLogin",properties);
      }
      
      public static function showProfile(options:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.stayOnTop();
         MochiServices.send("social_showProfile",options);
      }
      
      public static function saveUserProperties(properties:Object) : void
      {
         MochiServices.send("social_saveUserProperties",properties);
      }
      
      public static function getFriendsList(properties:Object = null) : void
      {
         MochiServices.send("social_getFriendsList",properties);
      }
      
      public static function postToStream(properties:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_postToStream",properties);
      }
      
      public static function inviteFriends(properties:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_inviteFriends",properties);
      }
      
      public static function requestFan(properties:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_requestFan",properties);
      }
      
      public static function addEventListener(eventType:String, delegate:Function) : void
      {
         _dispatcher.addEventListener(eventType,delegate);
      }
      
      public static function get loggedIn() : Boolean
      {
         return _user_info != null;
      }
      
      public static function triggerEvent(eventType:String, args:Object) : void
      {
         _dispatcher.triggerEvent(eventType,args);
      }
      
      public static function removeEventListener(eventType:String, delegate:Function) : void
      {
         _dispatcher.removeEventListener(eventType,delegate);
      }
   }
}
