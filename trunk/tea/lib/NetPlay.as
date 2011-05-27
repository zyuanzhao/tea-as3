/*
	NetPlay.shareNet();
	.connect(op,port);
	.addEventListener("get",abcde);
	.addEventListener("reg",abcde);
	.addEventListener("close",abcde);
	.send(bytes)
*/
package tea.lib{
	import flash.net.Socket;
	import flash.events.*;
	import flash.utils.ByteArray;
	public class NetPlay extends EventDispatcher{
		static private var Shared:NetPlay;
		private var S:Socket;
		private var ip:String;
		private var port:uint;
		public var reData:ByteArray;
		public var myid:uint;
		static public function shareNet():NetPlay {
			if (Shared==null) {
				Shared = new NetPlay();
			}
			return Shared;
		}
		public function connect(_ip:String, _port:uint) :void {
			S = new Socket();
			S.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			S.addEventListener(Event.CLOSE, closeHandler);
			S.addEventListener(Event.CONNECT, connectHandler);
			S.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			S.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			ip = _ip;
			port = _port;
			S.connect(ip, port);
		}
		private function callEvent(_state:String):void {
			Shared.dispatchEvent(new Event(_state));
		}
		public function NetPlay() {
			reData = new ByteArray();
		}
		public function send(b:ByteArray):void {
			S.writeBytes(b);
			S.flush();
		}
		private function socketDataHandler(event:ProgressEvent):void {
			//
			try {
				S.readBytes(reData, 0, S.bytesAvailable);
			}catch(e:Error) {
				try {
					trace('getData:',S.readUTFBytes(S.bytesAvailable))
				}catch(ee:Error) {
					trace('wtf',e)
				}
			}
			callEvent('get');
		}
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			callEvent('reg');
		}
		private function closeHandler(event:Event):void {
			callEvent('close');
			trace("closeHandler: " + event);
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			callEvent('close');
			trace("ioErrorHandler: " + event);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			callEvent('close');
			trace("securityErrorHandler: " + event);
		}
	}
}