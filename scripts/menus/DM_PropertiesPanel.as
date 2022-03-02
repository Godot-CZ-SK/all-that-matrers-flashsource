package menus
{
   import com.bit101.components.Label;
   import com.bit101.components.RadioButton;
   import com.bit101.components.Window;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import managers.KM;
   
   public class DM_PropertiesPanel
   {
       
      
      protected var _costume:MovieClip;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _isCreated:Boolean;
      
      protected var _window:Window;
      
      protected var _firstGravityLabel:Label;
      
      protected var _upButton:RadioButton;
      
      protected var _downButton:RadioButton;
      
      protected const ww:Number = 320;
      
      protected const wh:Number = 320;
      
      public function DM_PropertiesPanel(parent:DisplayObjectContainer)
      {
         super();
         this._parent = parent;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MovieClip();
         this._costume.graphics.beginFill(0,0.8);
         this._costume.graphics.drawRect(0,0,640,480);
         this._costume.graphics.endFill();
         this._parent.addChild(this._costume);
         this._window = new Window(this._costume,(640 - this.ww) / 2,(480 - this.wh) / 2,"Properties");
         this._window.setSize(this.ww,this.wh);
         this._window.draggable = false;
         this._window.hasCloseButton = true;
         this._window.hasMinimizeButton = false;
         this._window.addEventListener(Event.CLOSE,this.closeHandler,false,0,true);
         this._firstGravityLabel = new Label(this._window.content,10,10,"First Gravity:");
         this._upButton = new RadioButton(this._window.content,10,40,"UP",false);
         this._downButton = new RadioButton(this._window.content,60,40,"DOWN",false);
         if(DesignMenu.ins.gravityAngle == 0)
         {
            this._downButton.selected = true;
         }
         else
         {
            this._upButton.selected = true;
         }
         this._upButton.addEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         this._downButton.addEventListener(MouseEvent.CLICK,this.buttonClickHandler);
         Main.s.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == KM.ESCAPE)
         {
            this.remove();
         }
      }
      
      private function buttonClickHandler(e:MouseEvent) : void
      {
         if(this._downButton.selected)
         {
            DesignMenu.ins.gravityAngle = 0;
         }
         else
         {
            DesignMenu.ins.gravityAngle = Math.PI;
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
         Main.s.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      protected function closeHandler(e:Event) : void
      {
         this.remove();
      }
      
      public function get isCreated() : Boolean
      {
         return this._isCreated;
      }
   }
}
