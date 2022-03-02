package
{
   import Playtomic.Link;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import mochi.as3.MochiAd;
   
   public class Preloader extends MovieClip
   {
       
      
      private var _costume:MC_PreloadMenu;
      
      private var _bytesTotal:int;
      
      private const ALLOWED_DOMAINS:Array = ["flashgamelicense.com","kongregate.com","batiali.com","www.flashgamelicense.com","www.kongregate.com","www.batiali.com"];
      
      protected var _first:Boolean = true;
      
      public function Preloader()
      {
         super();
         if(stage)
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
         }
         this._bytesTotal = 0;
         this._costume = new MC_PreloadMenu();
         addChild(this._costume);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP;
         this._costume.mc_completed.visible = false;
         this._costume.mc_background.stop();
         this._costume.mc_loadBar.stop();
         this._costume.btn_sponsor.addEventListener(MouseEvent.CLICK,this.sponsorHandler,false,0,true);
         this._costume.btn_sponsor.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._costume.btn_sponsor.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._costume.btn_dev.addEventListener(MouseEvent.CLICK,this.sponsorHandler,false,0,true);
         this._costume.btn_dev.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._costume.btn_dev.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._costume.btn_sponsor.buttonMode = true;
         this._costume.btn_sponsor.mouseChildren = false;
         this._costume.btn_dev.buttonMode = true;
         this._costume.btn_dev.mouseChildren = false;
         this._costume.mc_ad.visible = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedHandler);
         var available:Boolean = true;
         var siteLocked:Boolean = false;
         if(siteLocked)
         {
            available = this.checkDomains();
         }
         if(available)
         {
            addEventListener(Event.ENTER_FRAME,this.checkFrame,false,0,true);
            loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress,false,0,true);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError,false,0,true);
            this._costume.mc_sitelock.visible = false;
         }
         else
         {
            this._costume.mc_loadBar.visible = false;
         }
      }
      
      private function addedHandler(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedHandler);
         MochiAd.showClickAwayAd({
            "clip":this._costume.mc_ad,
            "id":"228b3503b5dfbb9f",
            "ad_started":function():void
            {
               trace("Ad Started.");
            },
            "ad_loaded":function():void
            {
               _costume.mc_ad.visible = true;
               trace("Ad Loaded.");
            },
            "ad_failed":function():void
            {
               trace("Ad failed.");
            },
            "ad_progress":function(percent:Number):void
            {
               trace(percent);
            },
            "ad_finished":function():void
            {
               trace("Ad finished.");
            },
            "ad_skipped":function():void
            {
               trace("Ad skipped.");
               _costume.mc_ad.visible = false;
            }
         });
      }
      
      private function sponsorHandler(e:MouseEvent) : void
      {
         if(e.currentTarget == this._costume.btn_sponsor)
         {
            Link.Open(Constants.SPONSOR_LINK,"preloader","sponsor");
         }
         else if(e.currentTarget == this._costume.btn_dev)
         {
            Link.Open(Constants.DEV_LINK,"preloader","batiali");
         }
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("out");
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("over");
      }
      
      private function checkDomains() : Boolean
      {
         var domain:String = this.getHostNameFromUrl(stage.loaderInfo.loaderURL);
         if(domain.search("kongregate") >= 0 || domain.search("batiali") >= 0)
         {
            return true;
         }
         return false;
      }
      
      private function ioError(e:IOErrorEvent) : void
      {
         trace(e.text);
      }
      
      private function progress(e:ProgressEvent) : void
      {
         this._bytesTotal = e.bytesTotal;
         this._costume.mc_loadBar.txt_current.text = Math.round(e.bytesLoaded / 1000).toString();
         this._costume.mc_loadBar.txt_total.text = Math.round(e.bytesTotal / 1000).toString();
         var percent:Number = e.bytesLoaded / e.bytesTotal;
         this._costume.mc_loadBar.gotoAndStop(int(this._costume.mc_loadBar.totalFrames * percent));
         this._costume.mc_background.gotoAndStop(int(this._costume.mc_background.totalFrames * percent));
      }
      
      private function getHostNameFromUrl(url:String) : String
      {
         var i:int = 0;
         var cut:String = null;
         var arr:Array = url.split("://");
         var found:Boolean = false;
         for(i = 0; i < arr.length; i++)
         {
            cut = arr[i];
            if(cut.indexOf("/") >= 0)
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            trace("domain not found");
            return "";
         }
         var arr2:Array = cut.split("/");
         return arr2[0];
      }
      
      private function checkFrame(e:Event) : void
      {
         var mainClass:Class = null;
         var mainDisplay:DisplayObject = null;
         if(currentFrame == totalFrames)
         {
            stop();
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
            if(Constants.IS_TEST)
            {
               CF.removeDisplayObject(this._costume);
               stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
               this._costume.btn_continue.removeEventListener(MouseEvent.CLICK,this.clickHandler);
               mainClass = getDefinitionByName("Main") as Class;
               mainDisplay = new mainClass() as DisplayObject;
               addChild(mainDisplay);
            }
            else
            {
               setTimeout(function():void
               {
                  loadingFinished();
               },400);
            }
         }
      }
      
      private function loadingFinished() : void
      {
         this._costume.mc_loadBar.txt_current.text = Math.round(this._bytesTotal / 1000).toString();
         this._costume.mc_loadBar.txt_total.text = Math.round(this._bytesTotal / 1000).toString();
         this._costume.mc_loadBar.gotoAndStop(int(this._costume.mc_loadBar.totalFrames));
         this._costume.mc_background.gotoAndStop(int(this._costume.mc_background.totalFrames));
         TweenLite.to(this._costume.mc_loadBar,1,{
            "alpha":0,
            "y":60
         });
         TweenLite.to(this._costume.mc_completed,1,{
            "alpha":1,
            "delay":0.5
         });
         this._costume.mc_completed.visible = true;
         this._costume.mc_completed.alpha = 0;
         setTimeout(function():void
         {
            stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler,false,0,true);
            _costume.btn_continue.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
            stage.focus = stage;
         },1000);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         this.startup();
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         this.startup();
      }
      
      private function startup() : void
      {
         TweenLite.to(this._costume,2,{"alpha":0});
         setTimeout(function():void
         {
            CF.removeDisplayObject(_costume);
         },2000);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         this._costume.btn_continue.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         var mainClass:Class = getDefinitionByName("Main") as Class;
         var mainDisplay:DisplayObject = new mainClass() as DisplayObject;
         addChild(mainDisplay);
      }
   }
}
