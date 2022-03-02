package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.b2Collision;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   
   use namespace b2internal;
   
   public class b2PolygonContact extends b2Contact
   {
       
      
      public function b2PolygonContact()
      {
         super();
      }
      
      public static function Create(allocator:*) : b2Contact
      {
         return new b2PolygonContact();
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
         b2Collision.CollidePolygons(m_manifold,m_fixtureA.GetShape() as b2PolygonShape,bA.m_xf,m_fixtureB.GetShape() as b2PolygonShape,bB.m_xf);
      }
   }
}
