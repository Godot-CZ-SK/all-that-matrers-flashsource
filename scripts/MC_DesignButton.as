package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_DesignButton extends MovieClip
   {
       
      
      public function MC_DesignButton()
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
