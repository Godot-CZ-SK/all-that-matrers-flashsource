package mochi.as3
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.Timer;
   
   public class MochiServices
   {
      
      public static const CONNECTED:String = "onConnected";
      
      private static var _id:String;
      
      private static var _container:Object;
      
      private static var _clip:MovieClip;
      
      private static var _loader:Loader;
      
      private static var _timer:Timer;
      
      private static var _preserved:Object;
      
      private static var _servURL:String = "http://www.mochiads.com/static/lib/services/";
      
      private static var _services:String = "services.swf";
      
      private static var _mochiLC:String = "MochiLC.swf";
      
      private static var _swfVersion:String;
      
      private static var _listenChannelName:String = "__ms_";
      
      private static var _sendChannel:LocalConnection;
      
      private static var _sendChannelName:String;
      
      private static var _connecting:Boolean = false;
      
      private static var _connected:Boolean = false;
      
      public static var netup:Boolean = true;
      
      public static var netupAttempted:Boolean = false;
      
      public static var onError:Object;
      
      public static var widget:Boolean = false;
      
      private static var _mochiLocalConnection:MovieClip;
      
      private static var _queue:Array;
      
      private static var _nextCallbackID:Number;
      
      private static var _callbacks:Object;
      
      private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
       
      
      public function MochiServices()
      {
         super();
      }
      
      public static function get id() : String
      {
         return _id;
      }
      
      public static function get clip() : Object
      {
         return _container;
      }
      
      public static function get childClip() : Object
      {
         return _clip;
      }
      
      public static function getVersion() : String
      {
         return "3.9.4 as3";
      }
      
      public static function allowDomains(server:String) : String
      {
         var hostname:String = null;
         if(Security.sandboxType != "application")
         {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
         }
         if(server.indexOf("http://") != -1)
         {
            hostname = server.split("/")[2].split(":")[0];
            if(Security.sandboxType != "application")
            {
               Security.allowDomain(hostname);
               Security.allowInsecureDomain(hostname);
            }
         }
         return hostname;
      }
      
      public static function isNetworkAvailable() : Boolean
      {
         return Security.sandboxType != "localWithFile";
      }
      
      public static function set comChannelName(val:String) : void
      {
         if(val != null)
         {
            if(val.length > 3)
            {
               _sendChannelName = val + "_fromgame";
               initComChannels();
            }
         }
      }
      
      public static function get connected() : Boolean
      {
         return _connected;
      }
      
      public static function warnID(bid:String, leaderboard:Boolean) : void
      {
         bid = bid.toLowerCase();
         if(bid.length != 16)
         {
            trace("WARNING: " + (!!leaderboard ? "board" : "game") + " ID is not the appropriate length");
            return;
         }
         if(bid == "1e113c7239048b3f")
         {
            if(leaderboard)
            {
               trace("WARNING: Using testing board ID");
            }
            else
            {
               trace("WARNING: Using testing board ID as game ID");
            }
            return;
         }
         if(bid == "84993a1de4031cd8")
         {
            if(leaderboard)
            {
               trace("WARNING: Using testing game ID as board ID");
            }
            else
            {
               trace("WARNING: Using testing game ID");
            }
            return;
         }
         var i:Number = 0;
         while(true)
         {
            if(i >= bid.length)
            {
               return;
            }
            switch(bid.charAt(i))
            {
               case "0":
               case "1":
               case "2":
               case "3":
               case "4":
               case "5":
               case "6":
               case "7":
               case "8":
               case "9":
               case "a":
               case "b":
               case "c":
               case "d":
               case "e":
               case "f":
            }
            i++;
         }
         trace("WARNING: Board ID contains illegal characters: " + bid);
      }
      
      public static function connect(id:String, clip:Object, onError:Object = null) : void
      {
         warnID(id,false);
         if(onError != null)
         {
            MochiServices.onError = onError;
         }
         else if(MochiServices.onError == null)
         {
            MochiServices.onError = function(errorCode:String):void
            {
               trace(errorCode);
            };
         }
         if(clip is DisplayObject)
         {
            if(clip.stage == null)
            {
               trace("MochiServices connect requires the containing clip be attached to the stage");
            }
            if(!_connected && _clip == null)
            {
               trace("MochiServices Connecting...");
               _connecting = true;
               init(id,clip);
            }
         }
         else
         {
            trace("Error, MochiServices requires a Sprite, Movieclip or instance of the stage.");
         }
      }
      
      public static function disconnect() : void
      {
         if(_connected || _connecting)
         {
            if(_clip != null)
            {
               if(_clip.parent != null)
               {
                  if(_clip.parent is Sprite)
                  {
                     Sprite(_clip.parent).removeChild(_clip);
                     _clip = null;
                  }
               }
            }
            _connecting = _connected = false;
            flush(true);
            try
            {
               _mochiLocalConnection.close();
            }
            catch(error:Error)
            {
            }
         }
         if(_timer != null)
         {
            try
            {
               _timer.stop();
               _timer.removeEventListener(TimerEvent.TIMER,connectWait);
               _timer = null;
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public static function stayOnTop() : void
      {
         _container.addEventListener(Event.ENTER_FRAME,MochiServices.bringToTop,false,0,true);
         if(_clip != null)
         {
            _clip.visible = true;
         }
      }
      
      public static function doClose() : void
      {
         _container.removeEventListener(Event.ENTER_FRAME,MochiServices.bringToTop);
      }
      
      public static function bringToTop(e:Event = null) : void
      {
         if(MochiServices.clip != null && MochiServices.childClip != null)
         {
            try
            {
               if(MochiServices.clip.numChildren > 1)
               {
                  MochiServices.clip.setChildIndex(MochiServices.childClip,MochiServices.clip.numChildren - 1);
               }
            }
            catch(errorObject:Error)
            {
               trace("Warning: Depth sort error.");
               _container.removeEventListener(Event.ENTER_FRAME,MochiServices.bringToTop);
            }
         }
      }
      
      private static function init(id:String, clip:Object) : void
      {
         _id = id;
         if(clip != null)
         {
            _container = clip;
            loadCommunicator(id,_container);
         }
      }
      
      public static function setContainer(container:Object = null, doAdd:Boolean = true) : void
      {
         if(_clip.parent)
         {
            _clip.parent.removeChild(_clip);
         }
         if(container != null)
         {
            if(container is DisplayObjectContainer)
            {
               _container = container;
            }
         }
         if(doAdd)
         {
            if(_container is DisplayObjectContainer)
            {
               DisplayObjectContainer(_container).addChild(_clip);
            }
         }
      }
      
      private static function loadCommunicator(id:String, clip:Object) : MovieClip
      {
         if(_clip != null)
         {
            return _clip;
         }
         if(!MochiServices.isNetworkAvailable())
         {
            MochiServices.onError("NotConnected");
            return null;
         }
         if(urlOptions(clip).servURL)
         {
            _servURL = urlOptions(clip).servURL;
         }
         var servicesURL:String = _servURL + _services;
         if(urlOptions(clip).servicesURL)
         {
            servicesURL = urlOptions(clip).servicesURL;
         }
         _listenChannelName += Math.floor(new Date().time) + "_" + Math.floor(Math.random() * 99999);
         MochiServices.allowDomains(servicesURL);
         _clip = new MovieClip();
         loadLCBridge(_clip);
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,detach);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,detach);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
         var req:URLRequest = new URLRequest(servicesURL);
         var vars:URLVariables = new URLVariables();
         vars.listenLC = _listenChannelName;
         vars.mochiad_options = clip.loaderInfo.parameters.mochiad_options;
         vars.api_version = getVersion();
         if(widget)
         {
            vars.widget = true;
         }
         req.data = vars;
         _loader.load(req);
         _clip.addChild(_loader);
         _sendChannel = new LocalConnection();
         _queue = [];
         _nextCallbackID = 0;
         _callbacks = {};
         _timer = new Timer(10000,1);
         _timer.addEventListener(TimerEvent.TIMER,connectWait);
         _timer.start();
         return _clip;
      }
      
      private static function detach(event:Event) : void
      {
         var loader:LoaderInfo = LoaderInfo(event.target);
         loader.removeEventListener(Event.COMPLETE,detach);
         loader.removeEventListener(IOErrorEvent.IO_ERROR,detach);
         loader.removeEventListener(Event.COMPLETE,loadLCBridgeComplete);
         loader.removeEventListener(IOErrorEvent.IO_ERROR,loadError);
      }
      
      private static function loadLCBridge(clip:Object) : void
      {
         var loader:Loader = new Loader();
         var mochiLCURL:String = _servURL + _mochiLC;
         var req:URLRequest = new URLRequest(mochiLCURL);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,detach);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,detach);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadLCBridgeComplete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
         loader.load(req);
         clip.addChild(loader);
      }
      
      private static function loadLCBridgeComplete(e:Event) : void
      {
         var loader:Loader = LoaderInfo(e.target).loader;
         _mochiLocalConnection = MovieClip(loader.content);
         listen();
      }
      
      private static function loadError(ev:Object) : void
      {
         _clip._mochiad_ctr_failed = true;
         trace("MochiServices could not load.");
         MochiServices.disconnect();
         MochiServices.onError("IOError");
      }
      
      public static function connectWait(e:TimerEvent) : void
      {
         if(!_connected)
         {
            _clip._mochiad_ctr_failed = true;
            trace("MochiServices could not load. (timeout)");
            MochiServices.disconnect();
            MochiServices.onError("IOError");
         }
         else
         {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER,connectWait);
            _timer = null;
         }
      }
      
      private static function listen() : void
      {
         _mochiLocalConnection.connect(_listenChannelName);
         _clip.handshake = function(args:Object):void
         {
            MochiServices.comChannelName = args.newChannel;
         };
         trace("Waiting for MochiAds services to connect...");
      }
      
      private static function initComChannels() : void
      {
         if(!_connected)
         {
            trace("[SERVICES_API] connected!");
            _connecting = false;
            _connected = true;
            _mochiLocalConnection.send(_sendChannelName,"onReceive",{"methodName":"handshakeDone"});
            _mochiLocalConnection.send(_sendChannelName,"onReceive",{
               "methodName":"registerGame",
               "preserved":_preserved,
               "id":_id,
               "version":getVersion(),
               "parentURL":_container.loaderInfo.loaderURL
            });
            _clip.onReceive = onReceive;
            _clip.onEvent = onEvent;
            _clip.onError = function():void
            {
               MochiServices.onError("IOError");
            };
            while(_queue.length > 0)
            {
               _mochiLocalConnection.send(_sendChannelName,"onReceive",_queue.shift());
            }
         }
      }
      
      private static function onReceive(pkg:Object) : void
      {
         var methodName:String = null;
         var cb:String = pkg.callbackID;
         var cblst:Object = _callbacks[cb];
         if(!cblst)
         {
            return;
         }
         var method:* = cblst.callbackMethod;
         methodName = "";
         var obj:Object = cblst.callbackObject;
         if(obj && typeof method == "string")
         {
            methodName = method;
            if(obj[method] != null)
            {
               method = obj[method];
            }
            else
            {
               trace("Error: Method  " + method + " does not exist.");
            }
         }
         if(method != undefined)
         {
            try
            {
               method.apply(obj,pkg.args);
            }
            catch(error:Error)
            {
               trace("Error invoking callback method \'" + methodName + "\': " + error.toString());
            }
         }
         else if(obj != null)
         {
            try
            {
               obj(pkg.args);
            }
            catch(error:Error)
            {
               trace("Error invoking method on object: " + error.toString());
            }
         }
         delete _callbacks[cb];
      }
      
      private static function onEvent(pkg:Object) : void
      {
         var target:String = pkg.target;
         var event:String = pkg.event;
         switch(target)
         {
            case "services":
               MochiServices.triggerEvent(pkg.event,pkg.args);
               break;
            case "events":
               MochiEvents.triggerEvent(pkg.event,pkg.args);
               break;
            case "coins":
               MochiCoins.triggerEvent(pkg.event,pkg.args);
               break;
            case "social":
               MochiSocial.triggerEvent(pkg.event,pkg.args);
         }
      }
      
      private static function flush(error:Boolean) : void
      {
         var request:Object = null;
         var callback:Object = null;
         if(_clip && _queue)
         {
            while(_queue.length > 0)
            {
               request = _queue.shift();
               callback = null;
               if(request != null)
               {
                  if(request.callbackID != null)
                  {
                     callback = _callbacks[request.callbackID];
                  }
                  delete _callbacks[request.callbackID];
                  if(error && callback != null)
                  {
                     handleError(request.args,callback.callbackObject,callback.callbackMethod);
                  }
               }
            }
         }
      }
      
      private static function handleError(args:Object, callbackObject:Object, callbackMethod:Object) : void
      {
         if(args != null)
         {
            if(args.onError != null)
            {
               args.onError("NotConnected");
            }
            if(args.options != null && args.options.onError != null)
            {
               args.options.onError("NotConnected");
            }
         }
         if(callbackMethod != null)
         {
            args = {};
            args.error = true;
            args.errorCode = "NotConnected";
            if(callbackObject != null && callbackMethod is String)
            {
               try
               {
                  callbackObject[callbackMethod](args);
               }
               catch(error:Error)
               {
               }
            }
            else if(callbackMethod != null)
            {
               try
               {
                  callbackMethod.apply(args);
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      public static function send(methodName:String, args:Object = null, callbackObject:Object = null, callbackMethod:Object = null) : void
      {
         if(_connected)
         {
            _mochiLocalConnection.send(_sendChannelName,"onReceive",{
               "methodName":methodName,
               "args":args,
               "callbackID":_nextCallbackID
            });
         }
         else
         {
            if(_clip == null || !_connecting)
            {
               trace("Error: MochiServices not connected.   Please call MochiServices.connect().  Function: " + methodName);
               handleError(args,callbackObject,callbackMethod);
               flush(true);
               return;
            }
            _queue.push({
               "methodName":methodName,
               "args":args,
               "callbackID":_nextCallbackID
            });
         }
         if(_clip != null)
         {
            if(_callbacks != null)
            {
               _callbacks[_nextCallbackID] = {
                  "callbackObject":callbackObject,
                  "callbackMethod":callbackMethod
               };
               ++_nextCallbackID;
            }
         }
      }
      
      private static function urlOptions(clip:Object) : Object
      {
         var options:String = null;
         var pairs:Array = null;
         var i:Number = NaN;
         var kv:Array = null;
         var opts:Object = {};
         if(clip.stage)
         {
            options = clip.stage.loaderInfo.parameters.mochiad_options;
         }
         else
         {
            options = clip.loaderInfo.parameters.mochiad_options;
         }
         if(options)
         {
            pairs = options.split("&");
            for(i = 0; i < pairs.length; i++)
            {
               kv = pairs[i].split("=");
               opts[unescape(kv[0])] = unescape(kv[1]);
            }
         }
         return opts;
      }
      
      public static function addLinkEvent(url:String, burl:String, btn:DisplayObjectContainer, onClick:Function = null) : void
      {
         var avm1Click:DisplayObject = null;
         var x:String = null;
         var req:URLRequest = null;
         var loader:Loader = null;
         var setURL:Function = null;
         var err:Function = null;
         var complete:Function = null;
         var vars:Object = new Object();
         vars["mav"] = getVersion();
         vars["swfv"] = "9";
         vars["swfurl"] = btn.loaderInfo.loaderURL;
         vars["fv"] = Capabilities.version;
         vars["os"] = Capabilities.os;
         vars["lang"] = Capabilities.language;
         vars["scres"] = Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
         var s:String = "?";
         var i:Number = 0;
         for(x in vars)
         {
            if(i != 0)
            {
               s += "&";
            }
            i++;
            s = s + x + "=" + escape(vars[x]);
         }
         req = new URLRequest("http://link.mochiads.com/linkping.swf");
         loader = new Loader();
         setURL = function(url:String):void
         {
            if(avm1Click)
            {
               btn.removeChild(avm1Click);
            }
            avm1Click = clickMovie(url,onClick);
            var rect:Rectangle = btn.getBounds(btn);
            btn.addChild(avm1Click);
            avm1Click.x = rect.x;
            avm1Click.y = rect.y;
            avm1Click.scaleX = 0.01 * rect.width;
            avm1Click.scaleY = 0.01 * rect.height;
         };
         err = function(ev:Object):void
         {
            netup = false;
            ev.target.removeEventListener(ev.type,arguments.callee);
            setURL(burl);
         };
         complete = function(ev:Object):void
         {
            ev.target.removeEventListener(ev.type,arguments.callee);
         };
         if(netup)
         {
            setURL(url + s);
         }
         else
         {
            setURL(burl);
         }
         if(!(netupAttempted || _connected))
         {
            netupAttempted = true;
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,err);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
            loader.load(req);
         }
      }
      
      private static function clickMovie(url:String, cb:Function) : MovieClip
      {
         var b:int = 0;
         var loader:Loader = null;
         var avm1_bytecode:Array = [150,21,0,7,1,0,0,0,0,98,116,110,0,7,2,0,0,0,0,116,104,105,115,0,28,150,22,0,0,99,114,101,97,116,101,69,109,112,116,121,77,111,118,105,101,67,108,105,112,0,82,135,1,0,0,23,150,13,0,4,0,0,111,110,82,101,108,101,97,115,101,0,142,8,0,0,0,0,2,42,0,114,0,150,17,0,0,32,0,7,1,0,0,0,8,0,0,115,112,108,105,116,0,82,135,1,0,1,23,150,7,0,4,1,7,0,0,0,0,78,150,8,0,0,95,98,108,97,110,107,0,154,1,0,0,150,7,0,0,99,108,105,99,107,0,150,7,0,4,1,7,1,0,0,0,78,150,27,0,7,2,0,0,0,7,0,0,0,0,0,76,111,99,97,108,67,111,110,110,101,99,116,105,111,110,0,64,150,6,0,0,115,101,110,100,0,82,79,150,15,0,4,0,0,95,97,108,112,104,97,0,7,0,0,0,0,79,150,23,0,7,255,0,255,0,7,1,0,0,0,4,0,0,98,101,103,105,110,70,105,108,108,0,82,23,150,25,0,7,0,0,0,0,7,0,0,0,0,7,2,0,0,0,4,0,0,109,111,118,101,84,111,0,82,23,150,25,0,7,100,0,0,0,7,0,0,0,0,7,2,0,0,0,4,0,0,108,105,110,101,84,111,0,82,23,150,25,0,7,100,0,0,0,7,100,0,0,0,7,2,0,0,0,4,0,0,108,105,110,101,84,111,0,82,23,150,25,0,7,0,0,0,0,7,100,0,0,0,7,2,0,0,0,4,0,0,108,105,110,101,84,111,0,82,23,150,25,0,7,0,0,0,0,7,0,0,0,0,7,2,0,0,0,4,0,0,108,105,110,101,84,111,0,82,23,150,16,0,7,0,0,0,0,4,0,0,101,110,100,70,105,108,108,0,82,23];
         var header:Array = [104,0,31,64,0,7,208,0,0,12,1,0,67,2,255,255,255,63,3];
         var footer:Array = [0,64,0,0,0];
         var mc:MovieClip = new MovieClip();
         var lc:LocalConnection = new LocalConnection();
         var lc_name:String = "_click_" + Math.floor(Math.random() * 999999) + "_" + Math.floor(new Date().time);
         lc = new LocalConnection();
         mc.lc = lc;
         mc.click = cb;
         lc.client = mc;
         lc.connect(lc_name);
         var ba:ByteArray = new ByteArray();
         var cpool:ByteArray = new ByteArray();
         cpool.endian = Endian.LITTLE_ENDIAN;
         cpool.writeShort(1);
         cpool.writeUTFBytes(url + " " + lc_name);
         cpool.writeByte(0);
         var actionLength:uint = avm1_bytecode.length + cpool.length + 4;
         var fileLength:uint = actionLength + 35;
         ba.endian = Endian.LITTLE_ENDIAN;
         ba.writeUTFBytes("FWS");
         ba.writeByte(8);
         ba.writeUnsignedInt(fileLength);
         for each(b in header)
         {
            ba.writeByte(b);
         }
         ba.writeUnsignedInt(actionLength);
         ba.writeByte(136);
         ba.writeShort(cpool.length);
         ba.writeBytes(cpool);
         for each(b in avm1_bytecode)
         {
            ba.writeByte(b);
         }
         for each(b in footer)
         {
            ba.writeByte(b);
         }
         loader = new Loader();
         loader.loadBytes(ba);
         mc.addChild(loader);
         return mc;
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
