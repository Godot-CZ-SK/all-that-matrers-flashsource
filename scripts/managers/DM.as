package managers
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.filters.ColorMatrixFilter;
   import game.GameCamera;
   
   public class DM
   {
      
      private static var _ins:DM;
       
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _costume:MovieClip;
      
      protected var _bwTimer:int;
      
      protected var _bwMax:int;
      
      public var top:MovieClip;
      
      public var menu:MovieClip;
      
      public var bg:MovieClip;
      
      public var game_mc:MovieClip;
      
      public var fg:MovieClip;
      
      public var iface:MovieClip;
      
      public var physics:MovieClip;
      
      public var debug:MovieClip;
      
      public function DM()
      {
         super();
      }
      
      public static function get ins() : DM
      {
         if(!_ins)
         {
            _ins = new DM();
         }
         return _ins;
      }
      
      public function init(parent:DisplayObjectContainer) : void
      {
         this._bwTimer = 0;
         this._bwMax = 0;
         this._parent = parent;
         this._costume = new MovieClip();
         this.top = new MovieClip();
         this.menu = new MovieClip();
         this.bg = new MovieClip();
         this.game_mc = new MovieClip();
         this.fg = new MovieClip();
         this.iface = new MovieClip();
         this.physics = new MovieClip();
         this.debug = new MovieClip();
         this._parent.addChild(this._costume);
         this._costume.addChild(this.bg);
         this._costume.addChild(this.game_mc);
         this._costume.addChild(this.fg);
         this._costume.addChild(this.iface);
         this._costume.addChild(this.menu);
         this._costume.addChild(this.top);
         this._costume.addChild(this.physics);
         this._costume.addChild(this.debug);
         this.debug.visible = false;
         this.physics.visible = false;
         parent.addEventListener(KeyboardEvent.KEY_UP,this.keyUpListener,false,0,true);
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(0);
         mask.graphics.drawRect(0,0,640,480);
         mask.graphics.endFill();
         this._parent.addChild(mask);
         var mask2:Sprite = new Sprite();
         mask2.graphics.beginFill(0);
         mask2.graphics.drawRect(0,0,640,480);
         mask2.graphics.endFill();
         this._costume.mask = mask;
         GameCamera.ins.init(this.game_mc);
      }
      
      public function setBlackAndWhite(bool:Boolean) : void
      {
         var xc:Number = NaN;
         var yc:Number = NaN;
         var cmf:ColorMatrixFilter = null;
         if(bool)
         {
            xc = 1 / 3;
            yc = 1 / 3;
            cmf = new ColorMatrixFilter([xc,yc,yc,0,0,yc,xc,yc,0,0,yc,yc,xc,0,0,0,0,0,1,0]);
            this.game_mc.filters = [cmf];
            this.bg.filters = [cmf];
         }
         else
         {
            this.game_mc.filters = [];
            this.bg.filters = [];
         }
      }
      
      public function timedBlackAndWhite(time:int) : void
      {
         this._bwTimer = time;
         this._bwMax = time;
      }
      
      public function update() : void
      {
         var ratio:Number = NaN;
         var xc:Number = NaN;
         var yc:Number = NaN;
         var cmf:ColorMatrixFilter = null;
         if(this._bwTimer > 0)
         {
            ratio = 1 - this._bwTimer / this._bwMax;
            xc = 1 / 3 + 2 / 3 * ratio;
            yc = 1 / 3 - 1 / 3 * ratio;
            cmf = new ColorMatrixFilter([xc,yc,yc,0,0,yc,xc,yc,0,0,yc,yc,xc,0,0,0,0,0,1,0]);
            --this._bwTimer;
            if(this._bwTimer == 0)
            {
               this.game_mc.filters = [];
               this.bg.filters = [];
            }
            else
            {
               this.game_mc.filters = [cmf];
               this.bg.filters = [cmf];
            }
         }
      }
      
      public function setPhysicsPosition(pX:Number, pY:Number, dX:Number = 0, dY:Number = 0) : void
      {
         TweenLite.to(this.physics,0.25,{
            "x":pX + dX,
            "y":pY + dY
         });
      }
      
      private function keyUpListener(e:KeyboardEvent) : void
      {
         if(e.keyCode == 221)
         {
            this.debug.visible = !this.debug.visible;
         }
         else if(e.keyCode == 219)
         {
            this.physics.visible = !this.physics.visible;
         }
      }
      
      public function reset() : void
      {
         GameCamera.ins.reset();
      }
   }
}
