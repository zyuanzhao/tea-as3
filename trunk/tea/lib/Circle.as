package tea.lib{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import tea.lib.TMath;
	class Circle
	{
		public var position:Point;
		public var r:Number;
		public var border:Rectangle;
		public function Cirecle(_p:Point, _r:Number):void {
			position = _p;
			r = _r;
			border = new Rectangle(position.x - r, position.y - r, r * 2, r * 2);
		}
		public function hitCircle(c:Circle):Boolean {
			if (Point.distance(position, c.position) <= r + c.r) {
				return true;
			}
			return false;
		}
		public function hitPoint(p:Point):Boolean {
			if (Point.distance(position, p) <= r) {
				return true;
			}
			return false;
		}
		public function hitBorder(r:Rectangle):Boolean {
			return border.intersects(r);
		}
	}
}