package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Kid extends MovieClip
   {
       
      
      public function MC_Kid()
      {
         super();
         addFrameScript(135,this.frame136,148,this.frame149,163,this.frame164,217,this.frame218,222,this.frame223);
      }
      
      function frame136() : *
      {
         gotoAndPlay("idle");
      }
      
      function frame149() : *
      {
         gotoAndPlay("air");
      }
      
      function frame164() : *
      {
         stop();
      }
      
      function frame218() : *
      {
         gotoAndPlay("onLadder");
      }
      
      function frame223() : *
      {
         gotoAndPlay("idle");
      }
   }
}
