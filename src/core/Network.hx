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
/**
 * ...
 * @author 
 */
class Network 
{
	
	public var secure:Bool = false;
	private var host:Host;
	private var port:Int = 9696;
	public var connected:Bool = false;
	public var connecting:Bool = false;
	
	var socket:Socket;
	
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
	public function new(ipString:String,portInt:Int) 
	{
		try
		{
		host = new Host(ipString);
		}catch (e:Dynamic)
		{
			
		}
		port = portInt;
		connect();
	}
	
	public function connect()
	{
		if (connecting) return;
		connecting = true;
		socket = new Socket();
		try
		{
		socket.connect(host, port);
		socket.setBlocking(false);
		//socket.setFastSend(true);
		connected = true;
		//tcp relay
		socket.output.writeString("8");
		connectEvent();
		}catch (e:Dynamic)
		{
			trace("fail");
			close();
		}
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
	private function close()
	{
		var tim = new Timer(20);
		tim.run = function()
		{
		if (onClose != null) onClose();
		tim.stop();
		tim = null;
		}
		connected = false;
	}
	
	public function update()
	{
		#if (cpp || neko)
		read();
		#end
	}
	
	public function read()
	{
		if (!connected) return;
		try
		{
		unSer(socket.input.readLine());
		}catch (e:Dynamic)
		{
		
		}
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
		ws.send(str);
		#else
		socket.output.writeString(ser.toString() + "\n");
		#end
		}
		catch (e:Dynamic)
		{
			trace("write " + e);
			if (onClose != null) onClose();
		}
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
}