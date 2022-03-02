package be.boulevart.as3.security
{
   public class Encryption
   {
       
      
      protected var encryptionType:Object;
      
      protected var input:String;
      
      protected var key:String;
      
      protected var mode:String;
      
      protected var keySize:Number;
      
      protected var blockSize:Number;
      
      protected var isBase8orBase64:Boolean = false;
      
      protected var isTEAorRC4:Boolean = false;
      
      protected var isGoauldorMD5orROT13orSHA1:Boolean = false;
      
      protected var isRijndael:Boolean = false;
      
      protected var isLZW:Boolean = false;
      
      protected var r:Rijndael;
      
      public function Encryption(type:Object, input:String, key:String, mode:String, keySize:Number = -1, blockSize:Number = -1)
      {
         super();
         if(type != null)
         {
            this.setEncryptionType(type);
         }
         if(input != null)
         {
            this.setInput(input);
         }
         if(key != null)
         {
            this.setKey(key);
         }
         if(mode != null)
         {
            this.setMode(mode);
         }
         switch(type)
         {
            case Base8:
               this.isBase8orBase64 = true;
               break;
            case Base64:
               this.isBase8orBase64 = true;
               break;
            case SHA1:
               this.isGoauldorMD5orROT13orSHA1 = true;
               break;
            case MD5:
               this.isGoauldorMD5orROT13orSHA1 = true;
               break;
            case RC4:
               this.isTEAorRC4 = true;
               break;
            case TEA:
               this.isTEAorRC4 = true;
               break;
            case LZW:
               this.isLZW = true;
               break;
            case ROT13:
               this.isGoauldorMD5orROT13orSHA1 = true;
               break;
            case Goauld:
               this.isGoauldorMD5orROT13orSHA1 = true;
               break;
            case Rijndael:
               this.isRijndael = true;
               this.r = new Rijndael(keySize,blockSize);
         }
      }
      
      public function calculate() : void
      {
         if(!this.isGoauldorMD5orROT13orSHA1)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'calculate\' kan enkel aangeroepen worden voor het berekenen van een MD5, SHA1, ROT13 of Goauld string.");
         }
         if(this.getInput().length <= 0)
         {
            throw new Error("Input string bestaat niet");
         }
         this.setInput(this.getEncryptionType().calculate(this.getInput()));
      }
      
      public function compress() : void
      {
         if(!this.isLZW)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'compress\' kan enkel aangeroepen worden voor het comprimeren van een string via LZW.");
         }
         if(this.getInput().length <= 0)
         {
            throw new Error("Input string bestaat niet");
         }
         this.setInput(this.getEncryptionType().compress(this.getInput()));
      }
      
      public function decompress() : void
      {
         if(!this.isLZW)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'decompress\' kan enkel aangeroepen worden voor het decomprimeren van een string via LZW.");
         }
         if(this.getInput().length <= 0)
         {
            throw new Error("Input string bestaat niet");
         }
         this.setInput(this.getEncryptionType().decompress(this.getInput()));
      }
      
      public function encode() : void
      {
         if(!this.isBase8orBase64)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'encode\' kan enkel aangeroepen worden voor een Base8 of Base64 encryptie.");
         }
         if(this.getInput().length <= 0)
         {
            throw new Error("Input string bestaat niet");
         }
         this.setInput(this.getEncryptionType().encode(this.getInput()));
      }
      
      public function decode() : void
      {
         if(!this.isBase8orBase64)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'decode\' kan enkel aangeroepen worden voor een Base8 of Base64 decryptie.");
         }
         if(this.getInput().length <= 0)
         {
            throw new Error("Input string bestaat niet");
         }
         this.setInput(this.getEncryptionType().decode(this.getInput()));
      }
      
      public function encrypt() : void
      {
         if(!this.isTEAorRC4)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'encrypt\' kan enkel aangeroepen worden voor een TEA of RC4 encryptie.");
         }
         if(this.getInput().length > 0 && this.getKey().length > 0)
         {
            this.setInput(this.getEncryptionType().encrypt(this.getInput(),this.getKey()));
         }
         else
         {
            if(this.getInput().length <= 0)
            {
               throw new Error("Input string bestaat niet");
            }
            if(this.getKey().length <= 0)
            {
               throw new Error("Geen key opgegeven voor de encryptie");
            }
         }
      }
      
      public function decrypt() : void
      {
         if(!this.isTEAorRC4)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'decrypt\' kan enkel aangeroepen worden voor een TEA of RC4 encryptie.");
         }
         if(this.getInput().length > 0 && this.getKey().length > 0)
         {
            this.setInput(this.getEncryptionType().decrypt(this.getInput(),this.getKey()));
         }
         else
         {
            if(this.getInput().length <= 0)
            {
               throw new Error("Input string bestaat niet");
            }
            if(this.getKey().length <= 0)
            {
               throw new Error("Geen key opgegeven voor de encryptie");
            }
         }
      }
      
      public function encryptRijndael() : void
      {
         if(!this.isRijndael)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'encryptRijndael\' kan enkel aangeroepen worden voor een Rijndael encryptie.");
         }
         if(this.getInput().length > 0 && this.getKey().length > 0 && this.getMode().length > 0)
         {
            this.setInput(this.r.encrypt(this.getInput(),this.getKey(),this.getMode()));
         }
         else
         {
            if(this.getInput().length <= 0)
            {
               throw new Error("Input string bestaat niet");
            }
            if(this.getKey().length <= 0)
            {
               throw new Error("Geen key opgegeven voor de encryptie");
            }
            if(this.getMode().length <= 0)
            {
               throw new Error("Geen modus opgegeven voor Rijndael encryptie.  Geldige modi zijn CBC en ECB.");
            }
         }
      }
      
      public function decryptRijndael() : void
      {
         if(!this.isRijndael)
         {
            throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie \'decryptRijndael\' kan enkel aangeroepen worden voor een Rijndael decryptie.");
         }
         if(this.getInput().length > 0 && this.getKey().length > 0 && this.getMode().length > 0)
         {
            this.setInput(this.r.decrypt(this.getInput(),this.getKey(),this.getMode()));
         }
         else
         {
            if(this.getInput().length <= 0)
            {
               throw new Error("Input string bestaat niet");
            }
            if(this.getKey().length <= 0)
            {
               throw new Error("Geen key opgegeven voor de decryptie");
            }
            if(this.getMode().length <= 0)
            {
               throw new Error("Geen modus opgegeven voor Rijndael decryptie.  Geldige modi zijn CBC en ECB.");
            }
         }
      }
      
      public function getInput() : String
      {
         return this.input;
      }
      
      protected function setEncryptionType(et:Object) : void
      {
         this.encryptionType = et;
      }
      
      protected function getEncryptionType() : Object
      {
         return this.encryptionType;
      }
      
      protected function setInput(str:String) : void
      {
         this.input = str;
      }
      
      protected function getKey() : String
      {
         return this.key;
      }
      
      protected function setKey(str:String) : void
      {
         this.key = str;
      }
      
      protected function getMode() : String
      {
         return this.mode;
      }
      
      protected function setMode(str:String) : void
      {
         this.mode = str;
      }
   }
}
