package AllThatMatters_fla
{
   import flash.display.MovieClip;
   
   public dynamic class BTN_Walkthrough_230 extends MovieClip
   {
       
      
      public function BTN_Walkthrough_230()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,131,this.frame132);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
      
      function frame132() : *
      {
         gotoAndStop("out");
      }
   }
}
