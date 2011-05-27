package tea.lib{
	import flash.net.Socket;
	import flash.events.*;
	import flash.utils.ByteArray;
	public class NetPlay {
		static private var Shared:NetPlay;
		private var S:Socket;
		private var ip:String;
		private var port:uint;
		private var reData:ByteArray;

		public function shareNet():NetPlay {
			if (!Shared) {
				Shared = new netPlay();
			}
			return Shared
		}
		public function connect(_ip:String = ip, _port:uint = port) :void {
			ip = _ip;
			port = _port;
			S.connect(ip, port);
		}
		public function NetPlay() {
			S = new Socket();
			S.addEventListener(Event.CLOSE, closeHandler);
			S.addEventListener(Event.CONNECT, connectHandler);
			S.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			S.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			S.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			S.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		private function socketDataHandler(event:ProgressEvent):void {
			trace("getDate: " + event);
			S.readBytes(reData,0,S.bytesAvailable);
		}
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
		}
		function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
	}
}