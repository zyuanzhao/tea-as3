package tea.lib {
	import flash.geom.Point;
	import tea.lib.TMath;
	public class Point3d {
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function Point3d(_x:Number=0,_y:Number=0,_z:Number=0):void {
			x = _x;
			y = _y;
			z = _z;
		}
		public function addPoint(obj:Point):Point3d {
			return new Point3d(x + obj.x, y + obj.y, z);
		}
		public function addPoint3d(obj:Point3d):Point3d {
			return new Point3d(this.x + obj.x, this.y + obj.y, this.z + obj.z);
		}
		public function avgPoint3d(obj:Point3d, rate:Number = 0.5):Point3d {
			return new Point3d(	x*rate + obj.x*(1-rate),
								y * rate + obj.y*(1-rate),
								z * rate + obj.z*(1-rate));
		}
		public function toString():String{
			return 'x:' + TMath.crop(x) + '	 y:' + TMath.crop(y) + '	 z:' + TMath.crop(z);
		}
		public function distance(pt:Point3d):Number {
			return Math.sqrt((x - pt.x) * (x - pt.x) + (y - pt.y) * (y - pt.y) + (z - pt.z) * (z - pt.z));
		}
		public function get to2d():Point {
			return new Point(this.x,this.y);
		}
		public function get to2dz():Point {
			return new Point(this.x,this.z);
		}
	}
	
}