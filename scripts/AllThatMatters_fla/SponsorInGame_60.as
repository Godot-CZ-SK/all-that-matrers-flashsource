package AllThatMatters_fla
{
   import flash.display.MovieClip;
   
   public dynamic class SponsorInGame_60 extends MovieClip
   {
       
      
      public function SponsorInGame_60()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14,14,this.frame15,26,this.frame27);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame14() : *
      {
         gotoAndStop("over");
      }
      
      function frame15() : *
      {
         stop();
      }
      
      function frame27() : *
      {
         gotoAndStop("out");
      }
   }
}
