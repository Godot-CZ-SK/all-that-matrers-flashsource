package particle
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import com.greensock.TweenLite;
   import design.data.DO_SignData;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.GameCamera;
   import game.GameSound;
   import managers.PM;
   import managers.SM;
   import managers.TM;
   import particle.units.P_Unit;
   
   public class P_Sign extends Particle
   {
      
      public static const MAIN:String = "sign_main";
       
      
      protected var _data:DO_SignData;
      
      protected var _isShown:Boolean;
      
      protected var _tfCostume:MovieClip;
      
      protected var _textField:TextField;
      
      protected var _textFormat:TextFormat;
      
      protected var _showCounter:int;
      
      public function P_Sign(layerNo:int, data:DO_SignData)
      {
         this._data = data;
         super(layerNo);
      }
      
      override public function create() : void
      {
         if(_isCreated)
         {
            return;
         }
         super.create();
         var bdef:b2BodyDef = new b2BodyDef();
         bdef.type = b2Body.b2_staticBody;
         bdef.position = new b2Vec2(this._data.x / Constants.SCALE,this._data.y / Constants.SCALE);
         _body = PM.ins.world.CreateBody(bdef);
         _body.SetUserData(this);
         _body.SetAngle(this._data.rotation / 180 * Math.PI);
         var shape:b2PolygonShape = new b2PolygonShape();
         shape.SetAsOrientedBox(this._data.WIDTH * this._data.scale / 2 / Constants.SCALE,this._data.HEIGHT * this._data.scale / 2 / Constants.SCALE,new b2Vec2(0,-this._data.HEIGHT * this._data.scale / 2 / Constants.SCALE));
         var fix:b2Fixture = _body.CreateFixture2(shape,1);
         fix.SetUserData(MAIN);
         fix.SetSensor(true);
         _costume = new MC_Sign();
         _costume.x = this._data.x;
         _costume.y = this._data.y;
         _costume.scaleX = this._data.scale;
         _costume.scaleY = this._data.scale;
         _costume.rotation = this._data.rotation;
         GameCamera.ins.addChildTo(_costume,_layerNo);
      }
      
      override public function remove() : void
      {
         if(!_isCreated)
         {
            return;
         }
         super.remove();
         CF.removeDisplayObject(this._textField);
         CF.removeDisplayObject(this._tfCostume);
         this._textField = null;
         this._textFormat = null;
      }
      
      override public function update() : void
      {
         var b1:b2Body = null;
         var b2:b2Body = null;
         var f1:b2Fixture = null;
         var f2:b2Fixture = null;
         var p1:Particle = null;
         var p2:Particle = null;
         var d1:String = null;
         var d2:String = null;
         if(!_isCreated)
         {
            return;
         }
         super.update();
         if(!this._isShown)
         {
            if(this._showCounter > 0)
            {
               --this._showCounter;
               if(this._showCounter == 0)
               {
                  this.hideText();
               }
            }
         }
         var show:Boolean = false;
         for(var ce:b2ContactEdge = _body.GetContactList(); ce != null; ce = ce.next)
         {
            if(ce.contact.IsTouching())
            {
               b1 = ce.contact.GetFixtureA().GetBody();
               b2 = ce.contact.GetFixtureB().GetBody();
               f1 = ce.contact.GetFixtureA();
               f2 = ce.contact.GetFixtureB();
               p1 = b1.GetUserData() as Particle;
               p2 = b2.GetUserData() as Particle;
               d1 = f1.GetUserData() as String;
               d2 = f2.GetUserData() as String;
               if(p1 is P_Unit || p2 is P_Unit)
               {
                  show = true;
                  break;
               }
            }
         }
         if(show)
         {
            this.showText();
         }
         else
         {
            this._isShown = false;
         }
      }
      
      private function hideText() : void
      {
         if(this._isShown)
         {
            return;
         }
         TweenLite.to(this._tfCostume,0.25,{
            "x":this._data.x,
            "y":this._data.y - this._data.HEIGHT * this._data.scale,
            "scaleX":0,
            "scaleY":0,
            "alpha":0
         });
         TM.ins.tf(this.removeTF,0.25);
      }
      
      private function removeTF() : void
      {
         if(this._isShown)
         {
            return;
         }
         CF.removeDisplayObject(this._textField);
         CF.removeDisplayObject(this._tfCostume);
         this._textField = null;
         this._textFormat = null;
      }
      
      private function showText() : void
      {
         if(this._isShown || this._showCounter > 0)
         {
            this._showCounter = 30;
            return;
         }
         this._isShown = true;
         this._showCounter = 30;
         this._tfCostume = new MovieClip();
         this._tfCostume.graphics.beginFill(16777215,0.75);
         this._tfCostume.graphics.lineStyle(1.5,18432,1);
         this._tfCostume.graphics.drawRoundRect(0,0,this._data.tf_width,this._data.tf_height,5,5);
         this._tfCostume.graphics.endFill();
         this._textField = new TextField();
         this._textFormat = new TextFormat("calibri",this._data.textHeight,13056,true,null,null,null,null,TextFormatAlign.CENTER);
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.embedFonts = true;
         this._textField.selectable = false;
         this._textField.wordWrap = true;
         this._textField.multiline = true;
         this._textField.width = this._data.tf_width - 10;
         this._textField.height = this._data.tf_height - 10;
         this._textField.x = 5;
         this._textField.y = 5;
         this._textField.text = this._data.text;
         this._tfCostume.x = this._data.x;
         this._tfCostume.y = this._data.y - this._data.HEIGHT * this._data.scale;
         this._tfCostume.addChild(this._textField);
         GameCamera.ins.addChildTo(this._tfCostume,GameCamera.SIGN_TEXT);
         this._tfCostume.alpha = 0;
         this._tfCostume.scaleX = 0;
         this._tfCostume.scaleY = 0;
         TweenLite.to(this._tfCostume,0.25,{
            "x":this._data.x + this._data.tf_x,
            "y":this._data.y + this._data.tf_y,
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         SM.ins.playSound(GameSound.SIGN_OPEN);
      }
      
      public function get data() : DO_SignData
      {
         return this._data;
      }
   }
}
