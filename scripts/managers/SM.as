package managers
{
   import flash.events.Event;
   import game.GameMusic;
   import game.GameSound;
   import game.GameVoice;
   
   public class SM
   {
      
      private static var _ins:SM;
       
      
      protected var _soundList:Vector.<GameSound>;
      
      protected var _voiceList:Vector.<GameVoice>;
      
      protected var _currentMusic:GameMusic;
      
      protected var _isMusicMuted:Boolean;
      
      protected var _isSoundMuted:Boolean;
      
      protected var _musicVolume:Number;
      
      protected var _soundVolume:Number;
      
      protected var _lastMusicVolume:Number;
      
      protected var _lastSoundVolume:Number;
      
      public function SM()
      {
         super();
      }
      
      public static function get ins() : SM
      {
         if(!_ins)
         {
            _ins = new SM();
         }
         return _ins;
      }
      
      public function init() : void
      {
         this._soundList = new Vector.<GameSound>();
         this._voiceList = new Vector.<GameVoice>();
         this._isMusicMuted = false;
         this._isSoundMuted = false;
         this._musicVolume = 1;
         this._soundVolume = 1;
         this._lastMusicVolume = 1;
         this._lastSoundVolume = 1;
      }
      
      public function setup(settings:Object) : void
      {
         if(settings)
         {
            this._isMusicMuted = settings.isMusicMuted;
            this._isSoundMuted = settings.isSoundMuted;
            this._musicVolume = settings.musicVolume;
            this._soundVolume = settings.soundVolume;
         }
         this.update();
      }
      
      public function getSettings() : Object
      {
         var settings:Object = new Object();
         settings.isMusicMuted = this._isMusicMuted;
         settings.isSoundMuted = this._isSoundMuted;
         settings.musicVolume = this._musicVolume;
         settings.soundVolume = this._soundVolume;
         return settings;
      }
      
      public function toggleMusic() : void
      {
         this._isMusicMuted = !this._isMusicMuted;
         if(this._isMusicMuted)
         {
            this._lastMusicVolume = this._musicVolume;
            this._musicVolume = 0;
         }
         else
         {
            this._musicVolume = this._lastMusicVolume;
         }
         this.update();
      }
      
      public function toggleAll() : void
      {
         if(this._musicVolume == 0 && this._soundVolume == 0)
         {
            this._isMusicMuted = false;
            this._isSoundMuted = false;
            this._soundVolume = this._lastSoundVolume;
            this._musicVolume = this._lastMusicVolume;
         }
         else
         {
            this._isMusicMuted = true;
            this._isSoundMuted = true;
            if(this._musicVolume > 0)
            {
               this._lastMusicVolume = this._musicVolume;
               this._musicVolume = 0;
            }
            if(this._soundVolume > 0)
            {
               this._lastSoundVolume = this._soundVolume;
               this._soundVolume = 0;
            }
         }
         this.update();
      }
      
      public function toggleSound() : void
      {
         this._isSoundMuted = !this._isSoundMuted;
         if(this._isSoundMuted)
         {
            this._lastSoundVolume = this._soundVolume;
            this._soundVolume = 0;
         }
         else
         {
            this._soundVolume = this._lastSoundVolume;
         }
         this.update();
      }
      
      public function setMusicVolume(val:Number) : void
      {
         this._musicVolume = Math.min(1,Math.max(0,val));
         this.update();
      }
      
      public function setSoundVolume(val:Number) : void
      {
         this._soundVolume = Math.min(1,Math.max(0,val));
         this.update();
      }
      
      private function update() : void
      {
         if(this._currentMusic)
         {
            this._currentMusic.fadeVolume(this._musicVolume);
         }
         for(var i:int = 0; i < this._soundList.length; i++)
         {
            this._soundList[i].fadeVolume(this._soundVolume);
         }
         LM.ins.cp.setSoundSettings(this.getSettings());
      }
      
      public function playMusic(id:int, volume:Number = -1) : GameMusic
      {
         if(volume < 0)
         {
            volume = this._musicVolume;
         }
         if(this._currentMusic)
         {
            this._currentMusic.removeEventListener(Event.SOUND_COMPLETE,this.musicCompleted);
            this._currentMusic.stop();
            this._currentMusic = null;
         }
         var music:GameMusic = new GameMusic(id,volume);
         music.addEventListener(Event.SOUND_COMPLETE,this.musicCompleted,false,0,true);
         music.play();
         this._currentMusic = music;
         return music;
      }
      
      public function stopMusic() : void
      {
         if(this._currentMusic)
         {
            this._currentMusic.removeEventListener(Event.SOUND_COMPLETE,this.musicCompleted);
            this._currentMusic.stop();
            this._currentMusic = null;
         }
      }
      
      public function playVoice(id:int) : GameVoice
      {
         var voice:GameVoice = new GameVoice(id,this._soundVolume);
         voice.addEventListener(Event.SOUND_COMPLETE,this.voiceCompleted,false,0,true);
         voice.addEventListener("stopped",this.voiceCompleted,false,0,true);
         voice.play();
         this.addVoice(voice);
         return voice;
      }
      
      public function playSound(id:int) : GameSound
      {
         var snd:GameSound = new GameSound(id,this._soundVolume);
         snd.addEventListener(Event.SOUND_COMPLETE,this.soundCompleted,false,0,true);
         snd.addEventListener("stopped",this.soundCompleted,false,0,true);
         snd.play();
         this.addSound(snd);
         return snd;
      }
      
      public function fadeMusic(dur:Number) : void
      {
         if(this._currentMusic)
         {
            this._currentMusic.fadeVolumeCoef(0,dur);
         }
      }
      
      private function musicCompleted(e:Event) : void
      {
         var music:GameSound = e.currentTarget as GameSound;
         var id:int = this.getNextMusic(music.id);
         this.playMusic(id);
      }
      
      private function soundCompleted(e:Event) : void
      {
         var snd:GameSound = e.currentTarget as GameSound;
         this.removeSound(snd);
      }
      
      private function voiceCompleted(e:Event) : void
      {
         var voice:GameVoice = e.currentTarget as GameVoice;
         this.removeVoice(voice);
      }
      
      private function getNextMusic(id:int) : int
      {
         if(id == GameMusic.VIEW_FROM_ABOVE)
         {
            return GameMusic.LEAP_OF_FAITH;
         }
         if(id == GameMusic.LEAP_OF_FAITH)
         {
            return GameMusic.VIEW_FROM_ABOVE;
         }
         return GameMusic.LEAP_OF_FAITH;
      }
      
      private function removeVoice(voice:GameVoice) : void
      {
         if(this._voiceList.indexOf(voice) >= 0)
         {
            this._voiceList.splice(this._voiceList.indexOf(voice),1);
         }
      }
      
      private function addVoice(voice:GameVoice) : void
      {
         if(this._voiceList.indexOf(voice) < 0)
         {
            this._voiceList.push(voice);
         }
      }
      
      private function removeSound(snd:GameSound) : void
      {
         if(this._soundList.indexOf(snd) >= 0)
         {
            this._soundList.splice(this._soundList.indexOf(snd),1);
         }
      }
      
      private function addSound(snd:GameSound) : void
      {
         if(this._soundList.indexOf(snd) < 0)
         {
            this._soundList.push(snd);
         }
      }
      
      public function get musicVolume() : Number
      {
         return this._musicVolume;
      }
      
      public function get soundVolume() : Number
      {
         return this._soundVolume;
      }
      
      public function get isMusicMuted() : Boolean
      {
         return this._isMusicMuted;
      }
      
      public function get isSoundMuted() : Boolean
      {
         return this._isSoundMuted;
      }
      
      public function get currentMusic() : GameMusic
      {
         return this._currentMusic;
      }
   }
}
