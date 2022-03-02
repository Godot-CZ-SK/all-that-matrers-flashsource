package game
{
   import flash.display.MovieClip;
   
   public class IntroItem
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var appear:int;
      
      public var appearTime:Number;
      
      public var disappear:int;
      
      public var disappearTime:Number;
      
      public var scale:Number;
      
      public var cl:Class;
      
      public var mc:MovieClip;
      
      public var blackWhite:Boolean;
      
      public var convolution:Boolean;
      
      public var alpha:Number;
      
      public function IntroItem(cl:Class, x:Number, y:Number, appear:int, appearTime:Number, disappear:int, disappearTime:Number, scale:Number, alpha:Number, blackWhite:Boolean, convolution:Boolean)
      {
         super();
         this.x = x;
         this.y = y;
         this.cl = cl;
         this.appearTime = appearTime;
         this.disappearTime = disappearTime;
         this.appear = appear;
         this.disappear = disappear;
         this.scale = scale;
         this.blackWhite = blackWhite;
         this.convolution = convolution;
         this.alpha = alpha;
      }
   }
}
