package effects
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FilmNoirEffect extends LevelEffect
   {
       
      
      protected var _costume:MC_FilmNoir;
      
      protected var _datas:Vector.<BitmapData>;
      
      protected var _bitmap:Bitmap;
      
      protected var _num:int;
      
      protected var _current:int;
      
      protected var _changeRatio:int;
      
      protected var _ratio:int;
      
      public function FilmNoirEffect(parent:DisplayObjectContainer)
      {
         super(parent);
         this._num = 4;
         this._changeRatio = 3;
         this._ratio = 0;
      }
      
      override public function create() : void
      {
         var noirData:BitmapData = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._datas = new Vector.<BitmapData>();
         for(var i:int = 0; i < this._num; i++)
         {
            noirData = new BitmapData(640,480,true,16777215);
            noirData.noise(Math.random() * 10000,0,255,7,true);
            noirData.threshold(noirData,new Rectangle(0,0,640,480),new Point(0,0),">",4280624421,16777215,16777215,false);
            this._datas.push(noirData);
         }
         this._current = 0;
         this._bitmap = new Bitmap(this._datas[this._current]);
         this._bitmap.alpha = 0.11;
         this._costume = new MC_FilmNoir();
         this._costume.addChild(this._bitmap);
         _parent.addChild(this._costume);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         for(var i:int = 0; i < this._datas.length; i++)
         {
            this._datas[i].dispose();
         }
         this._datas = new Vector.<BitmapData>();
         CF.removeDisplayObject(this._bitmap);
         CF.removeDisplayObject(this._costume);
      }
      
      override public function update() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.update();
         ++this._ratio;
         if(this._ratio >= this._changeRatio)
         {
            this._ratio = 0;
            this._current = (this._current + 1) % this._datas.length;
            this._bitmap.bitmapData = this._datas[this._current];
         }
      }
   }
}
