#include "FirebaseAppDelegate.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
@interface FirebaseAppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation FirebaseAppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

NSString* firebaseInstanceIdToken = @"";

+ (instancetype)sharedInstance
{
  static FirebaseAppDelegate *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[self alloc] _init];
  });
  return _sharedInstance;
}

- (instancetype)_init
{
  NSLog(@"FirebaseAppDelegate: _init");

  return self;
}

- (instancetype)init
{
  return nil;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    NSLog(@"FirebaseAppDelegate: willFinishLaunchingWithOptions");
    /*[FIRApp configure];
    [FIRMessaging messaging].delegate = self;

    // Push Notification Permission
    // This code will request permission from the user to accept Push Notifications on their device.
    // It is displayed when the app is launched. We will want some better control around when and how we ask users to enable push
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        NSLog(@"FirebaseAppDelegate: Requesting <= iOS 9 Notifications");
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        NSLog(@"FirebaseAppDelegate: ELSE Requesting >= iOS 10 Notifications");
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            NSLog(@"FirebaseAppDelegate: Requesting >= iOS 10 Notifications");
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error){
                NSLog(@"FirebaseAppDelegate: requestAuthorizationWithOptions granted = %d error = %@", granted, error);
            }];
        #endif
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];*/

    // Token may be null if it has not been generated yet.
    //NSLog(@"FirebaseAppDelegate: FCM registration token: %@", [FIRMessaging messaging].FCMToken);

    return YES;
}

- (BOOL)sendFirebaseAnalyticsEvent:(NSString *)eventName jsonPayload:(NSString *)jsonPayload
{
    NSLog(@"FirebaseAppDelegate: sendFirebaseAnalyticsEvent name= %@, parameter= %@", eventName, jsonPayload);

    NSData * jsonData = [jsonPayload dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    [FIRAnalytics logEventWithName:eventName parameters:parsedData];
    return YES;
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Обратите внимание, что этот обратный вызов будет запускаться каждый раз, когда генерируется новый токен, включая первый
    // время. Поэтому, если вам нужно получить токен, как только он будет доступен, это
    // должно быть сделано.
	NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"FirebaseAppDelegate: didRefreshRegistrationToken FCM registration token: %@", fcmToken);
	NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // При необходимости отправьте токен на сервер приложений.

    firebaseInstanceIdToken = fcmToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"FirebaseAppDelegate: Unable to register for remote notifications: %@", error);
}

// Эта функция добавляется здесь только для целей отладки и может быть удалена, если swizzling включен.
// Если swizzling отключен, эта функция должна быть реализована так, чтобы токен устройства APNs мог быть сопряжен с
// токен регистрации FCM.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"FirebaseAppDelegate: didRegisterForRemoteNotificationsWithDeviceToken token: %@", deviceToken);

	NSLog(@"--------------------------------------------------------------------------------------");
	NSLog(@"--------------------------------------------------------------------------------------");
    firebaseInstanceIdToken = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
	NSLog(@"VOT TUT SUKA EBANAYA YA HUY POYMY CHO DELATZOPADDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    // С отключением swizzling вы должны установить токен устройства APN.
    // [Messaging messaging].APNSToken = deviceToken;
	NSLog(@"--------------------------------------------------------------------------------------");
	NSLog(@"--------------------------------------------------------------------------------------");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Если вы получаете уведомление, когда ваше приложение находится в фоновом режиме,
    // этот обратный вызов не будет запущен, пока пользователь не закроет уведомление о запуске приложения.

    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
	NSLog(@"VOT TUT SUKA EBANAYA YA HUY POYMY CHO DELAT--------------");
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Если вы получаете уведомление, когда ваше приложение находится в фоновом режиме,
    // этот обратный вызов не будет запущен, пока пользователь не закроет уведомление о запуске приложения.

    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"%@", userInfo);
	NSLog(@"VOT TUT SUKA EBANAYA YA HUY POYMY CHO DELAT++++++++++++");
    completionHandler(UIBackgroundFetchResultNewData);
}

- (NSString*)getInstanceIDToken {
    return firebaseInstanceIdToken;
}

- (void)initFirebase {
    NSLog(@"VOT TUT SUKA EBANAYA YA HUY POYMY CHO DELAT");
    NSLog(@"FirebaseAppDelegate: willFinishLaunchingWithOptions");
	
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;

    // Разрешение Push-уведомления
    // Этот код запрашивает у пользователя разрешение принимать Push-уведомления на своем устройстве.
    // Он отображается при запуске приложения. Нам нужно немного лучше контролировать, когда и как мы просим пользователей активировать push
	
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        NSLog(@"FirebaseAppDelegate: Requesting <= iOS 9 Notifications");
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 или более поздняя версия
        NSLog(@"FirebaseAppDelegate: ELSE Requesting >= iOS 10 Notifications");
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            NSLog(@"FirebaseAppDelegate: Requesting >= iOS 10 Notifications");
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error){
                NSLog(@"FirebaseAppDelegate: requestAuthorizationWithOptions granted = %d error = %@", granted, error);
            }];
        #endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

	//Токен может быть нулевым, если он еще не создан.
	NSLog(@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	NSLog(@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    NSLog(@"FirebaseAppDelegate: FCM registration token: %@", [FIRMessaging messaging].FCMToken);
	NSLog(@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	NSLog(@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	
	//NSString *a = ;

	if ([[FIRMessaging messaging].FCMToken isEqual:[NSNull null]] || [FIRMessaging messaging].FCMToken == nil) {
		NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		//firebaseInstanceIdToken = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
		//firebaseInstanceIdToken = [FIRMessaging messaging].FCMToken;
		//[NSString stringWithUTF8String:val_string(topic)]
	} else {
		NSLog(@"KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
		firebaseInstanceIdToken = [FIRMessaging messaging].FCMToken;
	}
	
}

-(void)registerTopic:(NSString*)topic
{
	[[FIRMessaging messaging] subscribeToTopic:topic];
	NSLog(@"Subscribed to news topic=%@", topic);
}
@end