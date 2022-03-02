package AllThatMatters_fla
{
   import flash.display.MovieClip;
   
   public dynamic class SkipButton_337 extends MovieClip
   {
       
      
      public function SkipButton_337()
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
