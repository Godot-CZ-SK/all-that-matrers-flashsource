package AllThatMatters_fla
{
   import flash.display.MovieClip;
   
   public dynamic class BTN_Pause_58 extends MovieClip
   {
       
      
      public function BTN_Pause_58()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
