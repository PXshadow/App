package core;
import haxe.Serializer;
#if html5
import js.html.WebSocket;
#else
import sys.net.Socket;
import sys.net.Host;
#end
import haxe.Unserializer;
/**
 * ...
 * @author 
 */
class Networking 
{
	#if html5
	/**
	 * web socket
	 */
	public var ws:WebSocket;
	#else
	public var client:Socket;
	#end
	public var secure:Bool = false;
	public static var ip:String = "localhost";
	public static var port:Int = 9696;
	public var connected:Bool = false;
	public var oldMessage:String;
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
	public function new() 
	{
		#if html5
		var param:String = "ws";
		if (secure) param = "wss";
		ws = new WebSocket(param + "://" + ip + ":" + Std.string(port));
		ws.onopen = function()
		{
			connected = true;
			onConnect();
		}
		ws.onmessage = function(line)
		{
			try
			{
			onMessage(new Unserializer(line.data).unserialize());
			}
			catch (e:Dynamic)
			{
				trace("unseri " + e);
			}
		}
		ws.onclose = function()
		{
			ws.close(0, "Lost Connection");
			onClose(null);
		}
		#else
		throw("System Sockets not working yet");
		connected = true;
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
		
		#end
	oldMessage = str;
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
		trace("obj " + obj);
		var ser = new Serializer();
		ser.serialize(obj);
		write(ser.toString());
		}
		catch (e:Dynamic)
		{
			trace("serialize send " + e);
		}
	}
	
	public function readRaw()
	{
		#if !html5
		try{
       	    	trace(client.input.readLine());
    	      
          	} catch (err:Dynamic){
             //s trace("no Message to read");
          	}
		#end
	}
	
	public function update()
	{
		//readRaw();
	}
}