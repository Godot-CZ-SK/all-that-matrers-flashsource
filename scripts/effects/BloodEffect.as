package effects
{
   import design.data.DO_BubbleData;
   import flash.display.Sprite;
   import game.GameCamera;
   
   public class BloodEffect extends UnitEffect
   {
       
      
      public function BloodEffect(x:Number, y:Number, effect:Number, duration:int)
      {
         super(x,y,effect,duration);
      }
      
      override public function create() : void
      {
         var bubble:DO_BubbleData = null;
         if(_isCreated)
         {
            return;
         }
         super.create();
         _life = _duration;
         _list = new Vector.<DO_BubbleData>();
         _costume = new Sprite();
         _costume.graphics.clear();
         GameCamera.ins.addChildTo(_costume,GameCamera.BLOOD);
         for(var i:int = 0; i < int(_effect * 5); i++)
         {
            bubble = new DO_BubbleData();
            bubble.startX = _x + Math.random() * _effect - _effect / 2;
            bubble.startY = _y + Math.random() * _effect - _effect / 2;
            bubble.curX = bubble.startX;
            bubble.curY = bubble.startY;
            bubble.radius = Math.random() * 2 + 2;
            bubble.speed = Math.random() * 3 + 1.5;
            if(Math.random() < 0.5)
            {
               bubble.angle = Math.PI / 4 * Math.random() - Math.PI / 8;
            }
            else
            {
               bubble.angle = Math.PI + Math.PI / 4 * Math.random() - Math.PI / 8;
            }
            _list.push(bubble);
            bubble.time = _duration / 2 + Math.random() * _duration / 2;
            bubble.current = 0;
         }
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         CF.removeDisplayObject(_costume);
         _list = new Vector.<DO_BubbleData>();
      }
      
      override public function update() : void
      {
         var bubble:DO_BubbleData = null;
         var alpha:Number = NaN;
         if(!_isCreated)
         {
            return;
         }
         --_life;
         if(_life == 0)
         {
            this.remove();
            return;
         }
         _costume.graphics.clear();
         for(var i:int = _list.length - 1; i >= 0; i--)
         {
            bubble = _list[i];
            ++bubble.current;
            alpha = 0.5 - bubble.current / bubble.time * 0.5;
            bubble.curX += bubble.speed * Math.cos(bubble.angle);
            bubble.curY += bubble.speed * Math.sin(bubble.angle) + bubble.current * 0.2;
            _costume.graphics.beginFill(13369344,alpha);
            _costume.graphics.drawCircle(bubble.curX,bubble.curY,bubble.radius);
            _costume.graphics.endFill();
            if(bubble.current >= bubble.time)
            {
               _list.splice(i,1);
            }
         }
      }
   }
}
