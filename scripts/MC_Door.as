package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Door extends MovieClip
   {
       
      
      public function MC_Door()
      {
         super();
         addFrameScript(3,this.frame4,16,this.frame17);
      }
      
      function frame4() : *
      {
         stop();
      }
      
      function frame17() : *
      {
         stop();
      }
   }
}
