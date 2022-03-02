package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_LS_LevelIconLocked extends MovieClip
   {
       
      
      public function MC_LS_LevelIconLocked()
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
