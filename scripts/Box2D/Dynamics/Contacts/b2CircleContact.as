package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.b2Collision;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   
   use namespace b2internal;
   
   public class b2CircleContact extends b2Contact
   {
       
      
      public function b2CircleContact()
      {
         super();
      }
      
      public static function Create(allocator:*) : b2Contact
      {
         return new b2CircleContact();
      }
      
      public static function Destroy(contact:b2Contact, allocator:*) : void
      {
      }
      
      public function Reset(fixtureA:b2Fixture, fixtureB:b2Fixture) : void
      {
         super.Reset(fixtureA,fixtureB);
      }
      
      override b2internal function Evaluate() : void
      {
         var bA:b2Body = m_fixtureA.GetBody();
         var bB:b2Body = m_fixtureB.GetBody();
         b2Collision.CollideCircles(m_manifold,m_fixtureA.GetShape() as b2CircleShape,bA.m_xf,m_fixtureB.GetShape() as b2CircleShape,bB.m_xf);
      }
   }
}
