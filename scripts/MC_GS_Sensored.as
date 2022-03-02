package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_GS_Sensored extends MovieClip
   {
       
      
      public function MC_GS_Sensored()
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
