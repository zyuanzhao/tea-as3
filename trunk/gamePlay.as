package ActionScript{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import tea.game.world25d.Human;
	import tea.game.world25d.Map25d;
	import tea.game.world25d.World25d;
	import tea.lib.KeyboardInput;
	import tea.lib.Point3d;
	import tea.lib.TMath;
	
	
	public class gamePlay extends MovieClip {
		
		private var KB:KeyboardInput;
		private var world:World25d;
		private var player:Human;
		
		public function gamePlay() {
			addEventListener(Event.ADDED_TO_STAGE, ats);
		}

		private function ats(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, ats);
			stop();
			//
			y = 280;
			x = 20;
			KB = new KeyboardInput(stage);
			world = new World25d();
			world.init();
			var map1:Map25d = new Map25d();
			for (var i:int=0; i<tester.numChildren; i++) {
				if (getQualifiedClassName(tester.getChildAt(i))=="pointMaker") {
					tester.getChildAt(i).visible=false;
					map1.landPoint.push(new Point(tester.getChildAt(i).x,tester.getChildAt(i).y));
				}
			}
			map1.landPoint.sort(sortPoints); 
			map1.addArea(1,12,0,	0,0);//p1,p2,typr,z,lowZ,depth
			map1.addArea(2,7,1,		62,0);
			map1.addArea(3,9,0,		62,0);
			map1.addArea(4,10,0,	-22,-22);
			map1.addArea(6,13,2,	0,-22);
			map1.addArea(8, 14, 0,	-22, -22);
			map1.addArea(9,15,1,	40,-22);
			
			player = new Human();
			
			world.addMap(map1, new Point3d(map.x,map.y,0));
			world.addObj(player, map1, new Point3d(
				TMath.avg(map1.getP(0, 1).x, map1.getP(0, 4).x),0,
				TMath.avg(map1.getP(0, 1).y, map1.getP(0, 4).y) ));
			//
			
			addEventListener(Event.ENTER_FRAME, gameLoop, false, 0, true);
		}

		private function sortPoints(a,b):int {
			if (Math.abs(a.y-b.y)>4) {
				return a.y-b.y;
			} else {
				return a.x-b.x;
			}
		}
		
		private function gameLoop(e:Event):void {
			tempControl();
			world.phyLoop();
			render();
		}
		
		private function tempControl():void {
			if(player.touchGround>=0){
				if (KB.isDown['JUMP']) {
					player.speed.y = 16;
				}
				player.speed.x = KB.direct[0]*8;
				player.speed.z = KB.direct[1] * 3;
			}
		}

		private function render():void {
			tester.man.x = player.pos.x;
			tester.man.y = player.pos.z;
			
			mc_shadow.x = player.pos.x;
			mc_shadow.y = player.pos.z-player.bottomY;
			man.x = player.pos.x;
			man.y = player.pos.z - player.pos.y;
			
			tracer.text = player.pos.toString() +"\n" +
				player.speed.toString() +"\n" +
				player.att.toString() +"\n" +
				player.bottomLand + '__' + player.bottomY + "\n";
		}
	}

}