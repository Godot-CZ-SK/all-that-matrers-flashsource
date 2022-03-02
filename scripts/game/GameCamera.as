package game
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GameCamera
   {
      
      public static var _layerNo:int = 0;
      
      public static const BACKGROUND:int = ++_layerNo;
      
      public static const LADDER:int = ++_layerNo;
      
      public static const STONE_BACK:int = ++_layerNo;
      
      public static const FLOWER_BACK:int = ++_layerNo;
      
      public static const UNIT_GLOW:int = ++_layerNo;
      
      public static const WALL:int = ++_layerNo;
      
      public static const TEXT:int = ++_layerNo;
      
      public static const OTHERS:int = ++_layerNo;
      
      public static const SIGN:int = ++_layerNo;
      
      public static const ELEVATOR:int = ++_layerNo;
      
      public static const DOOR:int = ++_layerNo;
      
      public static const SLIDE_DOOR:int = ++_layerNo;
      
      public static const PORTAL:int = ++_layerNo;
      
      public static const PORTAL_EFFECT:int = ++_layerNo;
      
      public static const THING:int = ++_layerNo;
      
      public static const OBSTACLE:int = ++_layerNo;
      
      public static const TRAP:int = ++_layerNo;
      
      public static const CHECKPOINT:int = ++_layerNo;
      
      public static const UO:int = ++_layerNo;
      
      public static const KEY:int = ++_layerNo;
      
      public static const LAYER_UNIT:int = ++_layerNo;
      
      public static const CANNON_BALL:int = ++_layerNo;
      
      public static const MINI_KEY:int = ++_layerNo;
      
      public static const POWER_UP:int = ++_layerNo;
      
      public static const PLATFORM:int = ++_layerNo;
      
      public static const CANNON:int = ++_layerNo;
      
      public static const LEVER:int = ++_layerNo;
      
      public static const CLOUD:int = ++_layerNo;
      
      public static const BOUNCER:int = ++_layerNo;
      
      public static const BLOWER:int = ++_layerNo;
      
      public static const LASER:int = ++_layerNo;
      
      public static const BUTTON:int = ++_layerNo;
      
      public static const GRAVITY_SWITCHER:int = ++_layerNo;
      
      public static const WHEEL:int = ++_layerNo;
      
      public static const CHAIN:int = ++_layerNo;
      
      public static const LAMP:int = ++_layerNo;
      
      public static const UNIT:int = ++_layerNo;
      
      public static const BLOOD:int = ++_layerNo;
      
      public static const FLOWER_FRONT:int = ++_layerNo;
      
      public static const STONE_FRONT:int = ++_layerNo;
      
      public static const HEART:int = ++_layerNo;
      
      public static const SIGN_TEXT:int = ++_layerNo;
      
      private static var _ins:GameCamera;
       
      
      private var _costume:MovieClip;
      
      private var _layerNoList:Array;
      
      public var x:Number;
      
      public var y:Number;
      
      public function GameCamera()
      {
         super();
      }
      
      public static function get ins() : GameCamera
      {
         if(!_ins)
         {
            _ins = new GameCamera();
         }
         return _ins;
      }
      
      public function setPosition(pX:Number, pY:Number) : void
      {
         this._costume.x = pX;
         this._costume.y = pY;
         this.x = pX;
         this.y = pY;
      }
      
      public function updatePosition(pX:Number, pY:Number, dX:Number = 0, dY:Number = 0) : void
      {
         TweenLite.to(this._costume,0.25,{
            "x":pX + dX,
            "y":pY + dY
         });
         this.x = pX;
         this.y = pY;
      }
      
      public function init(parent:DisplayObjectContainer) : void
      {
         this._costume = new MovieClip();
         parent.addChild(this._costume);
         this._layerNoList = [];
      }
      
      public function addChildTo(child:DisplayObject, layerNo:int) : void
      {
         this._layerNoList.push(layerNo);
         this._layerNoList.sort(Array.NUMERIC);
         var index:int = this._layerNoList.lastIndexOf(layerNo);
         this._costume.addChildAt(child,index);
         child.addEventListener(Event.REMOVED_FROM_STAGE,this.childRemovedHandler,false,0,true);
      }
      
      public function changeChildrenLayer(child:DisplayObject, layerNo:int) : void
      {
         this._costume.removeChild(child);
         this.addChildTo(child,layerNo);
      }
      
      private function childRemovedHandler(e:Event) : void
      {
         (e.currentTarget as DisplayObject).removeEventListener(Event.REMOVED,this.childRemovedHandler);
         var index:int = this._costume.getChildIndex(e.currentTarget as DisplayObject);
         this._layerNoList.splice(index,1);
      }
      
      public function reset() : void
      {
         TweenLite.killTweensOf(this._costume,false);
         var i:int = this._costume.numChildren;
         while(i--)
         {
            this._costume.removeChildAt(0);
         }
         this._layerNoList = [];
         this._costume.x = 0;
         this._costume.y = 0;
         this.x = 0;
         this.y = 0;
      }
      
      public function get costume() : MovieClip
      {
         return this._costume;
      }
   }
}
