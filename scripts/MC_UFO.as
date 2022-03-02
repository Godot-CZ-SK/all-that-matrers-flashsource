package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_UFO extends MovieClip
   {
       
      
      public function MC_UFO()
      {
         super();
         addFrameScript(9,this.frame10,26,this.frame27);
      }
      
      function frame10() : *
      {
         gotoAndPlay("loop");
      }
      
      function frame27() : *
      {
         stop();
      }
   }
}
