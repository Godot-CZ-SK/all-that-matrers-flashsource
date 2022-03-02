package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Lever extends MovieClip
   {
       
      
      public function MC_Lever()
      {
         super();
         addFrameScript(4,this.frame5,5,this.frame6,10,this.frame11,11,this.frame12);
      }
      
      function frame5() : *
      {
         gotoAndStop("unpulled");
      }
      
      function frame6() : *
      {
         stop();
      }
      
      function frame11() : *
      {
         gotoAndStop("pulled");
      }
      
      function frame12() : *
      {
         stop();
      }
   }
}
