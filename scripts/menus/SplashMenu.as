package menus
{
   import Playtomic.Link;
   import design.data.LevelData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameSound;
   import managers.DM;
   import managers.SM;
   
   public class SplashMenu
   {
      
      private static var _ins:SplashMenu;
       
      
      protected var _isCreated:Boolean;
      
      protected var _isCompleted:Boolean;
      
      protected var _loadLevelAfter:LevelData;
      
      protected var _costume:MC_SponsorIntro;
      
      public function SplashMenu()
      {
         super();
      }
      
      public static function get ins() : SplashMenu
      {
         if(!_ins)
         {
            _ins = new SplashMenu();
         }
         return _ins;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_SponsorIntro();
         DM.ins.menu.addChild(this._costume);
         this._costume.btn_sponsor.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._costume.addEventListener("end",this.endHandler);
         this._costume.addEventListener("bomb",this.bombHandler);
         this._costume.addEventListener("drop",this.dropHandler);
      }
      
      private function endHandler(e:Event) : void
      {
         this.remove();
         this._isCompleted = true;
         if(!this._loadLevelAfter)
         {
            MainMenu.ins.firstTime();
            MainMenu.ins.create();
         }
      }
      
      private function bombHandler(e:Event) : void
      {
         SM.ins.playSound(GameSound.SEEKER_EXPLODE);
      }
      
      private function dropHandler(e:Event) : void
      {
         SM.ins.playSound(GameSound.BOX_DROP);
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var frame:int = this._costume.currentFrame;
         if(frame > 170)
         {
            Link.Open(Constants.DEV_LINK,"splashMenu","batiali");
         }
         else
         {
            Link.Open(Constants.SPONSOR_LINK,"splashMenu","sponsor");
         }
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._costume);
      }
      
      public function get isCompleted() : Boolean
      {
         return this._isCompleted;
      }
      
      public function get loadLevelAfter() : LevelData
      {
         return this._loadLevelAfter;
      }
      
      public function set loadLevelAfter(value:LevelData) : void
      {
         this._loadLevelAfter = value;
      }
   }
}
