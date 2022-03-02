package com.bit101.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="resize",type="flash.events.Event")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="select",type="flash.events.Event")]
   public class Window extends Component
   {
       
      
      protected var _title:String;
      
      protected var _titleBar:Panel;
      
      protected var _titleLabel:Label;
      
      protected var _panel:Panel;
      
      protected var _color:int = -1;
      
      protected var _shadow:Boolean = true;
      
      protected var _draggable:Boolean = true;
      
      protected var _minimizeButton:Sprite;
      
      protected var _hasMinimizeButton:Boolean = false;
      
      protected var _minimized:Boolean = false;
      
      protected var _hasCloseButton:Boolean;
      
      protected var _closeButton:PushButton;
      
      protected var _grips:Shape;
      
      public function Window(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "Window")
      {
         this._title = title;
         super(parent,xpos,ypos);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,100);
      }
      
      override protected function addChildren() : void
      {
         this._titleBar = new Panel();
         this._titleBar.filters = [];
         this._titleBar.buttonMode = true;
         this._titleBar.useHandCursor = true;
         this._titleBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseGoDown);
         this._titleBar.height = 20;
         super.addChild(this._titleBar);
         this._titleLabel = new Label(this._titleBar.content,5,1,this._title);
         this._grips = new Shape();
         for(var i:int = 0; i < 4; i++)
         {
            this._grips.graphics.lineStyle(1,16777215,0.55);
            this._grips.graphics.moveTo(0,3 + i * 4);
            this._grips.graphics.lineTo(100,3 + i * 4);
            this._grips.graphics.lineStyle(1,0,0.125);
            this._grips.graphics.moveTo(0,4 + i * 4);
            this._grips.graphics.lineTo(100,4 + i * 4);
         }
         this._titleBar.content.addChild(this._grips);
         this._grips.visible = false;
         this._panel = new Panel(null,0,20);
         this._panel.visible = !this._minimized;
         this._panel.background.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseGoDown);
         super.addChild(this._panel);
         this._minimizeButton = new Sprite();
         this._minimizeButton.graphics.beginFill(0,0);
         this._minimizeButton.graphics.drawRect(-10,-10,20,20);
         this._minimizeButton.graphics.endFill();
         this._minimizeButton.graphics.beginFill(0,0.35);
         this._minimizeButton.graphics.moveTo(-5,-3);
         this._minimizeButton.graphics.lineTo(5,-3);
         this._minimizeButton.graphics.lineTo(0,4);
         this._minimizeButton.graphics.lineTo(-5,-3);
         this._minimizeButton.graphics.endFill();
         this._minimizeButton.x = 10;
         this._minimizeButton.y = 10;
         this._minimizeButton.useHandCursor = true;
         this._minimizeButton.buttonMode = true;
         this._minimizeButton.addEventListener(MouseEvent.CLICK,this.onMinimize);
         this._closeButton = new PushButton(null,86,6,"",this.onClose);
         this._closeButton.setSize(8,8);
         filters = [getShadow(4,false)];
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         this.content.addChild(child);
         return child;
      }
      
      public function addRawChild(child:DisplayObject) : DisplayObject
      {
         super.addChild(child);
         return child;
      }
      
      override public function draw() : void
      {
         super.draw();
         this._titleBar.color = this._color;
         this._panel.color = this._color;
         this._titleBar.width = width;
         this._titleBar.draw();
         this._titleLabel.x = !!this._hasMinimizeButton ? Number(20) : Number(5);
         this._closeButton.x = _width - 14;
         this._grips.x = this._titleLabel.x + this._titleLabel.width;
         if(this._hasCloseButton)
         {
            this._grips.width = this._closeButton.x - this._grips.x - 2;
         }
         else
         {
            this._grips.width = _width - this._grips.x - 2;
         }
         this._panel.setSize(_width,_height - 20);
         this._panel.draw();
      }
      
      protected function onMouseGoDown(event:MouseEvent) : void
      {
         if(this._draggable)
         {
            this.startDrag();
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseGoUp);
            parent.addChild(this);
         }
         dispatchEvent(new Event(Event.SELECT));
      }
      
      protected function onMouseGoUp(event:MouseEvent) : void
      {
         this.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseGoUp);
      }
      
      protected function onMinimize(event:MouseEvent) : void
      {
         this.minimized = !this.minimized;
      }
      
      protected function onClose(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function set shadow(b:Boolean) : void
      {
         this._shadow = b;
         if(this._shadow)
         {
            filters = [getShadow(4,false)];
         }
         else
         {
            filters = [];
         }
      }
      
      public function get shadow() : Boolean
      {
         return this._shadow;
      }
      
      public function set color(c:int) : void
      {
         this._color = c;
         invalidate();
      }
      
      public function get color() : int
      {
         return this._color;
      }
      
      public function set title(t:String) : void
      {
         this._title = t;
         this._titleLabel.text = this._title;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get content() : DisplayObjectContainer
      {
         return this._panel.content;
      }
      
      public function set draggable(b:Boolean) : void
      {
         this._draggable = b;
         this._titleBar.buttonMode = this._draggable;
         this._titleBar.useHandCursor = this._draggable;
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      public function set hasMinimizeButton(b:Boolean) : void
      {
         this._hasMinimizeButton = b;
         if(this._hasMinimizeButton)
         {
            super.addChild(this._minimizeButton);
         }
         else if(contains(this._minimizeButton))
         {
            removeChild(this._minimizeButton);
         }
         invalidate();
      }
      
      public function get hasMinimizeButton() : Boolean
      {
         return this._hasMinimizeButton;
      }
      
      public function set minimized(value:Boolean) : void
      {
         this._minimized = value;
         if(this._minimized)
         {
            if(contains(this._panel))
            {
               removeChild(this._panel);
            }
            this._minimizeButton.rotation = -90;
         }
         else
         {
            if(!contains(this._panel))
            {
               super.addChild(this._panel);
            }
            this._minimizeButton.rotation = 0;
         }
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      public function get minimized() : Boolean
      {
         return this._minimized;
      }
      
      override public function get height() : Number
      {
         if(contains(this._panel))
         {
            return super.height;
         }
         return 20;
      }
      
      public function set hasCloseButton(value:Boolean) : void
      {
         this._hasCloseButton = value;
         if(this._hasCloseButton)
         {
            this._titleBar.content.addChild(this._closeButton);
         }
         else if(this._titleBar.content.contains(this._closeButton))
         {
            this._titleBar.content.removeChild(this._closeButton);
         }
         invalidate();
      }
      
      public function get hasCloseButton() : Boolean
      {
         return this._hasCloseButton;
      }
      
      public function get titleBar() : Panel
      {
         return this._titleBar;
      }
      
      public function set titleBar(value:Panel) : void
      {
         this._titleBar = value;
      }
      
      public function get grips() : Shape
      {
         return this._grips;
      }
   }
}
