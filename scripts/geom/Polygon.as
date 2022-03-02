package geom
{
   public class Polygon
   {
       
      
      private var _nVertices:int;
      
      public var x:Array;
      
      public var y:Array;
      
      public function Polygon(_x:Array, _y:Array = null)
      {
         this.x = new Array();
         this.y = new Array();
         super();
         if(_y == null)
         {
            _y = _x.y;
            _x = _x.x;
         }
         this.nVertices = _x.length;
         for(var i:int = 0; i < this.nVertices; i++)
         {
            this.x[i] = _x[i];
            this.y[i] = _y[i];
         }
      }
      
      public function toString() : String
      {
         var result:String = "Poly: " + this._nVertices.toString() + " vertices.\n";
         for(var i:int = 0; i < this._nVertices; i++)
         {
            result += "(" + i.toString() + ") " + this.x[i].toString() + ", " + this.y[i].toString() + "\n";
         }
         return result;
      }
      
      public function set(p:Polygon) : void
      {
         this.nVertices = p.nVertices;
         this.x = new Array();
         this.y = new Array();
         for(var i:int = 0; i < this.nVertices; i++)
         {
            this.x[i] = p.x[i];
            this.y[i] = p.y[i];
         }
      }
      
      public function isConvex() : Boolean
      {
         var lower:int = 0;
         var middle:int = 0;
         var upper:int = 0;
         var dx0:Number = NaN;
         var dy0:Number = NaN;
         var dx1:Number = NaN;
         var dy1:Number = NaN;
         var cross:Number = NaN;
         var newIsP:Boolean = false;
         var isPositive:Boolean = false;
         for(var i:int = 0; i < this.nVertices; i++)
         {
            lower = i == 0 ? int(this.nVertices - 1) : int(i - 1);
            middle = i;
            upper = i == this.nVertices - 1 ? int(0) : int(i + 1);
            dx0 = this.x[middle] - this.x[lower];
            dy0 = this.y[middle] - this.y[lower];
            dx1 = this.x[upper] - this.x[middle];
            dy1 = this.y[upper] - this.y[middle];
            cross = dx0 * dy1 - dx1 * dy0;
            newIsP = cross >= 0 ? Boolean(true) : Boolean(false);
            if(i == 0)
            {
               isPositive = newIsP;
            }
            else if(isPositive != newIsP)
            {
               return false;
            }
         }
         return true;
      }
      
      public function add(t:Triangle) : Polygon
      {
         var firstP:int = -1;
         var firstT:int = -1;
         var secondP:int = -1;
         var secondT:int = -1;
         var i:int = 0;
         for(i = 0; i < this.nVertices; i++)
         {
            if(t.x[0] == this.x[i] && t.y[0] == this.y[i])
            {
               if(firstP == -1)
               {
                  firstP = i;
                  firstT = 0;
               }
               else
               {
                  secondP = i;
                  secondT = 0;
               }
            }
            else if(t.x[1] == this.x[i] && t.y[1] == this.y[i])
            {
               if(firstP == -1)
               {
                  firstP = i;
                  firstT = 1;
               }
               else
               {
                  secondP = i;
                  secondT = 1;
               }
            }
            else if(t.x[2] == this.x[i] && t.y[2] == this.y[i])
            {
               if(firstP == -1)
               {
                  firstP = i;
                  firstT = 2;
               }
               else
               {
                  secondP = i;
                  secondT = 2;
               }
            }
         }
         if(firstP == 0 && secondP == this.nVertices - 1)
         {
            firstP = this.nVertices - 1;
            secondP = 0;
         }
         if(secondP == -1)
         {
            return null;
         }
         var tipT:int = 0;
         if(tipT == firstT || tipT == secondT)
         {
            tipT = 1;
         }
         if(tipT == firstT || tipT == secondT)
         {
            tipT = 2;
         }
         var newx:Array = new Array();
         var newy:Array = new Array();
         var currOut:int = 0;
         for(i = 0; i < this.nVertices; i++)
         {
            newx[currOut] = this.x[i];
            newy[currOut] = this.y[i];
            if(i == firstP)
            {
               currOut++;
               newx[currOut] = t.x[tipT];
               newy[currOut] = t.y[tipT];
            }
            currOut++;
         }
         return new Polygon(newx,newy);
      }
      
      public function get nVertices() : int
      {
         return this._nVertices;
      }
      
      public function set nVertices(value:int) : void
      {
         this._nVertices = value;
      }
   }
}
