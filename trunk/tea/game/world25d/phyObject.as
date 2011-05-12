package tea.game.world25d {
	import tea.game.world25d.Map25d;
	import tea.lib.TMath;
	import tea.lib.Point3d;
	
	public class phyObject
	{
		public var pos:Point3d;
		public var speed:Point3d;
		public var att:Point3d;
		public var type:uint;
		
		public var mass:Number;//KG
		public var touchMap:Map25d;
		public var touchGround:int;
		public var bottomLand:int;
		public var bottomY:Number;
		
		public var moveSlope:Number;
		
		public function phyObject() {
			mass = 50;
			type = 0;//0box 1ball 2point
			pos = new Point3d();
			speed = new Point3d();
			att = new Point3d();
			bottomLand = -1;
			bottomY = 0;
			setSlope(70);
		}
		
		public function setSlope(arg1:Number):void {
			moveSlope = Math.tan(arg1 / 180 * Math.PI);
		}
		
		
		public function init(_pos:Point3d,_kg:Number ) {
			pos = _pos;
			mass = _kg;
		}
	}
	
}