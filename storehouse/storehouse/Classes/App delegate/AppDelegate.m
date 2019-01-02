//
//  AppDelegate.m
//  storehouse
//
//  Created by 万宇 on 2018/5/30.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTabBarController.h"
#import "LogInVC.h"
#import "CcUserModel.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *userCookie = userModel.userCookie;
    if (userCookie) {
        //初始化一个tabBar控制器
        YYTabBarController *tabbarVC = [[YYTabBarController alloc]init];
        self.window.rootViewController = tabbarVC;
        [self.window makeKeyAndVisible];
    }else{
        LogInVC *logInVC = [[LogInVC alloc]init];
        self.window.rootViewController = logInVC;
        [self.window makeKeyAndVisible];
    }
    // ----------------------极光推送----------------------
    //添加初始化 APNs 代码
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //    添加初始化 JPush 代码
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"678a0cbdcfe023ba62a827af"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:nil];
    //    apsForProduction
    //    1.3.1 版本新增，用于标识当前应用所使用的 APNs 证书环境。
    //    0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
    //    注：此字段的值要与 Build Settings的Code Signing 配置的证书环境一致。
    // Override point for customization after application launch.
    //自定义极光消息推送 注册通知并实现回调方法
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //    集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。
    //    应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);//唯一的该设备的标识 - RegistrationID
    }];
    // apn 内容获取：
//    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
////    如果 App 状态为未运行，此函数将被调用，如果 launchOptions 包含 UIApplicationLaunchOptionsRemoteNotificationKey 表示用户点击 apn 通知导致 app 被启动运行；如果不含有对应键值则表示 App 不是因点击 apn 而被启动，可能为直接点击 icon 被启动或其他
//    if (remoteNotification) {//点击通知
//        NSLog(@"点击通知%@",remoteNotification);
//    }else{//点击icon
//        NSLog(@"点击icon%@",remoteNotification);
//    }
    return YES;
}
#pragma mark ------------JPUSH----------------------
//注册APNs成功并上报给极光DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"注册远程通知失败: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//收到的远程推送自动走此
        [JPUSHService handleRemoteNotification:userInfo];
//        NSDictionary *noticeDic = userInfo[@"aps"];
//        NSLog(@"%@ %@ %@",noticeDic[@"alert"],noticeDic[@"badge"],noticeDic[@"sound"]);
//        [SVProgressHUD showWithStatus:noticeDic[@"alert"]];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//    [JPUSHService resetBadge];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //收到的远程推送点击到此
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *noticeDic = userInfo[@"aps"];
//        NSLog(@"%@ %@ %@",noticeDic[@"alert"],noticeDic[@"badge"],noticeDic[@"sound"]);
         [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//点击就设置badge值为0
        //跳转登录首页
        YYTabBarController *firstVC = [[YYTabBarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
    }else {
        // 本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}
//添加处理 JPush 自定义消息回调方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];//获取推送的内容
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];//获取推送的 messageID（key 为 @"_j_msgid"）
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];//获取用户自定义参数
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的 根据自定义 key 获取自定义的 value
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
