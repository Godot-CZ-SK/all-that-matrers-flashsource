package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   [Event(name="change",type="flash.events.Event")]
   public class UISlider extends Component
   {
       
      
      protected var _label:Label;
      
      protected var _valueLabel:Label;
      
      protected var _slider:Slider;
      
      protected var _precision:int = 1;
      
      protected var _sliderClass:Class;
      
      protected var _labelText:String;
      
      protected var _tick:Number = 1;
      
      public function UISlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
      {
         this._labelText = label;
         super(parent,xpos,ypos);
         if(defaultHandler != null)
         {
            addEventListener(Event.CHANGE,defaultHandler);
         }
         this.formatValueLabel();
      }
      
      override protected function addChildren() : void
      {
         this._label = new Label(this,0,0);
         this._slider = new this._sliderClass(this,0,0,this.onSliderChange);
         this._valueLabel = new Label(this);
      }
      
      protected function formatValueLabel() : void
      {
         var i:uint = 0;
         if(isNaN(this._slider.value))
         {
            this._valueLabel.text = "NaN";
            return;
         }
         var mult:Number = Math.pow(10,this._precision);
         var val:String = (Math.round(this._slider.value * mult) / mult).toString();
         var parts:Array = val.split(".");
         if(parts[1] == null)
         {
            if(this._precision > 0)
            {
               val += ".";
            }
            for(i = 0; i < this._precision; i++)
            {
               val += "0";
            }
         }
         else if(parts[1].length < this._precision)
         {
            for(i = 0; i < this._precision - parts[1].length; i++)
            {
               val += "0";
            }
         }
         this._valueLabel.text = val;
         this.positionLabel();
      }
      
      protected function positionLabel() : void
      {
      }
      
      override public function draw() : void
      {
         super.draw();
         this._label.text = this._labelText;
         this._label.draw();
         this.formatValueLabel();
      }
      
      public function setSliderParams(min:Number, max:Number, value:Number) : void
      {
         this._slider.setSliderParams(min,max,value);
      }
      
      protected function onSliderChange(event:Event) : void
      {
         this.formatValueLabel();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set value(v:Number) : void
      {
         this._slider.value = v;
         this.formatValueLabel();
      }
      
      public function get value() : Number
      {
         return this._slider.value;
      }
      
      public function set maximum(m:Number) : void
      {
         this._slider.maximum = m;
      }
      
      public function get maximum() : Number
      {
         return this._slider.maximum;
      }
      
      public function set minimum(m:Number) : void
      {
         this._slider.minimum = m;
      }
      
      public function get minimum() : Number
      {
         return this._slider.minimum;
      }
      
      public function set labelPrecision(decimals:int) : void
      {
         this._precision = decimals;
      }
      
      public function get labelPrecision() : int
      {
         return this._precision;
      }
      
      public function set label(str:String) : void
      {
         this._labelText = str;
         this.draw();
      }
      
      public function get label() : String
      {
         return this._labelText;
      }
      
      public function set tick(t:Number) : void
      {
         this._tick = t;
         this._slider.tick = this._tick;
      }
      
      public function get tick() : Number
      {
         return this._tick;
      }
   }
}
