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
	public var oldMessage:String;
	public var oldMessageBool:Bool;
	public var reconnectBool:Bool = true;
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
		oldMessageBool = blockSameMessage;
		connect();
	}
	
	public function connect()
	{
		#if html5
		var param:String = "ws";
		if (secure) param = "wss";
		ws = new WebSocket(param + "://" + ip + ":" + Std.string(port));
		ws.onopen = function()
		{
			connected = true;
			if(onConnect != null)onConnect();
		}
		ws.onmessage = function(line)
		{
			unSer(line.data);
		}
		ws.onclose = function()
		{
			disconnect();
		}
		#else
		socket = new Socket();
    try {
		socket.connect(new Host(ip), port);
		socket.setBlocking(false);
		socket.setFastSend(true);
		socket.setTimeout(2);
		connected = true;
		//establish to server that it's a tcp socket
		socket.output.writeString("8");
		if (onConnect != null) onConnect();
    }
    catch (e: Dynamic) {
      //onFailure(e);
      connected = false;
    }
	#end
	
	}
	
	/**
	 * write to server
	 * @param	str String to send to server
	 * @return Whether or not The message was sent
	 */
	public function write(str:String):Bool
	{
		if (connected)
		{
		try
		{
	if (oldMessage != str)
	{
		#if html5
		ws.send(str);
		#else
		socket.output.writeString(str + "\n");
		#end
	if(oldMessageBool)oldMessage = str;
	}
		}
		catch (e:Dynamic)
		{
			trace("faild writing to socket " + e);
			return false;
		}
		return true;
		}else{
		disconnect();
		return false;
		}
	}
	/**
	 * Send Dynamic data 
	 * @param	obj Data
	 */
	public function send(obj:Dynamic)
	{
		try
		{
		var ser = new Serializer();
		ser.serialize(obj);
		write(ser.toString());
		}
		catch (e:Dynamic)
		{
			trace("serialize send " + e);
		}
	}
	public function read()
	{
		#if (cpp || neko)
		try
		{
		unSer(socket.input.readLine());
		}catch (e:Dynamic)
		{
		//trace(e);
		}
		#end
	}
	public function unSer(str:String)
	{
		    //try
			//{
			var data = new Unserializer(str).unserialize();
			if(onMessage != null)onMessage(data);
			if(mainMessage != null)mainMessage(data);
			/*}
			catch (e:Dynamic)
			{
				trace("unser " + e);
			}*/
	}
	public function close()
	{
		#if html5
		ws.close(1000, "in activity");
		#else
		socket.close();
		#end
	}
	public function disconnect()
	{
		if (onClose != null) onClose();
		var tim = new Timer(200);
		tim.run = function()
		{
			connect();
			tim.stop();
			tim = null;
		}
	}
  
	public function update()
	{
		#if (cpp || neko)
		read();
		#end
	}
}