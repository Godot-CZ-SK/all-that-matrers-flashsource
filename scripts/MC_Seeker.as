package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class MC_Seeker extends MovieClip
   {
       
      
      public function MC_Seeker()
      {
         super();
         addFrameScript(53,this.frame54,69,this.frame70,92,this.frame93,100,this.frame101,119,this.frame120);
      }
      
      function frame54() : *
      {
         gotoAndPlay("stay");
      }
      
      function frame70() : *
      {
         gotoAndPlay("walk");
      }
      
      function frame93() : *
      {
         dispatchEvent(new Event("prepared"));
         gotoAndPlay("attack");
      }
      
      function frame101() : *
      {
         stop();
      }
      
      function frame120() : *
      {
         stop();
      }
   }
}
