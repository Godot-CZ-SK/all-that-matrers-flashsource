package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_HeartIcon extends MovieClip
   {
       
      
      public function MC_HeartIcon()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15,15,this.frame16);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame15() : *
      {
         gotoAndStop("unlocked");
      }
      
      function frame16() : *
      {
         stop();
      }
   }
}
