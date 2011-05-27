package tea.lib{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class BmpList{

		static private var shareObj:BmpList;
		public var bmpList:Array;
		private var doneNumber:uint;

		public function BmpList() {
			bmpList=new Array();
			doneNumber=0;
		}
		private function loadPhoto(path:String):void {
			var lr:Loader=new Loader();
			lr.contentLoaderInfo.addEventListener(Event.COMPLETE, finishPhoto, false, 0, true);
			lr.load(new URLRequest(path));
		}
		private function finishPhoto(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE,finishPhoto);
			bmpList[e.target.url.substr(5)]=e.target.content.bitmapData;
			doneNumber++;
			if (doneNumber==bmpLength) {
				this.dispatchEvent(new Event("load_all"));
			}
		}
		//
		static public function get shareBmpList():BmpList {
			if (! shareObj) {
				shareObj=new BmpList();
			}
			return shareObj;
		}
		public function addPhotos(arr:Array):void {
			for (var i:String in arr) {
				if (! bmpList[arr[i]]) {
					bmpList[arr[i]]="loading";
					loadPhoto(arr[i]);
				}
			}
		}
		public function updateList(arr:Array):void {
			var i:String;
			for (i in bmpList) {
				if (! arr[bmpList[i]]) {
					BitmapData(bmpList[i]).dispose();
					bmpList[i]=null;
				}
			}
			addPhotos(arr);
		}
		public function get finish():Boolean {
			return doneNumber==bmpLength;
		}
		public function get bmpLength():uint {
			var j:uint=0;
			for(var i:String in bmpList){
				j++
			}
			return j;
		}
	}

}