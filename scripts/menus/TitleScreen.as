package menus
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import managers.DM;
   import managers.TM;
   
   public class TitleScreen
   {
      
      private static var _ins:TitleScreen;
       
      
      protected var _isCreated:Boolean;
      
      protected var _costume:MC_TitleScreen;
      
      protected var _fade:Sprite;
      
      public function TitleScreen()
      {
         super();
      }
      
      public static function get ins() : TitleScreen
      {
         if(!_ins)
         {
            _ins = new TitleScreen();
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
         this._costume = new MC_TitleScreen();
         DM.ins.menu.addChild(this._costume);
      }
      
      public function fadeIn(time:Number = 1) : void
      {
         this.create();
         this._costume.alpha = 0;
         TweenLite.to(this._costume,time,{"alpha":1});
      }
      
      public function fadeOutAndRemove(duration:Number) : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this._fade = new Sprite();
         this._fade.graphics.beginFill(16777215);
         this._fade.graphics.drawRect(0,0,640,480);
         this._fade.graphics.endFill();
         DM.ins.top.addChild(this._fade);
         this._fade.alpha = 0;
         TweenLite.to(this._fade,duration,{"alpha":1});
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_costume);
            TweenLite.to(_fade,0.5,{
               "alpha":0,
               "delay":0.5
            });
         },duration);
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(_fade);
         },duration + 1);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._costume);
         CF.removeDisplayObject(this._fade);
      }
   }
}
