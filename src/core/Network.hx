package core;

import haxe.io.Eof;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.Bytes;
import haxe.io.Error;
#if (js || html)
import js.html.WebSocket as Socket;
#else
import sys.net.Socket;
#end

class Network {
  public static var onConnect(default, default): Void->Void;
  public static var onClose(default, default): Void->Void;
  public var onMessage:Dynamic->Void;
  public var mainMessage:Dynamic->Void;
  #if (cpp || neko)
  var host:sys.net.Host;
  #end
  var port:Int;
  var url:String;
  var connected:Bool = false;
  var closed:Bool = true;
  var MAX_DATA_SIZE: Int = 65535;
  private var socket:Socket;
  
  public function new(ipString:String, portInt:Int,urlString:String="") 
  {
  	port = portInt;
	  url = urlString;
    socket = new Socket();

    #if (cpp || neko)
    try {
      host = new sys.net.Host(ipString);
    }catch(e:Dynamic)
    {
      trace("unacccepted host");
    }
    #end
  }
  private function _connect(_)
  {
    connected = true;
    //write
    #if (cpp || neko)
    write("9");
    #end
    //connect
    if (onConnect != null) onConnect();
  }
  private function _close(_)
  {
    closed = true;
    connected = false;
    socket.close();
    //close
    if(onClose != null) onClose();
  }

  public function connect() 
  {
    #if (js || html)
    socket = new Socket(url);
    socket.onopen = _connect;
    socket.onclose = _close;
    socket.onmessage = _message;
    #else
    try { 
      socket.connect(host,port);
      socket.setBlocking(false);
      socket.setFastSend(true);
      closed = false;
    }catch(e:Dynamic) {
      trace("connect error " + e);
    }
    #end
  }
  private function cleanSocket()
  {
    #if (cpp || neko)
    try {
      socket.close();
    }catch (e:Dynamic) {}
    socket = null;
    connected = false;
    closed = true;
    #end
  }
  public function reConnect()
  {
    cleanSocket();
    socket = new Socket();
    connect();
  }
  #if (js || html)
  public function _message(buffer:Dynamic)
  {

  }
  #end
  public function send(obj:Dynamic)
  {
    #if (js || html)
    write(Serializer.run(obj));
    #else
    write(Serializer.run(obj) + "\r");
    #end
  }
  private function write(string:String)
  {
    try {
      #if (js || html)
      socket.send(string);
      #else 
      socket.output.writeString(string);
      #end
    }catch(e:Dynamic)
    {
      _close(null);
    }
  }
  public function update()
  {
    #if (neko || cpp)
    //trace("co " + connected + " cl " + closed);
    if(!connected)
    {
      if(!closed)
      {
        var r = Socket.select(null,[socket],null,0);
        if(r.write[0] == socket) _connect(null);
      }
    }else{
      try {
      var obj = Unserializer.run(socket.input.readUntil(0x0D));
      if (onMessage != null) onMessage(obj);
      if (mainMessage != null) mainMessage(obj);
      }catch(e:Dynamic)
      {
        if(e == haxe.io.Eof)
        {
          _close(null);
        }
      }
    }
    #end 
  }
}