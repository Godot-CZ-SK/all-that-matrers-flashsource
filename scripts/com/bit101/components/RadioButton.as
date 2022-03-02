package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RadioButton extends Component
   {
      
      protected static var buttons:Array;
       
      
      protected var _back:Sprite;
      
      protected var _button:Sprite;
      
      protected var _selected:Boolean = false;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _groupName:String = "defaultRadioGroup";
      
      public function RadioButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", checked:Boolean = false, defaultHandler:Function = null)
      {
         RadioButton.addButton(this);
         this._selected = checked;
         this._labelText = label;
         super(parent,xpos,ypos);
         if(defaultHandler != null)
         {
            addEventListener(MouseEvent.CLICK,defaultHandler);
         }
      }
      
      protected static function addButton(rb:RadioButton) : void
      {
         if(buttons == null)
         {
            buttons = new Array();
         }
         buttons.push(rb);
      }
      
      protected static function clear(rb:RadioButton) : void
      {
         for(var i:uint = 0; i < buttons.length; i++)
         {
            if(buttons[i] != rb && buttons[i].groupName == rb.groupName)
            {
               buttons[i].selected = false;
            }
         }
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.CLICK,this.onClick,false,1);
         this.selected = this._selected;
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
         mouseChildren = false;
      }
      
      override public function draw() : void
      {
         super.draw();
         this._back.graphics.clear();
         this._back.graphics.beginFill(Style.BACKGROUND);
         this._back.graphics.drawCircle(5,5,5);
         this._back.graphics.endFill();
         this._button.graphics.clear();
         this._button.graphics.beginFill(Style.BUTTON_FACE);
         this._button.graphics.drawCircle(5,5,3);
         this._label.x = 12;
         this._label.y = (10 - this._label.height) / 2;
         this._label.text = this._labelText;
         this._label.draw();
         _width = this._label.width + 12;
         _height = 10;
      }
      
      protected function onClick(event:MouseEvent) : void
      {
         this.selected = true;
      }
      
      public function set selected(s:Boolean) : void
      {
         this._selected = s;
         this._button.visible = this._selected;
         if(this._selected)
         {
            RadioButton.clear(this);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
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
      
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function set groupName(value:String) : void
      {
         this._groupName = value;
      }
   }
}
