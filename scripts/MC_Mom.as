package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Mom extends MovieClip
   {
       
      
      public function MC_Mom()
      {
         super();
         addFrameScript(70,this.frame71,77,this.frame78,91,this.frame92,137,this.frame138,142,this.frame143);
      }
      
      function frame71() : *
      {
         gotoAndPlay("idle");
      }
      
      function frame78() : *
      {
         gotoAndPlay("air");
      }
      
      function frame92() : *
      {
         stop();
      }
      
      function frame138() : *
      {
         gotoAndPlay("onLadder");
      }
      
      function frame143() : *
      {
         gotoAndPlay("idle");
      }
   }
}
