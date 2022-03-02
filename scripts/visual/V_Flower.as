package visual
{
   import design.data.DO_FlowerData;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   
   public class V_Flower extends Visual
   {
       
      
      protected var _data:DO_FlowerData;
      
      protected var _costume:MovieClip;
      
      public function V_Flower(layerNo:int, data:DO_FlowerData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         var xc:Number = NaN;
         var cmf:ColorMatrixFilter = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         var layer:int = GameCamera.FLOWER_FRONT;
         if(this._data.back)
         {
            layer = GameCamera.FLOWER_BACK;
         }
         var clName:String = "MC_Flower" + this._data.flowerType.toString();
         var cl:Class = getDefinitionByName(clName) as Class;
         this._costume = new cl() as MovieClip;
         this._costume.gotoAndPlay(int(this._costume.totalFrames * Math.random()));
         GameCamera.ins.addChildTo(this._costume,layer);
         this._costume.x = this._data.x;
         this._costume.y = this._data.y;
         this._costume.scaleX = this._data.scale;
         this._costume.scaleY = this._data.scale;
         this._costume.rotation = this._data.rotation * 180 / Math.PI;
         if(this._data.back)
         {
            xc = 0.7;
            cmf = new ColorMatrixFilter([xc,0,0,0,0,0,xc,0,0,0,0,0,xc,0,0,0,0,0,1,0]);
            this._costume.filters = [cmf];
         }
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         CF.removeDisplayObject(this._costume);
      }
   }
}
