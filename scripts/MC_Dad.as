package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Dad extends MovieClip
   {
       
      
      public function MC_Dad()
      {
         super();
         addFrameScript(167,this.frame168,216,this.frame217,246,this.frame247,294,this.frame295,299,this.frame300);
      }
      
      function frame168() : *
      {
         gotoAndPlay("idle");
      }
      
      function frame217() : *
      {
         gotoAndPlay("air");
      }
      
      function frame247() : *
      {
         stop();
      }
      
      function frame295() : *
      {
         gotoAndPlay("onLadder");
      }
      
      function frame300() : *
      {
         gotoAndPlay("idle");
      }
   }
}
