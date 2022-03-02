package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TextArea extends Text
   {
       
      
      protected var _scrollbar:VScrollBar;
      
      public function TextArea(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "")
      {
         super(parent,xpos,ypos,text);
      }
      
      override protected function init() : void
      {
         super.init();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._scrollbar = new VScrollBar(this,0,0,this.onScrollbarScroll);
         _tf.addEventListener(Event.SCROLL,this.onTextScroll);
      }
      
      protected function updateScrollbar() : void
      {
         var visibleLines:int = _tf.numLines - _tf.maxScrollV + 1;
         var percent:Number = visibleLines / _tf.numLines;
         this._scrollbar.setSliderParams(1,_tf.maxScrollV,_tf.scrollV);
         this._scrollbar.setThumbPercent(percent);
         this._scrollbar.pageSize = visibleLines;
      }
      
      override public function draw() : void
      {
         super.draw();
         _tf.width = _width - this._scrollbar.width - 4;
         this._scrollbar.x = _width - this._scrollbar.width;
         this._scrollbar.height = _height;
         this._scrollbar.draw();
         addEventListener(Event.ENTER_FRAME,this.onTextScrollDelay);
      }
      
      protected function onTextScrollDelay(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onTextScrollDelay);
         this.updateScrollbar();
      }
      
      override protected function onChange(event:Event) : void
      {
         super.onChange(event);
         this.updateScrollbar();
      }
      
      protected function onScrollbarScroll(event:Event) : void
      {
         _tf.scrollV = Math.round(this._scrollbar.value);
      }
      
      protected function onTextScroll(event:Event) : void
      {
         this._scrollbar.value = _tf.scrollV;
         this.updateScrollbar();
      }
      
      protected function onMouseWheel(event:MouseEvent) : void
      {
         this._scrollbar.value -= event.delta;
         _tf.scrollV = Math.round(this._scrollbar.value);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         _tf.tabEnabled = value;
      }
      
      public function set autoHideScrollBar(value:Boolean) : void
      {
         this._scrollbar.autoHide = value;
      }
      
      public function get autoHideScrollBar() : Boolean
      {
         return this._scrollbar.autoHide;
      }
   }
}
