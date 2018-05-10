package core;

import haxe.Serializer;
#if html5
import js.html.WebSocket;
#else
import sys.net.Socket;
import sys.net.Host;
#end
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.Bytes;
import haxe.io.Eof;
import haxe.io.Error;
/**
 * ...
 * @author 
 */
class Network 
{
	#if html5
	/**
	 * web socket
	 */
	public var ws:WebSocket;
	#else
	public var socket:Socket;
	#end
	public var secure:Bool = false;
	private var ip:String = "localhost";
	private var port:Int = 9696;
	public var connected:Bool = false;
	public var wait:Int = -1;
	
	/**
	 * onClose function 
	 */
	public var onClose:()->Void;
	/**
	 * OnMessage function
	 */
	public var onMessage(default, default):Dynamic->Void;
	/**
	 * main
	 */
public var mainMessage(default, default):Dynamic->Void;
/** Callback used called when a connection is established. This callback should not be handled manually. **/
 public var onConnect:()->Void;
  
/**
 * Setup networking
 */
	public function new(ipString:String,portInt:Int,blockSameMessage:Bool=true) 
	{
		ip = ipString;
		port = portInt;
		
		#if html5
		var param:String = "ws";
		if (secure) param = "wss";
		ws = new WebSocket(param + "://" + ip + ":" + Std.string(port));
		connected = true;
		ws.onopen = function()
		{
			if(onConnect != null && !connected)onConnect();
			connected = true;
		}
		ws.onmessage = function(line)
		{
			unSer(line.data);
		}
		ws.onclose = function()
		{
			close();
		}
		#end
		connect();
	}
	
	public function connect()
	{
	#if !html5
		socket = new Socket();
    try {
		socket.connect(new Host(ip), port);
		socket.setBlocking(false);
		socket.setFastSend(true);
		connected = true;
		//establish to server that it's a tcp socket
		socket.output.writeString("8");
		connected = true;
		trace("connected");
		if (onConnect != null) onConnect();
    }
    catch (e: Dynamic) {
        connected = false;
		wait = 0;
    }
	#end
	
	}
	
	/**
	 * write to server
	 * @param	str String to send to server
	 * @return Whether or not The message was sent
	 */
	public function write(str:String)
	{
		try
		{
		#if html5
		ws.send(str);
		#else
		socket.output.writeString(str + "\n");
		#end
		}
		catch (e:Dynamic)
		{
			trace("write " + e);
			close();
		}
	}
	/**
	 * Send Dynamic data 
	 * @param	obj Data
	 */
	public function send(obj:Dynamic,setWait:Int=0)
	{
		if(!connected)return;
		var ser = new Serializer();
		ser.serialize(obj);
		write(ser.toString());
		wait = setWait;
	}
	public function read()
	{
		#if (cpp || neko)
		try
		{
		unSer(socket.input.readLine());
		wait = -1;
		}catch (e:Dynamic)
		{
		//2 seconds
		if (wait > 120)
		{
			if (onClose != null)
			{
				connected = false;
				onClose();
			}
			wait = -1;
			connect();
		}
		if (wait >= 0) wait ++;
		}
		#end
	}
	public function unSer(str:String)
	{
		    try
			{
			var data = new Unserializer(str).unserialize();
			if(onMessage != null)onMessage(data);
			if(mainMessage != null)mainMessage(data);
			}
			catch (e:Dynamic)
			{
				trace("ser " + e);
			}
	}
	public function close()
	{
		#if html5
		ws.close(1000, "in activity");
		#else
		socket.close();
		#end
		connected = false;
	}
  
	public function update()
	{
		#if (cpp || neko)
		read();
		#end
	}
}