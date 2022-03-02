package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_UMO extends MovieClip
   {
       
      
      public function MC_UMO()
      {
         super();
         addFrameScript(8,this.frame9,23,this.frame24);
      }
      
      function frame9() : *
      {
         gotoAndPlay("loop");
      }
      
      function frame24() : *
      {
         stop();
      }
   }
}
