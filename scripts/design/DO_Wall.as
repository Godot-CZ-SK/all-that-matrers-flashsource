package design
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.Label;
   import com.bit101.components.RadioButton;
   import com.gskinner.utils.Rndm;
   import design.data.DO_PolyData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ConvolutionFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameCamera;
   import managers.DM;
   
   public class DO_Wall extends DO_Poly
   {
       
      
      protected var _bitmapCostume:Bitmap;
      
      protected var _cs1:RadioButton;
      
      protected var _cs2:RadioButton;
      
      protected var _cs3:RadioButton;
      
      protected var _cs4:RadioButton;
      
      protected var _typeSelector:HUISlider;
      
      protected var _colorLabel:Label;
      
      protected var _lineColor:uint = 2565927;
      
      public function DO_Wall(parent:DisplayObjectContainer)
      {
         _data = new DO_PolyData(DO_PolyData.WALL);
         super(parent,GameCamera.WALL);
      }
      
      override public function drawRealCostume() : void
      {
         var tempCostume:MovieClip = null;
         var ti:int = 0;
         var bi:int = 0;
         var li:int = 0;
         var ri:int = 0;
         tempCostume = new MovieClip();
         _realCostume = new MovieClip();
         _costume.addChild(_realCostume);
         var i:int = 0;
         var j:int = 0;
         var top:Number = 100000;
         var bot:Number = -100000;
         var left:Number = 100000;
         var right:Number = -100000;
         var width:Number = 30;
         var height:Number = 10;
         if(_data.wallType == 2)
         {
            width = 20;
            height = 10;
         }
         else if(_data.wallType == 3)
         {
            width = 20;
            height = 20;
         }
         else if(_data.wallType == 4)
         {
            width = 10;
            height = 20;
         }
         else if(_data.wallType == 5)
         {
            width = 10;
            height = 30;
         }
         var colors:Array = [_data.color1,_data.color2,_data.color3];
         Rndm.reset();
         Rndm.seed = _data.seed;
         for(i = 0; i < _data.vertices.length; i++)
         {
            if(_data.vertices[i].x > right)
            {
               right = _data.vertices[i].x;
               ri = i;
            }
            if(_data.vertices[i].x < left)
            {
               left = _data.vertices[i].x;
               li = i;
            }
            if(_data.vertices[i].y > bot)
            {
               bot = _data.vertices[i].y;
               bi = i;
            }
            if(_data.vertices[i].y < top)
            {
               top = _data.vertices[i].y;
               ti = i;
            }
         }
         tempCostume.graphics.clear();
         tempCostume.graphics.lineStyle(1,this._lineColor,1);
         if(_data.wallType == 1 || _data.wallType == 2)
         {
            for(i = left - width / 2; i < right; i += width)
            {
               for(j = top; j < bot; j += height)
               {
                  tempCostume.graphics.beginFill(colors[Math.floor(3 * Rndm.random())],1);
                  if(int((j - top) / height) % 2 == 0)
                  {
                     tempCostume.graphics.drawRect(i,j,width,height);
                  }
                  else
                  {
                     tempCostume.graphics.drawRect(i + width / 2,j,width,height);
                  }
               }
            }
         }
         else if(_data.wallType == 4 || _data.wallType == 5)
         {
            for(i = left; i < right; i += width)
            {
               for(j = top - height / 2; j < bot; j += height)
               {
                  tempCostume.graphics.beginFill(colors[Math.floor(3 * Rndm.random())],1);
                  if(int((i - left) / width) % 2 == 0)
                  {
                     tempCostume.graphics.drawRect(i,j,width,height);
                  }
                  else
                  {
                     tempCostume.graphics.drawRect(i,j + height / 2,width,height);
                  }
               }
            }
         }
         else
         {
            for(i = left; i < right; i += width)
            {
               for(j = top; j < bot; j += height)
               {
                  tempCostume.graphics.beginFill(colors[Math.floor(3 * Rndm.random())],1);
                  tempCostume.graphics.drawRect(i,j,width,height);
               }
            }
         }
         tempCostume.graphics.endFill();
         tempCostume.graphics.lineStyle(2,this._lineColor,1);
         tempCostume.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            tempCostume.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         tempCostume.graphics.lineTo(_data.vertices[0].x,_data.vertices[0].y);
         tempCostume.graphics.endFill();
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,1,1,0,1,0],1.35);
         var noiseData:BitmapData = new BitmapData(right - left,bot - top,true,16777215);
         var base:Number = 150;
         noiseData.perlinNoise(base,base,4,_data.seed,false,false,7,true);
         noiseData.applyFilter(noiseData,noiseData.rect,new Point(),cf);
         noiseData.applyFilter(noiseData,noiseData.rect,new Point(),cf);
         var noiseBitmap:Bitmap = new Bitmap(noiseData);
         noiseBitmap.alpha = 0.4;
         noiseBitmap.x = left;
         noiseBitmap.y = top;
         tempCostume.addChild(noiseBitmap);
         _mask = new Sprite();
         _mask.graphics.clear();
         _mask.graphics.beginFill(0,1);
         _mask.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _mask.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         _mask.graphics.endFill();
         tempCostume.mask = _mask;
         var bmd:BitmapData = new BitmapData(right - left + 10,bot - top + 10,true,16777215);
         var ct:ColorTransform = new ColorTransform(1,1,1);
         var mt:Matrix = new Matrix();
         mt.translate(-left + 5,-top + 5);
         var rect:Rectangle = new Rectangle(0,0,right - left + 10,bot - top + 10);
         bmd.draw(tempCostume,mt,ct,BlendMode.NORMAL,rect);
         bmd.applyFilter(bmd,bmd.rect,new Point(),cf);
         this._bitmapCostume = new Bitmap(bmd);
         this._bitmapCostume.x = left - 5;
         this._bitmapCostume.y = top - 5;
         GameCamera.ins.addChildTo(_mask,_layerNo);
         this._bitmapCostume.mask = _mask;
         _realCostume.addChild(this._bitmapCostume);
         CF.removeDisplayObject(tempCostume);
         CF.removeDisplayObject(noiseBitmap);
      }
      
      override public function drawProperties() : void
      {
         _propCostume = new MovieClip();
         _propCostume.graphics.clear();
         _propCostume.graphics.beginFill(16777215,0.9);
         _propCostume.graphics.drawRect(0,440,160,40);
         _propCostume.graphics.endFill();
         this._colorLabel = new Label(_propCostume,5,440,"Color");
         this._cs1 = new RadioButton(_propCostume,40,445,"1");
         this._cs2 = new RadioButton(_propCostume,70,445,"2");
         this._cs3 = new RadioButton(_propCostume,100,445,"3");
         this._cs4 = new RadioButton(_propCostume,130,445,"4");
         this._cs1.addEventListener(MouseEvent.CLICK,this.setClickHandler);
         this._cs2.addEventListener(MouseEvent.CLICK,this.setClickHandler);
         this._cs3.addEventListener(MouseEvent.CLICK,this.setClickHandler);
         this._cs4.addEventListener(MouseEvent.CLICK,this.setClickHandler);
         if(_data.isItSet(1))
         {
            this._cs1.selected = true;
         }
         if(_data.isItSet(2))
         {
            this._cs2.selected = true;
         }
         if(_data.isItSet(3))
         {
            this._cs3.selected = true;
         }
         if(_data.isItSet(4))
         {
            this._cs4.selected = true;
         }
         this._typeSelector = new HUISlider(_propCostume,5,460,"Type");
         this._typeSelector.setSize(160,20);
         this._typeSelector.addEventListener(Event.CHANGE,this.typeChangeHandler);
         this._typeSelector.minimum = 1;
         this._typeSelector.maximum = 5;
         this._typeSelector.value = _data.wallType;
         DM.ins.menu.addChild(_propCostume);
         super.drawProperties();
      }
      
      private function typeChangeHandler(e:Event) : void
      {
         _data.wallType = this._typeSelector.value;
      }
      
      private function setClickHandler(e:MouseEvent) : void
      {
         if(this._cs1.selected)
         {
            _data.selectSet(1);
         }
         else if(this._cs2.selected)
         {
            _data.selectSet(2);
         }
         else if(this._cs3.selected)
         {
            _data.selectSet(3);
         }
         else if(this._cs4.selected)
         {
            _data.selectSet(4);
         }
      }
      
      override public function removeProperties() : void
      {
         CF.removeDisplayObject(this._cs1);
         CF.removeDisplayObject(this._cs2);
         CF.removeDisplayObject(this._cs3);
         CF.removeDisplayObject(this._cs4);
         CF.removeDisplayObject(this._colorLabel);
         CF.removeDisplayObject(this._typeSelector);
         CF.removeDisplayObject(_propCostume);
         super.removeProperties();
      }
   }
}
