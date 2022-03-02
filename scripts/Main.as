package
{
   import design.data.LevelData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.net.URLRequest;
   import flash.system.Security;
   import game.GameMusic;
   import game.Stats;
   import managers.GM;
   import managers.LM;
   import managers.Management;
   import managers.SM;
   import menus.BL_EndMenu;
   import menus.CreditsMenu;
   import menus.DesignMenu;
   import menus.EndMenu;
   import menus.HighscoresPanel;
   import menus.IntroMenu;
   import menus.LevelSelectionMenu;
   import menus.MainMenu;
   import menus.MemoriesMenu;
   import menus.PauseMenu;
   import menus.SkipMenu;
   import menus.SplashMenu;
   import menus.TitleScreen;
   import menus.UL_EndMenu;
   
   [SWF(frameRate="30",backgroundColor="#000000",width="640",height="480")]
   [Frame(factoryClass="Preloader")]
   public class Main extends Sprite
   {
      
      public static var s:Stage;
      
      public static var isKong:Boolean;
      
      public static var k;
      
      public static var loadLevel:LevelData;
       
      
      public function Main()
      {
         super();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
         }
      }
      
      public static function startUserLevel(id:String, ld:LevelData) : void
      {
         MainMenu.ins.remove();
         DesignMenu.ins.remove();
         LevelSelectionMenu.ins.remove();
         BL_EndMenu.ins.remove();
         CreditsMenu.ins.remove();
         EndMenu.ins.remove();
         HighscoresPanel.ins.remove();
         IntroMenu.ins.remove();
         MemoriesMenu.ins.remove();
         PauseMenu.ins.remove();
         SkipMenu.ins.remove();
         SplashMenu.ins.remove();
         TitleScreen.ins.remove();
         UL_EndMenu.ins.remove();
         GM.ins.startUserLevel(id,ld);
      }
      
      private function init(e:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         s = stage;
         s.scaleMode = StageScaleMode.NO_SCALE;
         s.align = StageAlign.TOP;
         s.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.keyFocusChangeHandler);
         s.addEventListener(FocusEvent.FOCUS_OUT,this.keyFocusChangeHandler);
         Stats.view();
         Management.init();
         SplashMenu.ins.create();
         SM.ins.playMusic(GameMusic.LEAP_OF_FAITH);
         var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
         var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
         Security.allowDomain(apiPath);
         var request:URLRequest = new URLRequest(apiPath);
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
         loader.load(request);
         this.addChild(loader);
         var domain:String = this.getHostNameFromUrl(stage.loaderInfo.loaderURL);
         trace("Our domain is: " + domain);
         if(domain.search("kongregate") >= 0)
         {
            isKong = true;
            trace("We are inside kongregate.");
         }
         else
         {
            isKong = false;
            trace("We are outside of kongregate.");
         }
      }
      
      private function loadComplete(event:Event) : void
      {
         k = event.target.content;
         k.sharedContent.addLoadListener("UserLevel",this.onUserLevel);
         k.services.connect();
         if(LM.ins.cp)
         {
            LM.ins.cp.initKong();
         }
      }
      
      private function onUserLevel(params:Object) : void
      {
         var id:Number = params.id;
         var name:String = params.name;
         var permalink:String = params.permalink;
         var content:String = params.content;
         var label:String = params.label;
         var ld:LevelData = new LevelData();
         ld.loadLevelFromString(content);
         ld.setLevelName(name);
         startUserLevel(id.toString(),ld);
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
      
      private function keyFocusChangeHandler(e:FocusEvent) : void
      {
         Main.s.focus = Main.s;
      }
   }
}
