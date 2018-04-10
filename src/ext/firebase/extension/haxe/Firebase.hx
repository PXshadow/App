package extension.haxe;


import haxe.Constraints.Function;
import haxe.Log;
import lime.system.CFFI;
import lime.system.JNI;


/**
* https://firebase.google.com/
* Firebase is a suite of google libraries.
*
* We use Firebase for analytics, push notifications, and (TODO: deep links)
**/
class Firebase {

	public static function sendFirebaseAnalyticsEvent (eventName:String, payload:String):Void {

		#if (ios || android)
			//extension_firebase_send_analytics_event(eventName, payload);
		#else
			trace("sendFirebaseAnalyticsEvent not implemented on this platform.");
		#end
	}

	public static function getInstanceIDToken ():String {
		#if (ios || android)
			return extension_firebase_get_instance_id_token();
		#else
			trace("getInstanceIDToken not implemented on this platform.");
			return null;
		#end
	}

	#if (ios)
	//private static var extension_firebase_send_analytics_event = CFFI.load ("firebase", "sendFirebaseAnalyticsEvent", 2);
	private static var extension_firebase_get_instance_id_token = CFFI.load ("firebase", "getInstanceIDToken", 0);
	#end

	#if (android)
	//private static var extension_firebase_send_analytics_event = JNI.createStaticMethod("extension.java.Firebase", "sendFirebaseAnalyticsEvent", "(Ljava/lang/String;Ljava/lang/String;)V");
	private static var extension_firebase_get_instance_id_token = JNI.createStaticMethod("extension.java.Firebase", "getInstanceIDToken", "()Ljava/lang/String;");
	#end
	
	public static function registerTopic(_topic:String):Void {
		trace("extension registerTopic: " + _topic);
		#if (android || ios)
			extension_firebase_register_topics(_topic);
		#end
	}
	
	#if (ios)
	private static var extension_firebase_register_topics = CFFI.load ("firebase", "registerTopic", 1);
	#end
	#if (android)
	private static var extension_firebase_register_topics = JNI.createStaticMethod("extension.java.Firebase", "registerTopic", "(Ljava/lang/String;)V");
	#end

	public static function initFirebase():Void {
		#if (android || ios)
			exrension_firebase_init_firebase();
		#end
	}
	#if (ios)
	private static var exrension_firebase_init_firebase = CFFI.load ("firebase", "initFirebase", 0);
	#end
	#if (android)
	private static var exrension_firebase_init_firebase = JNI.createStaticMethod("extension.java.Firebase", "initFirebase", "()V");
	#end
	
	/*public static function registerOnMessageFunction(_function:Function):Void {
		#if (android)
			exrension_firebase_reg_on_message();
		#end
	}
	
	#if (android)
	private static var exrension_firebase_reg_on_message = JNI.createStaticMethod("extension.java.MyFirebaseMessagingService", "regOnMessage", "(Function)V");
	#end*/
	
	public static function vibrate():Void {
		#if (android || ios)
			//extension_firebase_start_vibrate();
		#end
	}
	
	#if (ios)
		//private static var extension_firebase_start_vibrate = CFFI.load ("firebase", "startVibrate", 0);
	#end
	#if (android)
		private static var extension_firebase_start_vibrate = JNI.createStaticMethod("extension.java.Firebase", "startVibrate", "()V");
	#end
	
	
	
	/*public static function makeToast(_msg:String):Void {
		#if (android)
			extension_make_toast(_msg);
		#end
	}
	#if (ios)
		
	#end
	#if (android)
		private static var extension_make_toast = JNI.createStaticMethod("extension.java.Firebase", "makeToast", "(Ljava/lang/String;)V");
	#end*/
}