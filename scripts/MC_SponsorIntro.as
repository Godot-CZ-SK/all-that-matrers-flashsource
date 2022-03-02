package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   
   public dynamic class MC_SponsorIntro extends MovieClip
   {
       
      
      public var btn_sponsor:SimpleButton;
      
      public function MC_SponsorIntro()
      {
         super();
         addFrameScript(224,this.frame225,260,this.frame261,267,this.frame268,334,this.frame335);
      }
      
      function frame225() : *
      {
         dispatchEvent(new Event("bomb"));
      }
      
      function frame261() : *
      {
         dispatchEvent(new Event("drop"));
      }
      
      function frame268() : *
      {
         dispatchEvent(new Event("drop"));
      }
      
      function frame335() : *
      {
         dispatchEvent(new Event("end"));
      }
   }
}
