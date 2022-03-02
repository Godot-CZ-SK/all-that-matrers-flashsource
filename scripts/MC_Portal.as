package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Portal extends MovieClip
   {
       
      
      public function MC_Portal()
      {
         super();
         addFrameScript(31,this.frame32,47,this.frame48,61,this.frame62);
      }
      
      function frame32() : *
      {
         gotoAndPlay("loop");
      }
      
      function frame48() : *
      {
         stop();
      }
      
      function frame62() : *
      {
         gotoAndPlay("loop");
      }
   }
}
