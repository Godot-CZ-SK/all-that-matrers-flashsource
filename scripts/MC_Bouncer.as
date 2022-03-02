package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Bouncer extends MovieClip
   {
       
      
      public function MC_Bouncer()
      {
         super();
         addFrameScript(3,this.frame4,8,this.frame9);
      }
      
      function frame4() : *
      {
         stop();
      }
      
      function frame9() : *
      {
         gotoAndStop("stay");
      }
   }
}
