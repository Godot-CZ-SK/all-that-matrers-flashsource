package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_LS_Sponsor extends MovieClip
   {
       
      
      public function MC_LS_Sponsor()
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
