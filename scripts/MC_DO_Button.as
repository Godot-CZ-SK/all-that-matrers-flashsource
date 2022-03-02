package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_DO_Button extends MovieClip
   {
       
      
      public function MC_DO_Button()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
