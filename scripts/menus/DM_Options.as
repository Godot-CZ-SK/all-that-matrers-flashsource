package menus
{
   import flash.geom.Point;
   
   public class DM_Options
   {
       
      
      public var objects_pos:Point;
      
      public var units_pos:Point;
      
      public var visuals_pos:Point;
      
      public var enemies_pos:Point;
      
      public var map_pos:Point;
      
      public var map_size:Point;
      
      public var info_pos:Point;
      
      public function DM_Options()
      {
         super();
         this.objects_pos = new Point(DesignMenu.MENU_WIDTH - 120,20);
         this.enemies_pos = new Point(DesignMenu.MENU_WIDTH - 120,20);
         this.visuals_pos = new Point(DesignMenu.MENU_WIDTH - 120,20);
         this.units_pos = new Point(DesignMenu.MENU_WIDTH - 120,20);
         this.map_pos = new Point(0,20);
         this.map_size = new Point(80,80);
         this.info_pos = new Point(DesignMenu.MENU_WIDTH - 120,20);
      }
   }
}
