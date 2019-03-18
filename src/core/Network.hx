package core;

import openfl.utils.ByteArray;
import haxe.io.Eof;
import haxe.io.BytesBuffer;
import openfl.events.ProgressEvent;
import openfl.events.Event;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.Bytes;
import haxe.io.Error;

class Network {
  public var MAX_DATA_SIZE: Int = 65535;
  public static var onConnect(default, default): Dynamic->Void;
  public static var onClose(default, default): Dynamic->Void;
  public var onMessage:Dynamic->Void;
  public var mainMessage:Dynamic->Void;
  private var ip:String;
  private var port:Int;
  private var url:String;
  private var socket:openfl.net.Socket;
  
  public function new(ipString:String, portInt:Int,urlString:String="") 
  {
	  ip = ipString;
  	port = portInt;
	  url = urlString;
    socket = new openfl.net.Socket();
    #if (html || js)
    @:privateAccess socket.secure = true;
    #end
  }
  private function _removeEvents()
  {
    socket.removeEventListener(Event.CONNECT,_connect);
    socket.removeEventListener(Event.CLOSE,_close);
    socket.removeEventListener(ProgressEvent.SOCKET_DATA,_message);
  }
  private function _connect(_)
  {
    trace("connect");
    #if (neko || cpp || mobile)
    socket.writeUTFBytes("9");
    socket.flush();
    #end
    if(onConnect != null) onConnect(null);
  }
  private function _close(_)
  {
    trace("close");

  }
  // Read 2 bytes as an unsigned integer.
  private function readUnsignedInt16(): UInt 
  {
    var byte1: Int = socket.readByte() & 0xFF;
    var byte2: Int = socket.readByte() & 0xFF;
    return (byte1 << 8) | byte2;
  }
  private function _message(e:ProgressEvent)
  {
    if(socket.connected)
    {
      if(socket.bytesAvailable == 0) return;
    }else{
      throw 'Disconnected';
    }
    var data:Dynamic = null;
    try {
    data = Unserializer.run(readUntil(0x0D));
    }catch(e:Dynamic){
      trace("e " + e);
    }
    if(data != null)
    {
      if(onMessage != null) onMessage(data);
      if(mainMessage != null) mainMessage(data);
    }
  }
  public function readUntil( end : Int ) : String 
  {
		var buf = new BytesBuffer();
		var last : Int;
		while( (last = socket.readByte()) != end )
			buf.addByte( last );
		return buf.getBytes().toString();
  }
  public function connect() 
  {
    _removeEvents();
    socket.addEventListener(Event.CLOSE, _close);
    socket.addEventListener(Event.CONNECT, _connect);
    #if (neko || cpp || mobile)
    socket.addEventListener(ProgressEvent.SOCKET_DATA,_message);
    socket.connect(ip,port);
    #else
    @:privateAccess socket.__timestamp = Timer.stamp();
    @:privateAccess socket.__host = ip;
		@:privateAccess socket.__port = port;

		@:privateAccess socket.__output = new ByteArray();
		@:privateAccess socket.__output.endian = socket.__endian;
		@:privateAccess socket.__input = new ByteArray();
    @:privateAccess socket.__input.endian = socket.__endian;
    @:privateAccess socket.__socket = new js.html.WebSocket(url);
		@:privateAccess socket.__socket.binaryType = "arraybuffer";
		@:privateAccess socket.__socket.onopen = socket.socket_onOpen;
		@:privateAccess socket.__socket.onmessage = function(buff:Dynamic)
    {
      var data = Unserializer.run(buff.data);
      if(data != null)
      {
        if(onMessage != null) onMessage(data);
        if (mainMessage != null) mainMessage(data);
      }
    }
		@:privateAccess socket.__socket.onclose = socket.socket_onClose;
    @:privateAccess socket.__socket.onerror = socket.socket_onError;
    @:privateAccess openfl.Lib.current.addEventListener(Event.ENTER_FRAME, socket.this_onEnterFrame);
    #end
  }
  /**
   * send data
   */
  public function send(obj:Dynamic)
  {
      #if (js || html)
      @:privateAccess socket.__socket.send(Serializer.run(obj));
      #else
      socket.writeUTFBytes(Serializer.run(obj) + "\r");
      socket.flush();
      #end
  }
  public function update()
  {
    //_message(null);
  }
}