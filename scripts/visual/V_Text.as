package visual
{
   import design.data.DO_TextData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.ConvolutionFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.GameCamera;
   
   public class V_Text extends Visual
   {
       
      
      protected var _data:DO_TextData;
      
      protected var _textField:TextField;
      
      protected var _textFormat:TextFormat;
      
      protected var _costume:MovieClip;
      
      public function V_Text(layerNo:int, data:DO_TextData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var noiseData:BitmapData = null;
         var base:Number = NaN;
         var noiseBitmap:Bitmap = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         this._costume = new MovieClip();
         GameCamera.ins.addChildTo(this._costume,_layerNo);
         this._costume.x = this._data.x;
         this._costume.y = this._data.y;
         this._costume.graphics.clear();
         var bg:MovieClip = new MovieClip();
         this._costume.addChild(bg);
         var cf:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-0.3,0,-0.3,1,0.3,0,0.3,0],1.2);
         if(this._data.background)
         {
            bg.graphics.lineStyle(1,3154453,1);
            bg.graphics.beginFill(8029033,1);
            bg.graphics.drawRect(0,0,this._data.width,this._data.height);
            bg.graphics.endFill();
            noiseData = new BitmapData(this._data.width,this._data.height,true,16777215);
            base = 100;
            noiseData.perlinNoise(base,base,4,int(Math.random() * 10000),false,false,7,true);
            noiseBitmap = new Bitmap(noiseData);
            noiseBitmap.alpha = 0.15;
            bg.addChild(noiseBitmap);
            bg.filters = [cf];
         }
         this._textField = new TextField();
         this._textFormat = new TextFormat("calibri",this._data.textHeight,14937586,true,null,null,null,null,TextFormatAlign.CENTER);
         this._textField.x = 5;
         this._textField.y = 5;
         this._textField.width = this._data.width - 10;
         this._textField.height = this._data.height - 10;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.embedFonts = true;
         this._textField.selectable = false;
         this._textField.text = this._data.text;
         this._textField.wordWrap = true;
         this._textField.multiline = true;
         this._costume.addChild(this._textField);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         CF.removeDisplayObject(this._textField);
         CF.removeDisplayObject(this._costume);
         this._textFormat = null;
         super.remove();
      }
   }
}
