package core;

import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.Bytes;
import haxe.io.Error;

#if (neko || cpp || android || ios || eval)
import sys.net.Socket;
import sys.net.Host;
#end

class Network {
  public var MAX_DATA_SIZE: Int = 65535;
  public static var onConnect(default, default): Dynamic->Void;
  public static var onClose(default, default): Dynamic->Void;
  public var onMessage:Dynamic->Void;
  public var mainMessage:Dynamic->Void;
  public var connected: Bool;
  #if (js || html)
  private var _socket:js.html.WebSocket;
  #else
  private var _socket: Socket;
  #end
  private var ip:String;
  private var port:Int;
  private var url:String;
  #if (neko || cpp)
  private var host:Host;
  #end
  private var reconnectTimer:Timer;
  
  public var secure:Bool = false;
  
  public function new(ipString:String, portInt:Int,urlString:String="") 
  {
	ip = ipString;
	port = portInt;
	url = urlString;
	#if (neko || cpp || eval)
	try
	{
		host = new Host(ip);
	}catch (e:Dynamic)
	{
		trace("catch la hosters");
	}
	#end
  }


  
  public function connect() {
	 
	  
	 #if (html || js)
	 _socket = new js.html.WebSocket(url);
	_socket.onopen = function(_)
	{
		trace("connect");
		connected = true;
		if (onConnect != null) onConnect(null);
		
		_socket.onmessage = function(buff:Dynamic)
		{
			trace("message " + buff.data);
			var obj = Unserializer.run(buff.data);
			if (onMessage != null) onMessage(obj);
			if (mainMessage != null) mainMessage(obj);
		}
		_socket.onclose = function(){reconnect(); };
		_socket.onerror = function(){reconnect(); };
			
	}
	 #else
	 _socket = new Socket();
	 if (secure)
	 {
		//_socket.setCA(sys.ssl.Certificate.loadFile("assets/cert/cacert.pem"));
		//_socket.setCertificate( sys.ssl.Certificate.loadFile("assets/cert/fullchain.pem"), sys.ssl.Key.loadFile("assets/cert/cert.pem") );
		//var cert = _socket.peerCertificate();
		//Sys.println( "Server CN=" + cert.commonName );
	 }
    try {
      _socket.connect(host, port);
      _socket.setBlocking(false);
	  _socket.setFastSend(true);
      connected = true;
	  //tcp relay
	  _socket.output.writeString("9");
	  if(onConnect != null)onConnect(null);
    }
    catch (e: Dynamic) {
		reconnect();
		trace("close " + e);
    }
    #end

  }
  
  public function reconnect()
  {
	  if (reconnectTimer == null)
	  {
	  if (onClose != null) onClose(null);
	  reconnectTimer = new Timer(500);
	  connected = false;
	  reconnectTimer.run = function()
	  {
		  if (!connected)
		  {
		  //reconnect
		  close();
		  connect();
		  }else{
		  //finish
		  if (onConnect != null) onConnect(null);
		  reconnectTimer.stop();
		  reconnectTimer = null;
		  }
	  }
	  }
  }

  /**
   * Close the client or server socket.
   */
  public function close() {
    #if !(cpp || neko)
   // if (!_socket.connected) return;
    #end

    #if (!neko && cpp)
    //_socket.shutdown(true, true);
    #end
    _socket.close();
	connected = false;
	
  }
  
  public function update()
  {
	  read();
  }

  /**
   * Read a string from the socket buffer.
   * This is a blocking method.
   *
   * @return A string.
   */
  /*public function read() {
    #if !(neko || cpp)
    if(!connected || (_socket.connected && _socket.bytesAvailable == 0)) return null;
    if(!_socket.connected) throw 'Disconnected from server';
    #end
	try
	{
	var str = readString();
	if (str != "")
	{
	var obj = Unserializer.run(str);
	onMessage(obj);
	mainMessage(obj);
	}
	}catch (e:Dynamic)
	{
		
	}
  }*/
  
  public function read()
	{
		if (!connected) return;
		var buff:String = "";
		var obj:Dynamic = null;
		
		#if !html5
		try
		{
		buff = _socket.input.readUntil(0x0D);
		obj = Unserializer.run(buff);
		if (onMessage != null) onMessage(obj);
		if (mainMessage != null) mainMessage(obj);
	}catch (e:Dynamic)
	{
		// end of stream
    if (Std.is(e, haxe.io.Eof) || e == haxe.io.Eof)
    {
        // close the socket, etc.
		reconnect();
    }
    else if (e == haxe.io.Error.Blocked)
    {
        // not an error - this is still a connected socket.
        
    }
	}
	#end
	}
	
	

  /**
   * Write a string into the socket buffer.
   *
   * @param data String to write into the buffer.
   */
  public function write(data: String) {
    #if !(neko || cpp)
    if (_socket == null) return;
    //if (!connected || !_socket.connected) throw 'Connection not established.';
    #end

    writeString(data);
    flush();
  }
  
  public function send(obj:Dynamic)
  {
	  if (connected)
	  {
	  #if (neko || cpp)
	  _socket.output.writeString(Serializer.run(obj) + "\r");
	  #else
	  @:privateAccess _socket.send(Serializer.run(obj));
	 // _socket.writeUTF(Serializer.run(obj));
	 // _socket.flush();
	  #end
	  }
  }

  /**
   * Write raw bytes stored in a buffer. Only available in native targets.
   *
   * @param buffer Buffer to wrint onto the socket's buffer.
   * @param length Buffer data's length.
   * @param offset Buffer data's initial byte.
   */
  public function writeBytes(buffer: Bytes, length: Int, offset: Int = 0) {
    #if (neko || cpp)
    _socket.output.writeBytes(buffer, offset, length);
    flush();
    #else
    throw 'Method not available in non-native targets.';
    #end
  }

  /**
   * Create a human readable representation of the socket.
   *
   * @return A string that represents the socket.
   */
  /*public function toString(): String {
    try {
      #if (neko || cpp)
        var peer = _socket.peer();
        return '${peer.host}:${peer.port}';
      #else
      //return _socket.toString();
      #end
    }
    catch (e: Dynamic) {
      
      return '?:?';
    }
  }*/

  // Flush output content.
  private function flush() {
    #if (neko || cpp)
    _socket.output.flush();
    #else
    //_socket.flush();
    #end
  }

  // Write 2 bytes as an unsigned integer.
  private function writeUnsignedInt16(x: UInt) {
    #if (neko || cpp)
    _socket.output.writeByte((x >> 8) & 0xFF);
    _socket.output.writeByte(x & 0xFF);
    #else
    //_socket.writeByte((x >> 8) & 0xFF);
   // _socket.writeByte(x & 0xFF);
    #end
  }

  // Write a string (size + bytes).
  private function writeString(s: String) {
    if (s.length > MAX_DATA_SIZE)
      throw 'String data is too big - ${s.length} bytes (${MAX_DATA_SIZE} bytes max)';

    writeUnsignedInt16(s.length);

    #if (neko || cpp)
    _socket.output.writeString(s);
    #else
    _socket.send(s);
    #end
  }

  // Read 2 bytes as an unsigned integer.
  /*private function readUnsignedInt16(): UInt {
    #if (neko || cpp)
    var byte1: Int = _socket.input.readByte() & 0xFF;
    var byte2: Int = _socket.input.readByte() & 0xFF;
    #else
    //var byte1: Int = _socket.readByte() & 0xFF;
    //var byte2: Int = _socket.readByte() & 0xFF;
    #end

    return (byte1 << 8) | byte2;
  }*/

  // Read a string (size + bytes).
 /* private function readString(): String {
	  
	  
	try 
	{
    var len: UInt = readUnsignedInt16();
    #if (neko || cpp)
    return _socket.input.readString(len);
    #else
    return _socket.readUTFBytes(len);
    #end
	}catch (e:Dynamic)
	{
		return "";
	}
  }*/
}