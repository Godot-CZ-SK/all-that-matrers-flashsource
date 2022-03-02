package Playtomic
{
   public final class Parse
   {
      
      private static var SECTION:String;
      
      private static var SAVE:String;
      
      private static var DELETE:String;
      
      private static var LOAD:String;
      
      private static var FIND:String;
       
      
      public function Parse()
      {
         super();
      }
      
      static function Initialise(apikey:String) : void
      {
         SECTION = Encode.MD5("parse-" + apikey);
         SAVE = Encode.MD5("parse-save-" + apikey);
         DELETE = Encode.MD5("parse-delete-" + apikey);
         LOAD = Encode.MD5("parse-load-" + apikey);
         FIND = Encode.MD5("parse-find-" + apikey);
      }
      
      public static function Save(pobject:PFObject, callback:Function = null) : void
      {
         Request.Load(SECTION,SAVE,SaveComplete,callback,ObjectPostData(pobject));
      }
      
      private static function SaveComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var key:* = null;
         var s:String = null;
         var fieldname:String = null;
         var pointerobj:PFObject = null;
         var object:XMLList = null;
         if(callback == null)
         {
            return;
         }
         var obj:XMLList = data["object"];
         var item:XML = obj[0];
         var pobject:PFObject = new PFObject();
         pobject.ObjectId = item["id"];
         pobject.ClassName = postdata["classname"];
         pobject.Password = postdata["password"];
         for(key in postdata)
         {
            if(key.indexOf("data") == 0)
            {
               pobject.Data[key.substring(4)] = postdata[key];
            }
            if(key.indexOf("pointer") == 0 && key.indexOf("fieldname") > -1)
            {
               s = key.substring(7);
               s = s.substring(0,s.indexOf("fieldname"));
               fieldname = postdata["pointer" + s + "fieldname"];
               pointerobj = new PFObject();
               pointerobj.ClassName = postdata["pointer" + s + "classname"];
               pointerobj.ObjectId = postdata["pointer" + s + "id"];
               pobject.Pointers.push(new PFPointer(fieldname,pointerobj));
            }
         }
         if(response.Success)
         {
            object = data["object"];
            pobject.CreatedAt = DateParse(object["created"]);
            pobject.UpdatedAt = DateParse(object["updated"]);
         }
         callback(pobject,response);
      }
      
      public static function Delete(pobject:PFObject, callback:Function = null) : void
      {
         Request.Load(SECTION,DELETE,DeleteComplete,callback,ObjectPostData(pobject));
      }
      
      private static function DeleteComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         if(callback == null)
         {
            return;
         }
         callback(response);
         data = data;
         postdata = postdata;
      }
      
      public static function Load(pobjectid:String, classname:String, callback:Function = null) : void
      {
         var pobject:PFObject = new PFObject();
         pobject.ObjectId = pobjectid;
         pobject.ClassName = classname;
         Request.Load(SECTION,LOAD,LoadComplete,callback,ObjectPostData(pobject));
      }
      
      private static function LoadComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var object:XMLList = null;
         var fields:XMLList = null;
         var field:XML = null;
         var pointers:XMLList = null;
         var pointer:XML = null;
         var pfieldname:String = null;
         var pchild:PFObject = null;
         if(callback == null)
         {
            return;
         }
         var pobject:PFObject = new PFObject();
         pobject.ObjectId = postdata["objectid"];
         pobject.ClassName = postdata["classname"];
         if(response.Success)
         {
            object = data["object"];
            pobject.CreatedAt = DateParse(object["created"]);
            pobject.UpdatedAt = DateParse(object["updated"]);
            if(object.contains("fields"))
            {
               fields = object["fields"];
               for each(field in fields.children())
               {
                  pobject[field.name] = field.text();
               }
            }
            if(object.contains("pointers"))
            {
               pointers = object["pointers"];
               for each(pointer in pointers.children())
               {
                  pfieldname = pointer["fieldname"];
                  pchild = new PFObject();
                  pchild.ClassName = pointer["classname"];
                  pchild.ObjectId = pointer["id"];
                  pobject.Pointers.push(new PFPointer(pfieldname,pchild));
               }
            }
         }
         callback(pobject,response);
      }
      
      public static function Find(pquery:PFQuery, callback:Function = null) : void
      {
         var key:* = null;
         var i:int = 0;
         var postdata:Object = new Object();
         postdata["classname"] = pquery.ClassName;
         postdata["limit"] = pquery.Limit;
         postdata["order"] = pquery.Order != null && pquery.Order != "" ? pquery.Order : "created_at";
         for(key in pquery.WhereData)
         {
            postdata["data" + key] = pquery.WhereData[key];
         }
         for(i = pquery.WherePointers.length - 1; i > -1; i--)
         {
            postdata["pointer" + i + "fieldname"] = pquery.WherePointers[i].FieldName;
            postdata["pointer" + i + "classname"] = pquery.WherePointers[i].PObject.ClassName;
            postdata["pointer" + i + "id"] = pquery.WherePointers[i].PObject.ObjectId;
         }
         Request.Load(SECTION,FIND,FindComplete,callback,postdata);
      }
      
      private static function FindComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null) : void
      {
         var objects:XMLList = null;
         var object:XML = null;
         var pobject:PFObject = null;
         var fields:XMLList = null;
         var field:XML = null;
         var pointers:XMLList = null;
         var pointer:XML = null;
         var pfieldname:String = null;
         var pchild:PFObject = null;
         if(callback == null)
         {
            return;
         }
         var objs:Array = new Array();
         if(response.Success)
         {
            objects = data["objects"];
            for each(object in objects.children())
            {
               pobject = new PFObject();
               pobject.ObjectId = object["id"];
               pobject.CreatedAt = DateParse(object["created"]);
               pobject.UpdatedAt = DateParse(object["updated"]);
               if(object.contains("fields"))
               {
                  fields = object["fields"];
                  for each(field in fields.children())
                  {
                     pobject[field.name] = field.text();
                  }
               }
               if(object.contains("pointers"))
               {
                  pointers = object["pointers"];
                  for each(pointer in pointers.children())
                  {
                     pfieldname = pointer["fieldname"];
                     pchild = new PFObject();
                     pchild.ClassName = pointer["classname"];
                     pchild.ObjectId = pointer["id"];
                     pobject.Pointers.push(new PFPointer(pfieldname,pchild));
                  }
               }
               objs.push(pobject);
            }
         }
         callback(objs,response);
         postdata = postdata;
      }
      
      private static function ObjectPostData(pobject:PFObject) : Object
      {
         var key:* = null;
         var i:int = 0;
         var postobject:Object = new Object();
         postobject["classname"] = pobject.ClassName;
         postobject["id"] = pobject.ObjectId == null ? "" : pobject.ObjectId;
         postobject["password"] = pobject.Password == null ? "" : pobject.Password;
         for(key in pobject.Data)
         {
            postobject["data" + key] = pobject.Data[key];
         }
         for(i = pobject.Pointers.length - 1; i > -1; i--)
         {
            postobject["pointer" + i + "fieldname"] = pobject.Pointers[i].FieldName;
            postobject["pointer" + i + "classname"] = pobject.Pointers[i].PObject.ClassName;
            postobject["pointer" + i + "id"] = pobject.Pointers[i].PObject.ObjectId;
         }
         return postobject;
      }
      
      private static function DateParse(date:String) : Date
      {
         var parts:Array = date.split(" ");
         var dateparts:Array = (parts[0] as String).split("/");
         var timeparts:Array = (parts[1] as String).split(":");
         var day:int = int(dateparts[1]);
         var month:int = int(dateparts[0]);
         var year:int = int(dateparts[2]);
         var hours:int = int(timeparts[0]);
         var minutes:int = int(timeparts[1]);
         var seconds:int = int(timeparts[2]);
         return new Date(Date.UTC(year,month,day,hours,minutes,seconds));
      }
   }
}
