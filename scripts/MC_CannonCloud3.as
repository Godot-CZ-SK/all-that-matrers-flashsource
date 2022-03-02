package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class MC_CannonCloud3 extends MovieClip
   {
       
      
      public function MC_CannonCloud3()
      {
         super();
         addFrameScript(6,this.frame7);
      }
      
      function frame7() : *
      {
         dispatchEvent(new Event("end"));
         stop();
      }
   }
}
