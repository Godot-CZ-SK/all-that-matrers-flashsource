package
{
   import flash.display.MovieClip;
   
   public dynamic class STORY_Wing extends MovieClip
   {
       
      
      public function STORY_Wing()
      {
         super();
         addFrameScript(99,this.frame100);
      }
      
      function frame100() : *
      {
         stop();
      }
   }
}
