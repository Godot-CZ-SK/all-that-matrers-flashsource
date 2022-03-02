package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Elder extends MovieClip
   {
       
      
      public function MC_Elder()
      {
         super();
         addFrameScript(61,this.frame62,72,this.frame73,99,this.frame100,104,this.frame105,110,this.frame111);
      }
      
      function frame62() : *
      {
         gotoAndPlay("idle");
      }
      
      function frame73() : *
      {
         gotoAndPlay("air");
      }
      
      function frame100() : *
      {
         stop();
      }
      
      function frame105() : *
      {
         stop();
      }
      
      function frame111() : *
      {
         gotoAndPlay("idle");
      }
   }
}
