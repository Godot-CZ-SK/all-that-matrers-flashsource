package game
{
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class GameSound extends EventDispatcher
   {
      
      public static var num:int = 0;
      
      public static const DEFAULT:int = num++;
      
      public static const HEART_COLLECT:int = num++;
      
      public static const SIGN_OPEN:int = num++;
      
      public static const SPIKE_HIT:int = num++;
      
      public static const FIRE_HIT:int = num++;
      
      public static const BOUNCER_BOUNCE:int = num++;
      
      public static const WHEEL_DROP:int = num++;
      
      public static const BOX_DROP:int = num++;
      
      public static const BUTTON_PRESSED:int = num++;
      
      public static const KEY_TAKEN:int = num++;
      
      public static const KEY_UNLOCK:int = num++;
      
      public static const PLATE_PUSHED:int = num++;
      
      public static const PISTON_CLOSE:int = num++;
      
      public static const BOMB_EXPLODE:int = num++;
      
      public static const CHAIN_SWING:int = num++;
      
      public static const CANNON_SHOOT:int = num++;
      
      public static const LEVER_PULLED:int = num++;
      
      public static const GRAVITY_SWITCHED:int = num++;
      
      public static const SEEKER_EXPLODE:int = num++;
      
      public static const LASER_SHOT:int = num++;
      
      public static const ELEVATOR_START:int = num++;
      
      public static const ELEVATOR_STOP:int = num++;
      
      public static const POWERUP:int = num++;
      
      public static const CHECKPOINT:int = num++;
      
      public static const BUTTON_OVER:int = num++;
      
      public static const BUTTON_CLICK:int = num++;
      
      public static const SHARE_ALERT:int = num++;
      
      public static const MEMORY_EARNED:int = num++;
      
      public static const HEART_COUNT:int = num++;
      
      public static const NEW_HIGHSCORE:int = num++;
       
      
      protected var _isPlaying:Boolean;
      
      protected var _id:int;
      
      protected var _sound:Sound;
      
      protected var _channel:SoundChannel;
      
      protected var _transform:SoundTransform;
      
      protected var _volume:Number;
      
      protected var _volCoef:Number;
      
      protected var _clName:String;
      
      protected var _class:Class;
      
      protected var _isMusic:Boolean;
      
      protected var _isVoice:Boolean;
      
      public function GameSound(id:int = 0, volume:Number = 1)
      {
         super();
         this._id = id;
         this._volume = volume;
         var rand:Number = Math.random();
         this._volCoef = 1;
         switch(id)
         {
            case DEFAULT:
               this._class = SND_Default;
               break;
            case HEART_COLLECT:
               this._class = SND_HeartCollect;
               break;
            case SIGN_OPEN:
               this._class = SignOpen;
               break;
            case SPIKE_HIT:
               this._class = SND_Spike;
               break;
            case FIRE_HIT:
               if(rand < 0.5)
               {
                  this._class = SND_Fire1;
               }
               else
               {
                  this._class = SND_Fire2;
               }
               break;
            case BOUNCER_BOUNCE:
               if(rand < 0.5)
               {
                  this._class = SND_Bouncer1;
               }
               else
               {
                  this._class = SND_Bouncer2;
               }
               this._volCoef = 0.6;
               break;
            case WHEEL_DROP:
               this._class = SND_Default;
               break;
            case BOX_DROP:
               if(rand < 0.25)
               {
                  this._class = SND_BoxDrop1;
               }
               else if(rand < 0.5)
               {
                  this._class = SND_BoxDrop2;
               }
               else if(rand < 0.75)
               {
                  this._class = SND_BoxDrop3;
               }
               else
               {
                  this._class = SND_BoxDrop4;
               }
               this._volCoef = 0.5;
               break;
            case BUTTON_PRESSED:
               this._class = SND_ButtonPressed;
               break;
            case KEY_TAKEN:
               this._class = SND_KeyCollected;
               break;
            case KEY_UNLOCK:
               this._class = SND_DoorUnlock;
               break;
            case PLATE_PUSHED:
               this._class = SND_PistonPlate;
               break;
            case PISTON_CLOSE:
               this._class = SND_Default;
               break;
            case BOMB_EXPLODE:
               this._class = SND_Explosion1;
               break;
            case CHAIN_SWING:
               this._class = SND_ChainGrab;
               break;
            case CANNON_SHOOT:
               this._class = SND_Default;
               break;
            case LEVER_PULLED:
               this._class = SND_LeverPull;
               break;
            case GRAVITY_SWITCHED:
               this._class = SND_Gravity;
               this._volCoef = 0.5;
               break;
            case SEEKER_EXPLODE:
               this._class = SND_SeekerExplosion;
               break;
            case LASER_SHOT:
               this._class = SND_LaserShot;
               this._volCoef = 0.6;
               break;
            case ELEVATOR_STOP:
               this._class = SND_ElevatorStop;
               break;
            case ELEVATOR_START:
               this._class = SND_ElevatorStart;
               break;
            case POWERUP:
               this._class = SND_Powerup;
               break;
            case BUTTON_OVER:
               this._class = SND_RollOver;
               break;
            case BUTTON_CLICK:
               this._class = SND_MouseClick;
               break;
            case SHARE_ALERT:
               this._class = SND_Default;
               break;
            case MEMORY_EARNED:
               this._class = SND_Memory;
               this._volCoef = 0.7;
               break;
            case HEART_COUNT:
               this._class = SND_Default;
               break;
            case NEW_HIGHSCORE:
               this._class = SND_Default;
               break;
            case CHECKPOINT:
               this._class = SND_Checkpoint;
               break;
            default:
               this._class = SND_Default;
         }
      }
      
      public function play() : void
      {
         if(this._isPlaying)
         {
            return;
         }
         this._isPlaying = true;
         if(this._sound)
         {
            this.stop();
         }
         this._sound = new this._class() as Sound;
         this._transform = new SoundTransform(this._volume * this._volCoef);
         this._channel = this._sound.play(0,0,this._transform);
         this._channel.addEventListener(Event.SOUND_COMPLETE,this.completed,false,0,true);
      }
      
      public function goto(time:Number) : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this._channel.stop();
         if(this._sound.length > time * 1000)
         {
            this._channel = this._sound.play(time * 1000,0,this._transform);
         }
      }
      
      private function completed(e:Event) : void
      {
         this.stop();
         dispatchEvent(e);
      }
      
      public function stop() : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this._isPlaying = false;
         if(this._channel)
         {
            this._channel.stop();
         }
         this._channel = null;
         this._sound = null;
         dispatchEvent(new Event("stopped"));
      }
      
      public function fadeVolume(val:Number, dur:Number = 2) : void
      {
         TweenLite.to(this,dur,{"volume":val});
      }
      
      public function fadeVolumeCoef(val:Number, dur:Number = 2) : void
      {
         TweenLite.to(this,dur,{"volCoef":val});
      }
      
      public function setVolumeInstantly(val:Number) : void
      {
         this.volume = val;
      }
      
      public function pause() : void
      {
      }
      
      public function resume() : void
      {
      }
      
      private function setTransform() : void
      {
         this._transform.volume = this._volume * this._volCoef;
         if(this._channel)
         {
            this._channel.soundTransform = this._transform;
         }
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         this._volume = value;
         this.setTransform();
      }
      
      public function get isMusic() : Boolean
      {
         return this._isMusic;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set volCoef(value:Number) : void
      {
         this._volCoef = value;
         this.setTransform();
      }
      
      public function get volCoef() : Number
      {
         return this._volCoef;
      }
   }
}
