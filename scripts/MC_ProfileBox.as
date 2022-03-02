package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class MC_ProfileBox extends MovieClip
   {
       
      
      public var txt_player:TextField;
      
      public var btn_delete:MovieClip;
      
      public var btn_profile:MovieClip;
      
      public function MC_ProfileBox()
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
