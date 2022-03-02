package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class MC_CannonCloud4 extends MovieClip
   {
       
      
      public function MC_CannonCloud4()
      {
         super();
         addFrameScript(9,this.frame10);
      }
      
      function frame10() : *
      {
         dispatchEvent(new Event("end"));
         stop();
      }
   }
}
