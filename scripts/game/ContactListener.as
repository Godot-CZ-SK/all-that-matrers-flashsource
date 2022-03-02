package game
{
   import Box2D.Collision.b2Manifold;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2ContactImpulse;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Dynamics.b2Fixture;
   import managers.KM;
   import particle.P_Cloud;
   import particle.P_KeyMini;
   import particle.Particle;
   import particle.units.P_Unit;
   
   public class ContactListener extends b2ContactListener
   {
       
      
      public function ContactListener()
      {
         super();
      }
      
      override public function BeginContact(contact:b2Contact) : void
      {
         super.BeginContact(contact);
         var count:int = contact.GetManifold().m_pointCount;
         var b1:b2Body = contact.GetFixtureA().GetBody();
         var b2:b2Body = contact.GetFixtureB().GetBody();
         var p1:Particle = b1.GetUserData();
         var p2:Particle = b2.GetUserData();
         var d1:String = contact.GetFixtureA().GetUserData();
         var d2:String = contact.GetFixtureB().GetUserData();
         if(!p1 || !p2)
         {
            return;
         }
         var point:b2Vec2 = new b2Vec2(b1.GetPosition().x - b2.GetPosition().x,b1.GetPosition().y - b2.GetPosition().y);
         var angle:Number = Math.atan2(point.y,point.x);
         p1.preHit(p2,b2,-angle,d1,d2);
         p2.preHit(p1,b1,angle,d2,d1);
      }
      
      override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse) : void
      {
         var maxImpulse:Number = NaN;
         var maxImpId:int = 0;
         var i:int = 0;
         var point:b2Vec2 = null;
         var angle:Number = NaN;
         super.PostSolve(contact,impulse);
         var count:int = contact.GetManifold().m_pointCount;
         var f1:b2Fixture = contact.GetFixtureA();
         var f2:b2Fixture = contact.GetFixtureB();
         var b1:b2Body = f1.GetBody();
         var b2:b2Body = f2.GetBody();
         var p1:Particle = b1.GetUserData();
         var p2:Particle = b2.GetUserData();
         var d1:String = f1.GetUserData();
         var d2:String = f2.GetUserData();
         if(p1 && p2)
         {
            maxImpulse = 0;
            maxImpId = 0;
            for(i = 0; i < count; i++)
            {
               maxImpulse = Math.max(maxImpulse,Math.abs(impulse.normalImpulses[i]));
            }
            point = new b2Vec2(b1.GetPosition().x - b2.GetPosition().x,b1.GetPosition().y - b2.GetPosition().y);
            angle = Math.atan2(point.y,point.x);
            p1.postHit(p2,b2,-angle,maxImpulse,d1,d2);
            p2.postHit(p1,b1,angle,maxImpulse,d2,d1);
         }
      }
      
      override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold) : void
      {
         super.PreSolve(contact,oldManifold);
         var count:int = contact.GetManifold().m_pointCount;
         var f1:b2Fixture = contact.GetFixtureA();
         var f2:b2Fixture = contact.GetFixtureB();
         var b1:b2Body = f1.GetBody();
         var b2:b2Body = f2.GetBody();
         var p1:Particle = b1.GetUserData();
         var p2:Particle = b2.GetUserData();
         var d1:String = f1.GetUserData();
         var d2:String = f2.GetUserData();
         if(p1 && p2)
         {
            if(p1 is P_Cloud && p2 is P_Unit)
            {
               if((p2 as P_Unit).isTracked && (KM.ins.isDown(KM.DOWN) || KM.ins.isDown(KM.KEY_S)) || b2.GetPosition().y * Constants.SCALE + (p2 as P_Unit).data.radius * 0.8 > b1.GetPosition().y * Constants.SCALE - (p1 as P_Cloud).data.height / 2)
               {
                  contact.SetEnabled(false);
               }
            }
            else if(p1 is P_Unit && p2 is P_Cloud)
            {
               if((p1 as P_Unit).isTracked && (KM.ins.isDown(KM.DOWN) || KM.ins.isDown(KM.KEY_S)) || b1.GetPosition().y * Constants.SCALE + (p1 as P_Unit).data.radius * 0.8 > b2.GetPosition().y * Constants.SCALE - (p2 as P_Cloud).data.height / 2)
               {
                  contact.SetEnabled(false);
               }
            }
            else if(p1 is P_Cloud && p2 is P_KeyMini)
            {
               if(b2.GetPosition().y * Constants.SCALE + (p2 as P_KeyMini).data.radius * 0.8 > b1.GetPosition().y * Constants.SCALE - (p1 as P_Cloud).data.height / 2)
               {
                  contact.SetEnabled(false);
               }
            }
            else if(p1 is P_KeyMini && p2 is P_Cloud)
            {
               if(b1.GetPosition().y * Constants.SCALE + (p1 as P_KeyMini).data.radius * 0.8 > b2.GetPosition().y * Constants.SCALE - (p2 as P_Cloud).data.height / 2)
               {
                  contact.SetEnabled(false);
               }
            }
         }
      }
   }
}
