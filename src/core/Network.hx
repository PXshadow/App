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
import haxe.io.Error;
/**
 * ...
 * @author 
 */
class Network 
{
	
	public var secure:Bool = false;
	private var port:Int = 9696;
	public var connected:Bool = false;
	public var connecting:Bool = false;
	#if !html5
	private var host:Host;
	public var socket:Socket;
	#end
	
	/**
	 * onClose function 
	 */
	public var onClose:Void->Void;
	/**
	 * OnMessage function
	 */
	public var onMessage:Dynamic->Void;
	/**
	 * main
	 */
	public var mainMessage:Dynamic->Void;
/** Callback used called when a connection is established. This callback should not be handled manually. **/
 public var onConnect:Void->Void;
  
/**
 * Setup networking
 */
	public function new(ipString:String,portInt:Int) 
	{
		#if html5
		
		#else
		try
		{
		host = new Host(ipString);
		}catch (e:Dynamic)
		{
			
		}
		port = portInt;
		#end
		connect();
	}
	
	public function connect()
	{
		connecting = false;
		if (connecting) return;
		#if html5
		
		#else
		connecting = true;
		socket = new Socket();
		try
		{
		socket.connect(host, port);
		socket.setBlocking(false);
		socket.setFastSend(true);
		connected = true;
		//tcp relay
		socket.output.writeString("8");
		connectEvent();
		}catch (e:Dynamic)
		{
			trace("fail");
			close();
		}
		#end
		connecting = false;
	}
	
	private function connectEvent()
	{
		var tim = new Timer(20);
		tim.run = function()
		{
		if (onConnect != null) onConnect();
		tim.stop();
		tim = null;
		}
		connected = true;
	}
	
	public function update()
	{
		#if (cpp || neko)
		read();
		#end
	}
	
	public function close()
	{
		#if (cpp || neko)
		socket.close();
		#end
		connected = false;
		var tim = new Timer(20);
		tim.run = function()
		{
		if (onClose != null) onClose();
		tim.stop();
		tim = null;
		}
	}
	
	public function read()
	{
		#if !html5
		if (!connected) return;
		try
		{
		var buff = socket.input.readUntil(0x0A);
		unSer(buff);
		}catch (e:Dynamic)
		{
		if (e != Error.Blocked) trace("issue " + e);
		}
		#end
	}
	
	/**
	 * Send Dynamic data 
	 * @param	obj Data
	 */
	public function send(obj:Dynamic)
	{
		if(!connected)return;
		var ser = new Serializer();
		ser.serialize(obj);
		try
		{
		#if html5
		//ws.send(str);
		#else
		socket.output.writeString(ser.toString() + "\n");
		#end
		}
		catch (e:Dynamic)
		{
			trace("write " + e);
			close();
		}
	}
	
	public function unSer(str:String)
	{
		   // try
			//{
			var data = new Unserializer(str).unserialize();
			if(onMessage != null)onMessage(data);
			if(mainMessage != null)mainMessage(data);
			//}
			//catch (e:Dynamic)
			//{
			//	trace("ser " + e + " data " + str);
			//}
	}
}