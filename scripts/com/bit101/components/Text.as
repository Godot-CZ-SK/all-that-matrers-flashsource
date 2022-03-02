package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   [Event(name="change",type="flash.events.Event")]
   public class Text extends Component
   {
       
      
      protected var _tf:TextField;
      
      protected var _text:String = "";
      
      protected var _editable:Boolean = true;
      
      protected var _panel:Panel;
      
      protected var _selectable:Boolean = true;
      
      protected var _html:Boolean = false;
      
      protected var _format:TextFormat;
      
      public function Text(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "")
      {
         this.text = text;
         super(parent,xpos,ypos);
         setSize(200,100);
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         this._panel = new Panel(this);
         this._panel.color = Style.TEXT_BACKGROUND;
         this._format = new TextFormat(Style.fontName,Style.fontSize,Style.LABEL_TEXT);
         this._tf = new TextField();
         this._tf.x = 2;
         this._tf.y = 2;
         this._tf.height = _height;
         this._tf.embedFonts = Style.embedFonts;
         this._tf.multiline = true;
         this._tf.wordWrap = true;
         this._tf.selectable = true;
         this._tf.type = TextFieldType.INPUT;
         this._tf.defaultTextFormat = this._format;
         this._tf.addEventListener(Event.CHANGE,this.onChange);
         addChild(this._tf);
      }
      
      override public function draw() : void
      {
         super.draw();
         this._panel.setSize(_width,_height);
         this._panel.draw();
         this._tf.width = _width - 4;
         this._tf.height = _height - 4;
         if(this._html)
         {
            this._tf.htmlText = this._text;
         }
         else
         {
            this._tf.text = this._text;
         }
         if(this._editable)
         {
            this._tf.mouseEnabled = true;
            this._tf.selectable = true;
            this._tf.type = TextFieldType.INPUT;
         }
         else
         {
            this._tf.mouseEnabled = this._selectable;
            this._tf.selectable = this._selectable;
            this._tf.type = TextFieldType.DYNAMIC;
         }
         this._tf.setTextFormat(this._format);
      }
      
      protected function onChange(event:Event) : void
      {
         this._text = this._tf.text;
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
      
      public function set editable(b:Boolean) : void
      {
         this._editable = b;
         invalidate();
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set selectable(b:Boolean) : void
      {
         this._selectable = b;
         invalidate();
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set html(b:Boolean) : void
      {
         this._html = b;
         invalidate();
      }
      
      public function get html() : Boolean
      {
         return this._html;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this._tf.tabEnabled = value;
      }
   }
}
