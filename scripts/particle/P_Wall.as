package particle
{
   import com.gskinner.utils.Rndm;
   import design.data.DO_PolyData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ConvolutionFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameCamera;
   
   public class P_Wall extends P_Polygon
   {
       
      
      protected var _colors:Array;
      
      protected var _lineColor:uint = 2565927;
      
      public function P_Wall(layerNo:int, data:DO_PolyData)
      {
         super(layerNo,data);
      }
      
      override public function drawCostume() : void
      {
         var ti:int = 0;
         var bi:int = 0;
         var li:int = 0;
         var ri:int = 0;
         _costume = new MovieClip();
         var i:int = 0;
         var j:int = 0;
         var top:Number = 100000;
         var bot:Number = -100000;
         var left:Number = 100000;
         var right:Number = -100000;
         this._colors = [_data.color1,_data.color2,_data.color3];
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
         _costume.graphics.clear();
         _costume.graphics.lineStyle(1,this._lineColor,1);
         if(_data.wallType == 1 || _data.wallType == 2)
         {
            for(i = left - width / 2; i < right; i += width)
            {
               for(j = top; j < bot; j += height)
               {
                  _costume.graphics.beginFill(this._colors[Math.floor(3 * Rndm.random())],1);
                  if(int((j - top) / height) % 2 == 0)
                  {
                     _costume.graphics.drawRect(i,j,width,height);
                  }
                  else
                  {
                     _costume.graphics.drawRect(i + width / 2,j,width,height);
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
                  _costume.graphics.beginFill(this._colors[Math.floor(3 * Rndm.random())],1);
                  if(int((i - left) / width) % 2 == 0)
                  {
                     _costume.graphics.drawRect(i,j,width,height);
                  }
                  else
                  {
                     _costume.graphics.drawRect(i,j + height / 2,width,height);
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
                  _costume.graphics.beginFill(this._colors[Math.floor(3 * Rndm.random())],1);
                  _costume.graphics.drawRect(i,j,width,height);
               }
            }
         }
         _costume.graphics.endFill();
         _costume.graphics.lineStyle(2,this._lineColor,1);
         _costume.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _costume.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         _costume.graphics.lineTo(_data.vertices[0].x,_data.vertices[0].y);
         _costume.graphics.endFill();
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
         _costume.addChild(noiseBitmap);
         _mask = new Sprite();
         _mask.graphics.clear();
         _mask.graphics.beginFill(0,1);
         _mask.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _mask.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         _mask.graphics.endFill();
         GameCamera.ins.addChildTo(_mask,_layerNo);
         _costume.mask = _mask;
         var bmd:BitmapData = new BitmapData(right - left + 10,bot - top + 10,true,16777215);
         var ct:ColorTransform = new ColorTransform(1,1,1);
         var mt:Matrix = new Matrix();
         mt.translate(-left + 5,-top + 5);
         var rect:Rectangle = new Rectangle(0,0,right - left + 10,bot - top + 10);
         bmd.draw(_costume,mt,ct,BlendMode.NORMAL,rect);
         bmd.applyFilter(bmd,bmd.rect,new Point(),cf);
         _bitmapCostume = new Bitmap(bmd);
         GameCamera.ins.addChildTo(_bitmapCostume,_layerNo);
         _bitmapCostume.x = left - 5;
         _bitmapCostume.y = top - 5;
         CF.removeDisplayObject(_costume);
         CF.removeDisplayObject(noiseBitmap);
      }
   }
}
