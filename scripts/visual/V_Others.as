package visual
{
   import design.data.DO_OthersData;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   
   public class V_Others extends Visual
   {
       
      
      protected var _data:DO_OthersData;
      
      protected var _costume:MovieClip;
      
      public function V_Others(layerNo:int, data:DO_OthersData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var layer:int = GameCamera.OTHERS;
         var clName:String = "MC_Others" + this._data.othersType.toString();
         var cl:Class = getDefinitionByName(clName) as Class;
         this._costume = new cl() as MovieClip;
         this._costume.gotoAndPlay(int(this._costume.totalFrames * Math.random()));
         GameCamera.ins.addChildTo(this._costume,layer);
         this._costume.x = this._data.x;
         this._costume.y = this._data.y;
         this._costume.scaleX = this._data.scale;
         this._costume.scaleY = this._data.scale;
         this._costume.rotation = this._data.rotation * 180 / Math.PI;
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
