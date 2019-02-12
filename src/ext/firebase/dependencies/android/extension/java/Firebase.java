package extension.java;


import android.app.Activity;
import android.app.Application;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;

import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;
import com.google.firebase.messaging.FirebaseMessaging;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.Map;

import org.haxe.extension.Extension;
import android.app.AlertDialog;
import android.content.DialogInterface;
import com.google.firebase.FirebaseApp;

import android.os.Vibrator;

public class Firebase extends Extension {
	public static String idToken = "fake";
	public static String getInstanceIDToken() {
		idToken = FirebaseInstanceId.getInstance().getToken();
		Log.i("Firebase", "getInstanceIDToken " + idToken);
		return idToken;
	}
	
	public static void registerTopic(String topic) {
		FirebaseMessaging.getInstance().subscribeToTopic(topic);
	}
	
	public static void startVibrate() {
		Log.i("Firebase", "startVibrate");
		java.lang.System.out.println("Firebase - startVibrate");
		long mills = 75L;
		Vibrator vibrator = (Vibrator) Extension.mainActivity.getSystemService(Context.VIBRATOR_SERVICE);
		vibrator.vibrate(mills);
	}
	
	//private static MyFirebaseMessagingService msgs;
	public static void initFirebase() {
		//FirebaseMessagingService.
		//startVibrate();
		//msgs = new MyFirebaseMessagingService();
	}
	private static Bundle getFirebaseAnalyticsBundleFromJson(String jsonString) {
		Map<String, String> payloadMap = getPayloadFromJson(jsonString);

		Bundle payloadBundle = new Bundle();
		for (Map.Entry<String, String> entry : payloadMap.entrySet()) {
			payloadBundle.putString(entry.getKey(), entry.getValue());
		}

		return payloadBundle;
	}
	private static Map<String, String> getPayloadFromJson(String jsonString) {
		Type type = new TypeToken<Map<String, String>>(){}.getType();
		Map<String, String> payload = new Gson().fromJson(jsonString, type);
		return payload;
	}
	public static void sendFirebaseAnalyticsEvent(String eventName, String jsonPayload) {
		Log.i("trace","Firebase.java: sendFirebaseAnalyticsEvent name= " + eventName + ", payload= " + jsonPayload);
		Application mainApp = Extension.mainActivity.getApplication();
		FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.getInstance(mainApp);
		Bundle payloadBundle = getFirebaseAnalyticsBundleFromJson(jsonPayload);
		firebaseAnalytics.logEvent(eventName, payloadBundle);
	}
}
