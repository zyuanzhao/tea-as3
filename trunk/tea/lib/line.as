package tea.lib{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import tea.lib.TMath;
	public class Line
	{
		public var p1:Point;
		public var p2:Point;
		public var c:Number;
		public var m:Number;
		public var length:Number;
		public var border:Rectangle;
		public var mid:Point;
		public function Line(_p1:Point, _p2:Point):void {
			p1 = _p1;
			p2 = _p2;
			change();
		}
		public function move(_x, _y):void {
			p1.offset(_x, _y);
			p2.offset(_x, _y);
		}
		public function clone():Line {
			return new Line(p1, p2);
		}
		public function getPoint(rate:Number):Point {
			rate = TMath.limit(rate, 0, 1);
			return new Point(p1.x + (p2.x - p1.x) * rate, p1.y + (p2.y - p1.y) * rate);
		}
		public function toString():String {
			return p1.toString() +','+ p2.toString();
		}
		//hittest point,line,box,circle
		public function hitPoint(p:Point):Number {
			if (!border.containsPoint(p)) {
				return -1;
			}
			var tempLine:Line = new Line(p1, p);
			if (TMath.similar(tempLine.m, m) && TMath.similar(tempLine.c, c)) {
				if (m != 0 && tempLine.m != 0) {
					return (p.y - p1.y) / (p2.y - p1.y);
					if (Math.abs(m) != Infinity && Math.abs(tempLine.m) != Infinity) {
						return (p.x - p1.x) / (p2.x - p1.x);
					}
				}
				return (p.x - p1.x) / (p2.x - p1.x);
			}
			return -2;
		}
		public function hitBorder(r:Rectangle):Boolean {
			return r.intersects(border)
		}
		public function hitRectangle(r:Rectangle):Boolean {
			if (hitBorder(r) || r.containsPoint(p1) || r.containsPoint(p2) ) {
				return true;
			}
			for (var i:uint = 0; i < 3; i++) {
				if (hitLine(Line.rectLine(r, i))) {
					return true;
				}
			} 
			return false
		}
		public function hitRectanglePoint(r:Rectangle):Point {
			if (!hitRectangle(r)) {
				return null;
			}
			var _p1, _p2:Point;
			if (r.containsPoint(p1)) {
				_p1 = p1;
			}
			if (r.containsPoint(p2)) {
				_p2 = p2;
				if (_p1 != null) {
					return new Point((_p1.x+_p2.x)/2,(_p1.y+_p2.y)/2);
				}
			}
			for (var i:uint = 0; i <= 3 && (_p1 == null || _p2 == null); i++) {
				if (hitLine(Line.rectLine(r, i))) {
					if (_p1 == null) {
						_p1 = hitLine(Line.rectLine(r, i));
					}else {
						_p2 = hitLine(Line.rectLine(r, i));
					}
				}
			} 
			if (_p1 == null || _p2 == null) {
				return null
			}
			return new Point((_p1.x+_p2.x)/2,(_p1.y+_p2.y)/2);
		}
		public function hitLine(l:Line):Point {
			if (!hitBorder(l.border)) {
				return null;
			}
			var tx:Number;
			if (m == Infinity || m == -Infinity){
				tx = p1.x;
			}else if (l.m == Infinity || l.m == -Infinity){
				tx = l.p1.x;
			}else {
				tx = (l.c - c) / (m - l.m);
			}
			var cp:Point = new Point(tx, m * tx + c);
			if (m == 0){
				cp.y = p1.y;
			}else if (l.m == 0) {
				cp.y = l.p1.y;
			}
			if (hitPoint(cp)>=0 && l.hitPoint(cp)>=0) {
				return cp;
			}
			return null;
		}
		//
		static public function rectLine(r:Rectangle,num:uint):Line {
			var l:Line;
			switch(num) {
				case 0:
					l = new Line(new Point(r.x,r.y),new Point(r.x+r.width,r.y));
					break;
				case 1:
					l = new Line(new Point(r.x+r.width,r.y),new Point(r.x+r.width,r.y+r.height));
					break;
				case 2:
					l = new Line(new Point(r.x,r.y+r.height),new Point(r.x+r.width,r.y+r.height));
					break;
				default:
					l = new Line(new Point(r.x,r.y),new Point(r.x,r.y+r.height));
					break;
			}
			return l;
		}
		//
		private function change():void {
			m = TMath.slope(p1, p2);
			c = p1.y - m * p1.x;
			length = Point.distance(p1, p2);
			border = new Rectangle(Math.min(p1.x, p2.x), Math.min(p1.y, p2.y), Math.abs(p1.x - p2.x), Math.abs(p1.y - p2.y));
			//if (border.width == 0) {
				border.width += 1
				border.x-=0.5
			//}
			//if (border.height == 0) {
				border.height += 1
				border.y-=0.5
			//}
			mid = getPoint(0.5);
		}
	}
}