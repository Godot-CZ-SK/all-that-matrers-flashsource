package game
{
   public class GameVoice extends GameSound
   {
      
      public static var num:int = 100;
      
      public static const WALTER_INTRO:int = num++;
      
      public static const WALTER_OUTRO:int = num++;
      
      public static const BILLY_OUTRO:int = num++;
      
      public static const WALTER_SELECT:int = num++;
      
      public static const WALTER_HIT:int = num++;
      
      public static const WALTER_JUMP:int = num++;
      
      public static const WALTER_DIE:int = num++;
      
      public static const WALTER_VICTORY:int = num++;
      
      public static const BILLY_SELECT:int = num++;
      
      public static const BILLY_HIT:int = num++;
      
      public static const BILLY_JUMP:int = num++;
      
      public static const BILLY_DOUBLE_JUMP:int = num++;
      
      public static const BILLY_DIE:int = num++;
      
      public static const BILLY_VICTORY:int = num++;
      
      public static const TOBY_SELECT:int = num++;
      
      public static const TOBY_HIT:int = num++;
      
      public static const TOBY_DIE:int = num++;
      
      public static const TOBY_VICTORY:int = num++;
      
      public static const SYDNEY_SELECT:int = num++;
      
      public static const SYDNEY_HIT:int = num++;
      
      public static const SYDNEY_JUMP:int = num++;
      
      public static const SYDNEY_DIE:int = num++;
      
      public static const SYDNEY_VICTORY:int = num++;
      
      public static const MRGREER_SELECT:int = num++;
      
      public static const MRGREER_HIT:int = num++;
      
      public static const MRGREER_JUMP:int = num++;
      
      public static const MRGREER_DIE:int = num++;
      
      public static const MRGREER_VICTORY:int = num++;
       
      
      public function GameVoice(id:int = 0, volume:Number = 1)
      {
         super();
         _id = id;
         _volume = volume;
         _isVoice = true;
         var rand:Number = Math.random();
         _volCoef = 0.8;
         switch(id)
         {
            case WALTER_INTRO:
               _class = VC_WalterIntro;
               _volCoef = 1;
               break;
            case WALTER_OUTRO:
               _class = VC_WalterOutro;
               _volCoef = 1;
               break;
            case BILLY_OUTRO:
               _class = VC_BillyOutro;
               _volCoef = 1;
               break;
            case WALTER_SELECT:
               if(rand < 0.2)
               {
                  _class = VC_WalterSelection1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_WalterSelection2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_WalterSelection3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_WalterSelection4;
               }
               else
               {
                  _class = VC_WalterSelection5;
               }
               break;
            case WALTER_HIT:
               if(rand < 0.2)
               {
                  _class = VC_WalterHit1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_WalterHit2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_WalterHit3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_WalterHit4;
               }
               else
               {
                  _class = VC_WalterHit5;
               }
               break;
            case WALTER_JUMP:
               if(rand < 0.25)
               {
                  _class = VC_WalterJump1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_WalterJump2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_WalterJump3;
               }
               else
               {
                  _class = VC_WalterHit4;
               }
               break;
            case WALTER_DIE:
               if(rand < 0.33)
               {
                  _class = VC_WalterDie1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_WalterDie2;
               }
               else
               {
                  _class = VC_WalterDie3;
               }
               break;
            case WALTER_VICTORY:
               if(rand < 0.25)
               {
                  _class = VC_WalterVictory1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_WalterVictory2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_WalterVictory3;
               }
               else
               {
                  _class = VC_WalterVictory4;
               }
               break;
            case BILLY_SELECT:
               if(rand < 0.2)
               {
                  _class = VC_BillySelection1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_BillySelection2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_BillySelection3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_BillySelection4;
               }
               else
               {
                  _class = VC_BillySelection5;
               }
               break;
            case BILLY_HIT:
               if(rand < 0.33)
               {
                  _class = VC_BillyHit1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_BillyHit2;
               }
               else
               {
                  _class = VC_BillyHit3;
               }
               break;
            case BILLY_JUMP:
               if(rand < 0.33)
               {
                  _class = VC_BillyJump1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_BillyJump2;
               }
               else
               {
                  _class = VC_BillyJump3;
               }
               break;
            case BILLY_DOUBLE_JUMP:
               if(rand < 0.33)
               {
                  _class = VC_BillyDoubleJump1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_BillyDoubleJump2;
               }
               else
               {
                  _class = VC_BillyDoubleJump3;
               }
               break;
            case BILLY_DIE:
               if(rand < 0.25)
               {
                  _class = VC_BillyDie1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_BillyDie2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_BillyDie3;
               }
               else
               {
                  _class = VC_BillyDie4;
               }
               break;
            case BILLY_VICTORY:
               if(rand < 0.25)
               {
                  _class = VC_BillyVictory1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_BillyVictory2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_BillyVictory3;
               }
               else
               {
                  _class = VC_BillyVictory4;
               }
               break;
            case SYDNEY_SELECT:
               if(rand < 0.2)
               {
                  _class = VC_SydneySelection1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_SydneySelection2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_SydneySelection3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_SydneySelection4;
               }
               else
               {
                  _class = VC_SydneySelection5;
               }
               break;
            case SYDNEY_HIT:
               if(rand < 0.25)
               {
                  _class = VC_SydneyHit1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_SydneyHit2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_SydneyHit3;
               }
               else
               {
                  _class = VC_SydneyHit4;
               }
               break;
            case SYDNEY_JUMP:
               if(rand < 0.2)
               {
                  _class = VC_SydneyJump1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_SydneyJump2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_SydneyJump3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_SydneyJump4;
               }
               else
               {
                  _class = VC_SydneyJump5;
               }
               break;
            case SYDNEY_DIE:
               if(rand < 0.25)
               {
                  _class = VC_SydneyDie1;
               }
               else if(rand < 0.5)
               {
                  _class = VC_SydneyDie2;
               }
               else if(rand < 0.75)
               {
                  _class = VC_SydneyDie3;
               }
               else
               {
                  _class = VC_SydneyDie4;
               }
               break;
            case SYDNEY_VICTORY:
               if(rand < 0.2)
               {
                  _class = VC_SydneyVictory1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_SydneyVictory2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_SydneyVictory3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_SydneyVictory4;
               }
               else
               {
                  _class = VC_SydneyVictory5;
               }
               break;
            case MRGREER_SELECT:
               if(rand < 0.17)
               {
                  _class = VC_MrGreerSelection1;
               }
               else if(rand < 0.34)
               {
                  _class = VC_MrGreerSelection2;
               }
               else if(rand < 0.5)
               {
                  _class = VC_MrGreerSelection3;
               }
               else if(rand < 0.67)
               {
                  _class = VC_MrGreerSelection4;
               }
               else if(rand < 0.84)
               {
                  _class = VC_MrGreerSelection5;
               }
               else
               {
                  _class = VC_MrGreerSelection6;
               }
               break;
            case MRGREER_HIT:
               if(rand < 0.2)
               {
                  _class = VC_MrGreerHit1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_MrGreerHit2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_MrGreerHit3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_MrGreerHit4;
               }
               else
               {
                  _class = VC_MrGreerHit5;
               }
               break;
            case MRGREER_JUMP:
               if(rand < 0.17)
               {
                  _class = VC_MrGreerJump1;
               }
               else if(rand < 0.34)
               {
                  _class = VC_MrGreerJump2;
               }
               else if(rand < 0.5)
               {
                  _class = VC_MrGreerJump3;
               }
               else if(rand < 0.67)
               {
                  _class = VC_MrGreerJump4;
               }
               else if(rand < 0.84)
               {
                  _class = VC_MrGreerJump5;
               }
               else
               {
                  _class = VC_MrGreerJump6;
               }
               break;
            case MRGREER_DIE:
               if(rand < 0.33)
               {
                  _class = VC_MrGreerDie1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_MrGreerDie2;
               }
               else
               {
                  _class = VC_MrGreerDie1;
               }
               break;
            case MRGREER_VICTORY:
               if(rand < 0.2)
               {
                  _class = VC_MrGreerVictory1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_MrGreerVictory2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_MrGreerVictory3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_MrGreerVictory4;
               }
               else
               {
                  _class = VC_MrGreerVictory5;
               }
               break;
            case TOBY_SELECT:
               if(rand < 0.2)
               {
                  _class = VC_TobySelection1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_TobySelection2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_TobySelection3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_TobySelection4;
               }
               else
               {
                  _class = VC_TobySelection5;
               }
               break;
            case TOBY_HIT:
               if(rand < 0.17)
               {
                  _class = VC_TobyHit1;
               }
               else if(rand < 0.34)
               {
                  _class = VC_TobyHit2;
               }
               else if(rand < 0.5)
               {
                  _class = VC_TobyHit3;
               }
               else if(rand < 0.67)
               {
                  _class = VC_TobyHit4;
               }
               else if(rand < 0.84)
               {
                  _class = VC_TobyHit5;
               }
               else
               {
                  _class = VC_TobyHit6;
               }
               break;
            case TOBY_DIE:
               if(rand < 0.33)
               {
                  _class = VC_TobyDie1;
               }
               else if(rand < 0.66)
               {
                  _class = VC_TobyDie2;
               }
               else
               {
                  _class = VC_TobyDie3;
               }
               break;
            case TOBY_VICTORY:
               if(rand < 0.2)
               {
                  _class = VC_TobyVictory1;
               }
               else if(rand < 0.4)
               {
                  _class = VC_TobyVictory2;
               }
               else if(rand < 0.6)
               {
                  _class = VC_TobyVictory3;
               }
               else if(rand < 0.8)
               {
                  _class = VC_TobyVictory4;
               }
               else
               {
                  _class = VC_TobyVictory5;
               }
               break;
            default:
               _class = SND_Default;
         }
      }
   }
}
