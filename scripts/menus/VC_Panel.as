package menus
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import managers.SM;
   
   public class VC_Panel
   {
       
      
      protected var _costume:MC_VolumeController;
      
      protected var _parent:DisplayObjectContainer;
      
      protected var _isCreated:Boolean;
      
      protected var _xpos:Number;
      
      protected var _ypos:Number;
      
      protected var _changing:MovieClip;
      
      public function VC_Panel(parent:DisplayObjectContainer, x:Number, y:Number)
      {
         super();
         this._parent = parent;
         this._xpos = x;
         this._ypos = y;
      }
      
      public function create() : void
      {
         if(this._isCreated)
         {
            return;
         }
         this._isCreated = true;
         this._costume = new MC_VolumeController();
         this._costume.alpha = 0;
         TweenLite.to(this._costume,1,{"alpha":1});
         this._parent.addChild(this._costume);
         this._costume.x = this._xpos;
         this._costume.y = this._ypos;
         this.addEvents();
         this.update();
      }
      
      public function remove() : void
      {
         if(!this._isCreated)
         {
            return;
         }
         this._isCreated = false;
         this.removeEvents();
         CF.removeDisplayObject(this._costume);
      }
      
      public function addEvents() : void
      {
         var buttons:Array = [this._costume.mc_music.btn_mute,this._costume.mc_music.btn_bar.btn_slider,this._costume.mc_sound.btn_mute,this._costume.mc_sound.btn_bar.btn_slider];
         for(var i:int = 0; i < buttons.length; i++)
         {
            buttons[i].addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            buttons[i].buttonMode = true;
            buttons[i].mouseChildren = false;
         }
         this._costume.mc_music.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._costume.mc_music.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._costume.mc_sound.addEventListener(MouseEvent.ROLL_OVER,this.overHandler,false,0,true);
         this._costume.mc_sound.addEventListener(MouseEvent.ROLL_OUT,this.outHandler,false,0,true);
         this._costume.mc_music.btn_bar.btn_slider.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler,false,0,true);
         this._costume.mc_sound.btn_bar.btn_slider.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler,false,0,true);
      }
      
      private function downHandler(e:MouseEvent) : void
      {
         this._changing = e.currentTarget as MovieClip;
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var val:Number = NaN;
         if(this._changing == this._costume.mc_music.btn_bar.btn_slider)
         {
            val = this._costume.mc_music.btn_bar.btn_slider.mouseX / 26 + 0.5;
            SM.ins.setMusicVolume(val);
            this.update();
         }
         else if(this._changing == this._costume.mc_sound.btn_bar.btn_slider)
         {
            val = this._costume.mc_sound.btn_bar.btn_slider.mouseX / 26 + 0.5;
            SM.ins.setSoundVolume(val);
            this.update();
         }
      }
      
      private function upHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("over");
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.gotoAndStop("out");
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var val:Number = NaN;
         if(e.currentTarget == this._costume.mc_music.btn_mute)
         {
            SM.ins.toggleMusic();
            this.update();
         }
         else if(e.currentTarget == this._costume.mc_sound.btn_mute)
         {
            SM.ins.toggleSound();
            this.update();
         }
         else if(e.currentTarget == this._costume.mc_music.btn_bar.btn_slider)
         {
            val = this._costume.mc_music.btn_bar.btn_slider.mouseX / 26 + 0.5;
            SM.ins.setMusicVolume(val);
            this.update();
         }
         else if(e.currentTarget == this._costume.mc_sound.btn_bar.btn_slider)
         {
            val = this._costume.mc_sound.btn_bar.btn_slider.mouseX / 26 + 0.5;
            SM.ins.setSoundVolume(val);
            this.update();
         }
      }
      
      private function update() : void
      {
         if(SM.ins.isMusicMuted)
         {
            this._costume.mc_music.btn_mute.gotoAndStop("muted");
         }
         else
         {
            this._costume.mc_music.btn_mute.gotoAndStop("unmuted");
         }
         if(SM.ins.isSoundMuted)
         {
            this._costume.mc_sound.btn_mute.gotoAndStop("muted");
         }
         else
         {
            this._costume.mc_sound.btn_mute.gotoAndStop("unmuted");
         }
         this._costume.mc_music.btn_bar.mc_slider.x = -26 + SM.ins.musicVolume * 26;
         this._costume.mc_sound.btn_bar.mc_slider.x = -26 + SM.ins.soundVolume * 26;
      }
      
      public function removeEvents() : void
      {
         var buttons:Array = [this._costume.mc_music.btn_mute,this._costume.mc_music.btn_bar.btn_slider,this._costume.mc_sound.btn_mute,this._costume.mc_sound.btn_bar.btn_slider];
         for(var i:int = 0; i < buttons.length; i++)
         {
            buttons[i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
            buttons[i].buttonMode = false;
         }
         this._costume.mc_music.removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         this._costume.mc_music.removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         this._costume.mc_sound.removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         this._costume.mc_sound.removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         this._costume.mc_music.btn_bar.btn_slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         this._costume.mc_sound.btn_bar.btn_slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
      }
   }
}
