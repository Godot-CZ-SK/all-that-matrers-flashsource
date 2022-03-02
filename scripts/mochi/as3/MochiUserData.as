package mochi.as3
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.ObjectEncoding;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class MochiUserData extends EventDispatcher
   {
       
      
      public var _loader:URLLoader;
      
      public var key:String = null;
      
      public var data = null;
      
      public var error:Event = null;
      
      public var operation:String = null;
      
      public var callback:Function = null;
      
      public function MochiUserData(key:String = "", callback:Function = null)
      {
         super();
         this.key = key;
         this.callback = callback;
      }
      
      public static function get(key:String, callback:Function) : void
      {
         var userData:MochiUserData = new MochiUserData(key,callback);
         userData.getEvent();
      }
      
      public static function put(key:String, obj:*, callback:Function) : void
      {
         var userData:MochiUserData = new MochiUserData(key,callback);
         userData.putEvent(obj);
      }
      
      public function serialize(obj:*) : ByteArray
      {
         var arr:ByteArray = new ByteArray();
         arr.objectEncoding = ObjectEncoding.AMF3;
         arr.writeObject(obj);
         arr.compress();
         return arr;
      }
      
      public function deserialize(arr:ByteArray) : *
      {
         arr.objectEncoding = ObjectEncoding.AMF3;
         arr.uncompress();
         return arr.readObject();
      }
      
      public function request(_operation:String, _data:ByteArray) : void
      {
         this.operation = _operation;
         var api_url:String = MochiSocial.getAPIURL();
         var api_token:String = MochiSocial.getAPIToken();
         if(api_url == null || api_token == null)
         {
            this.errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"not logged in"));
            return;
         }
         this._loader = new URLLoader();
         var args:URLVariables = new URLVariables();
         args.op = _operation;
         args.key = this.key;
         var req:URLRequest = new URLRequest(MochiSocial.getAPIURL() + "/" + "MochiUserData?" + args.toString());
         req.method = URLRequestMethod.POST;
         req.contentType = "application/x-mochi-userdata";
         req.requestHeaders = [new URLRequestHeader("x-mochi-services-version",MochiServices.getVersion()),new URLRequestHeader("x-mochi-api-token",api_token)];
         req.data = _data;
         this._loader.dataFormat = URLLoaderDataFormat.BINARY;
         this._loader.addEventListener(Event.COMPLETE,this.completeHandler);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         try
         {
            this._loader.load(req);
         }
         catch(e:SecurityError)
         {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"security error: " + e.toString()));
         }
      }
      
      public function completeHandler(event:Event) : void
      {
         try
         {
            if(this._loader.data.length)
            {
               this.data = this.deserialize(this._loader.data);
            }
            else
            {
               this.data = null;
            }
         }
         catch(e:Error)
         {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"deserialize error: " + e.toString()));
            return;
         }
         if(this.callback != null)
         {
            this.performCallback();
         }
         else
         {
            dispatchEvent(event);
         }
         this.close();
      }
      
      public function errorHandler(event:IOErrorEvent) : void
      {
         this.data = null;
         this.error = event;
         if(this.callback != null)
         {
            this.performCallback();
         }
         else
         {
            dispatchEvent(event);
         }
         this.close();
      }
      
      public function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         this.errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"security error: " + event.toString()));
      }
      
      public function performCallback() : void
      {
         try
         {
            this.callback(this);
         }
         catch(e:Error)
         {
            trace("[MochiUserData] exception during callback: " + e);
         }
      }
      
      public function close() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(Event.COMPLETE,this.completeHandler);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this._loader.close();
            this._loader = null;
         }
         this.error = null;
         this.callback = null;
      }
      
      public function getEvent() : void
      {
         this.request("get",this.serialize(null));
      }
      
      public function putEvent(obj:*) : void
      {
         this.request("put",this.serialize(obj));
      }
      
      override public function toString() : String
      {
         return "[MochiUserData operation=" + this.operation + " key=\"" + this.key + "\" data=" + this.data + " error=\"" + this.error + "\"]";
      }
   }
}
