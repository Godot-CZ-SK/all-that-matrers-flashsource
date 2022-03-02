package design
{
   import design.data.DO_Data;
   import design.data.DO_PolyData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import geom.Line;
   import geom.LineIntersection;
   import geom.Triangle;
   import managers.KM;
   
   public class DO_Poly extends DesignObject
   {
      
      private static const LT:Number = 6;
       
      
      protected var _rectStartPos:Point;
      
      protected var _canAddVertex:Boolean;
      
      protected var _data:DO_PolyData;
      
      protected var _vertexSprites:Vector.<Sprite>;
      
      protected var _lineSprites:Vector.<Sprite>;
      
      protected var _drawVertices:Sprite;
      
      protected var _drawLines:Sprite;
      
      protected var _drawBody:Sprite;
      
      protected var _mask:Sprite;
      
      protected var _movingVertexNo:int;
      
      protected var _movingLineNo:int;
      
      protected var _movingPoint:Point;
      
      protected var _lastVertices:Vector.<Point>;
      
      protected var _rectDrawing:Boolean;
      
      public function DO_Poly(parent:DisplayObjectContainer, layerNo:int)
      {
         super(parent,layerNo);
         this._data.seed = Math.floor(Math.random() * 10000);
         this._vertexSprites = new Vector.<Sprite>();
         this._lineSprites = new Vector.<Sprite>();
         this._lastVertices = new Vector.<Point>();
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.rectMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.rectUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.vertexMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.vertexUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.drawClickHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_DOWN,this.drawDownHandler);
      }
      
      override public function startDrawing() : void
      {
         if(_isDrawing)
         {
            return;
         }
         super.startDrawing();
         this.drawFakeCostume();
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_DOWN,this.drawDownHandler,false,0,true);
      }
      
      override public function completeDrawing() : void
      {
         if(!_isDrawing)
         {
            return;
         }
         super.completeDrawing();
         drawRealCostume();
         this.removeFakeCostume();
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.rectMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.rectUpHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         Main.s.removeEventListener(MouseEvent.CLICK,this.drawClickHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_DOWN,this.drawDownHandler);
      }
      
      override public function clearData() : void
      {
         super.clearData();
         this._data.clear();
         this._vertexSprites = null;
         this._lineSprites = null;
         this._drawVertices = null;
         this._drawLines = null;
         this._drawBody = null;
         this._lastVertices = null;
      }
      
      override public function select() : void
      {
         if(_isSelected)
         {
            return;
         }
         super.select();
      }
      
      override public function unselect() : void
      {
         if(!_isSelected)
         {
            return;
         }
         super.unselect();
      }
      
      override public function addToMultipleSelection() : void
      {
         if(_isMultipleSelected)
         {
            return;
         }
         super.addToMultipleSelection();
      }
      
      override public function removeFromMultipleSelection() : void
      {
         if(!_isMultipleSelected)
         {
            return;
         }
         super.removeFromMultipleSelection();
      }
      
      override public function removeRealCostume() : void
      {
         CF.removeDisplayObject(_realCostume);
      }
      
      override public function drawFakeCostume() : void
      {
         super.drawFakeCostume();
         _fakeCostume = new MovieClip();
         this._drawVertices = new Sprite();
         this._drawLines = new Sprite();
         this._drawBody = new Sprite();
         _fakeCostume.addChild(this._drawBody);
         _fakeCostume.addChild(this._drawLines);
         _fakeCostume.addChild(this._drawVertices);
         this._drawBody.addEventListener(MouseEvent.MOUSE_DOWN,this.fakeBodyDownHandler,false,0,true);
         _costume.addChild(_fakeCostume);
         this.drawUpdate();
      }
      
      override public function removeFakeCostume() : void
      {
         super.removeFakeCostume();
         this.clearDraw();
         CF.removeDisplayObject(this._drawVertices);
         CF.removeDisplayObject(this._drawLines);
         CF.removeDisplayObject(_fakeCostume);
      }
      
      private function fakeBodyDownHandler(e:MouseEvent) : void
      {
         if(!_isCreated || _isMultipleSelected)
         {
            return;
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler,false,0,true);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / 5) * 5,Math.round(Main.s.mouseY / 5) * 5);
         this._lastVertices = new Vector.<Point>();
         for(var i:int = 0; i < this._data.vertices.length; i++)
         {
            this._lastVertices.push(this._data.vertices[i].clone());
         }
      }
      
      private function fakeBodyUpHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
         this._movingPoint = new Point();
         if(!this._canAddVertex && this._lastVertices.length)
         {
            for(i = 0; i < this._data.vertices.length; i++)
            {
               this._data.vertices[i].x = this._lastVertices[i].x;
               this._data.vertices[i].y = this._lastVertices[i].y;
            }
            this.drawUpdate();
         }
         this._lastVertices = new Vector.<Point>();
      }
      
      private function fakeBodyMoveHandler(e:MouseEvent) : void
      {
         var l1:Line = null;
         var l2:Line = null;
         if(_isMultipleSelected || !_isSelected)
         {
            Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.fakeBodyMoveHandler);
            Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.fakeBodyUpHandler);
            return;
         }
         var current:Point = new Point(Math.round(Main.s.mouseX / 5) * 5,Math.round(Main.s.mouseY / 5) * 5);
         var displacement:Point = new Point(this._movingPoint.x - current.x,this._movingPoint.y - current.y);
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < this._data.vertices.length; i++)
         {
            this._data.vertices[i].x = properX(this._lastVertices[i].x - displacement.x);
            this._data.vertices[i].y = properY(this._lastVertices[i].y - displacement.y);
         }
         this._canAddVertex = true;
         for(i = 0; i < this._data.vertices.length - 1; i++)
         {
            for(j = i + 1; j < this._data.vertices.length; j++)
            {
               l1 = new Line(this._data.vertices[i].x,this._data.vertices[i].y,this._data.vertices[i + 1].x,this._data.vertices[i + 1].y);
               l2 = new Line(this._data.vertices[j].x,this._data.vertices[j].y,this._data.vertices[(j + 1) % this._data.vertices.length].x,this._data.vertices[(j + 1) % this._data.vertices.length].y);
               if(LineIntersection.doesIntersect(l1,l2))
               {
                  this._canAddVertex = false;
                  this._lineSprites[i].graphics.clear();
                  this._lineSprites[i].graphics.lineStyle(13369344,1);
                  this._lineSprites[i].graphics.moveTo(this._data.vertices[i].x,this._data.vertices[i].y);
                  this._lineSprites[i].graphics.lineTo(this._data.vertices[i + 1].x,this._data.vertices[i + 1].y);
               }
            }
         }
         this.drawUpdate();
      }
      
      public function clearDraw() : void
      {
         this._lineSprites = new Vector.<Sprite>();
         this._vertexSprites = new Vector.<Sprite>();
      }
      
      override protected function drawUpdate() : void
      {
         var i:int = 0;
         var vs:Sprite = null;
         var ls:Sprite = null;
         if(this._data.vertices.length == 0)
         {
            return;
         }
         while(this._vertexSprites.length < this._data.vertices.length)
         {
            vs = new Sprite();
            vs.addEventListener(MouseEvent.MOUSE_DOWN,this.vertexDownHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OVER,this.vertexOverHandler,false,0,true);
            vs.addEventListener(MouseEvent.ROLL_OUT,this.vertexOutHandler,false,0,true);
            vs.graphics.beginFill(13369344,1);
            vs.graphics.lineStyle(1,13369344,1);
            vs.graphics.drawCircle(0,0,5);
            vs.graphics.endFill();
            this._vertexSprites.push(vs);
            this._drawVertices.addChild(vs);
         }
         while(this._lineSprites.length < this._data.vertices.length)
         {
            ls = new Sprite();
            ls.addEventListener(MouseEvent.MOUSE_DOWN,this.lineDownHandler,false,0,true);
            ls.addEventListener(MouseEvent.ROLL_OVER,this.lineOverHandler,false,0,true);
            ls.addEventListener(MouseEvent.ROLL_OUT,this.lineOutHandler,false,0,true);
            this._lineSprites.push(ls);
            this._drawLines.addChild(ls);
         }
         for(i = 0; i < this._data.vertices.length; i++)
         {
            this._vertexSprites[i].x = this._data.vertices[i].x;
            this._vertexSprites[i].y = this._data.vertices[i].y;
         }
         for(i = 0; i < this._data.vertices.length - 1; i++)
         {
            this._lineSprites[i].graphics.clear();
            this._lineSprites[i].graphics.lineStyle(LT,65280,1);
            this._lineSprites[i].graphics.moveTo(this._data.vertices[i].x,this._data.vertices[i].y);
            this._lineSprites[i].graphics.lineTo(this._data.vertices[i + 1].x,this._data.vertices[i + 1].y);
         }
         if(_isCreated && (!_isDrawing || this._rectDrawing))
         {
            i = this._data.vertices.length - 1;
            this._lineSprites[i].graphics.clear();
            this._lineSprites[i].graphics.lineStyle(LT,65280,1);
            this._lineSprites[i].graphics.moveTo(this._data.vertices[i].x,this._data.vertices[i].y);
            this._lineSprites[i].graphics.lineTo(this._data.vertices[0].x,this._data.vertices[0].y);
            this._drawBody.graphics.clear();
            this._drawBody.graphics.beginFill(9712407,0.5);
            this._drawBody.graphics.moveTo(this._data.vertices[0].x,this._data.vertices[0].y);
            for(i = 1; i < this._data.vertices.length; i++)
            {
               this._drawBody.graphics.lineTo(this._data.vertices[i].x,this._data.vertices[i].y);
            }
            this._drawBody.graphics.lineTo(this._data.vertices[0].x,this._data.vertices[0].y);
         }
      }
      
      private function lineDownHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         this._movingLineNo = this._lineSprites.indexOf(Sprite(e.currentTarget),0);
         this._movingPoint = new Point(Math.round(Main.s.mouseX / 5) * 5,Math.round(Main.s.mouseY / 5) * 5);
         if(KM.ins.isDown(KM.SHIFT))
         {
            this._data.vertices.push(new Point());
            for(i = this._data.vertices.length - 1; i > this._movingLineNo; i--)
            {
               this._data.vertices[i].x = this._data.vertices[(i - 1 + this._data.vertices.length) % this._data.vertices.length].x;
               this._data.vertices[i].y = this._data.vertices[(i - 1 + this._data.vertices.length) % this._data.vertices.length].y;
            }
            this._data.vertices[this._movingLineNo + 1].x = int((this._movingPoint.x - _parent.x) / 5) * 5;
            this._data.vertices[this._movingLineNo + 1].y = int((this._movingPoint.y - _parent.y) / 5) * 5;
            this.drawUpdate();
            return;
         }
         this._lastVertices = new Vector.<Point>();
         this._lastVertices.push(this._data.vertices[this._movingLineNo].clone());
         this._lastVertices.push(this._data.vertices[(this._movingLineNo + 1) % this._data.vertices.length].clone());
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler,false,0,true);
      }
      
      private function lineOverHandler(e:MouseEvent) : void
      {
      }
      
      private function lineOutHandler(e:MouseEvent) : void
      {
      }
      
      private function lineMoveHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         var iminus:int = 0;
         var l2:Line = null;
         var xpos:Number = Math.round(Main.s.mouseX / 5) * 5;
         var ypos:Number = Math.round(Main.s.mouseY / 5) * 5;
         var displacement:Point = new Point(this._movingPoint.x - xpos,this._movingPoint.y - ypos);
         var minus:int = (this._movingLineNo - 1 + this._data.vertices.length) % this._data.vertices.length;
         var plus:int = (this._movingLineNo + 1) % this._data.vertices.length;
         var plus1:int = (this._movingLineNo + 2) % this._data.vertices.length;
         this._data.vertices[this._movingLineNo].x = properX(this._lastVertices[0].x - displacement.x);
         this._data.vertices[this._movingLineNo].y = properY(this._lastVertices[0].y - displacement.y);
         this._data.vertices[plus].x = properX(this._lastVertices[1].x - displacement.x);
         this._data.vertices[plus].y = properY(this._lastVertices[1].y - displacement.y);
         this.drawUpdate();
         var l11:Line = new Line(this._data.vertices[minus].x,this._data.vertices[minus].y,this._data.vertices[this._movingLineNo].x,this._data.vertices[this._movingLineNo].y);
         var l12:Line = new Line(this._data.vertices[plus].x,this._data.vertices[plus].y,this._data.vertices[this._movingLineNo].x,this._data.vertices[this._movingLineNo].y);
         var l13:Line = new Line(this._data.vertices[plus].x,this._data.vertices[plus].y,this._data.vertices[plus1].x,this._data.vertices[plus1].y);
         this._canAddVertex = true;
         for(i = 0; i < this._data.vertices.length; i++)
         {
            iminus = (i - 1 + this._data.vertices.length) % this._data.vertices.length;
            if(!(i == plus || i == this._movingLineNo || i == plus1))
            {
               l2 = new Line(this._data.vertices[iminus].x,this._data.vertices[iminus].y,this._data.vertices[i].x,this._data.vertices[i].y);
               this._lineSprites[iminus].graphics.clear();
               if(LineIntersection.doesIntersect(l11,l2) || LineIntersection.doesIntersect(l12,l2) || LineIntersection.doesIntersect(l13,l2))
               {
                  this._canAddVertex = false;
                  this._lineSprites[iminus].graphics.lineStyle(LT,13369344,1);
               }
               else
               {
                  this._lineSprites[iminus].graphics.lineStyle(LT,65280,1);
               }
               this._lineSprites[iminus].graphics.moveTo(l2.x1,l2.y1);
               this._lineSprites[iminus].graphics.lineTo(l2.x2,l2.y2);
            }
         }
         if(LineIntersection.doesIntersect(l11,l13))
         {
            this._canAddVertex = false;
            this._lineSprites[plus].graphics.clear();
            this._lineSprites[plus].graphics.lineStyle(LT,13369344,1);
            this._lineSprites[plus].graphics.moveTo(l13.x1,l13.y1);
            this._lineSprites[plus].graphics.lineTo(l13.x2,l13.y2);
         }
      }
      
      private function lineUpHandler(e:MouseEvent) : void
      {
         var plus:int = (this._movingLineNo + 1) % this._data.vertices.length;
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.lineMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.lineUpHandler);
         if(!this._canAddVertex)
         {
            this._data.vertices[this._movingLineNo].x = this._lastVertices[0].x;
            this._data.vertices[this._movingLineNo].y = this._lastVertices[0].y;
            this._data.vertices[plus].x = this._lastVertices[1].x;
            this._data.vertices[plus].y = this._lastVertices[1].y;
            this.drawUpdate();
            return;
         }
         this._movingLineNo = -1;
      }
      
      private function vertexOverHandler(e:MouseEvent) : void
      {
      }
      
      private function vertexOutHandler(e:MouseEvent) : void
      {
      }
      
      private function vertexDownHandler(e:MouseEvent) : void
      {
         var d:int = 0;
         var m:int = 0;
         var u:int = 0;
         var tri:Triangle = null;
         var canRemove:Boolean = false;
         var i:int = 0;
         this._movingVertexNo = this._vertexSprites.indexOf(Sprite(e.currentTarget),0);
         if(KM.ins.isDown(KM.SHIFT))
         {
            if(this._data.vertices.length > 3)
            {
               d = (this._movingVertexNo - 1 + this._data.vertices.length) % this._data.vertices.length;
               m = this._movingVertexNo;
               u = (this._movingVertexNo + 1) % this._data.vertices.length;
               tri = new Triangle(this._data.vertices[d].x,this._data.vertices[d].y,this._data.vertices[m].x,this._data.vertices[m].y,this._data.vertices[u].x,this._data.vertices[u].y);
               canRemove = true;
               for(i = 0; i < this._data.vertices.length; i++)
               {
                  if(!(i == d || i == m || i == u))
                  {
                     if(tri.isInside(this._data.vertices[i].x,this._data.vertices[i].y))
                     {
                        canRemove = false;
                     }
                  }
               }
               if(!canRemove)
               {
                  return;
               }
               this._data.vertices.splice(this._movingVertexNo,1);
               CF.removeDisplayObject(this._vertexSprites.pop());
               CF.removeDisplayObject(this._lineSprites.pop());
               this.drawUpdate();
               return;
            }
         }
         Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.vertexMoveHandler,false,0,true);
         Main.s.addEventListener(MouseEvent.MOUSE_UP,this.vertexUpHandler,false,0,true);
         this._movingPoint = new Point(this._data.vertices[this._movingVertexNo].x,this._data.vertices[this._movingVertexNo].y);
      }
      
      private function vertexUpHandler(e:MouseEvent) : void
      {
         Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.vertexMoveHandler);
         Main.s.removeEventListener(MouseEvent.MOUSE_UP,this.vertexUpHandler);
         if(!this._canAddVertex)
         {
            this._data.vertices[this._movingVertexNo].x = this._movingPoint.x;
            this._data.vertices[this._movingVertexNo].y = this._movingPoint.y;
            this.drawUpdate();
         }
         this._movingVertexNo = -1;
      }
      
      private function vertexMoveHandler(e:MouseEvent) : void
      {
         var i:int = 0;
         var iminus:int = 0;
         var l2:Line = null;
         var xpos:Number = Math.round(_parent.mouseX / 5) * 5;
         var ypos:Number = Math.round(_parent.mouseY / 5) * 5;
         this._data.vertices[this._movingVertexNo].x = properX(xpos);
         this._data.vertices[this._movingVertexNo].y = properY(ypos);
         this.drawUpdate();
         var l11:Line = new Line(this._data.vertices[(this._movingVertexNo + 1) % this._data.vertices.length].x,this._data.vertices[(this._movingVertexNo + 1) % this._data.vertices.length].y,xpos,ypos);
         var l12:Line = new Line(xpos,ypos,this._data.vertices[(this._movingVertexNo - 1 + this._data.vertices.length) % this._data.vertices.length].x,this._data.vertices[(this._movingVertexNo - 1 + this._data.vertices.length) % this._data.vertices.length].y);
         this._canAddVertex = true;
         for(i = 0; i < this._data.vertices.length; i++)
         {
            iminus = (i - 1 + this._data.vertices.length) % this._data.vertices.length;
            if(!(i == this._movingVertexNo || i == (this._movingVertexNo + 1) % this._data.vertices.length))
            {
               l2 = new Line(this._data.vertices[iminus].x,this._data.vertices[iminus].y,this._data.vertices[i].x,this._data.vertices[i].y);
               this._lineSprites[iminus].graphics.clear();
               if(LineIntersection.doesIntersect(l11,l12) || LineIntersection.doesIntersect(l11,l2) || LineIntersection.doesIntersect(l12,l2))
               {
                  this._canAddVertex = false;
                  this._lineSprites[iminus].graphics.lineStyle(LT,13369344,1);
               }
               else
               {
                  this._lineSprites[iminus].graphics.lineStyle(LT,65280,1);
               }
               this._lineSprites[iminus].graphics.moveTo(l2.x1,l2.y1);
               this._lineSprites[iminus].graphics.lineTo(l2.x2,l2.y2);
            }
         }
      }
      
      override public function addPosition(posX:Number, posY:Number) : void
      {
         super.addPosition(posX,posY);
         for(var i:int = 0; i < this._data.vertices.length; i++)
         {
            this._data.vertices[i].x += posX * 10;
            this._data.vertices[i].y += posY * 10;
         }
         this.drawUpdate();
      }
      
      private function drawDownHandler(e:MouseEvent) : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         if(!KM.ins.isDown(KM.CTRL))
         {
            Main.s.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
            Main.s.removeEventListener(MouseEvent.MOUSE_DOWN,this.drawDownHandler);
            Main.s.addEventListener(MouseEvent.MOUSE_MOVE,this.rectMoveHandler,false,0,true);
            Main.s.addEventListener(MouseEvent.MOUSE_UP,this.rectUpHandler,false,0,true);
            xpos = properX(Math.round(_parent.mouseX / 5) * 5);
            ypos = properY(Math.round(_parent.mouseY / 5) * 5);
            this._rectStartPos = new Point(xpos,ypos);
            this._data.vertices.push(this._rectStartPos.clone(),new Point(this._rectStartPos.x + 15,this._rectStartPos.y),new Point(this._rectStartPos.x + 15,this._rectStartPos.y + 15),new Point(this._rectStartPos.x,this._rectStartPos.y + 15));
            this._rectDrawing = true;
         }
         else
         {
            Main.s.removeEventListener(MouseEvent.MOUSE_DOWN,this.drawDownHandler);
            Main.s.addEventListener(MouseEvent.CLICK,this.drawClickHandler);
            this._rectDrawing = false;
         }
      }
      
      private function rectUpHandler(e:MouseEvent) : void
      {
         this.completeDrawing();
      }
      
      private function rectMoveHandler(e:MouseEvent) : void
      {
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         var width:Number = this._rectStartPos.x - xpos;
         var height:Number = this._rectStartPos.y - ypos;
         if(width < 0)
         {
            width = Math.min(-15,width);
         }
         else
         {
            width = Math.max(15,width);
         }
         if(height < 0)
         {
            height = Math.min(-15,height);
         }
         else
         {
            height = Math.max(15,height);
         }
         this._data.vertices[1].x = this._rectStartPos.x - width;
         this._data.vertices[2].x = this._rectStartPos.x - width;
         this._data.vertices[2].y = this._rectStartPos.y - height;
         this._data.vertices[3].y = this._rectStartPos.y - height;
         this.drawUpdate();
      }
      
      private function drawClickHandler(e:MouseEvent) : void
      {
         if(!this._canAddVertex)
         {
            return;
         }
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         if(this._data.vertices.length > 2)
         {
            if(Math.abs(this._data.vertices[0].x - xpos) <= 10 && Math.abs(this._data.vertices[0].y - ypos) <= 10)
            {
               xpos = this._data.vertices[0].x;
               ypos = this._data.vertices[0].y;
            }
         }
         if(this._data.vertices.length > 0 && xpos == this._data.vertices[0].x && ypos == this._data.vertices[0].y)
         {
            if(this._data.vertices.length > 2)
            {
               this.completeDrawing();
            }
            return;
         }
         this._data.vertices.push(new Point(xpos,ypos));
         this.drawUpdate();
      }
      
      private function moveHandler(e:MouseEvent) : void
      {
         var l1:Line = null;
         var l2:Line = null;
         var i:int = 0;
         var xpos:Number = properX(Math.round(_parent.mouseX / 5) * 5);
         var ypos:Number = properY(Math.round(_parent.mouseY / 5) * 5);
         if(this._data.vertices.length > 2)
         {
            if(Math.abs(this._data.vertices[0].x - xpos) <= 10 && Math.abs(this._data.vertices[0].y - ypos) <= 10)
            {
               xpos = this._data.vertices[0].x;
               ypos = this._data.vertices[0].y;
            }
         }
         this._canAddVertex = true;
         if(_isDrawing)
         {
            _fakeCostume.graphics.clear();
            if(this._data.vertices.length > 0)
            {
               l1 = new Line(this._data.vertices[this._data.vertices.length - 1].x,this._data.vertices[this._data.vertices.length - 1].y,xpos,ypos);
               for(i = 1; i < this._data.vertices.length; i++)
               {
                  this._lineSprites[i - 1].graphics.clear();
                  l2 = new Line(this._data.vertices[i - 1].x,this._data.vertices[i - 1].y,this._data.vertices[i].x,this._data.vertices[i].y);
                  if(this._data.vertices[i].x == xpos && this._data.vertices[i].y == ypos || LineIntersection.doesIntersect(l1,l2))
                  {
                     this._canAddVertex = false;
                     this._lineSprites[i - 1].graphics.lineStyle(LT,13369344,1);
                  }
                  else
                  {
                     this._lineSprites[i - 1].graphics.lineStyle(LT,65280,1);
                  }
                  this._lineSprites[i - 1].graphics.moveTo(l2.x1,l2.y1);
                  this._lineSprites[i - 1].graphics.lineTo(l2.x2,l2.y2);
               }
               if(this._canAddVertex)
               {
                  _fakeCostume.graphics.lineStyle(2,65280,1);
               }
               else
               {
                  _fakeCostume.graphics.lineStyle(2,13369344,1);
               }
               _fakeCostume.graphics.moveTo(this._data.vertices[this._data.vertices.length - 1].x,this._data.vertices[this._data.vertices.length - 1].y);
               _fakeCostume.graphics.lineTo(xpos,ypos);
            }
            _fakeCostume.graphics.lineStyle(2,13369344,1);
            _fakeCostume.graphics.beginFill(13369344,0.5);
            _fakeCostume.graphics.drawCircle(xpos,ypos,5);
            _fakeCostume.graphics.endFill();
         }
      }
      
      override public function getData() : DO_Data
      {
         return this._data;
      }
      
      override public function setData(data:DO_Data) : void
      {
         this._data = data as DO_PolyData;
         drawRealCostume();
         super.setData(data);
      }
      
      override public function doesItIntersect(r:Rectangle) : Boolean
      {
         var i:int = 0;
         var j:int = 0;
         if(!_isCreated)
         {
            return false;
         }
         if(this._data.vertices.length < 3)
         {
            return false;
         }
         var lines:Vector.<Line> = this._data.getLines();
         var rectLines:Vector.<Line> = new Vector.<Line>();
         var l1:Line = new Line(r.x,r.y,r.x + r.width,r.y);
         var l2:Line = new Line(r.x + r.width,r.y,r.x + r.width,r.y + r.height);
         var l3:Line = new Line(r.x + r.width,r.y + r.height,r.x,r.y + r.height);
         var l4:Line = new Line(r.x,r.y + r.height,r.x,r.y);
         rectLines.push(l1,l2,l3,l4);
         for(i = 0; i < rectLines.length; i++)
         {
            for(j = 0; j < lines.length; j++)
            {
               if(LineIntersection.doesIntersect(rectLines[i],lines[j]))
               {
                  return true;
               }
            }
         }
         for(i = 0; i < this._data.vertices.length; i++)
         {
            if(r.contains(this._data.vertices[i].x,this._data.vertices[i].y))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function getHitArea() : Rectangle
      {
         if(!_isCreated)
         {
            return null;
         }
         var t:Number = this._data.vertices[0].y;
         var b:Number = this._data.vertices[0].y;
         var l:Number = this._data.vertices[0].x;
         var r:Number = this._data.vertices[0].x;
         for(var i:int = 0; i < this._data.vertices.length; i++)
         {
            if(this._data.vertices[i].x < l)
            {
               l = this._data.vertices[i].x;
            }
            if(this._data.vertices[i].x > r)
            {
               r = this._data.vertices[i].x;
            }
            if(this._data.vertices[i].y < t)
            {
               t = this._data.vertices[i].y;
            }
            if(this._data.vertices[i].y > b)
            {
               b = this._data.vertices[i].y;
            }
         }
         return new Rectangle(l,t,r - l,b - t);
      }
      
      override public function startMoving() : void
      {
         if(_isMoving)
         {
            return;
         }
         this._lastVertices = new Vector.<Point>();
         for(var i:int = 0; i < this._data.vertices.length; i++)
         {
            this._lastVertices.push(new Point(this._data.vertices[i].x,this._data.vertices[i].y));
         }
         super.startMoving();
      }
      
      override public function moveBy(xpos:Number, ypos:Number) : void
      {
         var l1:Line = null;
         var l2:Line = null;
         if(!_isMoving)
         {
            return;
         }
         var displacement:Point = new Point(Math.round(xpos / G_INTERVAL) * G_INTERVAL,Math.round(ypos / G_INTERVAL) * G_INTERVAL);
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < this._data.vertices.length; i++)
         {
            this._data.vertices[i].x = properX(this._lastVertices[i].x - displacement.x);
            this._data.vertices[i].y = properY(this._lastVertices[i].y - displacement.y);
         }
         this._canAddVertex = true;
         for(i = 0; i < this._data.vertices.length - 1; i++)
         {
            for(j = i + 1; j < this._data.vertices.length; j++)
            {
               l1 = new Line(this._data.vertices[i].x,this._data.vertices[i].y,this._data.vertices[i + 1].x,this._data.vertices[i + 1].y);
               l2 = new Line(this._data.vertices[j].x,this._data.vertices[j].y,this._data.vertices[(j + 1) % this._data.vertices.length].x,this._data.vertices[(j + 1) % this._data.vertices.length].y);
               if(LineIntersection.doesIntersect(l1,l2))
               {
                  this._canAddVertex = false;
               }
            }
         }
         this.drawUpdate();
         super.moveBy(xpos,ypos);
      }
      
      override public function endMoving() : void
      {
         var i:int = 0;
         if(!_isMoving)
         {
            return;
         }
         this._movingPoint = new Point();
         if(!this._canAddVertex && this._lastVertices.length)
         {
            for(i = 0; i < this._data.vertices.length; i++)
            {
               this._data.vertices[i].x = this._lastVertices[i].x;
               this._data.vertices[i].y = this._lastVertices[i].y;
            }
            this.drawUpdate();
         }
         this._lastVertices = new Vector.<Point>();
         super.endMoving();
      }
   }
}
