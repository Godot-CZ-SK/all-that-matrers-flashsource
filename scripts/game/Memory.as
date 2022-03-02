package game
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import managers.DM;
   import managers.SM;
   import managers.TM;
   
   public class Memory
   {
      
      protected static const WIDTH:Number = 515;
      
      protected static const HEIGHT:Number = 60;
      
      public static const NUMBER_OF_MEMORIES:int = 40;
      
      public static const GETTING_UGLY:int = 110;
      
      public static const NOT_AGAIN:int = 111;
      
      public static const THIS_GAME_SUCKS:int = 112;
      
      public static const LETS_SWING:int = 120;
      
      public static const BEAT_IT:int = 130;
      
      public static const PIECE_OF_CAKE:int = 131;
      
      public static const INTERESTING:int = 132;
      
      public static const MOAR_PLEASE:int = 133;
      
      public static const FINISH_IT:int = 134;
      
      public static const TOBY_THE_BABY:int = 140;
      
      public static const BILLY_THE_KID:int = 141;
      
      public static const SIDNEY_MY_HONEY:int = 142;
      
      public static const GREER_THE_ELDER:int = 143;
      
      public static const ACROBATIC:int = 150;
      
      public static const SAVE_ME:int = 160;
      
      public static const HUG_ME:int = 161;
      
      public static const LOVE_ME:int = 162;
      
      public static const I_BELIEVE:int = 170;
      
      public static const LASER_TAG:int = 180;
      
      public static const UBO:int = 190;
      
      public static const TEN_MINUTES:int = 200;
      
      public static const THIRTY_MINUTES:int = 201;
      
      public static const AN_HOUR:int = 202;
      
      public static const TD_15:int = 210;
      
      public static const TD_30:int = 211;
      
      public static const TD_45:int = 212;
      
      public static const TRAPPED:int = 230;
      
      public static const FREEDOM:int = 240;
      
      public static const BROKEN_HEART:int = 250;
      
      public static const FIXED_HEART:int = 251;
      
      public static const DEBUGGING:int = 260;
      
      public static const FAMOUS:int = 270;
      
      public static const CURIOUS:int = 280;
      
      public static const BA_15:int = 290;
      
      public static const BA_30:int = 291;
      
      public static const BA_45:int = 292;
      
      public static const ER_15:int = 300;
      
      public static const ER_30:int = 301;
      
      public static const ER_45:int = 302;
      
      public static const PATIENT:int = 310;
      
      protected static var _reservedSpots:Array;
      
      public static var list:Vector.<Memory>;
       
      
      protected var _id:int;
      
      protected var _title:String;
      
      protected var _secTitle:String;
      
      protected var _explanation:String;
      
      protected var _level:int;
      
      protected var _className:String;
      
      public function Memory(id:int, className:String, title:String, secTitle:String, explanation:String, level:int)
      {
         super();
         this._id = id;
         this._title = title;
         this._secTitle = secTitle;
         this._explanation = explanation;
         this._level = level;
         this._className = className;
      }
      
      public static function init() : void
      {
         list = new Vector.<Memory>();
         list.push(new Memory(PATIENT,"MEM_Patient","Patient","Stay awhile and listen...","Don\'t skip the intro.",1),new Memory(GETTING_UGLY,"MEM_GettingUgly","Die Easy","Maybe you should try something else.","Die 3 times in same level.",1),new Memory(NOT_AGAIN,"MEM_NotAgain","Not Again...","You know you can skip levels right?","Die 6 times in same level.",2),new Memory(THIS_GAME_SUCKS,"MEM_ThisGameSucks","Insanity:","Doing the same thing over and over again and expecting different results.","Die 10 times in same level.",3),new Memory(LETS_SWING,"MEM_LetsSwing","Swinging","Like a boss.","Swing on a chain for 10 seconds.",1),new Memory(BEAT_IT,"MEM_BeatIt","Just Beat It","This game is soooo easy.","Beat level 1.",1),new Memory(PIECE_OF_CAKE,"MEM_PieceCake","Piece of Cake","But it tastes good.","Beat level 6.",2),new Memory(INTERESTING,"MEM_Interesting","Interesting","%51 already gave up.","Beat Level 12.",3),new Memory(MOAR_PLEASE,"MEM_MoarPlease","Success","Now you deserve a cookie.","Beat level 18.",4),new Memory(FINISH_IT,"MEM_FinishIt","Waking Up","Walter, wake up. It\'s time.","Beat level 25.",5),new Memory(TOBY_THE_BABY,"MEM_TobyBaby","Da da","Weeeee, lalala","Meet Toby, your baby.",1),new Memory(BILLY_THE_KID,"MEM_BillyKid","Adolescence","He hates everything.","Meet Billy, your son.",2),new Memory(SIDNEY_MY_HONEY,"MEM_SidneyHoney","My Woman","She is the one for Walter.","Meet Sydney, your honey.",3),new Memory(GREER_THE_ELDER,"MEM_GreerElder","Old & Wise","And a little bit insane.","Meet the Mr. Greer, your dad.",4),new Memory(ACROBATIC,"MEM_Acrobatic","Acrobatic","Is that the best you can do?","Dodge 25 seeker.",2),new Memory(SAVE_ME,"MEM_SaveMe","Leader","It\'s your duty to lead your family to peace.","Get 10 family members into the portal.",1),new Memory(HUG_ME,"MEM_HugMe","Saver","Every piece of love counts.","Get 25 family members into the portal.",2),new Memory(LOVE_ME,"MEM_LoveMe","Lover","Love is a strong word, but never enough.","Get 50 family members into the portal.",3),new Memory(I_BELIEVE,"MEM_IBelieve","Believe","I Believe I Can Fly","Don\'t touch anything for 10 seconds.",2),new Memory(LASER_TAG,"MEM_LaserTag","It Hurts","It\'s not laser tag, it\'s real.","Get shot by laser 100 times.",3),new Memory(UBO,"MEM_Ubo","UBO","Unidentified Bomb Object","Get killed by a bomb 10 times.",2),new Memory(BROKEN_HEART,"MEM_BrokenHeart","Broken","You need more love to fix a broken heart.","Collect a total of 15 hearts.",1),new Memory(FIXED_HEART,"MEM_FixedHeart","Fixed","I guess that\'s enough to fix it.","Collect a total of 75 hearts.",2),new Memory(TEN_MINUTES,"MEM_TenMinutes","Warming Up","The game is just starting.","Play the game for 10 minutes.",1),new Memory(THIRTY_MINUTES,"MEM_ThirtyMinutes","Thumbs Up","There\'s potential.","Play the game for 30 minutes.",3),new Memory(AN_HOUR,"MEM_AnHour","Fan Boy","Either you forgot the game open or you really liked it.","Play the game for an hour.",5),new Memory(TRAPPED,"MEM_Trapped","Ouch","You should learn not to play with fire.","Die by spike or fire traps 10 times.",1),new Memory(FREEDOM,"MEM_Freedom","Freeeedoooommm","Wrong way.","Manage to get out of the bounds for 5 times.",2),new Memory(CURIOUS,"MEM_Curious","Curious","I\'m glad you are not a cat.","Find out who made the game.",1),new Memory(DEBUGGING,"MEM_Debug","Debugging","You are doing it wrong.","Get a warning in share panel.",2),new Memory(FAMOUS,"MEM_Famous","Famous","How about sharing it with world?","Test a level you\'ve created.",3),new Memory(TD_15,"MEM_Newborn","Newborn","That was easy, even for a baby.","Collect 15 hearts in Toby\'s Dream bonus level.",1),new Memory(TD_30,"MEM_Crawler","Crawler","Hey, when did you start crawling?","Collect 30 hearts in Toby\'s Dream bonus level.",3),new Memory(TD_45,"MEM_Legenbaby","Legen...","Wait for it... baby! Legenbaby!","Collect 45 hearts in Toby\'s Dream bonus level.",5),new Memory(BA_15,"MEM_Spoiled","Spoiled","Even spoiled brats can do it.","Collect 15 hearts in Billy\'s Adventure bonus level.",1),new Memory(BA_30,"MEM_Vigilant","Vigilant","So you are a vigilant boy, how far can you go?","Collect 30 hearts in Billy\'s Adventure bonus level.",3),new Memory(BA_45,"MEM_GoldenBoy","Golden Boy","You are the golden boy that can do anything.","Collect 45 hearts in Billy\'s Adventure bonus level.",5),new Memory(ER_15,"MEM_Oldie","Oldie","You\'re an oldie but a goodie.","Collect 15 hearts in Elder Rolls bonus level.",1),new Memory(ER_30,"MEM_Sage","Sage","Years of knowledge must have taught you some tricks.","Collect 30 hearts in Elder Rolls bonus level.",3),new Memory(ER_45,"MEM_Elder","Elder","Only an elder could have done it.","Collect 45 hearts in Elder Rolls bonus level.",5));
         _reservedSpots = [];
      }
      
      public static function getMemory(id:int) : Memory
      {
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].id == id)
            {
               return list[i];
            }
         }
         return null;
      }
      
      public static function reward(id:int) : void
      {
         var spot:int = 0;
         var costume:MC_MemoryReward = null;
         var memory:Memory = getMemory(id);
         if(!memory)
         {
            trace("Memory not found!.");
            return;
         }
         spot = 5;
         for(var i:int = 0; i < 5; i++)
         {
            if(_reservedSpots.indexOf(i) < 0)
            {
               spot = i;
               _reservedSpots.push(i);
               break;
            }
         }
         SM.ins.playSound(GameSound.MEMORY_EARNED);
         costume = new MC_MemoryReward();
         var clName:String = memory.className;
         var cl:Class = getDefinitionByName(clName) as Class;
         var badge:MovieClip = new cl() as MovieClip;
         costume.addChild(badge);
         costume.txt_memoryExplanation.text = memory.explanation;
         costume.txt_memorySecondTitle.text = memory.secTitle;
         costume.txt_memoryTitle.text = memory.title;
         if(costume.txt_memorySecondTitle.numLines == 1)
         {
            costume.txt_memorySecondTitle.y = -11;
         }
         DM.ins.top.addChild(costume);
         costume.x = 65;
         costume.y = 530;
         TweenLite.to(costume,1,{"y":480 - 30 - HEIGHT * spot});
         TM.ins.tf(function():void
         {
            TweenLite.to(costume,1,{
               "y":Main.s.stageHeight + 50,
               "delay":4
            });
         },1);
         TM.ins.tf(function():void
         {
            CF.removeDisplayObject(costume);
            _reservedSpots.splice(_reservedSpots.indexOf(spot),1);
         },6);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get className() : String
      {
         return this._className;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get explanation() : String
      {
         return this._explanation;
      }
      
      public function get secTitle() : String
      {
         return this._secTitle;
      }
   }
}
