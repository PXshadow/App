package core;

import haxe.Serializer;
#if html5
import js.html.WebSocket;
#else
import sys.net.Socket;
import sys.net.Host;
#end
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
	/**
	 * onClose function 
	 */
	public var onClose(default, default): Dynamic->Void;
	/**
	 * OnMessage function
	 */
	public var onMessage(default, default):Dynamic->Void;
	 
/**
 * Setup networking
 */
	public function new(ipString:String,portInt:Int,blockSameMessage:Bool=true) 
	{
		ip = ipString;
		port = portInt;
		oldMessageBool = blockSameMessage;
		var param:String = "ws";
		if (secure) param = "wss";
		
		#if html5
		ws = new WebSocket(param + "://" + ip + ":" + Std.string(port));
		ws.onopen = function()
		{
			connected = true;
			onConnect();
		}
		ws.onmessage = function(line)
		{
			unSer(line.data);
		}
		ws.onclose = function()
		{
			ws.close(0, "Lost Connection");
			onClose(null);
		}
		#else
		try
		{
		socket = new Socket();
		socket.connect(new Host(ip), port);
		socket.setBlocking(false);
		connected = true;
		//establish to server that it's a tcp socket
		socket.output.writeString("8");
		}catch (e:Dynamic)
		{
			connected = false;
			trace(e);
		}
		#end
		
	}
	//client connected to the server
	public function onConnect()
	{
		trace("connected");
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
		trace("not connected to server");
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
			onMessage(new Unserializer(str).unserialize());
			/*}
			catch (e:Dynamic)
			{
				trace("unser " + e);
			}*/
	}
  
	public function update()
	{
		#if (cpp || neko)
		read();
		#end
	}
}