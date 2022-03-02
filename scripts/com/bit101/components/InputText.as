package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class InputText extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _password:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _tf:TextField;
      
      public function InputText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", defaultHandler:Function = null)
      {
         this.text = text;
         super(parent,xpos,ypos);
         if(defaultHandler != null)
         {
            addEventListener(Event.CHANGE,defaultHandler);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,16);
      }
      
      override protected function addChildren() : void
      {
         this._back = new Sprite();
         this._back.filters = [getShadow(2,true)];
         addChild(this._back);
         this._tf = new TextField();
         this._tf.embedFonts = Style.embedFonts;
         this._tf.selectable = true;
         this._tf.type = TextFieldType.INPUT;
         this._tf.defaultTextFormat = new TextFormat(Style.fontName,Style.fontSize,Style.INPUT_TEXT);
         addChild(this._tf);
         this._tf.addEventListener(Event.CHANGE,this.onChange);
      }
      
      override public function draw() : void
      {
         super.draw();
         this._back.graphics.clear();
         this._back.graphics.beginFill(Style.BACKGROUND);
         this._back.graphics.drawRect(0,0,_width,_height);
         this._back.graphics.endFill();
         this._tf.displayAsPassword = this._password;
         if(this._text != null)
         {
            this._tf.text = this._text;
         }
         else
         {
            this._tf.text = "";
         }
         this._tf.width = _width - 4;
         if(this._tf.text == "")
         {
            this._tf.text = "X";
            this._tf.height = Math.min(this._tf.textHeight + 4,_height);
            this._tf.text = "";
         }
         else
         {
            this._tf.height = Math.min(this._tf.textHeight + 4,_height);
         }
         this._tf.x = 2;
         this._tf.y = Math.round(_height / 2 - this._tf.height / 2);
      }
      
      protected function onChange(event:Event) : void
      {
         this._text = this._tf.text;
         event.stopImmediatePropagation();
         dispatchEvent(event);
      }
      
      public function set text(t:String) : void
      {
         this._text = t;
         if(this._text == null)
         {
            this._text = "";
         }
         invalidate();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get textField() : TextField
      {
         return this._tf;
      }
      
      public function set restrict(str:String) : void
      {
         this._tf.restrict = str;
      }
      
      public function get restrict() : String
      {
         return this._tf.restrict;
      }
      
      public function set maxChars(max:int) : void
      {
         this._tf.maxChars = max;
      }
      
      public function get maxChars() : int
      {
         return this._tf.maxChars;
      }
      
      public function set password(b:Boolean) : void
      {
         this._password = b;
         invalidate();
      }
      
      public function get password() : Boolean
      {
         return this._password;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this._tf.tabEnabled = value;
      }
   }
}
