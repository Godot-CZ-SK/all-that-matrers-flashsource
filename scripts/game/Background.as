package game
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class Background
   {
      
      public static const MOUNTAIN:String = "Mountain";
      
      public static const FAERIE:String = "Faerie";
      
      public static const CITY:String = "City";
      
      public static const CAVE:String = "Cave";
       
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _xpos:Number;
      
      protected var _ypos:Number;
      
      protected var _skyObjects:Vector.<MovieClip>;
      
      protected var _soPositions:Vector.<Point>;
      
      protected var _bg1:MovieClip;
      
      protected var _bg2:MovieClip;
      
      protected var _sky:MovieClip;
      
      protected var _clouds:MovieClip;
      
      protected var _visible:Boolean;
      
      protected var _counter:int;
      
      protected var _maxNumClouds:int;
      
      protected var _type:String;
      
      protected var _isCreated:Boolean;
      
      public function Background(parent:DisplayObjectContainer, type:String)
      {
         super();
         this._type = type;
         this._parent = parent;
         this._visible = true;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         if(this._type == FAERIE)
         {
            this._bg1 = new MC_BG_Faerie1();
            this._bg2 = new MC_BG_Faerie2();
            this._sky = new MC_BG_FaerieSky();
         }
         else if(this._type == MOUNTAIN)
         {
            this._bg1 = new MC_BG_Mountain1();
            this._bg2 = new MC_BG_Mountain2();
            this._sky = new MC_BG_MountainSky();
         }
         else if(this._type == CITY)
         {
            this._bg1 = new MC_BG_City1();
            this._bg2 = new MC_BG_City2();
            this._sky = new MC_BG_CitySky();
         }
         else if(this._type == CAVE)
         {
            this._bg1 = new MC_BG_Cave1();
            this._bg2 = new MC_BG_Cave2();
            this._sky = new MC_BG_CaveSky();
         }
         this._clouds = new MovieClip();
         this._parent.addChild(this._sky);
         this._parent.addChild(this._clouds);
         this._parent.addChild(this._bg2);
         this._parent.addChild(this._bg1);
         this._counter = 0;
         this._maxNumClouds = 6;
         this._skyObjects = new Vector.<MovieClip>();
         this._soPositions = new Vector.<Point>();
         this._xpos = 0;
         this._ypos = 0;
         this.createCloud(100 + Math.random() * 150);
         this.createCloud(300 + Math.random() * 150);
         this.createCloud(400 + Math.random() * 150);
         this.createCloud(600 + Math.random() * 150);
         this.createCloud(800 + Math.random() * 150);
      }
      
      public function changeType(type:String) : void
      {
         this._type = type;
         this.remove();
         this.create();
         this.setVisible(this._visible);
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         CF.removeDisplayObject(this._bg1);
         CF.removeDisplayObject(this._bg2);
         CF.removeDisplayObject(this._sky);
         for(var i:int = 0; i < this._skyObjects.length; i++)
         {
            CF.removeDisplayObject(this._skyObjects[i]);
         }
         this._skyObjects = new Vector.<MovieClip>();
         this._soPositions = new Vector.<Point>();
      }
      
      public function setPosition(xpos:Number, ypos:Number) : void
      {
         this._xpos = xpos;
         this._ypos = ypos;
         this._bg1.x = xpos * 0.3;
         this._bg1.y = ypos * 0.3;
         this._bg2.x = xpos * 0.2;
         this._bg2.y = ypos * 0.2;
         this._sky.x = xpos * 0.08;
         this._sky.y = ypos * 0.08;
         this._clouds.x = xpos * 0.5;
         this._clouds.y = ypos * 0.5;
      }
      
      public function tweenPosition(xpos:Number, ypos:Number, xDis:Number, yDis:Number) : void
      {
         this._xpos = xpos;
         this._ypos = ypos;
         TweenLite.to(this._bg1,0.25,{
            "x":(this._xpos + xDis) * 0.3,
            "y":(this._ypos + yDis) * 0.3
         });
         TweenLite.to(this._bg2,0.25,{
            "x":(this._xpos + xDis) * 0.2,
            "y":(this._ypos + yDis) * 0.2
         });
         TweenLite.to(this._sky,0.25,{
            "x":(this._xpos + xDis) * 0.08,
            "y":(this._ypos + yDis) * 0.08
         });
      }
      
      public function update() : void
      {
         for(var i:int = this._skyObjects.length - 1; i >= 0; i--)
         {
            this._soPositions[i].x += 0.5 * this._skyObjects[i].scaleX;
            this._skyObjects[i].x = this._soPositions[i].x + this._xpos * 0.15 * this._skyObjects[i].scaleX;
            this._skyObjects[i].y = this._soPositions[i].y + this._ypos * 0.15 * this._skyObjects[i].scaleY;
            if(this._skyObjects[i].x >= 960 + this._skyObjects[i].width / 2)
            {
               CF.removeDisplayObject(this._skyObjects[i]);
               this._skyObjects.splice(i,1);
               this._soPositions.splice(i,1);
            }
         }
         if(this._skyObjects.length >= this._maxNumClouds)
         {
            return;
         }
         ++this._counter;
         if(this._counter > 400)
         {
            this._counter = 0;
            this.createCloud();
         }
      }
      
      public function createCloud(x:Number = 0) : void
      {
         if(this._type == CAVE)
         {
            return;
         }
         var str:String = "MC_Cloud" + int(Math.ceil(Math.random() * 7)).toString();
         var cl:Class = getDefinitionByName(str) as Class;
         var cloud:MovieClip = new cl() as MovieClip;
         var scale:Number = Math.random() * 0.5 + 0.5;
         cloud.scaleX = scale;
         cloud.scaleY = scale;
         cloud.alpha = scale / 2;
         cloud.x = x - cloud.width / 2 - 20;
         cloud.y = Math.random() * 250 + 100;
         this._clouds.addChild(cloud);
         this._skyObjects.push(cloud);
         this._soPositions.push(new Point(cloud.x,cloud.y));
         cloud.filters = [new GlowFilter(16777215,0.5,10,10,0.5),new BlurFilter()];
      }
      
      public function setVisible(visible:Boolean) : void
      {
         this._visible = visible;
         this._sky.visible = visible;
         this._clouds.visible = visible;
         this._bg1.visible = visible;
         this._bg2.visible = visible;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
