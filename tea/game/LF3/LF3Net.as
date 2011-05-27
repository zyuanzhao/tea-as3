package tea.game.LF3 {
	import tea.lib.NetPlay;
	import flash.events.*;
	public class LF3Net extends NetPlay {
		static private var Shared:LF3Net;
		public function LF3Net() :void {
		}
		static public function shareNet():LF3Net {
			if (Shared==null) {
				Shared = new LF3Net();
				Shared.addEventListener("reg", Ereg);
				Shared.addEventListener("close", Eclose);
				Shared.addEventListener("get", Eget);
			}
			return Shared;
		}
		private function Ereg(e:Event) :void {
			trace(reData.toString());
		}
		private function Eclose(e:Event) :void {
			trace("close");
		}
		private function Eget(e:Event) :void {
			trace(reData.toString());
		}
	}
}