package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Baby extends MovieClip
   {
       
      
      public function MC_Baby()
      {
         super();
         addFrameScript(130,this.frame131,140,this.frame141,156,this.frame157,206,this.frame207,211,this.frame212);
      }
      
      function frame131() : *
      {
         gotoAndPlay("idle");
      }
      
      function frame141() : *
      {
         gotoAndPlay("air");
      }
      
      function frame157() : *
      {
         stop();
      }
      
      function frame207() : *
      {
         gotoAndPlay("onLadder");
      }
      
      function frame212() : *
      {
         gotoAndPlay("idle");
      }
   }
}
