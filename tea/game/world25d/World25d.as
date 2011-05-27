package  tea.game.world25d {
	
	import tea.game.world25d.phyObject;
	import tea.game.world25d.Human;
	import tea.lib.TMath;
	import tea.game.world25d.Map25d;
	import tea.lib.Point3d;
	import flash.geom.Point;
	
	public class World25d {
		private var mapList:Array;
		private var objList:Array;
		public var g:Number;
		public var minBorderPoint:Point3d;
		public var maxBorderPoint:Point3d;
		
		public function World25d() {
			minBorderPoint = new Point3d();
			maxBorderPoint = new Point3d();
			mapList = new Array();
			objList = new Array();
		}
		
		public function init():void {
			g = -0.4;
		}

		public function addMap(map:Map25d, _pt3d:Point3d):void {
			map.pos = _pt3d;
			mapList.push(map);
			minBorderPoint.x = Math.min(minBorderPoint.x, (map.minBorderPoint.x + map.pos.x));
			minBorderPoint.y = Math.min(minBorderPoint.y, (map.minBorderPoint.y + map.pos.y));
			minBorderPoint.z = Math.min(minBorderPoint.z, (map.minBorderPoint.z + map.pos.z));
			maxBorderPoint.x = Math.max(maxBorderPoint.x, (map.maxBorderPoint.x + map.pos.x));
			maxBorderPoint.y = Math.max(maxBorderPoint.y, (map.maxBorderPoint.y + map.pos.y));
			maxBorderPoint.z = Math.max(maxBorderPoint.z, (map.maxBorderPoint.z + map.pos.z));
		}
		
		public function addObj(_obj:phyObject,_map:Map25d,_pt3d:Point3d):void {
			objList.push(_obj);
			_obj.pos = _pt3d.addPoint3d(_map.pos);
		}
		
		private function lockInWorld(pt:Point3d):Point3d {
			return new Point3d(
				TMath.limit(pt.x, minBorderPoint.x, maxBorderPoint.x),
				TMath.limit(pt.y, minBorderPoint.y),
				TMath.limit(pt.z, minBorderPoint.z, maxBorderPoint.z) );
		}
		
		private function touchLand(_obj:phyObject, pt:Point3d,_map:Map25d):void {
			_obj.touchMap = _map;
			pt.y = _map.findLandY(pt, _map.findArea(pt));
			_obj.speed.y = 0;
			_obj.att.y = 0;
		}
		
		public function phyLoop():void {
			for (var objID:String in objList) {
				var obj:phyObject = objList[objID];
				obj.att.y += g;
				obj.speed=obj.speed.addPoint3d(obj.att);
				var nextPoint:Point3d = obj.pos.addPoint3d(obj.speed);
				nextPoint = lockInWorld(nextPoint);
				var phyMapList = [];
				for (var mapID in mapList) {
					//(mapList[mapID].lockInMap(obj.pos).distance(obj.pos), mapList[mapID].lockInMap(nextPoint).distance(obj.pos));
					
					if (mapList[mapID].lockInMap(obj.pos).distance(obj.pos) < 1 ||
						mapList[mapID].lockInMap(nextPoint).distance(obj.pos) < 1) {
						phyMapList.push(mapID);
					}
				}
				//trace(phyMapList)
				for (mapID in phyMapList) {
					var map:Map25d = mapList[phyMapList[mapID]];
					var currentLand:int = map.findArea(obj.pos);
					var nextLand:int = map.findArea(nextPoint);
					var nextY:Number = map.findLandY(nextPoint, nextLand);
					
					var upZ=obj.touchGround<=0?'0':Math.abs(Math.sin(Math.atan(obj.moveSlope)) * obj.speed.x);
					if (nextY > Math.max(obj.pos.y, nextPoint.y) + upZ) {
						//bug1:lock
						var np = map.lockCurrentLand(nextPoint.to2dz, currentLand, 1);
						nextPoint.x = np.x;
						nextPoint.z = np.y;
						nextY=map.findLandY(nextPoint, currentLand)
						nextPoint.y = Math.max(nextY, nextPoint.y);
					}else if (nextY > obj.pos.y - upZ && obj.speed.y <= 0) {
						//miss:walk speed on skew
						obj.touchGround = nextLand;
						nextPoint.y = map.findLandY(nextPoint, map.findArea(nextPoint));
					}
					
					if ((nextY < this.minBorderPoint.y && nextLand < 0) || ( nextPoint.y > nextY && nextPoint.y<nextY+map.landList[nextLand].depth)) {
						obj.touchGround = -1;
					}else {
						obj.touchGround = nextLand;
					}
					if (obj.touchGround >=0) {
						touchLand(obj, nextPoint, map);
					}else {
						
					}
					
					obj.bottomLand = map.findArea(nextPoint);
					obj.bottomY = map.findLandY(nextPoint, obj.bottomLand);
				}
				if (phyMapList.length==0) {
					
				}
				obj.pos = nextPoint;
			}
		}
		
	}
}
