package core;
import haxe.Http;
import haxe.Timer;

/**
 * ...
 * @author 
 */
class KeyEvent 
{
	public static var uuid:String = "";
	public static var tracking:String = "";
	private static var params:String = "";
	private static var url:String = "www.google-analytics.com";
	public static function time(name:String, past:Float)
	{
		defualt();
		var stamp = Math.floor((Timer.stamp() - past) * 1000);
		addParam("t", "timing");
		addParam("utc", "timestamp");
		addParam("utt", Std.string(stamp));
		addParam("utl", name);
		run();
	}
	public static function view(name:String)
	{
		defualt();
		addParam("t", "event");
		addParam("ec", "state");
		addParam("ea", "view");
		addParam("el", name);
		run();
	}
	public static function inital(name:String)
	{
		defualt();
		addParam("t", "event");
		addParam("ec", "state");
		addParam("ea", "inital");
		addParam("el", name);
		run();
	}
	public static function page(name:String)
	{
		defualt();
		addParam("t", "pageview");
		addParam("dh", "app");
		addParam("dp", name);
		run();
	}
	private static function addParam(name:String, value:String)
	{
		params += name + "=" + value + "&";
	}
	public static function defualt()
	{
		params = "/collect?";
		addParam("v", "1");
		addParam("tid", tracking);
		addParam("cid", uuid);
	}
	public static function run()
	{
		params = params.substring(0, params.length - 1);
		var http = new Http(url + params);
		#if js
		http.async = true;
		#end
		http.request(false);
		http = null;
	}
}