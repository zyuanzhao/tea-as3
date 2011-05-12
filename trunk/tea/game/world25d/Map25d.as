package tea.game.world25d{
	import flash.geom.Point;
	import tea.lib.Point3d;
	import tea.lib.TMath;
	public class Map25d {
		public var landPoint:Array;
		public var landList:Array;
		public var pos:Point3d;
		public var minBorderPoint:Point3d;
		public var maxBorderPoint:Point3d;
		
		public function Map25d() {
			minBorderPoint = new Point3d();
			maxBorderPoint = new Point3d();
			pos = new Point3d();
			landPoint=new Array();
			landList = new Array();
		}
		public function addArea(...args):void {
			var landObj = { p1:args[0], p2:args[1], type:args[2], Y:args[3],lowY:args[4] };
			if (args[5]) {
				landObj.depth=args[5];
			}else {
				landObj.depth = Infinity;
			}
			landList.push(landObj);
			//
			minBorderPoint.x = Math.min(minBorderPoint.x, landPoint[landObj.p1].x);
			maxBorderPoint.x = Math.max(maxBorderPoint.x, landPoint[landObj.p2].x);
			minBorderPoint.z = Math.min(minBorderPoint.z, landPoint[landObj.p1].y);
			maxBorderPoint.z = Math.max(maxBorderPoint.z, landPoint[landObj.p2].y);
			minBorderPoint.y = Math.min(minBorderPoint.y, landObj.Y);
			maxBorderPoint.y = Math.max(maxBorderPoint.y, landObj.lowY);
		}
		public function getP(area:uint, num:uint):Point {
			var p1 = landPoint[landList[area].p1];
			var p2 = landPoint[landList[area].p2];
			switch(num) {
				case 1:
					return p1;
					break;
				case 2:
					return new Point(p1.x,p2.y);
					break;
				case 3:
					return new Point(p2.x,p1.y);
					break;
				default:
					return p2
			}
		}
		
		public function lockCurrentLand(targetPoint:Point,land:uint,border:Number=0):Point{
			var _result=new Point(
				TMath.limit(targetPoint.x, getP(land, 1).x+border, getP(land, 4).x-border),
				TMath.limit(targetPoint.y, getP(land, 1).y + border, getP(land, 4).y - border));
			return _result;	
		}
		public function lockInMap(pt:Point3d):Point3d {
			return new Point3d(
				TMath.limit(pt.x, minBorderPoint.x, maxBorderPoint.x),
				TMath.limit(pt.y, minBorderPoint.y, maxBorderPoint.y),
				TMath.limit(pt.z, minBorderPoint.z, maxBorderPoint.z) );
		}

		public function findArea(pt:Point3d):int {
			for (var i:uint = 0; i < landList.length; i++) {
				if (pt.x >= getP(i, 1).x && pt.x <= getP(i, 4).x &&
					pt.z>=getP(i, 1).y && pt.z<=getP(i, 4).y) {
					return i;
				}
			}
			return -1;
		}
		public function findLandY(pt:Point3d, landNum:int):Number {
			if (landNum < 0) return pt.y;
			var land = landList[landNum];
			switch (land.type) {
				case 1 :
					return land.lowY+(land.Y-land.lowY)*
						((pt.x-landPoint[land.p1].x)/(landPoint[land.p2].x-landPoint[land.p1].x));
					break;
				case 2 :
					return land.lowY+(land.Y-land.lowY)*
						(1-(pt.x-landPoint[land.p1].x)/(landPoint[land.p2].x-landPoint[land.p1].x));
					break;
				default :
					return landList[landNum].Y;
			}
		}
		
		public function areaSlope(pos:Point3d=null,areaID:int=-2):Number {
			if (areaID == -2) {
				areaID = findArea(pos);
			}
			var land = landList[areaID];
			switch (land.type) {
				case 1 :
					return TMath.slope(new Point(land.p1.x,land.lowY),new Point(land.p2.x,land.Y));	
					break;
				case 2 :
					return TMath.slope(new Point(land.p1.x,land.Y),new Point(land.p2.x,land.lowY));
					break;
				default :
					return 0;
			}
		}
	}
}
