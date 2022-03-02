package
{
   import flash.display.MovieClip;
   
   public dynamic class MC_VolumeSound extends MovieClip
   {
       
      
      public var btn_mute:MovieClip;
      
      public var btn_bar:MC_VolumeBar;
      
      public function MC_VolumeSound()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
