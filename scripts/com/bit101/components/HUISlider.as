package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   
   public class HUISlider extends UISlider
   {
       
      
      public function HUISlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
      {
         _sliderClass = HSlider;
         super(parent,xpos,ypos,label,defaultHandler);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(200,18);
      }
      
      override protected function positionLabel() : void
      {
         _valueLabel.x = _slider.x + _slider.width + 5;
      }
      
      override public function draw() : void
      {
         super.draw();
         _slider.x = _label.width + 5;
         _slider.y = height / 2 - _slider.height / 2;
         _slider.width = width - _label.width - 50 - 10;
         _valueLabel.x = _slider.x + _slider.width + 5;
      }
   }
}
