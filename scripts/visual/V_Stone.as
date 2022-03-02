package visual
{
   import design.data.DO_StoneData;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import game.GameCamera;
   
   public class V_Stone extends Visual
   {
       
      
      protected var _data:DO_StoneData;
      
      protected var _costume:MovieClip;
      
      public function V_Stone(layerNo:int, data:DO_StoneData)
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
         var clName:String = "MC_Stone" + this._data.stoneType.toString();
         var cl:Class = getDefinitionByName(clName) as Class;
         this._costume = new cl() as MovieClip;
         GameCamera.ins.addChildTo(this._costume,GameCamera.STONE_FRONT);
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
