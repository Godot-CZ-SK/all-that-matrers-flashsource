package design.data
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import geom.Line;
   import geom.Polygon;
   import geom.Triangle;
   import geom.Triangulator;
   
   public class DO_PolyData extends DO_Data
   {
      
      public static const EMPTY:String = "empty";
      
      public static const WALL:String = "wall";
      
      public static const OBSTACLE:String = "obstacle";
      
      public static const SET_1:Array = [5131599,6118739,8092521,2565927];
      
      public static const SET_2:Array = [6638147,7362633,8087121,2565927];
      
      public static const SET_3:Array = [9541538,8160143,6580853,2565927];
      
      public static const SET_4:Array = [8492730,8427182,10728397,2565927];
       
      
      public var vertices:Vector.<Point>;
      
      public var seed:int;
      
      public var polyType:String;
      
      public var color1:uint;
      
      public var color2:uint;
      
      public var color3:uint;
      
      public var wallType:int;
      
      public function DO_PolyData(polyType:String = "empty")
      {
         super(TYPE_POLY);
         this.polyType = polyType;
         this.vertices = new Vector.<Point>();
         this.color1 = SET_1[0];
         this.color2 = SET_1[1];
         this.color3 = SET_1[2];
         this.wallType = 1;
      }
      
      public function getLines() : Vector.<Line>
      {
         var first:int = 0;
         var second:int = 0;
         var l:Line = null;
         var lines:Vector.<Line> = new Vector.<Line>();
         for(var i:int = 0; i < this.vertices.length; i++)
         {
            first = i;
            second = (i + 1) % this.vertices.length;
            l = new Line(this.vertices[first].x,this.vertices[first].y,this.vertices[second].x,this.vertices[second].y);
            lines.push(l);
         }
         return lines;
      }
      
      public function getTriangles() : Vector.<Triangle>
      {
         var tri:Vector.<Triangle> = Triangulator.triangulatePolygon(this.vertices);
         if(!tri)
         {
            this.vertices.reverse();
            tri = Triangulator.triangulatePolygon(this.vertices);
            if(!tri)
            {
               throw new Error("Couldn\'t triangulate.");
            }
         }
         return tri;
      }
      
      public function getPolygons() : Vector.<Polygon>
      {
         var i:int = 0;
         var poly:Polygon = null;
         var tri:Vector.<Triangle> = this.getTriangles();
         var polygons:Vector.<Polygon> = Triangulator.polygonizeTriangles(tri);
         if(!polygons)
         {
            polygons = new Vector.<Polygon>();
            for(i = 0; i < tri.length; i++)
            {
               poly = new Polygon(tri[i].x,tri[i].y);
               polygons.push(poly);
            }
         }
         return polygons;
      }
      
      override public function convertToString() : String
      {
         var result:String = type + ";" + this.polyType + ";" + this.seed.toString() + ";" + this.color1.toString() + ";" + this.color2.toString() + ";" + this.color3.toString() + ";" + this.wallType.toString();
         for(var i:int = 0; i < this.vertices.length; i++)
         {
            result += ";" + this.vertices[i].x.toString() + "," + this.vertices[i].y.toString();
         }
         return result;
      }
      
      override public function loadFromArray(data:Array) : Boolean
      {
         var poistr:String = null;
         var poiarr:Array = null;
         var poi:Point = null;
         if(data.length < 10)
         {
            return false;
         }
         type = data[0];
         this.polyType = data[1];
         this.seed = int(data[2]);
         this.vertices = new Vector.<Point>();
         for(var i:int = 7; i < data.length; i++)
         {
            poistr = data[i];
            poiarr = poistr.split(",");
            if(poiarr.length != 2)
            {
               return false;
            }
            poi = new Point(Number(poiarr[0]),Number(poiarr[1]));
            this.vertices.push(poi);
         }
         this.color1 = uint(data[3]);
         this.color2 = uint(data[4]);
         this.color3 = uint(data[5]);
         this.wallType = uint(data[6]);
         if(this.wallType == 0)
         {
            this.wallType = 1;
         }
         return true;
      }
      
      public function isItSet(setNo:int) : Boolean
      {
         var c_set:Array = [];
         if(setNo == 1)
         {
            c_set = SET_1;
         }
         else if(setNo == 2)
         {
            c_set = SET_2;
         }
         else if(setNo == 3)
         {
            c_set = SET_3;
         }
         else
         {
            c_set = SET_4;
         }
         if(this.color1 == c_set[0] && this.color2 == c_set[1] && this.color3 == c_set[2])
         {
            return true;
         }
         return false;
      }
      
      public function selectSet(setNo:int) : void
      {
         var c_set:Array = [];
         if(setNo == 1)
         {
            c_set = SET_1;
         }
         else if(setNo == 2)
         {
            c_set = SET_2;
         }
         else if(setNo == 3)
         {
            c_set = SET_3;
         }
         else
         {
            c_set = SET_4;
         }
         this.color1 = c_set[0];
         this.color2 = c_set[1];
         this.color3 = c_set[2];
      }
      
      override public function clear() : void
      {
         this.vertices = new Vector.<Point>();
         super.clear();
      }
      
      override public function clone() : DO_Data
      {
         var result:DO_PolyData = new DO_PolyData();
         result.type = type;
         result.polyType = this.polyType;
         result.color1 = this.color1;
         result.color2 = this.color2;
         result.color3 = this.color3;
         result.wallType = this.wallType;
         for(var i:int = 0; i < this.vertices.length; i++)
         {
            result.vertices.push(this.vertices[i].clone());
         }
         result.seed = this.seed;
         return result;
      }
      
      override public function debugDraw(s:Number, g:Graphics) : void
      {
         if(this.vertices.length <= 0)
         {
            return;
         }
         g.beginFill(this.color1,1);
         g.moveTo(this.vertices[0].x * s,this.vertices[0].y * s);
         for(var i:int = 1; i < this.vertices.length; i++)
         {
            g.lineTo(this.vertices[i].x * s,this.vertices[i].y * s);
         }
         g.lineTo(this.vertices[0].x * s,this.vertices[0].y * s);
      }
   }
}
