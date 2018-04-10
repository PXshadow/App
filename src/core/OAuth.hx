package core;
import core.OAuth.Application;
#if mobile
//import extension.webview.WebView;
#end
import openfl.Lib;
import openfl.net.URLRequest;
/**
 * ...
 * @author 
 */
enum Application
{
	reddit;
	facebook;
}

class OAuth 
{
	
	public static var facebookId:String = "";
	public static var redditId:String = "";
	public static var redirect:String = "";
	public static var getAuth:(type:Application, code:String)->Void;

	public function new(type:Application,scope:String) 
	{
		var url:String = "";
		var state:String = create();
		switch(type)
		{
			case Application.reddit:
			url = "https://www.reddit.com/api/v1/authorize?client_id=" + redditId + 
			"&response_type=code" + 
			"&duration=temporary";
			case Application.facebook:
			url = "https://www.facebook.com/v2.12/dialog/oauth?client_id=" + facebookId;
			default:
		}
		
		url +=
		"&redirect_uri=" + redirect + 
		"&state=" + state + 
		"&display=popup" +
		"&scope=" + scope;
		
		#if mobile
		/*WebView.open(url,true,null,[redirect + "(.*)"]);
		WebView.onURLChanging = function(newUrl:String)
		{
			if (newUrl.indexOf(state) > -1 && newUrl.substring(0, redirect.length) == redirect)
			{
				var point = newUrl.indexOf("code=") + 5;
				var end = newUrl.indexOf("&", point);
				if (end == -1) end = newUrl.length;
				var code = newUrl.substring(point, end);
				//callback
				if (getAuth != null) getAuth(type, code);
			}
		};*/
		#else 
		#if debug
		Lib.navigateToURL(new URLRequest(url));
		#end
		#end
	}
	
	private function create(): String {
    //return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
	return s4() + s4() + s4() + s4() + s4() + s4() + s4() + s4();
  }

    private function s4(): String {
    return StringTools.hex(Math.floor((1 + Math.random()) * 0x10000)).substr(1);
  }
  
}