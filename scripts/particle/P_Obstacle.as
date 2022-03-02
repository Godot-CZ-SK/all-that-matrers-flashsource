package particle
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2FilterData;
   import com.gskinner.utils.Rndm;
   import design.data.DO_PolyData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import game.GameCamera;
   import game.GameSound;
   import managers.SM;
   
   public class P_Obstacle extends P_Polygon
   {
       
      
      protected var _hurtCounter:int;
      
      protected var _isBounced:int;
      
      protected var _colors:Array;
      
      public function P_Obstacle(layerNo:int, data:DO_PolyData)
      {
         this._colors = [5720117,2565927];
         super(layerNo,data);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         _filterData = new b2FilterData();
         _filterData.categoryBits = 4;
         super.create();
         this._isBounced = 0;
         this._hurtCounter = 0;
      }
      
      override public function drawCostume() : void
      {
         var ti:int = 0;
         var bi:int = 0;
         var li:int = 0;
         var ri:int = 0;
         var center:Point = new Point(_body.GetWorldCenter().x * Constants.SCALE,_body.GetWorldCenter().y * Constants.SCALE);
         var iCostume:MovieClip = new MovieClip();
         _costume = new MovieClip();
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
         iCostume.graphics.clear();
         iCostume.graphics.lineStyle(1,this._colors[1],1);
         iCostume.graphics.beginFill(this._colors[0],1);
         iCostume.graphics.moveTo(_data.vertices[0].x - center.x,_data.vertices[0].y - center.y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            iCostume.graphics.lineTo(_data.vertices[i].x - center.x,_data.vertices[i].y - center.y);
         }
         iCostume.graphics.lineTo(_data.vertices[0].x - center.x,_data.vertices[0].y - center.y);
         iCostume.graphics.endFill();
         iCostume.graphics.endFill();
         var noiseData:BitmapData = new BitmapData(right - left,bot - top,true,16777215);
         var base:Number = 150;
         noiseData.perlinNoise(base,base,4,int(Math.random() * 1000),true,true,7,true);
         var noiseBitmap:Bitmap = new Bitmap(noiseData);
         noiseBitmap.alpha = 0.1;
         noiseBitmap.x = left - center.x;
         noiseBitmap.y = top - center.y;
         iCostume.addChild(noiseBitmap);
         _mask = new Sprite();
         _mask.graphics.clear();
         _mask.graphics.beginFill(0,1);
         _mask.graphics.moveTo(_data.vertices[0].x - center.x,_data.vertices[0].y - center.y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _mask.graphics.lineTo(_data.vertices[i].x - center.x,_data.vertices[i].y - center.y);
         }
         _mask.graphics.endFill();
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[-1,-1,0,0,1,0,0,1,1],1.1);
         iCostume.addChild(_mask);
         iCostume.mask = _mask;
         iCostume.filters = [cf];
         _costume.addChild(iCostume);
         _costume.graphics.lineStyle(2,this._colors[1],1);
         _costume.graphics.moveTo(_data.vertices[0].x - center.x,_data.vertices[0].y - center.y);
         for(i = 1; i < _data.vertices.length; i++)
         {
            _costume.graphics.lineTo(_data.vertices[i].x - center.x,_data.vertices[i].y - center.y);
         }
         _costume.graphics.lineTo(_data.vertices[0].x - center.x,_data.vertices[0].y - center.y);
         _costume.graphics.endFill();
         GameCamera.ins.addChildTo(_costume,_layerNo);
         this.update();
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         _costume.x = Math.round(_body.GetWorldCenter().x * Constants.SCALE);
         _costume.y = Math.round(_body.GetWorldCenter().y * Constants.SCALE);
         _costume.rotation = _body.GetAngle() * 180 / Math.PI;
         if(this._isBounced > 0)
         {
            --this._isBounced;
         }
         if(this._hurtCounter > 0)
         {
            --this._hurtCounter;
         }
         super.update();
      }
      
      override public function postHit(p:Particle, b:b2Body, angle:Number, power:Number, selfData:String, targetData:String) : void
      {
         var threshold:Number = 8 * _body.GetMass();
         if(power > threshold && this._hurtCounter == 0)
         {
            this._hurtCounter = 10;
            SM.ins.playSound(GameSound.BOX_DROP);
         }
         super.postHit(p,b,angle,power,selfData,targetData);
      }
      
      public function get isBounced() : int
      {
         return this._isBounced;
      }
      
      public function set isBounced(value:int) : void
      {
         this._isBounced = value;
      }
   }
}
