package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CheckBox extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _button:Sprite;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _selected:Boolean = false;
      
      public function CheckBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
      {
         this._labelText = label;
         super(parent,xpos,ypos);
         if(defaultHandler != null)
         {
            addEventListener(MouseEvent.CLICK,defaultHandler);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
      }
      
      override protected function addChildren() : void
      {
         this._back = new Sprite();
         this._back.filters = [getShadow(2,true)];
         addChild(this._back);
         this._button = new Sprite();
         this._button.filters = [getShadow(1)];
         this._button.visible = false;
         addChild(this._button);
         this._label = new Label(this,0,0,this._labelText);
         this.draw();
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override public function draw() : void
      {
         super.draw();
         this._back.graphics.clear();
         this._back.graphics.beginFill(Style.BACKGROUND);
         this._back.graphics.drawRect(0,0,10,10);
         this._back.graphics.endFill();
         this._button.graphics.clear();
         this._button.graphics.beginFill(Style.BUTTON_FACE);
         this._button.graphics.drawRect(2,2,6,6);
         this._label.text = this._labelText;
         this._label.draw();
         this._label.x = 12;
         this._label.y = (10 - this._label.height) / 2;
         _width = this._label.width + 12;
         _height = 10;
      }
      
      protected function onClick(event:MouseEvent) : void
      {
         this._selected = !this._selected;
         this._button.visible = this._selected;
      }
      
      public function set label(str:String) : void
      {
         this._labelText = str;
         invalidate();
      }
      
      public function get label() : String
      {
         return this._labelText;
      }
      
      public function set selected(s:Boolean) : void
      {
         this._selected = s;
         this._button.visible = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         mouseChildren = false;
      }
   }
}
