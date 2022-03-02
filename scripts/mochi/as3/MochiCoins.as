package mochi.as3
{
   public class MochiCoins
   {
      
      public static const STORE_SHOW:String = "StoreShow";
      
      public static const STORE_HIDE:String = "StoreHide";
      
      public static const ITEM_OWNED:String = "ItemOwned";
      
      public static const ITEM_NEW:String = "ItemNew";
      
      public static const STORE_ITEMS:String = "StoreItems";
      
      public static const ERROR:String = "Error";
      
      public static const IO_ERROR:String = "IOError";
      
      public static const NO_USER:String = "NoUser";
      
      public static var _inventory:MochiInventory;
      
      private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
      
      {
         addEventListener(MochiSocial.LOGGED_IN,function(args:Object):void
         {
            _inventory = new MochiInventory();
         });
         addEventListener(MochiSocial.LOGGED_OUT,function(args:Object):void
         {
            _inventory = null;
         });
      }
      
      public function MochiCoins()
      {
         super();
      }
      
      public static function get inventory() : MochiInventory
      {
         return _inventory;
      }
      
      public static function getVersion() : String
      {
         return MochiServices.getVersion();
      }
      
      public static function showStore(options:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("coins_showStore",{"options":options},null,null);
      }
      
      public static function showItem(options:Object = null) : void
      {
         if(!options || typeof options.item != "string")
         {
            trace("ERROR: showItem call must pass an Object with an item key");
            return;
         }
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("coins_showItem",{"options":options},null,null);
      }
      
      public static function showVideo(options:Object = null) : void
      {
         if(!options || typeof options.item != "string")
         {
            trace("ERROR: showVideo call must pass an Object with an item key");
            return;
         }
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("coins_showVideo",{"options":options},null,null);
      }
      
      public static function getStoreItems() : void
      {
         MochiServices.send("coins_getStoreItems");
      }
      
      public static function requestFunding(properties:Object = null) : void
      {
         MochiServices.setContainer();
         MochiServices.bringToTop();
         MochiServices.send("social_requestFunding",properties);
      }
      
      public static function addEventListener(eventType:String, delegate:Function) : void
      {
         _dispatcher.addEventListener(eventType,delegate);
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
