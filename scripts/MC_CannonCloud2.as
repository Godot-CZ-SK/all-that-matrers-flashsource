package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class MC_CannonCloud2 extends MovieClip
   {
       
      
      public function MC_CannonCloud2()
      {
         super();
         addFrameScript(5,this.frame6);
      }
      
      function frame6() : *
      {
         dispatchEvent(new Event("end"));
         stop();
      }
   }
}
