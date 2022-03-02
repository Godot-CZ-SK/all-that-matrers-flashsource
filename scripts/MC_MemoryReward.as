package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class MC_MemoryReward extends MovieClip
   {
       
      
      public var txt_memoryExplanation:TextField;
      
      public var txt_memorySecondTitle:TextField;
      
      public var txt_memoryTitle:TextField;
      
      public function MC_MemoryReward()
      {
         super();
         addFrameScript(84,this.frame85);
      }
      
      function frame85() : *
      {
         stop();
      }
   }
}
