package design.data
{
   import be.boulevart.as3.security.Encryption;
   import be.boulevart.as3.security.EncryptionTypes;
   import game.LevelWarning;
   
   public class LevelData
   {
      
      protected static const MAX_OBJECTS:int = 60;
      
      protected static const MAX_VERTICE:int = 20;
      
      protected static const MAX_TOTAL_VERTICES:int = 300;
      
      protected static const MIN_CHARACTER_LEVEL:int = 3;
      
      protected static const MAX_SEEKER:int = 30;
      
      protected static const MAX_CANNON:int = 15;
      
      protected static const MAX_CHAIN:int = 8;
      
      protected static const MAX_LAMP:int = 4;
      
      protected static const MAX_TOTAL_PATH_VERTICE:int = 300;
      
      protected static const MAX_PATH_VERTICE:int = 20;
       
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _gravity:Number;
      
      protected var _list:Vector.<DO_Data>;
      
      protected var _background:String;
      
      protected var _levelName:String;
      
      protected var _creatorName:String;
      
      public function LevelData()
      {
         super();
         this._list = new Vector.<DO_Data>();
         this._width = 1280;
         this._height = 960;
         this._gravity = 0;
      }
      
      public function clone() : LevelData
      {
         var result:LevelData = new LevelData();
         for(var i:int = 0; i < this._list.length; i++)
         {
            result.addData(this._list[i].clone());
         }
         result.setLevelName(this.levelName);
         result.setBackground(this.background);
         result.setSize(this.width,this.height);
         result.setGravity(this.gravity);
         return result;
      }
      
      public function setGravity(val:Number) : void
      {
         this._gravity = val;
      }
      
      public function setLevelName(name:String) : void
      {
         this._levelName = name;
      }
      
      public function setCreatorName(name:String) : void
      {
         this._creatorName = name;
      }
      
      public function addData(data:DO_Data) : void
      {
         this._list.push(data);
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         this._width = width;
         this._height = height;
      }
      
      public function setBackground(type:String) : void
      {
         this._background = type;
      }
      
      public function convertToString() : String
      {
         var result:String = this._levelName + "::" + this._width.toString() + "::" + this._height.toString() + "::" + this._background + "::" + this._gravity.toString();
         for(var i:int = 0; i < this._list.length; i++)
         {
            result += "::" + this._list[i].convertToString();
         }
         var e:Encryption = new Encryption(EncryptionTypes.Base64(),result,null,null);
         e.encode();
         return e.getInput();
      }
      
      public function loadLevelFromString(data:String) : Boolean
      {
         var d_obj:DO_Data = null;
         var e:Encryption = new Encryption(EncryptionTypes.Base64(),data,null,null);
         e.decode();
         data = e.getInput();
         var arr:Array = data.split("::");
         if(arr.length < 5)
         {
            return false;
         }
         this._levelName = arr[0];
         this._width = Number(arr[1]);
         this._height = Number(arr[2]);
         this._background = arr[3];
         this._gravity = Number(arr[4]);
         this._list = new Vector.<DO_Data>();
         for(var i:int = 5; i < arr.length; i++)
         {
            d_obj = this.createDesignObjectDataFromString(arr[i]);
            if(!d_obj)
            {
               return false;
            }
            this._list.push(d_obj);
         }
         return true;
      }
      
      protected function createDesignObjectDataFromString(data:String) : DO_Data
      {
         var d_obj:DO_Data = null;
         var arr:Array = data.split(";");
         var type:String = arr[0];
         if(type == DO_Data.TYPE_CIRCLE)
         {
            d_obj = new DO_CircleData();
         }
         else if(type == DO_Data.TYPE_HEART)
         {
            d_obj = new DO_HeartData();
         }
         else if(type == DO_Data.TYPE_PLATFORM)
         {
            d_obj = new DO_PlatformData();
         }
         else if(type == DO_Data.TYPE_POLY)
         {
            d_obj = new DO_PolyData();
         }
         else if(type == DO_Data.TYPE_PORTAL)
         {
            d_obj = new DO_PortalData();
         }
         else if(type == DO_Data.TYPE_TRAP)
         {
            d_obj = new DO_TrapData();
         }
         else if(type == DO_Data.TYPE_UNIT)
         {
            d_obj = new DO_UnitData();
         }
         else if(type == DO_Data.TYPE_UO)
         {
            d_obj = new DO_UOData();
         }
         else if(type == DO_Data.TYPE_PATH_OBJECT)
         {
            d_obj = new DO_PathObjectData();
         }
         else if(type == DO_Data.TYPE_CANNON)
         {
            d_obj = new DO_CannonData();
         }
         else if(type == DO_Data.TYPE_LEVER)
         {
            d_obj = new DO_LeverData();
         }
         else if(type == DO_Data.TYPE_CLOUD)
         {
            d_obj = new DO_CloudData();
         }
         else if(type == DO_Data.TYPE_DOOR)
         {
            d_obj = new DO_DoorData();
         }
         else if(type == DO_Data.TYPE_KEY)
         {
            d_obj = new DO_KeyData();
         }
         else if(type == DO_Data.TYPE_LAMP)
         {
            d_obj = new DO_LampData();
         }
         else if(type == DO_Data.TYPE_BOUNCER)
         {
            d_obj = new DO_BouncerData();
         }
         else if(type == DO_Data.TYPE_BLOWER)
         {
            d_obj = new DO_BlowerData();
         }
         else if(type == DO_Data.TYPE_LASER)
         {
            d_obj = new DO_LaserData();
         }
         else if(type == DO_Data.TYPE_LADDER)
         {
            d_obj = new DO_LadderData();
         }
         else if(type == DO_Data.TYPE_BUTTON)
         {
            d_obj = new DO_ButtonData();
         }
         else if(type == DO_Data.TYPE_SLIDE_DOOR)
         {
            d_obj = new DO_SlideDoorData();
         }
         else if(type == DO_Data.TYPE_GRAVITY_SWITCHER)
         {
            d_obj = new DO_GravitySwitcherData();
         }
         else if(type == DO_Data.TYPE_WHEEL)
         {
            d_obj = new DO_WheelData();
         }
         else if(type == DO_Data.TYPE_SEEKER)
         {
            d_obj = new DO_SeekerData();
         }
         else if(type == DO_Data.TYPE_PISTON_DOOR)
         {
            d_obj = new DO_PistonDoorData();
         }
         else if(type == DO_Data.TYPE_PISTON_PLATE)
         {
            d_obj = new DO_PistonPlateData();
         }
         else if(type == DO_Data.TYPE_CHAIN)
         {
            d_obj = new DO_ChainData();
         }
         else if(type == DO_Data.TYPE_TEXT)
         {
            d_obj = new DO_TextData();
         }
         else if(type == DO_Data.TYPE_SIGN)
         {
            d_obj = new DO_SignData();
         }
         else if(type == DO_Data.TYPE_STONE)
         {
            d_obj = new DO_StoneData();
         }
         else if(type == DO_Data.TYPE_FLOWER)
         {
            d_obj = new DO_FlowerData();
         }
         else if(type == DO_Data.TYPE_THING)
         {
            d_obj = new DO_ThingData();
         }
         else if(type == DO_Data.TYPE_OTHERS)
         {
            d_obj = new DO_OthersData();
         }
         else if(type == DO_Data.TYPE_ELEVATOR)
         {
            d_obj = new DO_ElevatorData();
         }
         else if(type == DO_Data.TYPE_CHECKPOINT)
         {
            d_obj = new DO_CheckpointData();
         }
         if(d_obj && d_obj.loadFromArray(arr))
         {
            arr = null;
            return d_obj;
         }
         trace(type,d_obj,arr.length,d_obj.loadFromArray(arr));
         trace("Wrong Data");
         return null;
      }
      
      public function isValid() : Vector.<LevelWarning>
      {
         var level:LevelWarning = null;
         var levelShort:LevelWarning = null;
         var uType:String = null;
         var noPortal:LevelWarning = null;
         var noCharacter:LevelWarning = null;
         var multipleCharacter:LevelWarning = null;
         var maxObjects:LevelWarning = null;
         var maxVertice:LevelWarning = null;
         var maxPathVertice:LevelWarning = null;
         var maxSeeker:LevelWarning = null;
         var maxChain:LevelWarning = null;
         var maxLamp:LevelWarning = null;
         var maxCannon:LevelWarning = null;
         var maxTotalVertices:LevelWarning = null;
         var maxPathTotalVertices:LevelWarning = null;
         var result:Vector.<LevelWarning> = new Vector.<LevelWarning>();
         var i:int = 0;
         var totalVertices:int = 0;
         var totalPathVertices:int = 0;
         var verticeCount:int = 0;
         var numSeeker:int = 0;
         var numChain:int = 0;
         var numLamp:int = 0;
         var numCannon:int = 0;
         var hasPortal:Boolean = false;
         var hasDad:Boolean = false;
         var hasKid:Boolean = false;
         var hasMom:Boolean = false;
         var hasElder:Boolean = false;
         var hasBaby:Boolean = false;
         var hasMultipleChar:Boolean = false;
         if(this._levelName == "")
         {
            level = new LevelWarning(LevelWarning.TYPE_ERROR,"Level name can not be blank.");
            result.push(level);
         }
         else if(this._levelName.length < MIN_CHARACTER_LEVEL)
         {
            levelShort = new LevelWarning(LevelWarning.TYPE_ERROR,"Level name can not be shorter than " + MIN_CHARACTER_LEVEL.toString() + "characters.");
            result.push(levelShort);
         }
         for(i = 0; i < this._list.length; i++)
         {
            if(this._list[i] is DO_PortalData)
            {
               hasPortal = true;
            }
            if(this._list[i] is DO_UnitData)
            {
               uType = (this._list[i] as DO_UnitData).unitType;
               if(uType == DO_UnitData.BABY)
               {
                  if(hasBaby)
                  {
                     hasMultipleChar = true;
                  }
                  hasBaby = true;
               }
               else if(uType == DO_UnitData.DAD)
               {
                  if(hasDad)
                  {
                     hasMultipleChar = true;
                  }
                  hasDad = true;
               }
               else if(uType == DO_UnitData.ELDER)
               {
                  if(hasElder)
                  {
                     hasMultipleChar = true;
                  }
                  hasElder = true;
               }
               else if(uType == DO_UnitData.MOM)
               {
                  if(hasMom)
                  {
                     hasMultipleChar = true;
                  }
                  hasMom = true;
               }
               else if(uType == DO_UnitData.KID)
               {
                  if(hasKid)
                  {
                     hasMultipleChar = true;
                  }
                  hasKid = true;
               }
            }
         }
         if(!hasPortal)
         {
            noPortal = new LevelWarning(LevelWarning.TYPE_ERROR,"There has to be at least one portal in your level.");
            result.push(noPortal);
         }
         if(!hasBaby && !hasDad && !hasElder && !hasMom && !hasKid)
         {
            noCharacter = new LevelWarning(LevelWarning.TYPE_ERROR,"There has to be at least one character in your level.");
            result.push(noCharacter);
         }
         if(hasMultipleChar)
         {
            multipleCharacter = new LevelWarning(LevelWarning.TYPE_WARNING,"There are more than one character of same type in your level.");
            result.push(multipleCharacter);
         }
         if(this._list.length > MAX_OBJECTS)
         {
            maxObjects = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + this._list.length + " objects in the level. It has to be less than " + MAX_OBJECTS.toString() + ".");
            result.push(maxObjects);
         }
         for(i = 0; i < this._list.length; i++)
         {
            if(this._list[i] is DO_PolyData)
            {
               verticeCount = (this._list[i] as DO_PolyData).vertices.length;
               if(verticeCount > MAX_VERTICE)
               {
                  maxVertice = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + verticeCount.toString() + " vertices in a polygon. Max allowed is " + MAX_VERTICE.toString() + ".");
                  result.push(maxVertice);
               }
               totalVertices += verticeCount;
            }
            else if(this._list[i] is DO_PathObjectData)
            {
               verticeCount = (this._list[i] as DO_PathObjectData).path.waypoints.length;
               if(verticeCount > MAX_PATH_VERTICE)
               {
                  maxPathVertice = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + verticeCount.toString() + " path vertices in a path object. Max allowed is " + MAX_PATH_VERTICE.toString() + ".");
                  result.push(maxPathVertice);
               }
               totalPathVertices += verticeCount;
            }
            if(this._list[i] is DO_SeekerData)
            {
               numSeeker++;
            }
            else if(this._list[i] is DO_CannonData)
            {
               numCannon++;
            }
            else if(this._list[i] is DO_ChainData)
            {
               numChain++;
            }
            else if(this._list[i] is DO_LampData)
            {
               numLamp++;
            }
         }
         if(numSeeker > MAX_SEEKER)
         {
            maxSeeker = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + numSeeker.toString() + " seekers in this level. Max allowed is " + MAX_SEEKER.toString() + ".");
            result.push(maxSeeker);
         }
         if(numChain > MAX_CHAIN)
         {
            maxChain = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + numChain.toString() + " chains in this level. Max allowed is " + MAX_CHAIN.toString() + ".");
            result.push(maxChain);
         }
         if(numLamp > MAX_LAMP)
         {
            maxLamp = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + numLamp.toString() + " lamps in this level. Max allowed is " + MAX_LAMP.toString() + ".");
            result.push(maxLamp);
         }
         if(numCannon > MAX_CANNON)
         {
            maxCannon = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + numCannon.toString() + " cannons in this level. Max allowed is " + MAX_CANNON.toString() + ".");
            result.push(maxCannon);
         }
         if(totalVertices > MAX_TOTAL_VERTICES)
         {
            maxTotalVertices = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + totalVertices.toString() + " total vertices in all polygons. Max allowed is " + MAX_TOTAL_VERTICES.toString() + ".");
            result.push(maxTotalVertices);
         }
         if(totalPathVertices > MAX_TOTAL_PATH_VERTICE)
         {
            maxPathTotalVertices = new LevelWarning(LevelWarning.TYPE_ERROR,"There are " + totalPathVertices.toString() + " total path vertices in all path objects. Max allowed is " + MAX_TOTAL_PATH_VERTICE.toString() + ".");
            result.push(maxPathTotalVertices);
         }
         return result;
      }
      
      public function get list() : Vector.<DO_Data>
      {
         return this._list;
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function get background() : String
      {
         return this._background;
      }
      
      public function get levelName() : String
      {
         return this._levelName;
      }
      
      public function get creatorName() : String
      {
         return this._creatorName;
      }
      
      public function get gravity() : Number
      {
         return this._gravity;
      }
   }
}
