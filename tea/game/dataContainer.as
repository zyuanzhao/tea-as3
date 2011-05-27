package tea.game {
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher
	import flash.utils.ByteArray;
	public class dataContainer extends EventDispatcher{
		private var PathList:Array;
		private var ul:URLLoader;
		private var currentPath:String;
		private var DataList:Array;
		private var loaded:uint;
		static public var share:dataContainer;
		
		static public function getInstance():dataContainer {
			if (share == null) {
				share = new dataContainer();
			}
			return share;
		}
		public function load(path):void {
			addLoad(path);
			sendEvent();
		}
		public function loadAll(paths):void {
			for (var path in paths) {
				//trace(paths[path], paths, path);
				addLoad(paths[path]);
			}
			sendEvent();
		}
		public function getData(key:String):ByteArray {
			return DataList[key];
		}
		
		public function dataContainer():void {
			PathList = [];
			DataList = [];
			loaded = 0;
			ul = new URLLoader();
			ul.dataFormat = URLLoaderDataFormat.BINARY;
			ul.addEventListener(Event.COMPLETE, onCompleteDo, false, 0, true);
			ul.addEventListener(IOErrorEvent.IO_ERROR, ioErrorDo);
		}
		private function ioErrorDo(e:IOErrorEvent):void 
		{
			trace('shit!', e, e.target);
		}
		private function addLoad(path:String):void {
			if (PathList.indexOf(path) >= 0) {
				return
			}
			PathList.push(path);
			if (loaded >= PathList.length-1) {
				currentPath = path;
				ul.load(new URLRequest(currentPath));
			}
		}
		private function onCompleteDo(e:Event):void {
			DataList[currentPath] = ByteArray(e.target.data);
			loaded++;
			if (loaded < PathList.length) {
				currentPath = PathList[loaded];
				ul.load(new URLRequest(currentPath));
			}
			sendEvent()
		}
		private function sendEvent():void {
			if (loaded == PathList.length) {
				share.dispatchEvent(new Event("allDone"));
			}
		}
	}
}