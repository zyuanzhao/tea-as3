package tea.lib
{
    import flash.display.*;
    import flash.geom.*;

    public class line extends Object
    {
        public var p1:Object;
        public var p2:Point;
        public var myMC:Shape;

        public function line(param1:Point, param2:Point) : void
        {
            this.p1 = param1;
            this.p2 = param2;
            return;
        }

    }
}
