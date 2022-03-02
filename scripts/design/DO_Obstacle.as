package design
{
   import com.gskinner.utils.Rndm;
   import design.data.DO_PolyData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ConvolutionFilter;
   import game.GameCamera;
   
   public class DO_Obstacle extends DO_Poly
   {
       
      
      protected var _lineColor:uint = 2565927;
      
      public function DO_Obstacle(parent:DisplayObjectContainer)
      {
         _data = new DO_PolyData(DO_PolyData.OBSTACLE);
         super(parent,GameCamera.OBSTACLE);
      }
      
      override public function drawRealCostume() : void
      {
         var ti:int = 0;
         var bi:int = 0;
         var li:int = 0;
         var ri:int = 0;
         _realCostume = new MovieClip();
         _costume.addChild(_realCostume);
         var i:int = 0;
         var j:int = 0;
         var top:Number = 100000;
         var bot:Number = -100000;
         var left:Number = 100000;
         var right:Number = -100000;
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
         _realCostume.graphics.clear();
         _realCostume.graphics.lineStyle(1,this._lineColor,1);
         _realCostume.graphics.beginFill(_data.color2,1);
         _realCostume.graphics.drawRect(left,top,right - left,bot - top);
         _realCostume.graphics.endFill();
         _realCostume.graphics.lineStyle(3,this._lineColor,1);
         _realCostume.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _realCostume.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         _realCostume.graphics.lineTo(_data.vertices[0].x,_data.vertices[0].y);
         _realCostume.graphics.endFill();
         _mask = new Sprite();
         _mask.graphics.clear();
         _mask.graphics.beginFill(0,1);
         _mask.graphics.moveTo(_data.vertices[0].x,_data.vertices[0].y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _mask.graphics.lineTo(_data.vertices[i].x,_data.vertices[i].y);
         }
         _mask.graphics.endFill();
         _costume.addChild(_mask);
         _realCostume.mask = _mask;
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,1,1,0,1,0],1.5);
         _realCostume.filters = [cf];
      }
   }
}
