package mochi.as3
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Proxy;
   import flash.utils.Timer;
   import flash.utils.flash_proxy;
   
   public dynamic class MochiInventory extends Proxy
   {
      
      private static const CONSUMER_KEY:String = "MochiConsumables";
      
      private static const KEY_SALT:String = " syncMaint\x01";
      
      public static const READY:String = "InvReady";
      
      public static const WRITTEN:String = "InvWritten";
      
      public static const ERROR:String = "Error";
      
      public static const IO_ERROR:String = "IoError";
      
      public static const VALUE_ERROR:String = "InvValueError";
      
      public static const NOT_READY:String = "InvNotReady";
      
      private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
       
      
      private var _timer:Timer;
      
      private var _consumableProperties:Object;
      
      private var _syncPending:Boolean;
      
      private var _outstandingID:Number;
      
      private var _syncID:Number;
      
      private var _names:Array;
      
      private var _storeSync:Object;
      
      public function MochiInventory()
      {
         super();
         MochiCoins.addEventListener(MochiCoins.ITEM_OWNED,this.itemOwned);
         MochiCoins.addEventListener(MochiCoins.ITEM_NEW,this.newItems);
         MochiSocial.addEventListener(MochiSocial.LOGGED_IN,this.loggedIn);
         MochiSocial.addEventListener(MochiSocial.LOGGED_OUT,this.loggedOut);
         this._storeSync = new Object();
         this._syncPending = false;
         this._outstandingID = 0;
         this._syncID = 0;
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.sync);
         this._timer.start();
         if(MochiSocial.loggedIn)
         {
            this.loggedIn();
         }
         else
         {
            this.loggedOut();
         }
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
      
      public function release() : void
      {
         MochiCoins.removeEventListener(MochiCoins.ITEM_NEW,this.newItems);
         MochiSocial.removeEventListener(MochiSocial.LOGGED_IN,this.loggedIn);
         MochiSocial.removeEventListener(MochiSocial.LOGGED_OUT,this.loggedOut);
      }
      
      private function loggedOut(args:Object = null) : void
      {
         this._consumableProperties = null;
      }
      
      private function loggedIn(args:Object = null) : void
      {
         MochiUserData.get(CONSUMER_KEY,this.getConsumableBag);
      }
      
      private function newItems(event:Object) : void
      {
         if(!this[event.id + KEY_SALT])
         {
            this[event.id + KEY_SALT] = 0;
         }
         if(!this[event.id])
         {
            this[event.id] = 0;
         }
         this[event.id + KEY_SALT] += event.count;
         this[event.id] += event.count;
         if(event.privateProperties && event.privateProperties.consumable)
         {
            if(!this[event.privateProperties.tag])
            {
               this[event.privateProperties.tag] = 0;
            }
            this[event.privateProperties.tag] += event.privateProperties.inc * event.count;
         }
      }
      
      private function itemOwned(event:Object) : void
      {
         this._storeSync[event.id] = {
            "properties":event.properties,
            "count":event.count
         };
      }
      
      private function getConsumableBag(userData:MochiUserData) : void
      {
         var key:* = null;
         var unsynced:Number = NaN;
         if(userData.error)
         {
            triggerEvent(ERROR,{
               "type":IO_ERROR,
               "error":userData.error
            });
            return;
         }
         this._consumableProperties = {};
         this._names = new Array();
         if(userData.data)
         {
            for(key in userData.data)
            {
               this._names.push(key);
               this._consumableProperties[key] = new MochiDigits(userData.data[key]);
            }
         }
         for(key in this._storeSync)
         {
            unsynced = this._storeSync[key].count;
            if(this._consumableProperties[key + KEY_SALT])
            {
               unsynced -= this._consumableProperties[key + KEY_SALT].value;
            }
            if(unsynced != 0)
            {
               this.newItems({
                  "id":key,
                  "count":unsynced,
                  "properties":this._storeSync[key].properties
               });
            }
         }
         triggerEvent(READY,{});
      }
      
      private function putConsumableBag(userData:MochiUserData) : void
      {
         this._syncPending = false;
         if(userData.error)
         {
            triggerEvent(ERROR,{
               "type":IO_ERROR,
               "error":userData.error
            });
            this._outstandingID = -1;
         }
         triggerEvent(WRITTEN,{});
      }
      
      private function sync(e:Event = null) : void
      {
         var key:* = null;
         if(this._syncPending || this._syncID == this._outstandingID)
         {
            return;
         }
         this._outstandingID = this._syncID;
         var output:Object = {};
         for(key in this._consumableProperties)
         {
            output[key] = MochiDigits(this._consumableProperties[key]).value;
         }
         MochiUserData.put(CONSUMER_KEY,output,this.putConsumableBag);
         this._syncPending = true;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         if(this._consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return -1;
         }
         if(this._consumableProperties[name])
         {
            return MochiDigits(this._consumableProperties[name]).value;
         }
         return undefined;
      }
      
      override flash_proxy function deleteProperty(name:*) : Boolean
      {
         if(!this._consumableProperties[name])
         {
            return false;
         }
         this._names.splice(this._names.indexOf(name),1);
         delete this._consumableProperties[name];
         return true;
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         if(this._consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return false;
         }
         if(this._consumableProperties[name] == undefined)
         {
            return false;
         }
         return true;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var d:MochiDigits = null;
         if(this._consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return;
         }
         if(!(value is Number))
         {
            triggerEvent(ERROR,{
               "type":VALUE_ERROR,
               "error":"Invalid type",
               "arg":value
            });
            return;
         }
         if(this._consumableProperties[name])
         {
            d = MochiDigits(this._consumableProperties[name]);
            if(d.value == value)
            {
               return;
            }
            d.value = value;
         }
         else
         {
            this._names.push(name);
            this._consumableProperties[name] = new MochiDigits(value);
         }
         ++this._syncID;
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         return index >= this._names.length ? int(0) : int(index + 1);
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return this._names[index - 1];
      }
   }
}
